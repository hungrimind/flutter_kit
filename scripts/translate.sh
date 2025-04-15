#!/bin/bash

# Colors and formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Print header
print_header() {
    echo -e "\n${BOLD}🌍 Flutter Translation Manager${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Check if a translation key was provided
if [ -z "$1" ]; then
    print_header
    echo -e "${YELLOW}Usage:${NC} ./translate.sh <translation_key>"
    exit 1
fi

TRANSLATION_KEY=$1
L10N_DIR="lib/l10n"

print_header

# List available ARB files and let user select
echo -e "${BOLD}Available translation files:${NC}"
ARB_FILES=($(ls $L10N_DIR/*.arb))
for i in "${!ARB_FILES[@]}"; do
    filename=$(basename "${ARB_FILES[$i]}")
    echo -e "  ${BLUE}$((i+1))${NC}) $filename"
done

while true; do
    echo -e "\n${BOLD}Enter number (1-${#ARB_FILES[@]}):${NC}"
    read FILE_INDEX
    if [[ "$FILE_INDEX" =~ ^[0-9]+$ ]] && [ "$FILE_INDEX" -ge 1 ] && [ "$FILE_INDEX" -le "${#ARB_FILES[@]}" ]; then
        ARB_FILE="${ARB_FILES[$((FILE_INDEX-1))]}"
        break
    else
        echo -e "${YELLOW}Invalid selection. Please enter a number between 1 and ${#ARB_FILES[@]}.${NC}"
    fi
done

# Prompt for translation text
echo -e "\n${BOLD}Enter the translation text:${NC}"
read TRANSLATION_TEXT

# Prompt for description
echo -e "\n${BOLD}Enter the description:${NC}"
read DESCRIPTION

# Read the current content without the last line (closing brace)
content=$(sed '$ d' "$ARB_FILE")

# Check if we need to add a comma to the last line
if [[ $content != *"," ]]; then
    content="${content},"
fi

echo -e "\n${BLUE}Adding translation...${NC}"

# Write back the content and add the new translation
echo "$content" > "$ARB_FILE"
echo "  \"$TRANSLATION_KEY\": \"$TRANSLATION_TEXT\"," >> "$ARB_FILE"
echo "  \"@$TRANSLATION_KEY\": {" >> "$ARB_FILE"
echo "    \"description\": \"$DESCRIPTION\"" >> "$ARB_FILE"
echo "  }" >> "$ARB_FILE"
echo "}" >> "$ARB_FILE"

# Print success message with details
echo -e "\n${GREEN}✓ Translation added successfully!${NC}"
echo -e "${BOLD}Details:${NC}"
echo -e "  ${BLUE}File:${NC}        $(basename "$ARB_FILE")"
echo -e "  ${BLUE}Key:${NC}         $TRANSLATION_KEY"
echo -e "  ${BLUE}Text:${NC}        $TRANSLATION_TEXT"
echo -e "  ${BLUE}Description:${NC} $DESCRIPTION"

# Run flutter pub get to regenerate the localizations
echo -e "\n${BLUE}Regenerating localizations...${NC}"
flutter pub get

echo -e "\n${GREEN}✓ All done!${NC}\n"
