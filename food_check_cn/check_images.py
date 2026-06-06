from PIL import Image
import os

folder = "C:/Users/ebors/OneDrive/Bilder/matsjekk bilder"
target_w, target_h = 1080, 1920

for i in range(1, 8):
    fname = f"{i}.jpg"
    path = os.path.join(folder, fname)
    if not os.path.exists(path):
        print(f"{fname}: NOT FOUND, skipping")
        continue

    img = Image.open(path)
    orig_w, orig_h = img.size
    print(f"{fname}: {img.size} -> ", end="")

    # Resize so width fits target, maintaining aspect ratio
    scale = target_w / orig_w
    new_w = target_w
    new_h = int(orig_h * scale)
    img = img.resize((new_w, new_h), Image.LANCZOS)

    # Center-crop height to target
    if new_h > target_h:
        top = (new_h - target_h) // 2
        img = img.crop((0, top, new_w, top + target_h))
    
    out_name = f"{i}.1.png"
    out_path = os.path.join(folder, out_name)
    img.save(out_path, "PNG")
    print(f"{out_name}: {img.size} saved")
