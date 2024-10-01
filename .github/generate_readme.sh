find providers -name 'build.gradle.kts' | while read -r file; do
lib_name=$(basename "$(dirname "$file")")
status=$(grep -oP 'status\.set\((Status\.)?\K[^\)]+' "$file")

case $status in
Status.Working|Working) status_emoji="🟢 OK";;
Status.Beta|Beta) status_emoji="🔵 BETA";;
Status.Maintenance|Maintenance) status_emoji="🟡 MAINTENANCE";;
Status.Down|Down) status_emoji="🔴 DOWN";;
*) status_emoji="❓ UNKNOWN";;
esac

echo "| $lib_name | $status_emoji |" >> status_table.md
done

echo -e "| Name          | Status    |\n| :-----------  | :-------  |" | cat - status_table.md > updated_table.md

if grep -q '| Name          | Status    |' README.md; then
sed -i '/| Name          | Status    |/,$d' README.md
fi

line="#### List of available providers:"
if ! grep -Fxq "$line" README.md
then echo -e "\n$line" >> README.md
fi
cat updated_table.md >> README.md

rm status_table.md updated_table.md