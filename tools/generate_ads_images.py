"""Generate Google Ads asset-group images (DE/NO/EN) for Matsjekk.

Produces the image formats Google Ads requires for a full asset group so a
language group is no longer "limited by incomplete elements":

  * Landscape 1.91:1   -> 1200 x 628
  * Square    1:1      -> 1200 x 1200
  * Portrait  4:5      -> 960  x 1200
  * Logo      1:1      -> 1200 x 1200
  * Logo      4:1      -> 1200 x 300

One set is written per language into Bilder/google-ads-<lang>/.
Brand palette is taken from the website (docs/styles.css) and the app icon.
Run with the project venv:  .venv\\Scripts\\python.exe tools\\generate_ads_images.py
"""

from __future__ import annotations

import os
from PIL import Image, ImageDraw, ImageFont

# --- Paths -----------------------------------------------------------------
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ICON_PATH = os.path.join(ROOT, "assets", "icon", "icon.png")
BILDER_DIR = os.path.join(ROOT, "Bilder")

# --- Brand palette ---------------------------------------------------------
GREEN_TOP = (47, 127, 79)      # #2f7f4f
GREEN_MID = (31, 106, 63)      # #1f6a3f
TEAL_BOT = (22, 79, 90)        # #164f5a
ACCENT = (76, 175, 80)         # #4CAF50
DARK = (32, 48, 63)            # #20303f
WHITE = (255, 255, 255)

BRAND = "Matsjekk"

# --- Localized marketing copy ----------------------------------------------
# Several short messages per language so we can emit multiple distinct image
# variants per aspect ratio (Google Ads wants variety to reach high quality).
COPY = {
    "de": {
        "cta": "Jetzt kostenlos",
        "messages": [
            ("Bewusst einkaufen leicht gemacht",
             "Lebensmittel scannen und Risiken erkennen"),
            ("Wissen, was drin ist",
             "Bovaer, GMO und mehr im Blick"),
            ("Über 60.000 Hofläden",
             "Lokale Erzeuger in ganz Europa finden"),
        ],
    },
    "no": {
        "cta": "Last ned gratis",
        "messages": [
            ("Bevisste matvalg, enkelt",
             "Skann maten og oppdag risikoene"),
            ("Vit hva som er i maten",
             "Bovaer, GMO og mer – rett i lomma"),
            ("Over 60 000 gårdsbutikker",
             "Finn lokale produsenter i hele Europa"),
        ],
    },
    "en": {
        "cta": "Get it free",
        "messages": [
            ("Conscious shopping made simple",
             "Scan your food and spot the risks"),
            ("Know what's really inside",
             "Bovaer, GMO and more at a glance"),
            ("Over 60,000 farm shops",
             "Find local producers across Europe"),
        ],
    },
}

FONT_DIR = r"C:\Windows\Fonts"


def font(name: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(os.path.join(FONT_DIR, name), size)


def gradient(size: tuple[int, int], variant: int = 0) -> Image.Image:
    """Diagonal 3-stop brand gradient. `variant` swaps the colour emphasis."""
    palettes = [
        (GREEN_TOP, GREEN_MID, TEAL_BOT),   # green -> teal
        (TEAL_BOT, GREEN_MID, GREEN_TOP),   # teal -> green (reversed)
        (GREEN_MID, ACCENT, GREEN_TOP),     # brighter green
    ]
    c0, c1, c2 = palettes[variant % len(palettes)]
    w, h = size
    base = Image.new("RGB", (w, h), c1)
    px = base.load()
    diag = w + h
    for y in range(h):
        for x in range(w):
            t = (x + y) / diag
            if t < 0.5:
                k = t / 0.5
                r = int(c0[0] + (c1[0] - c0[0]) * k)
                g = int(c0[1] + (c1[1] - c0[1]) * k)
                b = int(c0[2] + (c1[2] - c0[2]) * k)
            else:
                k = (t - 0.5) / 0.5
                r = int(c1[0] + (c2[0] - c1[0]) * k)
                g = int(c1[1] + (c2[1] - c1[1]) * k)
                b = int(c1[2] + (c2[2] - c1[2]) * k)
            px[x, y] = (r, g, b)
    return base


def load_cart(color: tuple[int, int, int]) -> Image.Image:
    """Load the cart icon, trim whitespace, recolor to `color`, keep alpha.

    Works whether the source has a transparent background (use its alpha as
    the silhouette) or is an opaque dark-on-white image (derive a mask from
    darkness).
    """
    img = Image.open(ICON_PATH).convert("RGBA")
    px = img.load()
    w, h = img.size
    minx, miny, maxx, maxy = w, h, 0, 0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 128:
                alpha = 0  # outside the artwork -> fully transparent
            else:
                lum = (r + g + b) / 3
                alpha = max(0, min(255, int(255 - lum)))  # dark ink -> opaque
            px[x, y] = (color[0], color[1], color[2], alpha)
            if alpha > 40:
                minx, miny = min(minx, x), min(miny, y)
                maxx, maxy = max(maxx, x), max(maxy, y)
    if maxx <= minx or maxy <= miny:
        return img
    return img.crop((minx, miny, maxx + 1, maxy + 1))


def fit(cart: Image.Image, target_h: int) -> Image.Image:
    ratio = target_h / cart.height
    return cart.resize((int(cart.width * ratio), target_h), Image.LANCZOS)


def center_text(draw, cx, y, text, fnt, fill):
    bbox = draw.textbbox((0, 0), text, font=fnt)
    tw = bbox[2] - bbox[0]
    draw.text((cx - tw / 2, y), text, font=fnt, fill=fill)
    return bbox[3] - bbox[1]


def pill(draw, cx, y, text, fnt, pad_x=34, pad_y=16):
    bbox = draw.textbbox((0, 0), text, font=fnt)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    w = tw + pad_x * 2
    h = th + pad_y * 2
    x0 = cx - w / 2
    draw.rounded_rectangle([x0, y, x0 + w, y + h], radius=h / 2, fill=WHITE)
    draw.text((cx - tw / 2, y + pad_y - bbox[1]), text, font=fnt, fill=GREEN_MID)
    return h


def make_landscape(msg, cta, variant, out_dir, idx):
    tagline, subline = msg
    W, H = 1200, 628
    img = gradient((W, H), variant)
    d = ImageDraw.Draw(img)
    cart = fit(load_cart(WHITE), 250)
    cart_x, cart_y = 90, (H - cart.height) // 2
    img.paste(cart, (cart_x, cart_y), cart)
    tx = cart_x + cart.width + 70
    d.text((tx, 175), BRAND, font=font("arialbd.ttf", 96), fill=WHITE)
    d.text((tx, 300), tagline, font=font("arial.ttf", 38), fill=WHITE)
    d.text((tx, 358), subline, font=font("arial.ttf", 28),
           fill=(225, 240, 230))
    pill(d, tx + 150, 430, cta, font("arialbd.ttf", 30))
    img.save(os.path.join(out_dir, f"matsjekk_landscape_1200x628_{idx}.png"))


def make_square(msg, cta, variant, out_dir, idx):
    tagline, subline = msg
    W, H = 1200, 1200
    img = gradient((W, H), variant)
    d = ImageDraw.Draw(img)
    cart = fit(load_cart(WHITE), 360)
    img.paste(cart, ((W - cart.width) // 2, 250), cart)
    center_text(d, W / 2, 660, BRAND, font("arialbd.ttf", 130), WHITE)
    center_text(d, W / 2, 830, tagline, font("arial.ttf", 44), WHITE)
    center_text(d, W / 2, 900, subline, font("arial.ttf", 32),
                (225, 240, 230))
    pill(d, W / 2, 1010, cta, font("arialbd.ttf", 40))
    img.save(os.path.join(out_dir, f"matsjekk_square_1200x1200_{idx}.png"))


def make_portrait(msg, cta, variant, out_dir, idx):
    tagline, subline = msg
    W, H = 960, 1200
    img = gradient((W, H), variant)
    d = ImageDraw.Draw(img)
    cart = fit(load_cart(WHITE), 330)
    img.paste(cart, ((W - cart.width) // 2, 230), cart)
    center_text(d, W / 2, 620, BRAND, font("arialbd.ttf", 110), WHITE)
    center_text(d, W / 2, 770, tagline, font("arial.ttf", 38), WHITE)
    center_text(d, W / 2, 830, subline, font("arial.ttf", 28),
                (225, 240, 230))
    pill(d, W / 2, 940, cta, font("arialbd.ttf", 36))
    img.save(os.path.join(out_dir, f"matsjekk_portrait_960x1200_{idx}.png"))


def make_logo_square(out_dir):
    """Clean logo: cart icon centred with generous safe-zone padding so Google
    can crop it without clipping any text (no wordmark on this one)."""
    W, H = 1200, 1200
    img = Image.new("RGB", (W, H), WHITE)
    cart = fit(load_cart(DARK), 560)
    img.paste(cart, ((W - cart.width) // 2, (H - cart.height) // 2), cart)
    img.save(os.path.join(out_dir, "matsjekk_logo_1200x1200.png"))


def make_logo_landscape(out_dir):
    W, H = 1200, 300
    img = Image.new("RGB", (W, H), WHITE)
    d = ImageDraw.Draw(img)
    cart = fit(load_cart(DARK), 170)
    fnt = font("arialbd.ttf", 130)
    total_w = cart.width + 40 + _text_w(d, BRAND, fnt)
    start = (W - total_w) // 2
    img.paste(cart, (start, (H - cart.height) // 2), cart)
    bbox = d.textbbox((0, 0), BRAND, font=fnt)
    d.text((start + cart.width + 40, (H - (bbox[3] - bbox[1])) // 2 - bbox[1]),
           BRAND, font=fnt, fill=DARK)
    img.save(os.path.join(out_dir, "matsjekk_logo_1200x300.png"))


def _text_w(d, text, fnt):
    bbox = d.textbbox((0, 0), text, font=fnt)
    return bbox[2] - bbox[0]


def main():
    for lang, copy in COPY.items():
        out_dir = os.path.join(BILDER_DIR, f"google-ads-{lang}")
        os.makedirs(out_dir, exist_ok=True)
        msgs = copy["messages"]
        cta = copy["cta"]
        # 3 landscape, 2 square, 2 portrait -> satisfies Google's variety ask.
        for i in range(3):
            make_landscape(msgs[i % len(msgs)], cta, i, out_dir, i + 1)
        for i in range(2):
            make_square(msgs[i % len(msgs)], cta, i, out_dir, i + 1)
        for i in range(2):
            make_portrait(msgs[i % len(msgs)], cta, i, out_dir, i + 1)
        make_logo_square(out_dir)
        make_logo_landscape(out_dir)
        print(f"[{lang}] saved images to", out_dir)
        for f in sorted(os.listdir(out_dir)):
            print("  -", f)


if __name__ == "__main__":
    main()
