#!/bin/bash

if [ "$#" -ge 1 ]; then
  for file in "$@"; do
    if [ -f "$file" ]; then
      # labels.component
      yq write -i "$file" labels.component java
      # ... (rest of the modifications)

      # print final file
      yq read "$file"

      # print warnings if file needs to be manually updated
      if [[ $(cat "$file" | yq r -  lifecycle) != "null" ]]; then
        echo "WARNING: lifecycle detected in $file => you have to manually update values file"
      fi
      # ... (rest of the warnings)
    else
      echo "File $file not found."
    fi
  done
else
  echo "Usage: spring2backend.sh <file1.yaml> [file2.yaml file3.yaml ...]"
  exit 1
fi
