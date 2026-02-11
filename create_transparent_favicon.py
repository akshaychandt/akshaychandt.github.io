#!/usr/bin/env python3
from PIL import Image, ImageDraw
import math

# Configuration
SIZE = 512
CENTER = SIZE // 2
OUTER_RADIUS = 256
GRADIENT_WIDTH = 12
WHITE_WIDTH = 6
PROFILE_RADIUS = OUTER_RADIUS - GRADIENT_WIDTH - WHITE_WIDTH

# Colors
PURPLE = (99, 102, 241)  # #6366F1
CYAN = (34, 211, 238)    # #22D3EE
WHITE = (255, 255, 255)

# Create base image with transparency
img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Draw gradient ring (simplified as multiple circles with interpolated colors)
for i in range(GRADIENT_WIDTH):
    t = i / GRADIENT_WIDTH
    # Interpolate between purple and cyan
    r = int(PURPLE[0] + (CYAN[0] - PURPLE[0]) * t)
    g = int(PURPLE[1] + (CYAN[1] - PURPLE[1]) * t)
    b = int(PURPLE[2] + (CYAN[2] - PURPLE[2]) * t)
    
    radius = OUTER_RADIUS - i
    draw.ellipse(
        [CENTER - radius, CENTER - radius, CENTER + radius, CENTER + radius],
        outline=(r, g, b, 255),
        width=1
    )

# Draw white ring
white_outer = OUTER_RADIUS - GRADIENT_WIDTH
white_inner = white_outer - WHITE_WIDTH
for i in range(WHITE_WIDTH):
    radius = white_outer - i
    draw.ellipse(
        [CENTER - radius, CENTER - radius, CENTER + radius, CENTER + radius],
        outline=WHITE + (255,),
        width=1
    )

# Load and process profile image
profile = Image.open('assets/images/profile_dark.jpg').convert('RGB')

# Resize profile to fit
profile_size = PROFILE_RADIUS * 2
profile = profile.resize((profile_size, profile_size), Image.Resampling.LANCZOS)

# Create circular mask for profile
mask = Image.new('L', (profile_size, profile_size), 0)
mask_draw = ImageDraw.Draw(mask)
mask_draw.ellipse([0, 0, profile_size, profile_size], fill=255)

# Apply mask to profile
profile_with_alpha = Image.new('RGBA', (profile_size, profile_size), (0, 0, 0, 0))
profile_with_alpha.paste(profile, (0, 0))
profile_with_alpha.putalpha(mask)

# Paste profile onto main image
profile_pos = CENTER - PROFILE_RADIUS
img.paste(profile_with_alpha, (profile_pos, profile_pos), profile_with_alpha)

# Save favicon
img.save('web/favicon.png', 'PNG')

# Create other sizes
img.resize((192, 192), Image.Resampling.LANCZOS).save('web/icons/Icon-192.png', 'PNG')
img.resize((512, 512), Image.Resampling.LANCZOS).save('web/icons/Icon-512.png', 'PNG')

print("✅ Transparent circular favicon created successfully!")
print(f"   - web/favicon.png (512x512)")
print(f"   - web/icons/Icon-192.png (192x192)")
print(f"   - web/icons/Icon-512.png (512x512)")
