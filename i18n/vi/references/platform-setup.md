# Cài đặt và xác minh theo nền tảng — 2026-11-05

**Đây là các vị trí dựa trên tài liệu chính thức.** Nếu môi trường cụ thể khác phiên bản hoặc chính sách quản trị, kiểm tra host trước khi cài.

| Host | Global Skill | Global Rules | Kích hoạt/xác minh |
|---|---|---|---|
| Claude Code | `~/.claude/skills/universal-agent-memory/SKILL.md` | `~/.claude/CLAUDE.md` | `/universal-agent-memory`, kiểm `/memory`, hỏi file đã nạp |
| Codex | `~/.agents/skills/universal-agent-memory/SKILL.md` | `~/.codex/AGENTS.md` | `$universal-agent-memory`, hỏi source SKILL.md |
| Gemini CLI | `~/.agents/skills/universal-agent-memory/SKILL.md` (hoặc `~/.gemini/skills/...`) | `~/.gemini/GEMINI.md` | `/skills list`, `/skills reload`, xác nhận activate |
| Antigravity IDE/App | `~/.gemini/config/skills/universal-agent-memory/SKILL.md` | `~/.gemini/GEMINI.md` hoặc `~/.gemini/config/AGENTS.md` | Customizations → Skills/Rules, `/universal-agent-memory` khi hỗ trợ |

- Nếu cả Gemini và Antigravity cùng quét `~/.gemini/GEMINI.md`, **chỉ một mỏ neo** ở file đó là đủ. Không cài trùng khối UAM ở 2 global rules khác nhau.
- Với project scope, dùng `.claude/skills` (Claude), `.agents/skills` (Codex/Gemini/Antigravity) và file hướng dẫn phù hợp dự án. **Không ghi đè** `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` đang tồn tại.
- Không giả định Claude Code cloud/Cowork đọc `~/.claude/skills` ở máy local; cloud có cơ chế skills khác và có thể yêu cầu cài qua tài khoản hoặc repo.
- Nếu user có nhiều bản skill copy ở nhiều folder, cập nhật **từng bản** hoặc kiểm alias/symlink an toàn. Không coi cùng tên là cùng phiên bản.
- Nếu host không cho đọc filesystem/connector ngoài cuộc chat, Skill này chỉ có thể hướng dẫn trong phiên, **không thể đảm bảo lưu bền vững**.
- Kết hợp Skill và Global Rules: rules chỉ dẫn khi nào cần nạp `SKILL.md`; bản thân Skill **không phải startup hook**.

## Nguồn đối chiếu

- Claude Code skills: https://code.claude.com/docs/en/skills
- Claude Code user memory/instructions: https://code.claude.com/docs/en/memory
- Codex skills: https://learn.chatgpt.com/docs/build-skills
- Codex AGENTS.md: https://learn.chatgpt.com/docs/agent-configuration/agents-md
- Gemini CLI skills: https://geminicli.com/docs/cli/skills/
- Gemini CLI global context: https://geminicli.com/docs/cli/gemini-md/
- Antigravity skills: https://antigravity.google/docs/skills
- Antigravity global rules: https://antigravity.google/docs/rules/
