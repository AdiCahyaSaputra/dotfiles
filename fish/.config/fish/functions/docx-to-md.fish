function docx-to-md --description "Convert DOCX files to Markdown and extract media"
    set -l BASE_DIR input-files
    set -l ATTACH_ROOT attachments

    if test (count $argv) -ge 1
        set BASE_DIR $argv[1]
    end

    if test (count $argv) -ge 2
        set ATTACH_ROOT $argv[2]
    end

    if not test -d "$BASE_DIR"
        echo "Error: '$BASE_DIR' is not a directory." >&2
        return 1
    end

    mkdir -p "$ATTACH_ROOT"

    find "$BASE_DIR" -type f -name '*.docx' | while read -l docx
        # Relative path
        set -l rel (string replace -r "^$BASE_DIR/" "" "$docx")

        # Remove extension
        set -l rel_noext (string replace -r '\.[^.]+$' '' "$rel")

        # Create a filesystem-safe prefix
        set -l prefix (string lower "$rel_noext" \
            | sed -E 's/[^a-z0-9]+/-/g; s/-+/-/g; s/^-+//; s/-+$//')

        set -l media_dir "$ATTACH_ROOT/$prefix"
        mkdir -p "$media_dir"

        # Output Markdown path
        set -l md_out (string replace -r '\.[^.]+$' '.md' "$docx")
        set md_out (string replace -a ' ' '-' "$md_out")

        echo "Converting: $docx"
        echo "  -> Markdown: $md_out"
        echo "  -> Media:    $media_dir"

        pandoc \
            -t markdown_strict \
            --extract-media="$media_dir" \
            "$docx" \
            -o "$md_out"

        or begin
            echo "Failed to convert: $docx" >&2
            return 1
        end
    end

    echo "Done."
end
