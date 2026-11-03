#!/bin/zsh
# Genera Informe-Arquitectura-VeloCart.pdf desde informe-velocart.md.
# Requiere pandoc y Google Chrome.
cd "${0:A:h}" || exit 1
TMP=$(mktemp -d)
pandoc informe-velocart.md -f markdown+raw_html-implicit_figures -t html5 --standalone --embed-resources \
  --metadata pagetitle="Arquitectura de Microservicios para VeloCart Global" --metadata lang=es \
  --css estilos.css -o "$TMP/informe.html" || exit 1
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --no-pdf-header-footer \
  --user-data-dir="$TMP/chrome" --print-to-pdf="$PWD/Informe-Arquitectura-VeloCart.pdf" "file://$TMP/informe.html"
rm -rf "$TMP"
