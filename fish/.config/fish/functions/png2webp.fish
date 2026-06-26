function png2webp --description 'Convert all PNGs in the current folder to WebP with custom flags'
    for file in *.png
        ffmpeg -i $file -c:v libwebp $argv (string replace -r '\.png$' '.webp' $file)
    end
end
