#!/bin/bash

# Create transparent circular favicon with gradient border

cd "$(dirname "$0")"

# Step 1: Create circular profile
magick assets/images/profile_dark.jpg \
  -resize 340x340^ -gravity center -extent 340x340 \
  \( +clone -alpha extract -draw 'fill black polygon 0,0 0,340 340,340 340,0 fill white circle 170,170 170,0' -write mpr:mask +delete \) \
  -alpha off mpr:mask -compose CopyOpacity -composite \
  -gravity center -background none -extent 512x512 \
  /tmp/profile.png

# Step 2: Create white ring
magick -size 512x512 xc:none \
  -fill white -draw 'circle 256,256 256,68' \
  -fill none -stroke none -draw 'circle 256,256 256,74' \
  -alpha set -channel A -evaluate multiply 0 +channel \
  -fill white -draw 'circle 256,256 256,68' \
  \( +clone -fill black -colorize 100 -fill white -draw 'circle 256,256 256,74' -negate \) \
  -compose DstOut -composite \
  /tmp/white_ring.png

# Step 3: Create gradient ring  
magick -size 512x512 gradient:'#6366F1-#22D3EE' -rotate -45 \
  \( -size 512x512 xc:black -fill white -draw 'circle 256,256 256,56' \
     \( +clone -fill white -draw 'circle 256,256 256,68' -negate \) \
     -compose multiply -composite \) \
  -compose CopyOpacity -composite \
  /tmp/gradient_ring.png

# Step 4: Composite all layers
magick -size 512x512 xc:none \
  /tmp/gradient_ring.png -composite \
  /tmp/white_ring.png -composite \
  /tmp/profile.png -composite \
  web/favicon.png

# Create other sizes
magick web/favicon.png -resize 192x192 web/icons/Icon-192.png
magick web/favicon.png -resize 512x512 web/icons/Icon-512.png

echo "Favicon created successfully!"
