import yaml
import json

def handler(event):
  event = event.get_json()
  if "body" in event:
    try:
      body = json.loads(event["body"])
    except json.decoder.JSONDecodeError as err:
      return build_response({"Status": "Error", "Data": "Request body isn't json: " + repr(err)})
  else:
    body = event
  if "yamlData" not in body:
    return build_response({"Status": "Error", "Data": "yamlData not found"})
  
  yaml_data = body["yamlData"]
  try:
    data = yaml.load(yaml_data)
    print(data)
  except Exception as err:
    return build_response({"Status": "Error", "Data": "Yaml error: " + repr(err)})

  return build_response({"Status": "Success"})

def build_response(data):
  response = json.dumps({
    "body" : data
  })
  return response