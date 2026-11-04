<div align="center">

# 🧠 Universal Agent Memory (v3.0) — Bản Tiếng Việt

**Bộ Quy Tắc Làm Việc, Ghi Nhớ Xuyên Phiên, Kiểm Chứng & Phối Hợp Đa AI (Claude Code, OpenAI Codex, Gemini CLI, Antigravity)**

[![Version](https://img.shields.io/badge/version-v3.0.0-blue.svg)](RELEASE-NOTES.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Type: Agent Skill](https://img.shields.io/badge/Type-Markdown_Agent_Skill-purple.svg)](i18n/vi/SKILL.md)
[![Dependencies: Zero](https://img.shields.io/badge/Dependencies-Zero_(Kh%C3%B4ng_DB_%2F_Kh%C3%B4ng_Server)-brightgreen.svg)](HDSD.md)

🌐 **Ngôn ngữ:** [**English**](README.md) | [**Tiếng Việt (README)**](README.vi.md) | [**Hướng Dẫn Cho Người Không Biết Code (HDSD.md)**](HDSD.md)

</div>

---

## ⚡ Universal Agent Memory là gì?

**Universal Agent Memory (`universal-agent-memory`)** là bộ **Agent Skill + Mỏ neo Global Rules** hoàn toàn bằng Markdown (không cần cài database, server hay CLI phức tạp), được đúc kết từ hơn 1.400 tệp bộ nhớ thực chiến khi phối hợp Claude, Codex và Gemini hàng ngày.

Bộ Skill này dạy cho các AI của bạn kỷ luật làm việc chuẩn:
1. **Đọc đúng & đọc gọn trước khi làm:** Đọc `AGENTS.md` → mục lục `memory/MEMORY.md` → chỉ mở đúng các thẻ liên quan (tiết kiệm tối đa token).
2. **Checkpoint ngay giữa phiên:** Tự lưu trạng thái sau mỗi mốc đã kiểm chứng hoặc trước bước rủi ro cao — hết quota hay đứt phiên giữa chừng vẫn khôi phục tiếp được ngay.
3. **Không phá hỏng công việc đang làm dở (WIP) của AI khác:** Cấm tuyệt đối `git add -A`, `git checkout -- <file>`, và cấm tự ý xóa file ngoài phạm vi (`no-unscoped-delete`).
4. **Phân biệt rõ "Đã làm" (`completed`) với "Đã kiểm chứng" (`verified`) và "Đã lên prod" (`published`):** Chặn đứng bệnh AI báo cáo láo "đã test xong / đã đồng bộ".
5. **Kiểm chéo độc lập (Cross-Review):** Một AI làm, AI kia tự chạy lại test/kiểm chứng độc lập kèm đánh dấu tác giả (`[Claude]`, `[Codex]`, `[Gemini]`).
6. **Áp dụng cho mọi lĩnh vực:** Dùng tốt cho cả lập trình, nghiên cứu, viết lách, nhiếp ảnh, kinh doanh và học tập cá nhân.

---

## 🚀 Cài Đặt Nhanh Trong 30 Giây

### Cách 1: Cài tự động bằng 1 dòng lệnh (macOS / Linux / WSL)

- **Bản Tiếng Việt (cài toàn bộ `SKILL.md` và `Global Rules` bằng tiếng Việt):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.sh | bash -s -- --lang vi
  ```
- **Bản Quốc tế (Tiếng Anh):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.sh | bash
  ```

### Cách 2: Cài tự động trên Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.ps1 | iex
```

### Cách 3: Copy câu lệnh nhờ AI tự cài hộ

Tải repo này về máy, mở Claude Code / Codex / Antigravity và dán câu này:

> Đọc `HDSD.md` và `i18n/vi/rules/README.md` trong thư mục `universal-agent-memory`. Hãy cài bản Tiếng Việt (`i18n/vi/`) vào thư mục skills của các AI đang có trên máy (`~/.claude/skills/universal-agent-memory`, `~/.agents/skills/universal-agent-memory`, `~/.codex/skills/universal-agent-memory`, `~/.gemini/config/skills/universal-agent-memory`) và ghép khối marker `UAM-V3` vào các file Global Rules hiện có mà không ghi đè nội dung cũ. Sau đó kiểm tra đủ 4 lớp (`RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`) và báo kết quả bằng tiếng Việt.

---

## 📖 Xem Hướng Dẫn Chi Tiết

- 👉 [**HDSD.md — Hướng dẫn từng bước cho người không biết code**](HDSD.md)
- 👉 [**Bản Skill Tiếng Việt đầy đủ (`i18n/vi/SKILL.md`)**](i18n/vi/SKILL.md)
- 👉 [**28 Kịch bản kiểm thử hành vi AI (`i18n/vi/TEST-CASES.md`)**](i18n/vi/TEST-CASES.md)

---

## 📄 Giấy phép (License)

Phát hành miễn phí theo giấy phép mở [MIT License](LICENSE).
