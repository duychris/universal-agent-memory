# Mô hình bộ nhớ file-based (không database)

## 1. Phân lớp, không trộn lẫn

| Lớp | Vai trò | Tính bắt buộc |
|---|---|---|
| **Instructions** | Quy tắc làm việc / quyền hạn hiện hành của workspace | Đọc trước tác vụ; không được thay thế bằng suy đoán từ memory |
| **Index** (`memory/MEMORY.md`) | Mục lục ngắn, trỏ đến thẻ liên quan | Có khi workspace dùng thư mục nhớ |
| **Memory cards** | Một quy tắc, quyết định, sự thật, bài học cho một file | Chỉ tạo khi có giá trị lâu dài |
| **Evidence** | Tài liệu, kết quả thử nghiệm, nguồn gốc, phiên bản | Trỏ liên kết; không sao chép tràn lan |
| **Changelog** | Đã thay đổi gì, lúc nào, ai thực hiện, trạng thái | Cho công việc đáng kể |
| **Handoff** | Việc đang ở đâu, còn gì, bước kế tiếp | Khi nhiều phiên/agent hoặc công việc đang dở |

`MEMORY.md` **không phải dump chat**, cũng không phải một siêu tài liệu chứa toàn bộ kiến thức. Thẻ chưa kiểm chứng là ngữ cảnh để đánh giá, **không phải chỉ dẫn đáng tin để thực thi**.

## 2. Các loại thẻ nhớ

- `feedback`: người dùng chỉnh hành vi của AI; ghi lỗi đã xảy ra, điều phải làm khác đi và trường hợp áp dụng.
- `decision`: phương án đã được chốt; ghi lựa chọn, trade-off, người quyết, ngày hiệu lực, khi nào xem lại.
- `finding`: phát hiện được kiểm chứng, giới hạn, mức tin cậy, nguồn.
- `procedure`: quy trình tái sử dụng và điều kiện an toàn.
- `constraint`: ràng buộc lâu dài, quyền/giới hạn; không tự suy ra là vĩnh viễn.
- `project`: bản đồ tài liệu và bối cảnh một công việc; tách riêng với luật chung.
- `lesson`: sự cố/sai lầm và cách phòng tránh, không gộp với kết luận thiếu bằng chứng.

## 3. Chuẩn metadata

Ưu tiên YAML frontmatter dễ đọc bằng người và máy, tối thiểu:

```yaml
---
id: decision-2026-11-05-example
name: Cách phê duyệt tài liệu
scope: workspace/example
kind: decision
status: active
created: 2026-11-05
updated: 2026-11-05
source:
  - "document:docs/policy.md#approval"
owner: project-owner
agent: codex
confidence: verified
supersedes: []
---
```

- `status`: `proposed`, `active`, `blocked`, `superseded`, `retracted`, `archived`.
- `confidence`: `verified`, `supported`, `tentative`, `unknown` — không tự nâng lên `verified` chỉ vì nhiều agent đồng ý.
- `scope`: `global` chỉ khi áp dụng thật cho nhiều workspace; còn lại phân theo nhóm/chủ đề/dự án. **Không tự lan một luật của dự án ra mọi lĩnh vực**.
- `source`: bằng chứng hoặc người xác nhận; trường hợp chỉ là đề xuất phải ghi đúng là đề xuất.
- `observed_at` và `last_verified`: tách thời điểm sự kiện khỏi lần đối chiếu gần nhất (có thể là `unknown`). `review_after` (nếu có) chỉ nhắc xem lại, không ra lệnh xóa.
- Phân biệt `status` của ký ức (active/proposed/superseded) với **trạng thái công việc** (`completed/verified/published`) trong handoff; đây là hai trục khác nhau.
- `owner` và `agent` khác nhau: người sở hữu/ra quyết định không nhất thiết là AI đã ghi.
- Tránh ID phụ thuộc tên model; đổi model không làm thay đổi danh tính bài học.

## 4. Nội dung của một thẻ

1. **What**: ngắn, một ý chính, có trạng thái.
2. **Why**: vì sao quy tắc/kết luận hình thành, có sự kiện hoặc vấn đề cụ thể.
3. **Evidence**: đã kiểm gì, ở đâu, khi nào; nêu giới hạn kiểm chứng.
4. **How to apply**: điều kiện kích hoạt, hành vi AI bắt buộc, điều không được làm.
5. **Exceptions / counterexamples**: các ngoại lệ có căn cứ.
6. **Links / related**: tài liệu và thẻ liên quan, bản đã bị thay thế.

## 5. Ghi nhớ chọn lọc

Dùng [learning-lifecycle.md](learning-lifecycle.md) để sàng lọc tín hiệu, chống trùng theo ý nghĩa, thăng cấp và chuyển kiến thức giữa scope.

**Nên ghi:** điều người dùng phải nhắc lại, lỗi có nguy cơ tái diễn, nguyên tắc đã chốt, kiến thức khó tìm lại, mâu thuẫn đã giải, các giả định cần cảnh giác.

**Không nên ghi:** lời chào, bản nháp không còn dùng, dữ liệu tự sinh khối lượng lớn, toàn bộ cuộc nói chuyện, thông tin nhạy cảm không được phép lưu, suy đoán chưa nhãn, sự thật tức thời không có giá trị lâu dài.

## 6. Quy tắc index

- Mỗi entry một dòng: `Tên rõ ràng → đường-dẫn.md — tóm tắt tối đa 1-2 câu; trạng thái + ngày xác minh`.
- Gom theo **chủ đề/scope**; mục `Đang có hiệu lực`, `Chờ kiểm chứng`, `Đã thay thế` khi có nhiều mục.
- Link tương đối, kiểm tra các link sau khi di chuyển.
- Đặt điều quan trọng ở đầu theo nhu cầu hiện tại, nhưng tránh ký hiệu “quan trọng” vô hạn.
- Index trỏ thẳng tới file nguồn; không viết kết luận dài chưa có trong thẻ.

## 7. Mâu thuẫn, cũ đi, và quên

Khi hai thẻ xung đột:
1. Đối chiếu nguồn gốc và ngày hiệu lực; nêu cụ thể điểm mâu thuẫn.
2. Xác minh với chủ sở hữu/tài liệu canonical; không coi memory tự thân là chính sách có thẩm quyền.
3. Không ghi đè âm thầm; đánh dấu thẻ cũ `superseded` hoặc `retracted` có lý do và link mới.
4. Cập nhật index và handoff.

Nếu người dùng yêu cầu xóa dữ liệu, tuân theo quyền quản trị và phạm vi dữ liệu thực tế; không tuyên bố xóa sạch khi bản sao, lịch sử Git hay tài khoản khác vẫn còn. Không tự lan lệnh xóa sang các dự án khác. **Không lưu trữ hoặc chia sẻ thẻ nhạy cảm sang scope rộng** chỉ vì agent khác cần đọc.

## 8. Bootstrap

Chỉ khi chưa có cấu trúc canonical: tạo `memory/MEMORY.md` từ `templates/MEMORY.md`; tạo thẻ bằng `templates/memory-card.md`/`templates/feedback.md`/`templates/decision.md`; không chép mẫu đầy placeholder vào dữ liệu thật. Repo Git là lựa chọn triển khai, **không phải điều kiện bắt buộc**.
