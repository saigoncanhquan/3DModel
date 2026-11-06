#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Công cụ tự động hóa khởi tạo trang mô hình 3D mới cho Saigon Cảnh Quan.
Cách dùng:
    python add_model.py --id sh-3 --title "Mô hình 3D sh-3" --desc "Mô tả chi tiết"
"""

import os
import sys
import json
import argparse
from datetime import datetime

def create_model_page(model_id, title, desc, category="CAD Components", author="Saigon Cảnh Quan"):
    base_dir = os.path.dirname(os.path.abspath(__file__))
    model_dir = os.path.join(base_dir, "docs", "models", model_id)
    os.makedirs(model_dir, exist_ok=True)
    today_str = datetime.now().strftime("%Y-%m-%d")

    # 1. Đọc template từ sh-2 nếu có hoặc dùng template chuẩn
    template_path = os.path.join(base_dir, "docs", "models", "sh-2", "index.html")
    if os.path.exists(template_path):
        with open(template_path, "r", encoding="utf-8") as f:
            content = f.read()
        
        # Thay thế metadata
        content = content.replace("sh-2", model_id)
        content = content.replace("Mô hình 3D sh-2", title)
        content = content.replace("Mô hình 3D CAD sh-2 phục vụ thiết kế kỹ thuật và phối cảnh kiến trúc Saigon Cảnh Quan.", desc)
        content = content.replace("Chi tiết linh kiện 3D CAD kỹ thuật phục vụ cảnh quan & công trình. Tối ưu hiển thị WebGL PBR mượt mà.", desc)
    else:
        print("[!] Không tìm thấy template sh-2, vui lòng kiểm tra lại cấu trúc.")
        return False

    index_file = os.path.join(model_dir, "index.html")
    with open(index_file, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"[✓] Đã tạo trang con: docs/models/{model_id}/index.html")

    # 2. Tạo placeholder model.glb nếu chưa có
    glb_dest = os.path.join(model_dir, "model.glb")
    if not os.path.exists(glb_dest):
        glb_src = os.path.join(base_dir, "docs", "models", "sh-2", "model.glb")
        if os.path.exists(glb_src):
            import shutil
            shutil.copyfile(glb_src, glb_dest)
            print(f"[✓] Đã sao chép model.glb mẫu vào docs/models/{model_id}/model.glb")

    # 3. Tạo placeholder thumbnail thumb.png
    thumb_dest = os.path.join(model_dir, "thumb.png")
    if not os.path.exists(thumb_dest):
        try:
            from PIL import Image, ImageDraw, ImageFont
            w, h = 800, 500
            img = Image.new('RGB', (w, h), (11, 15, 25))
            draw = ImageDraw.Draw(img)
            for y in range(h):
                interp = y / h
                draw.line([(0, y), (w, y)], fill=(int(11 + interp * 15), int(15 + interp * 20), int(25 + interp * 35)))
            cx, cy = w // 2, h // 2 - 20
            poly = [(cx, cy - 110), (cx + 120, cy - 20), (cx, cy + 80), (cx - 120, cy - 20)]
            draw.polygon(poly, fill=(15, 76, 129), outline=(56, 189, 248), width=2)
            draw.line([(cx, cy - 110), (cx, cy + 80)], fill=(125, 211, 252), width=2)
            draw.rectangle([(0, h - 90), (w, h)], fill=(15, 23, 42))
            draw.line([(0, h - 90), (w, h - 90)], fill=(56, 189, 248), width=2)
            try:
                font_l = ImageFont.truetype('arial.ttf', 24)
                font_s = ImageFont.truetype('arial.ttf', 14)
            except:
                font_l = ImageFont.load_default()
                font_s = ImageFont.load_default()
            draw.text((24, h - 75), f"Mô hình 3D: {model_id}", fill=(248, 250, 252), font=font_l)
            draw.text((24, h - 42), f"{title} · {author}", fill=(148, 163, 184), font=font_s)
            img.save(thumb_dest)
            print(f"[✓] Đã tạo ảnh đại diện: docs/models/{model_id}/thumb.png")
        except Exception as e:
            # Fallback copy
            thumb_src = os.path.join(base_dir, "docs", "models", "sh-2", "thumb.png")
            if os.path.exists(thumb_src):
                import shutil
                shutil.copyfile(thumb_src, thumb_dest)
                print(f"[✓] Đã sao chép thumb.png mẫu: docs/models/{model_id}/thumb.png")

    # 4. Cập nhật catalog models.json
    catalog_path = os.path.join(base_dir, "docs", "models", "models.json")
    catalog = []
    if os.path.exists(catalog_path):
        try:
            with open(catalog_path, "r", encoding="utf-8") as f:
                catalog = json.load(f)
        except:
            catalog = []

    # Kiểm tra xem id đã tồn tại chưa
    existing = False
    for item in catalog:
        if item.get("id") == model_id:
            item["title"] = title
            item["description"] = desc
            item["category"] = category
            item["author"] = author
            existing = True
            break
    
    if not existing:
        catalog.append({
            "id": model_id,
            "title": title,
            "description": desc,
            "thumbnail": f"models/{model_id}/thumb.png",
            "modelPath": f"models/{model_id}/model.glb",
            "pageUrl": f"models/{model_id}/index.html",
            "category": category,
            "format": "GLB / 3D",
            "date": today_str,
            "author": author
        })

    with open(catalog_path, "w", encoding="utf-8") as f:
        json.dump(catalog, f, ensure_ascii=False, indent=2)
    print(f"[✓] Đã cập nhật danh mục: docs/models/models.json")

    print(f"\n[DONE] Hoàn tất thêm mô hình '{model_id}'. Bạn chỉ cần chép file 3D thật vào:")
    print(f"       -> docs/models/{model_id}/model.glb")
    print(f"       và chạy 'deploy.bat' để đẩy lên GitHub Pages!\n")
    return True

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Tạo mô hình 3D mới cho Saigon Cảnh Quan")
    parser.add_argument("--id", required=True, help="Mã ID thư mục mô hình (ví dụ: sh-2, sh-3)")
    parser.add_argument("--title", default=None, help="Tiêu đề hiển thị của mô hình")
    parser.add_argument("--desc", default=None, help="Mô tả ngắn của mô hình")
    parser.add_argument("--cat", default="CAD Components", help="Phân loại danh mục")
    parser.add_argument("--author", default="Saigon Cảnh Quan", help="Tên tác giả/đơn vị")
    
    args = parser.parse_args()
    title = args.title or f"Mô hình 3D {args.id}"
    desc = args.desc or f"Chi tiết linh kiện 3D CAD kỹ thuật phục vụ cảnh quan & công trình."
    create_model_page(args.id, title, desc, args.cat, args.author)

