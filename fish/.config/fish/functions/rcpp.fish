function rcpp
    if test (count $argv) -ne 1
        echo "Usage: rcpp <filename.cpp>"
        return 1
    end

    set file $argv[1]

    if not test -f $file
        echo "File not found: $file"
        return 1
    end

    set name (basename $file .cpp)
    set outdir out

    mkdir -p $outdir

    g++ -std=c++20 $file -o $outdir/$name
    or return 1

    ./$outdir/$name
end
