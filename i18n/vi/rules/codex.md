# Codex — CHỈ COPY KHỐI MARKER VÀO `~/.codex/AGENTS.md`

<!-- UAM-V3:BEGIN -->
## Universal Agent Memory v3 — Persistent working discipline
- Với việc nhiều bước hoặc cần kế thừa qua phiên: nạp Skill `universal-agent-memory` từ `~/.agents/skills/universal-agent-memory/SKILL.md` (bằng cơ chế kích hoạt của host hoặc đọc trực tiếp nếu được cấp quyền).
- Trước khi hành động: đọc hướng dẫn workspace, `memory/MEMORY.md` hoặc kho canonical đã được cấu hình, và handoff/checkpoint liên quan; xác minh nguồn và phạm vi. Nếu không có kho nhớ, KHÔNG tự tạo bản song song.
- Trong việc dài: checkpoint sau mốc đã xác minh / quyết định quan trọng / trước bàn giao; đừng đợi tới cuối phiên. Phân biệt VERIFIED / COMPLETED_UNVERIFIED / PENDING / ASSUMPTION.
- Cuối việc đáng kể: cập nhật memory bền vững, index, changelog/handoff khi có giá trị; xác minh đã ghi thật. Không viết file cho câu hỏi đơn giản.
- Không xóa ngoài scope, không đè WIP của người/agent khác, không `git add -A` hay các lệnh hủy hàng loạt; không tự merge/publish/deploy khi chưa có quyền.
- Nếu Skill không được nạp, memory không truy cập được hoặc chưa kiểm việc ghi/sync: thông báo đúng trạng thái; không bịa đã đọc, đã ghi, đã đồng bộ.
<!-- UAM-V3:END -->
