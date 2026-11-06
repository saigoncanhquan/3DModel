# Saigon Cảnh Quan - Thư Viện Mô Hình 3D Trực Tuyến

Hệ sinh thái lưu trữ, quản lý và trình chiếu mô hình 3D (CAD / Cảnh quan / Kiến trúc) trực tiếp trên trình duyệt web thông qua GitHub Pages, hỗ trợ WebGL 3D tương tác 360 độ và Thực tế ảo (AR).

🔗 **Website chính thức (GitHub Pages):** [https://saigoncanhquan.github.io/3DModel/](https://saigoncanhquan.github.io/3DModel/)  
🔗 **Repository:** [https://github.com/saigoncanhquan/3DModel](https://github.com/saigoncanhquan/3DModel)

---

## 📁 Cấu Trúc Dự Án Chuẩn

```text
3DModel/
├── index.html                   # Chuyển hướng tự động về docs/index.html
├── deploy.bat                   # Script One-Click đẩy lên GitHub (Command Prompt)
├── deploy.ps1                   # Script One-Click đẩy lên GitHub (PowerShell)
├── add_model.py                 # Script tự động khởi tạo mô hình con mới
├── README.md                    # Tài liệu hướng dẫn sử dụng
└── docs/                        # Thư mục kích hoạt GitHub Pages
    ├── index.html               # Trang chủ tổng (Lưới Grid Cards, Tìm kiếm, Lọc danh mục)
    ├── _config.yml              # File cấu hình Jekyll cho GitHub Pages
    ├── .nojekyll                # Vô hiệu hóa Jekyll để nạp đầy đủ tài nguyên tĩnh
    └── models/                  # Chứa toàn bộ các mô hình 3D con
        ├── models.json          # Danh mục metadata tự động quét của các mô hình
        └── sh-2/                # Thư mục mô hình con ví dụ (sh-2)
            ├── index.html       # Trình xem 3D chuyên dụng (<model-viewer> PBR, AR)
            ├── model.glb        # File mô hình 3D (.glb / .gltf)
            └── thumb.png        # Ảnh đại diện mô hình
```

---

## 🚀 Hướng Dẫn Thêm Mô Hình Mới

### Cách 1: Tự động bằng Script (Khuyên Dùng)
Mở Terminal/PowerShell tại thư mục dự án và chạy:
```bash
python add_model.py --id sh-3 --title "Mô hình 3D sh-3" --desc "Mô tả chi tiết mô hình cảnh quan"
```
*Script sẽ tự động tạo thư mục `docs/models/sh-3/`, trang `index.html`, ảnh `thumb.png` và cập nhật danh mục `models.json`.*

Sau đó chỉ cần:
1. Chép file 3D thật vào: `docs/models/sh-3/model.glb`
2. Chép ảnh chụp đại diện vào: `docs/models/sh-3/thumb.png` (khuyến nghị tỷ lệ 16:9 hoặc 800x500px)

---

### Cách 2: Tạo Thủ Công Theo Quy Chuẩn
1. Tạo thư mục: `docs/models/<tên-mã-mô-hình>/` (Ví dụ: `docs/models/sh-2/`)
2. Đặt các file vào thư mục:
   - `model.glb` (File 3D định dạng glTF 2.0 Binary)
   - `thumb.png` (Ảnh thumbnail xem trước)
   - `index.html` (Trình xem 3D dựa trên mẫu của `docs/models/sh-2/index.html`)
3. Khai báo Metadata ở đầu file `index.html`:
   ```html
   <title>Mô hình 3D [Tên Mã] · Saigon Cảnh Quan</title>
   <meta name="model:id" content="[mã-id]" />
   <meta name="model:title" content="[Tiêu đề]" />
   <meta name="model:thumbnail" content="thumb.png" />
   <meta name="model:src" content="model.glb" />
   <meta name="model:description" content="[Mô tả ngắn]" />
   ```
4. Đăng ký thông tin mô hình vào file `docs/models/models.json`.

---

## ⚡ Đồng Bộ Lên GitHub (One-Click Deploy)

Sau khi thêm hoặc chỉnh sửa mô hình, chỉ cần thực hiện 1 thao tác duy nhất:

### Trên Windows Explorer:
- **Nhấp đúp chuột vào file `deploy.bat`**  
  *Script sẽ tự động chạy `git add`, `git commit` kèm timestamp và `git push origin main` lên GitHub, thông báo thành công và tự đóng sau 3 giây.*

### Hoặc qua Command Line:
```cmd
# Chạy với commit message tự động theo thời gian:
deploy.bat

# Hoặc truyền commit message tùy chỉnh:
deploy.bat "Cập nhật mô hình sh-2 và bổ sung sh-3"
```

### Qua PowerShell:
```powershell
.\deploy.ps1 -Message "Thêm mô hình cảnh quan sh-3"
```

---

## 🌐 Kích Hoạt GitHub Pages

1. Truy cập Repository: **Settings** > **Pages**
2. Tại mục **Build and deployment**:
   - **Source:** `Deploy from a branch`
   - **Branch:** `main`
   - **Folder:** `/docs`
3. Bấm **Save**. Trang web sẽ hiển thị trực tuyến tại:  
   👉 **`https://saigoncanhquan.github.io/3DModel/`**

---
© 2026 Saigon Cảnh Quan. Bảo lưu mọi bản quyền.
