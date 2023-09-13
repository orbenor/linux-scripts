text=(
    text1
    text2
    text3
    "text with with spaces"
)
for t in "${text[@]}"; do
    echo "$t"
done
