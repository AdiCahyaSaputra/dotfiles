function ocrshot
  set TMPDIR (mktemp -d)

  gnome-screenshot -a -f "$TMPDIR/screenshot.png"
  tesseract "$TMPDIR/screenshot.png" "$TMPDIR/output"

  cat "$TMPDIR/output.txt" \
      | tr -cd '\11\12\15\40-\176' \
      | grep . \
      | perl -pe 'chomp if eof' \
      | wl-copy

  rm -r "$TMPDIR"
end 
