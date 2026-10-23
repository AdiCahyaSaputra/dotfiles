function copy --description 'Copy stdin to the clipboard without a trailing newline'
    perl -0777 -pe 's/\n\z//' | command pbcopy
end
