<div align="center">

# 🧠 Universal Agent Memory (v3.0) — Bản Tiếng Việt

**Bộ Quy Tắc Làm Việc, Ghi Nhớ Xuyên Phiên, Kiểm Chứng & Phối Hợp Đa AI (Claude Code, OpenAI Codex, Gemini CLI, Antigravity)**

[![Version](https://img.shields.io/badge/version-v3.0.0-blue.svg)](RELEASE-NOTES.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Type: Agent Skill](https://img.shields.io/badge/Type-Markdown_Agent_Skill-purple.svg)](SKILL.md)
[![Dependencies: Zero](https://img.shields.io/badge/Dependencies-Zero_(Kh%C3%B4ng_DB_%2F_Kh%C3%B4ng_Server)-brightgreen.svg)](HDSD.md)

🌐 **Ngôn ngữ:** [**English**](README.md) | [**Tiếng Việt (README)**](README.vi.md) | [**Hướng Dẫn Cho Người Không Biết Code (HDSD.md)**](HDSD.md)

</div>

---

## ⚡ Universal Agent Memory là gì?

**Universal Agent Memory (`universal-agent-memory`)** là bộ **Agent Skill + Mỏ neo Global Rules** hoàn toàn bằng Markdown (không cần cài database, server hay CLI phức tạp), được đúc kết từ một kho dự án đa AI thực chiến (~1.400 tệp dự án và hồ sơ vận hành, trong đó có hơn 110 thẻ memory nguyên tử) khi phối hợp Claude, Codex và Gemini hàng ngày.

Bộ Skill này dạy cho các AI của bạn kỷ luật làm việc chuẩn:
1. **Đọc đúng & đọc gọn trước khi làm:** Đọc `AGENTS.md` → mục lục `memory/MEMORY.md` → chỉ mở đúng các thẻ liên quan (tiết kiệm tối đa token).
2. **Checkpoint ngay giữa phiên:** Lưu trạng thái sau mỗi mốc đã kiểm chứng hoặc trước bước rủi ro cao — giúp giảm thiểu mất tiến độ đã lưu nếu hết quota hay đứt phiên giữa chừng *(lưu ý: các thao tác đang làm dở chưa kịp ghi ra file trước khi crash vẫn cần kiểm tra lại khi mở phiên mới)*.
3. **Không phá hỏng công việc đang làm dở (WIP) của AI khác:** Cấm tuyệt đối `git add -A`, `git checkout -- <file>`, và cấm tự ý xóa file ngoài phạm vi (`no-unscoped-delete`).
4. **Phân biệt rõ "Đã làm" (`completed`) với "Đã kiểm chứng" (`verified`) và "Đã lên prod" (`published`):** Chặn đứng bệnh AI báo cáo láo "đã test xong / đã đồng bộ".
5. **Kiểm chéo độc lập (Cross-Review):** Một AI làm, AI kia tự chạy lại test/kiểm chứng độc lập kèm đánh dấu tác giả (`[Claude]`, `[Codex]`, `[Gemini]`).
6. **Áp dụng cho mọi lĩnh vực:** Dùng tốt cho cả lập trình, nghiên cứu, viết lách, nhiếp ảnh, kinh doanh và học tập cá nhân.

---

## 🚀 Cài Đặt Nhanh

> **Lưu ý an toàn:** Chạy trực tiếp script từ nhánh `main` sẽ thực thi mã mới nhất trên nhánh đó. Để an toàn tối đa, bạn nên **tải script về đọc trước** (hoặc ghim tag cố định `v3.0.0`) và chạy thử với `--dry-run`. Bộ cài tự động tạo bản sao lưu (backup) cho Global Rules và các file Skill đã chỉnh sửa trước khi cập nhật.

### Cách 1: Cài tự động trên macOS / Linux / WSL

**Khuyên dùng (Tải về kiểm tra, xem trước bằng `--dry-run`, rồi cài bản Tiếng Việt):**
```bash
curl -fsSLO https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.sh
less install.sh
bash install.sh --ref v3.0.0 --lang vi --dry-run
bash install.sh --ref v3.0.0 --lang vi
```

**Cài nhanh bằng 1 dòng lệnh (Ghim tag `v3.0.0`):**
- **Bản Tiếng Việt (cài đồng bộ toàn bộ `SKILL.md`, `README.md`, `HDSD.md`, `references/`, `rules/`, `templates/` bằng tiếng Việt):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.sh | bash -s -- --ref v3.0.0 --lang vi
  ```
- **Bản Quốc tế (Tiếng Anh):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.sh | bash -s -- --ref v3.0.0
  ```
- **Chỉ cài cho nền tảng đang dùng (ví dụ chỉ Claude và Codex):** thêm `--platform claude,codex`.

### Cách 2: Cài tự động trên Windows PowerShell

**Khuyên dùng (Tải script về máy, kiểm tra và chạy với tham số `-Lang vi`):**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.ps1" -OutFile "install.ps1"
Get-Content .\install.ps1
.\install.ps1 -Ref v3.0.0 -Lang vi -DryRun
.\install.ps1 -Ref v3.0.0 -Lang vi
```

**Chạy 1 dòng lệnh trên PowerShell (Bản Tiếng Việt, ghim tag `v3.0.0`):**
```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.ps1))) -Ref v3.0.0 -Lang vi
```

### Cách 3: Copy câu lệnh nhờ AI tự cài hộ

Tải repo này về máy, mở Claude Code / Codex / Antigravity và dán câu này:

> Đọc `HDSD.md` và `i18n/vi/rules/README.md` trong thư mục `universal-agent-memory`. Hãy cài bản Tiếng Việt (`i18n/vi/`) vào thư mục skills chuẩn của các AI đang có trên máy (`~/.claude/skills/universal-agent-memory`, `~/.agents/skills/universal-agent-memory`, `~/.gemini/config/skills/universal-agent-memory`), tạo bản backup cho các file Global Rules hiện có rồi ghép khối marker `UAM-V3` vào mà không ghi đè nội dung cũ. Sau đó kiểm tra đủ 4 lớp (`RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`) và báo kết quả bằng tiếng Việt.

---

## 📖 Xem Hướng Dẫn Chi Tiết & Kịch Bản Kiểm Thử

- 👉 [**HDSD.md — Hướng dẫn từng bước cho người không biết code**](HDSD.md)
- 👉 [**SKILL.md — Quy trình vận hành lõi**](SKILL.md) *(Bản Tiếng Việt nằm tại thư mục `i18n/vi/` trong repo hoặc được cài trực tiếp khi dùng `--lang vi`)*
- 👉 [**TEST-CASES.md — 28 Kịch bản nghiệm thu hành vi AI (Thiết kế kiểm thử)**](TEST-CASES.md)
- 👉 [**RELEASE-NOTES.md — Ghi chú phát hành & Trạng thái kiểm chứng**](RELEASE-NOTES.md)

---

## 📄 Giấy phép (License)

Phát hành miễn phí theo giấy phép mở [MIT License](LICENSE).
