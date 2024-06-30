
for d in */ ; do
    cd "$d"
    find  . -mindepth 2 -type f -exec mv {} . \;
    cd ..
done

find . -type d -empty -delete

