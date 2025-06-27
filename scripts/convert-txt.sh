#!/bin/bash

# Ensure pandoc is installed: https://pandoc.org/installing.html
if ! command -v pandoc &> /dev/null
then
    echo "pandoc could not be found. Please install it to run this script."
    exit 1
fi

SOURCE_DIR="docs/source"
OUTPUT_DIR="docs/source-md"

mkdir -p "$OUTPUT_DIR"

echo "Converting .txt files from $SOURCE_DIR to Markdown in $OUTPUT_DIR..."

for f in "$SOURCE_DIR"/*.txt; do
    if [ -f "$f" ]; then
        filename=$(basename -- "$f")
        filename_no_ext="${filename%.*}"
        output_file="$OUTPUT_DIR/${filename_no_ext}.md"
        
        echo "Converting $f to $output_file"
        pandoc "$f" -o "$output_file"
    fi
done

echo "Conversion complete. Review files in $OUTPUT_DIR."
echo "You may now move them to their final destinations and delete the old .txt files."
