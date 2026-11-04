## Universal Agent Memory — quy ước dùng chung

Workspace này dùng Skill `universal-agent-memory` để chuẩn hóa cách AI làm việc, kiểm chứng và ghi nhớ.

- **Memory canonical:** `memory/MEMORY.md` (sửa đường dẫn nếu workspace khác).
- **Quy tắc hiện hành:** đọc file này và tài liệu canonical của workspace **trước** khi làm việc đáng kể.
- **Đầu phiên:** đọc handoff mới nhất, kiểm chứng sync/link nếu có, chỉ mở các memory card liên quan.
- **Trong phiên:** tuân thủ scope, kiểm chứng trước kết luận; không xóa ngoài phạm vi; không coi đề xuất là đã làm.
- **Đa agent:** ghi attribution, tránh đè WIP, yêu cầu review độc lập cho việc rủi ro cao.
- **Git nếu có:** cấm `git add -A`, `git add .`, `git commit -am`; chỉ stage file đúng scope sau khi kiểm diff.
- **Cuối phiên:** cập nhật memory card/index nếu có bài học bền vững, changelog/handoff khi cần; nói rõ trạng thái lưu/sync thực tế.
- **Quyền:** <điền ai được ghi, commit, duyệt, phát hành; không được tự suy diễn>.

Nếu chưa đọc được Skill hoặc kho memory, báo rõ giới hạn và yêu cầu nguồn đúng; không giả vờ đã đồng bộ.
