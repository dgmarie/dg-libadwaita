#! /usr/bin/env bash

color="$1"
suffix="$2"
gtk4_dir="${HOME}/.config/gtk-4.0"

# Accent colors
cp -rf "gtk-4.0/_accent-colors.scss" "gtk-4.0/_accent-colors-temp.scss"
sed -i "/\$accent_color:/s/orange/${color}/" "gtk-4.0/_accent-colors-temp.scss"

# Install gtk4 configuration
mkdir -p "${gtk4_dir}"
cp -rf "gtk-4.0/assets/mac-icons" "${gtk4_dir}/mac-icons"
sassc -M -t expanded "gtk-4.0/gtk${suffix}.scss" "${gtk4_dir}/gtk.css"
rm -rf "gtk-4.0/_accent-colors-temp.scss"

