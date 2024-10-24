while IFS= read -r line; do
    ./restart-messages-from-lsn.sh "$line"
done < $1
