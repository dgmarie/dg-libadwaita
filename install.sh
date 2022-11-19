#! /usr/bin/env bash

color_variants=('orange' 'bark' 'sage' 'olive' 'viridian' 'prussiangreen' 'lightblue' 'blue' 'purple' 'magenta' 'pink' 'red')
theme_variants=('light' 'dark')

color="orange"
theme="light"
suffix=""
gtk4_dir="${HOME}/.config/gtk-4.0"

nc='\033[0m'
bold='\033[1m'
red='\033[0;31m'
bgreen='\033[1;32m'

while getopts 't:c:h' flag; do
  case "${flag}" in
  t) theme="${OPTARG}" ;;
  c) color="${OPTARG}" ;;
  h)
    echo "OPTIONS:"
    echo "  -t <theme_variant>. Set theme variant."
    echo "     [light|dark] (Default: light)"
    echo "  -c <color_name>. Specify accent color."
    echo "     [orange|bark|sage|olive|viridian|prussiangreen|lightblue|blue|purple|magenta|pink|red]"
    echo "     (Default: orange)"
    echo "  -h Show this message."
    exit 0
    ;;
  *)
    exit 1
    ;;
  esac
done

if ! printf '%s\0' "${color_variants[@]}" | grep -Fxqz -- "${color}"; then
  >&2 echo "ERROR: Unrecognized accent color '${color}'."
  exit 1
fi

if ! printf '%s\0' "${theme_variants[@]}" | grep -Fxqz -- "${theme}"; then
  >&2 echo "ERROR: Unrecognized theme variant '${color}'."
  exit 1
fi

if [[ "${theme}" == "dark" ]]; then
  suffix="-dark"
fi

# Accent colors
cp -rf "gtk-4.0/_accent-colors.scss" "gtk-4.0/_accent-colors-temp.scss"
sed -i "/\$accent_color:/s/orange/${color}/" "gtk-4.0/_accent-colors-temp.scss"

# Install gtk4 configuration
if [[ "$(command -v sassc)" ]]; then
  echo -e "${bgreen}Installing${nc} the ${bold}${color} ${theme} qualia Libadwaita theme ${nc}in ${bold}${gtk4_dir}${nc}"
  mkdir -p "${gtk4_dir}"
  cp -rf "gtk-4.0/assets/mac-icons/" "${gtk4_dir}"
  sassc -M -t expanded "gtk-4.0/gtk${suffix}.scss" "${gtk4_dir}/gtk.css"
  rm -rf "gtk-4.0/_accent-colors-temp.scss"
else
  >&2 echo "ERROR: 'sassc' not found."
  exit 1
fi
