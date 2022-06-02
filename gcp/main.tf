terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "~> 3.84.0"
        }

        archive = {
            source  = "hashicorp/archive"
            version = "~> 2.2.0"
        }
    }
}

provider "google" {
    project = var.project
    region  = var.region
}

data "archive_file" "vulnerable_function" {
    type = "zip"

    source_dir  = "${path.module}/vuln_function_src"
    output_path = "${path.module}/vulnerable_function.zip"
}

resource "google_storage_bucket" "bucket" {
    name = "vuln-bucket"
}

resource "google_storage_bucket_object" "vuln_zip" {
    name    = "vulnerable_function.zip"
    bucket  = google_storage_bucket.bucket.name
    source  = data.archive_file.vulnerable_function.output_path
}

resource "google_project_service" "cb" {
    project = var.project
    service = "cloudbuild.googleapis.com"

    disable_dependent_services  = true
    disable_on_destroy          = false
}

resource "google_cloudfunctions_function" "vulnerable_function" {
    name    = "vulnerable_function"
    runtime = "python38"

    available_memory_mb     = 128
    source_archive_bucket   = google_storage_bucket.bucket.name
    source_archive_object   = google_storage_bucket_object.vuln_zip.name
    trigger_http            = true
    entry_point             = "handler"
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
    project         = google_cloudfunctions_function.vulnerable_function.project
    region          = google_cloudfunctions_function.vulnerable_function.region
    cloud_function  = google_cloudfunctions_function.vulnerable_function.name

    role    = "roles/cloudfunctions.invoker"
    member  = "allUsers"  
}