while IFS= read -r line; do
    if [ -n "$line" ]; then
        ./restart-messages-from-lsn.sh "$line"
    fi
done < $1
