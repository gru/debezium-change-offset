while IFS= read -r line; do
    ./restart-messages-from-beginning.sh "$line"
done < $1
