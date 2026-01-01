#!/usr/bin/env bash
#
# Regenerates CONTRIBUTORS.md from git history
#

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

cat > CONTRIBUTORS.md << 'HEADER'
# Contributors

Thanks to everyone who has contributed to ccplugins!

<!-- AUTO-GENERATED from git history. Run: ./scripts/update-contributors.sh -->

| Contributor | Commits |
|-------------|---------|
HEADER

git shortlog -sne --all | sort -rn | while read -r count name_email; do
  # Extract name and create GitHub link if possible
  name=$(echo "$name_email" | sed 's/ <.*//')
  email=$(echo "$name_email" | sed 's/.*<\(.*\)>/\1/')

  # Try to extract GitHub username from noreply email
  if [[ "$email" == *"@users.noreply.github.com"* ]]; then
    github_user=$(echo "$email" | sed 's/.*+\(.*\)@users.noreply.github.com/\1/' | sed 's/^[0-9]*+//')
    echo "| [${name}](https://github.com/${github_user}) | ${count} |"
  else
    echo "| ${name} | ${count} |"
  fi
done >> CONTRIBUTORS.md

echo "" >> CONTRIBUTORS.md
echo "---" >> CONTRIBUTORS.md
echo "*Last updated: $(date -u '+%Y-%m-%d')*" >> CONTRIBUTORS.md

echo "CONTRIBUTORS.md updated"
