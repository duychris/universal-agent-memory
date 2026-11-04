# Nguồn gốc và bảng tổng quát hóa

Tài liệu này **chỉ phục vụ audit nguồn thiết kế**; nó không phải quy tắc nghiệp vụ để AI áp dụng vào dự án mới.

Các bài học được chắt lọc từ một kho bộ nhớ đa AI thực chiến trong sản xuất (`1.400+` tệp, `110+` thẻ nhớ atomic, vận hành hàng ngày giữa Claude, Codex và Gemini). Nội dung Skill chính được viết độc lập hoàn toàn với nghiệp vụ chuyên ngành của kho gốc.

| Bài học được giữ | Sự cố / Kinh nghiệm thực chiến | Đưa vào Skill |
|---|---|---|
| Mục lục `MEMORY.md` + một file cho mỗi bài học | Nạp toàn bộ ghi chú gây tràn ngữ cảnh; mục lục 1 dòng/thẻ giúp phiên mới định vị tri thức trong vài giây | `memory-model.md`, phần 3 của `SKILL.md` |
| Lưu chỉ dẫn sửa sai thành thẻ `feedback-*.md` có `Why/How to apply` | Nhắc miệng trong chat bị quên ở phiên sau cho đến khi được chuẩn hóa kèm nguyên nhân và cách kiểm tra | `templates/feedback.md`, `memory-model.md` |
| Đọc hướng dẫn canonical trước mỗi phiên; memory cũ không phải nguồn trạng thái mới nhất | Ghi chú memory đôi khi trễ hơn commit mới nhất; tin memory cũ hơn tài liệu gốc gây lỗi hồi quy | phần 1 `SKILL.md`, `session-protocol.md` |
| Cấm xóa ngoài scope (`no-unscoped-delete`) | AI đang sửa lỗi A tự ý xóa file tưởng là thừa nhưng thực chất dùng cho nhánh khác | phần 1 `SKILL.md`, `security-and-scope.md` |
| Kiểm chứng nguồn thật, không kết luận chỉ dựa trên lời AI | Một AI nội suy tuyến tính làm tụt điểm chuẩn thực tế, chỉ phát hiện khi AI thứ hai chạy lại phép thử độc lập | `verification-and-decisions.md` |
| Nhiều AI cùng làm, attribution và review chéo | Gắn nhãn `[Claude]`, `[Codex]`, `[Gemini]` và kiểm chéo giúp truy vết chính xác và chặn lỗi trước khi phát hành | `multi-agent.md`, `templates/review.md` |
| Giữ changelog đủ để agent khác tiếp tục, ghi hash thật và trạng thái sau khi hoàn thành | Ghi changelog quá sớm làm thiếu commit SHA thật và việc còn lại | phần 8 `SKILL.md`, `templates/changelog-entry.md` |
| Bộ nhớ xuyên máy qua symlink/junction có thể đứt âm thầm và tạo hai nhánh nhớ | Cài lại hệ điều hành làm đứt junction khiến 2 máy ghi vào 2 thư mục tách rời suốt 3 tuần | `git-sync.md` |
| `git add -A` từng vô tình nuốt sửa đổi agent khác; lệnh khôi phục có thể xóa WIP | Hai agent chạy song song cùng thư mục bị gộp nhầm file sửa dở khi dùng `git add -A` | `git-sync.md`, phần 1 & 6 `SKILL.md` |
| Checkpoint giữa phiên (`handoffs/latest.md`) | Phiên dài bị hết quota hoặc đứt giữa chừng làm mất tiến độ nếu chỉ đợi viết handoff cuối phiên | phần 7 `SKILL.md`, `activation-and-checkpoints.md` |

## Đối chiếu các dự án công khai khi tối ưu v2 & v3

| Repo công khai | Bài học rút ra | Áp dụng vào Skill v3 | Cố ý không lấy |
|---|---|---|---|
| [vvnocode/AGENTS.md — agent-memory-setup](https://github.com/vvnocode/AGENTS.md/blob/main/skills/agent-memory-setup/SKILL.md) | Cần kiểm thật việc kết nối giữa các agent, config, shared root, worktree | Start/resume, kiểm link, nguồn canonical, read-after-write | Không bắt cài hook/script theo nền tảng |
| [affaan-m/ECC — unified-memory](https://github.com/affaan-m/ECC/blob/main/.agents/skills/unified-memory/SKILL.md) | Memory là chứng cứ chưa chắc đúng; scope và quyền quan trọng hơn tên harness; supersede có chủ đích | Memory state, scope, review nguồn, anti-prompt injection | Không yêu cầu Memory Vault, CLI, MCP hoặc npm runtime |
| [phnx-labs/.agents — learn](https://github.com/phnx-labs/.agents/blob/main/skills/learn/SKILL.md) | Không mã hóa tất cả trải nghiệm; tránh overfit vào một phiên; kiểm lỗi đã được giải quyết chưa | Learning gate, dedup, review trước promote | Không tự đọc toàn bộ transcript, không HTML report hoặc sửa Skill tự động |
| [gitstq/awesome-ai-agent-skills — self-evolver-pro](https://github.com/gitstq/awesome-ai-agent-skills/blob/main/skills/self-evolver-pro/SKILL.md) | Signal classification, dedup theo nghĩa, transfer và compaction | `learning-lifecycle.md`, source/scope review | Không áp dụng TTL/đếm lần như luật tự động hoặc config engine |
| [whaojie797-design/agent-handoff-kit](https://github.com/whaojie797-design/agent-handoff-kit/blob/main/SKILL.md) | `Verified` khác `Completed`, `Assumption` khác sự thật | Handoff template + task state | Không buộc mọi công việc tạo 4 file state |
| [WeirdSky924/agent-handoff-skill](https://github.com/WeirdSky924/agent-handoff-skill/blob/main/SKILL.md) | Handoff chỉ cần một nơi cập nhật nhất quán, chống ghi đè guidance | Handoff provenance, setup bảo tồn quy tắc | Không bootstrap Python hoặc rotate tự động |
