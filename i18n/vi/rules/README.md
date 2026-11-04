# Global Rules — mỏ neo để Skill được dùng xuyên phiên

**Đây không phải hook tự chạy.** Các file này là *mẫu đoạn hướng dẫn* để **ghép có kiểm soát** vào file global của từng sản phẩm. Không chép đè nguyên file global hiện có.

| Nền tảng | Mẫu lấy nội dung | Vị trí global |
|---|---|---|
| Claude Code | `claude-code.md` | `~/.claude/CLAUDE.md` |
| Codex | `codex.md` | `~/.codex/AGENTS.md` |
| Gemini CLI | `gemini.md` | `~/.gemini/GEMINI.md` |
| Antigravity (nếu không cùng Gemini CLI) | `antigravity-alternative.md` | `~/.gemini/config/AGENTS.md` hoặc Global Rules UI |

**Trên máy có cả Gemini CLI và Antigravity:** hai bên có thể cùng nạp `~/.gemini/GEMINI.md`. **Mặc định chỉ cài `gemini.md` tại đó**, không cài thêm bản `antigravity-alternative.md` để tránh trùng. Xác minh cấu hình của bản đang dùng.

Mỗi mẫu có marker `<!-- UAM-V3:BEGIN -->` và `<!-- UAM-V3:END -->` để khi nâng cấp, chỉ sửa đúng đoạn đó. Nếu file global đã có cùng marker thì cập nhật đoạn bên trong; nếu chưa có thì nối cuối (giữ nội dung khác). Không cố thay thế các quy tắc bảo mật hay đặc thù workspace. Nếu có mâu thuẫn, báo cho người phụ trách.

**Khi làm ở cloud:** copy rules và skill vào môi trường cloud được hỗ trợ/cho phép; cấu hình local không tự đi theo tài khoản.
