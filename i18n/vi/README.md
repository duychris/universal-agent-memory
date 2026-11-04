# Universal Agent Memory v3 — AI Agent Skill

**Một Skill quy định AI làm việc, kiểm chứng, học và bàn giao xuyên phiên — dùng được khi chỉ có một AI; multi-agent là phần mở rộng.** Thuần Markdown, không SaaS, không API/database, không chạy nền.

## Dùng trong 5 bước

1. **Giải nén** ZIP hoặc chạy script cài đặt (`install.sh` / `install.ps1` với `--lang vi`), giữ nguyên folder `universal-agent-memory/`.
2. **Cài Skill** vào thư mục host đọc: Claude `~/.claude/skills/`; Codex + Gemini CLI `~/.agents/skills/`; Antigravity `~/.gemini/config/skills/`.
3. **Ghép Global Rules** từ `rules/` vào file hướng dẫn global của AI (tạo backup trước khi ghép, không ghi đè nội dung cũ).
4. **Chọn kho memory canonical** cho workspace/chủ đề; nếu đã có bộ nhớ, dùng kho đó. Chỉ khởi tạo kho mới khi được phép.
5. **Mở phiên mới và kiểm 4 lớp:** Rules đọc? Skill nạp? Memory truy cập? Lưu/đọc lại đã được kiểm?

➡️ **[Đọc HDSD bằng tiếng Việt (không cần biết code)](HDSD.md)**

## Ba lớp và một hành vi

`Global Rules (startup anchor)` → `Skill (hướng dẫn AI)` → `Memory (dữ liệu thật)`.

**Checkpoint** là hành vi của Skill khi làm việc có tiến độ: ghi sau mốc quan trọng, để phiên mới có thể giảm thiểu mất mát trạng thái đã lưu nếu cuộc chat trước kết thúc bất ngờ.

## Cấu trúc

```text
universal-agent-memory/
├── SKILL.md                         # YAML frontmatter + hướng dẫn trực tiếp AI
├── HDSD.md                          # Hướng dẫn người dùng
├── README.md
├── RELEASE-NOTES.md
├── TEST-CASES.md                    # 28 kịch bản nghiệm thu được thiết kế
├── rules/                            # Global Rules cho từng nền tảng
│   ├── README.md
│   ├── claude-code.md
│   ├── codex.md
│   ├── gemini.md
│   └── antigravity-alternative.md
├── references/                       # Quy trình chi tiết
│   ├── activation-and-checkpoints.md
│   └── ...
├── templates/
│   ├── checkpoint.md
│   └── ...
└── examples/
    └── DEMO-README.md
```

## Những quy tắc cốt lõi

- Đầu việc: đọc ngữ cảnh workspace, memory index và handoff **nếu được phép đọc**.
- Khi làm: giữ scope, kiểm chứng nguồn thật, không hủy WIP và không `git add -A`.
- Khi học: chọn lọc, chống trùng, phân biệt feedback/decision/task; không tự nâng lỗi đơn lẻ thành luật global.
- Khi có mốc: **checkpoint** tiến độ và bằng chứng, tránh phụ thuộc chốt cuối phiên.
- Khi nhiều agent: phân vai, review chéo, kiểm xung đột và trạng thái sync.
- Kết thúc: handoff/changelog đủ để phiên sau tiếp nối, không nói đã làm khi chưa có xác nhận.

## Giới hạn

Global Rules/Skill là **chỉ dẫn**, không phải một hệ thống cưỡng chế kỹ thuật. Skill không nạp vào phiên khi host không hỗ trợ hoặc không cấp quyền; không thể tự lưu nếu không có filesystem/kho kết nối. Không có đồng bộ ngầm giữa máy/tài khoản/cloud và không phát hiện mọi sự cố bất ngờ.

**Nguồn thiết kế:** khái quát từ kho dự án đa AI thực chiến (~1.400 tệp dự án và hồ sơ vận hành, trong đó có hơn 110 thẻ memory nguyên tử) và so sánh các dự án agent memory/learning/handoff công khai, hoàn toàn độc lập với mọi nghiệp vụ chuyên ngành.
