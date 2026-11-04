# Phối hợp đa agent / đa tài khoản

## Nguyên tắc

Một kho tài liệu chia sẻ **không** đồng nghĩa với một trí nhớ đồng bộ tức thì trong mọi model. Một **nhãn agent hoặc target-harness không phải cơ chế xác thực hay cấp quyền**; phải dựa vào quyền thật của kho. Mỗi phiên chỉ được biết những gì đã đọc và có quyền truy cập. Không khẳng định đã trao đổi với agent khác nếu chưa có bằng chứng.

Mỗi agent phải rõ:
- **Identity**: tên/nền tảng/phiên hoặc nhãn có thể nhận diện (ví dụ `claude/review-01`, `codex/analysis-02`).
- **Role**: implementer, researcher, writer, reviewer, coordinator, hoặc vai trò được giao.
- **Scope**: danh sách tệp, chủ đề hoặc đầu việc được phép sửa.
- **Permissions**: đọc, soạn thảo, commit, push, duyệt, xuất bản; không suy ra quyền này từ vai trò.
- **Deliverable**: kết quả, trạng thái và tiêu chí nghiệm thu.

## Quy trình giao việc

1. Điều phối viên chia nhiệm vụ thành phần **ít chồng lấn**. Giao cùng một nội dung cho 2 AI chỉ khi đó là chủ ý kiểm chứng độc lập, không phải đồng thời chỉnh sửa.
2. Agent nhận việc đọc tài liệu canonical và handoff; kiểm tra file/nhánh đang có thay đổi dở.
3. Agent thực thi, ghi provenance và kiểm chứng, tránh thay đổi ngoài phần đã được giao.
4. Agent hoàn thành mở kết quả để review (tệp, diff, PR, tài liệu) và lập handoff rõ ràng.
5. Reviewer độc lập kiểm tra **nguồn gốc/bản diff/kiểm thử thực**, không chỉ đọc lời kết luận của implementer.
6. Điều phối viên hoặc người có quyền mới quyết định hợp nhất, phát hành, thay đổi quyền hoặc chốt quyết định quan trọng.

## Review chéo không phải “AI đồng ý với AI”

Reviewer phải đọc bằng chứng gốc và tự đánh giá, không chỉ hỏi agent A “có đúng không?”. Nếu không thể thực hiện kiểm tra độc lập, nói rõ `INCONCLUSIVE` hoặc `self-review`. Reviewer phải đưa ra một trong ba trạng thái:
- `PASS`: đã kiểm đủ các điều kiện nghiệm thu được nêu, không có blocker trong phạm vi kiểm.
- `REQUEST_CHANGES`: chỉ rõ lỗi, bằng chứng, tác động và bước sửa có thể kiểm lại.
- `INCONCLUSIVE`: không đủ nguồn, không có quyền truy cập, chưa tái hiện được, hoặc còn giả thuyết chưa được phân xử.

Mẫu review bắt buộc có: đối tượng (file/commit/version), tiêu chí, bằng chứng, phần đã xem, phần chưa kiểm, người review, verdict. Dùng `templates/review.md`.

## Attribution

- Ghi người thực sự làm thay đổi. Nếu dùng Git, commit có thể ghi `[AgentName] mô tả ngắn` hoặc dùng quy ước hiện có của repo.
- Không xóa thông tin tác giả của agent khác khi review/sửa tiếp.
- Chỉ thêm comment gắn tên agent vào tài liệu/code **khi thực sự cần truy nguyên logic**; không gây nhiễu bằng tag ở mọi dòng.
- Người review khác với người làm càng tốt; nếu cùng một AI tự review, phải nói đúng là **self-review**, không gọi đó là kiểm chứng độc lập.

## Chống đè nhau

- Ưu tiên mỗi agent có branch/worktree/không gian nháp riêng khi dùng Git.
- Nếu dùng chung một file, chia lượt bằng handoff và cập nhật trạng thái trước khi ghi.
- Trước commit, stage rõ từng file và kiểm tra stage; không gộp thay đổi người khác bằng `git add -A`.
- Nếu gặp diff lạ, **dừng thao tác tác động** và thông báo chủ thể/điều phối. Đừng tự hoàn tác phần chưa rõ chủ.
- Ghi thay đổi vào tài liệu canonical **sau khi** được duyệt; không cập nhật memory thành kết luận chính thức trước khi quyết định thực sự được chốt.

## Nhiều tài khoản, nhiều thiết bị

**Phân lớp chia sẻ:** thẻ thuộc một người (`user`), một workspace (`workspace`), nhóm có quyền (`shared/team`) hoặc đã được duyệt dùng chung (`global`). Không chuyển thẻ giữa các lớp chỉ vì có thể đọc. Nếu một bên không được cấp quyền, dừng ở đúng ranh giới, không mở rộng tìm kiếm để “cứu” kết quả. Khi không truy cập được bản gốc, tài liệu bàn giao phải nêu nguồn chưa kiểm chứng và snapshot cụ thể.

- Dùng chung một nguồn thực sự có thể truy cập (repo private, thư mục được chia sẻ, kho tài liệu có cấp quyền).
- Mỗi môi trường phải được cấu hình riêng để đọc Skill và đọc kho memory; không giả định hai tài khoản tự chia sẻ context nền.
- Nếu agent B không truy cập được memory của agent A, phải chuyển giao bằng handoff hoặc tài liệu được cấp quyền, **không suy đoán dựa trên tên cùng dự án**.
- Hạn chế quyền ở mức cần thiết; agent chỉ review thường không cần quyền phát hành hoặc xóa.

## Mẫu một ca phối hợp

- Agent A: soạn phương án; ghi tài liệu đầu ra, nguồn, giả định, handoff, trạng thái `ready-for-review`.
- Agent B: đọc tài liệu gốc, kiểm tiêu chí, thử phản chứng, lập `review.md` và verdict.
- Người phụ trách: chốt hoặc yêu cầu sửa. Agent tiếp theo cập nhật `decision.md`, `MEMORY.md` và changelog.

Không có bước nào mặc nhiên yêu cầu GitHub, deploy, API hay code.
