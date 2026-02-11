#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math

# Configuration
WIDTH = 1200
HEIGHT = 630
CENTER_X = WIDTH // 2
CENTER_Y = HEIGHT // 2 - 50  # Slightly higher to make room for text

# Colors (matching hero section)
DARK_BG = (10, 10, 15)  # #0A0A0F
PURPLE = (99, 102, 241)  # #6366F1
CYAN = (34, 211, 238)    # #22D3EE
WHITE = (255, 255, 255)

# Profile circle settings
PROFILE_RADIUS = 200
GRADIENT_WIDTH = 8
WHITE_RING_WIDTH = 4
GLOW_RADIUS = 40

# Create base image with dark background
img = Image.new('RGB', (WIDTH, HEIGHT), DARK_BG)
draw = ImageDraw.Draw(img)

# Add subtle particles/dots in background
import random
random.seed(42)
for _ in range(50):
    x = random.randint(0, WIDTH)
    y = random.randint(0, HEIGHT)
    size = random.randint(1, 3)
    opacity = random.randint(50, 150)
    color = PURPLE if random.random() > 0.5 else CYAN
    # Blend the color with opacity
    blended = tuple(int(DARK_BG[i] + (color[i] - DARK_BG[i]) * opacity / 255) for i in range(3))
    draw.ellipse([x, y, x+size, y+size], fill=blended)

# Create gradient glow layer
glow_layer = Image.new('RGBA', (WIDTH, HEIGHT), (0, 0, 0, 0))
glow_draw = ImageDraw.Draw(glow_layer)

# Draw gradient glow (multiple circles with decreasing opacity)
for i in range(GLOW_RADIUS, 0, -2):
    t = i / GLOW_RADIUS
    opacity = int(30 * (1 - t))  # Fade out as we go outward
    
    # Interpolate between purple and cyan
    r = int(PURPLE[0] + (CYAN[0] - PURPLE[0]) * 0.5)
    g = int(PURPLE[1] + (CYAN[1] - PURPLE[1]) * 0.5)
    b = int(PURPLE[2] + (CYAN[2] - PURPLE[2]) * 0.5)
    
    radius = PROFILE_RADIUS + GRADIENT_WIDTH + WHITE_RING_WIDTH + i
    glow_draw.ellipse(
        [CENTER_X - radius, CENTER_Y - radius, CENTER_X + radius, CENTER_Y + radius],
        outline=(r, g, b, opacity),
        width=2
    )

# Apply blur to glow
glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(radius=15))
img.paste(glow_layer, (0, 0), glow_layer)

# Draw gradient border ring
for i in range(GRADIENT_WIDTH):
    t = i / GRADIENT_WIDTH
    # Interpolate between purple and cyan
    r = int(PURPLE[0] + (CYAN[0] - PURPLE[0]) * t)
    g = int(PURPLE[1] + (CYAN[1] - PURPLE[1]) * t)
    b = int(PURPLE[2] + (CYAN[2] - PURPLE[2]) * t)
    
    radius = PROFILE_RADIUS + WHITE_RING_WIDTH + GRADIENT_WIDTH - i
    draw.ellipse(
        [CENTER_X - radius, CENTER_Y - radius, CENTER_X + radius, CENTER_Y + radius],
        outline=(r, g, b),
        width=1
    )

# Draw white ring
white_radius = PROFILE_RADIUS + WHITE_RING_WIDTH
for i in range(WHITE_RING_WIDTH):
    radius = white_radius - i
    draw.ellipse(
        [CENTER_X - radius, CENTER_Y - radius, CENTER_X + radius, CENTER_Y + radius],
        outline=WHITE,
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
profile_pos_x = CENTER_X - PROFILE_RADIUS
profile_pos_y = CENTER_Y - PROFILE_RADIUS
img.paste(profile_with_alpha, (profile_pos_x, profile_pos_y), profile_with_alpha)

# Add text below the profile
text_y = CENTER_Y + PROFILE_RADIUS + 40

# Try to use a nice font, fallback to default
try:
    name_font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Bold.ttf", 48)
    title_font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", 32)
except:
    name_font = ImageFont.load_default()
    title_font = ImageFont.load_default()

# Draw name with shadow
name_text = "Akshay Chand T"
name_bbox = draw.textbbox((0, 0), name_text, font=name_font)
name_width = name_bbox[2] - name_bbox[0]
name_x = CENTER_X - name_width // 2

# Shadow
draw.text((name_x + 2, text_y + 2), name_text, fill=(0, 0, 0, 128), font=name_font)
# Main text
draw.text((name_x, text_y), name_text, fill=WHITE, font=name_font)

# Draw title
title_text = "Flutter Developer"
title_bbox = draw.textbbox((0, 0), title_text, font=title_font)
title_width = title_bbox[2] - title_bbox[0]
title_x = CENTER_X - title_width // 2
title_y = text_y + 60

# Shadow
draw.text((title_x + 2, title_y + 2), title_text, fill=(0, 0, 0, 128), font=title_font)
# Main text in cyan
draw.text((title_x, title_y), title_text, fill=CYAN, font=title_font)

# Save
img.save('web/og-image.png', 'PNG')

print("✅ Professional og-image created successfully!")
print("   - Dark background matching hero section")
print("   - Gradient border with glow effect")
print("   - Your name and title included")
