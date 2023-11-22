#!/bin/bash

if [ "$#" -ge 1 ]; then
  for path in "$@"; do
    if [ -d "$path" ]; then
      find "$path" -type f -name "*.yaml" -print0 | while IFS= read -r -d '' file; do
        if [ -s "$file" ]; then
          # labels.component
          yq write -i "$file" labels.component java
          # vault.enabled
          yq write -i "$file" vault.enabled true
          yq delete -i "$file" vault.enable
          # vault.cluster.name
          if [[ $(cat "$file" | yq r - cluster.name) != "null" ]]; then
            yq write -i "$file" vault.cluster.name $(cat "$file" | yq r - cluster.name)
          fi
          yq delete -i "$file" cluster
          # ... (rest of the modifications)

          # print final file
          yq read "$file"

          # print warnings if file needs to be manually updated
          if [[ $(cat "$file" | yq r -  lifecycle) != "null" ]]; then
            echo "WARNING: lifecycle detected in $file => you have to manually update values file"
          fi
          # ... (rest of the warnings)
        else
          echo "File $file is empty. Skipping."
        fi
      done
    elif [ -f "$path" ]; then
      # If a single file is provided as an argument
      file="$path"
      if [ -s "$file" ]; then
        # labels.component
        yq write -i "$file" labels.component java
        # vault.enabled
        yq write -i "$file" vault.enabled true
        yq delete -i "$file" vault.enable
        # vault.cluster.name
        if [[ $(cat "$file" | yq r - cluster.name) != "null" ]]; then
          yq write -i "$file" vault.cluster.name $(cat "$file" | yq r - cluster.name)
        fi
        yq delete -i "$file" cluster
        # ... (rest of the modifications)

        # print final file
        yq read "$file"

        # print warnings if file needs to be manually updated
        if [[ $(cat "$file" | yq r -  lifecycle) != "null" ]]; then
          echo "WARNING: lifecycle detected in $file => you have to manually update values file"
        fi
        # ... (rest of the warnings)
      else
        echo "File $file is empty. Skipping."
      fi
    else
      echo "Path $path not found."
    fi
  done
else
  echo "Usage: spring2backend.sh <directory1/ or file1.yaml> [directory2/ file2.yaml directory3/ ...]"
  exit 1
fi
