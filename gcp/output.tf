output "bucket_and_object_name" {
    description = "Name of the bucket and object"

    value = "${google_storage_bucket.bucket.name}/${google_storage_bucket_object.vuln_zip.name}"
}

output "function_name" {
    description = "Name of the Cloud Function."

    value = google_cloudfunctions_function.vulnerable_function.name
}

output "function_url" {
    description = "Base URL for Cloud Function."

    value = google_cloudfunctions_function.vulnerable_function.https_trigger_url
}