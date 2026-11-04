# Learning lifecycle — học từ lỗi mà không phình bộ nhớ

Đây là **quy tắc cho agent tự thực hiện bằng ngôn ngữ tự nhiên**. Không có semantic database, embedding server, tự động quét tất cả transcript hoặc engine chấm điểm ẩn. Có thể dùng công cụ sẵn có nếu được quyền nhưng **không giả vờ** đã đo độ tương đồng nếu chưa đo.

## 1. Signal → Candidate → Durable memory

| Tín hiệu | Hành động khởi đầu | Khi nào lưu bền vững |
|---|---|---|
| Người dùng sửa AI trực tiếp | Xác nhận điều cần làm khác đi, xác định scope | Chỉ dẫn rõ, có ích cho phiên sau và người dùng cho phép lưu |
| AI làm sai / thao tác lỗi | Ghi nhận nguyên nhân và bằng chứng | Có khả năng lặp lại hoặc tác động đáng kể; chưa chắc thì `proposed` |
| Hai agent bất đồng | So nguồn và phương pháp | Khi xác minh được điều đúng/sai hoặc cần giữ open question |
| Phương pháp hiệu quả | Tách bước có thể tái sử dụng | Đã thử đủ tình huống, biết điều kiện biên |
| Quyết định | Lưu lựa chọn và trade-off | Có người có quyền chốt; nếu chưa thì `proposed` |
| Công việc dang dở | Lập handoff | Khi cần nối phiên/agent, **không cần** tạo memory dài hạn |

Không có chỉ tiêu phải lưu N thẻ mỗi ngày. **Không ghi chỉ vì có thể ghi.**

## 2. Kiểm trùng theo ý nghĩa

1. Tìm thẻ có cùng **hành động, lỗi, trigger hoặc chủ đề**.
2. So nội dung, phạm vi, ngoại lệ, người xác nhận và mốc thời gian.
3. Quyết định:
   - `DUPLICATE`: không tạo thẻ mới; bổ sung evidence và cập nhật `updated` nếu thực sự có dữ kiện mới.
   - `RELATED`: giữ hai thẻ nếu điều kiện áp dụng khác nhau, thêm links đôi.
   - `CONTRADICTORY`: không chọn theo `mtime`, agent nổi tiếng hay câu trả lời tự tin; kiểm nguồn chính thức và đánh dấu còn tranh cãi.
   - `NEW`: tạo thẻ, thêm **một** dòng index ngắn.
4. Không tự gộp hai chỉ dẫn khác scope để tạo luật toàn cục.

## 3. Thăng cấp có kiểm soát

`observed → candidate/proposed → confirmed-for-scope → durable → reviewed → superseded/retired`.

- `observed`: chỉ là sự kiện; không nhất thiết thành file.
- `candidate/proposed`: có tính khái quát nhưng chưa được xác nhận đủ.
- `confirmed-for-scope`: người có quyền xác nhận, hoặc bằng chứng đủ cho finding/procedure trong phạm vi hiện tại.
- `durable`: thẻ có nguồn và điều kiện sử dụng, index trỏ được.
- `reviewed`: kiểm lại khi nguồn, người dùng, sản phẩm hoặc workspace thay đổi.
- `superseded/retired`: có lý do, liên kết thẻ mới, không hủy lịch sử không cần thiết.

Không áp dụng luật tự động “3 lần lặp là skill mới”. **Số lần lặp là tín hiệu xem xét, không phải quyết định**, và một lỗi nghiêm trọng vẫn có thể đáng ghi ngay.

## 4. Context budget và dọn trí nhớ

- Đầu phiên đọc index + thẻ liên quan, không tải tất cả.
- Khi index dài, gom nhóm theo scope/chủ đề và tách archive index nếu cần; giữ phần đang hiệu lực, quyết định chính và handoff dễ tìm.
- Khi nhiều thẻ trùng, đề xuất hợp nhất với evidence bảo toàn. Không rút ngắn nội dung theo thời gian tuyệt đối; thẻ cũ vẫn có thể là luật cốt lõi.
- Không được xóa các bản ghi theo TTL nếu chưa được giao. Các thẻ quá hạn `review_after` chỉ được **đánh dấu cần xem lại**, không tự coi là sai hoặc tự xóa.
- Bảo đảm link tương đối, ID ổn định và các mốc nguồn còn truy xuất được.

## 5. Chuyển kiến thức giữa lĩnh vực

- Mặc định lưu ở scope nhỏ nhất đúng: `task` → `workspace` → `shared/team` → `global`.
- Chỉ chuyển sang scope rộng khi đó là **phương pháp tổng quát** chứ không phải bí mật/đặc thù của một dự án, đã có bằng chứng và được người có quyền duyệt.
- Khi chuyển, viết lại câu theo ngữ cảnh đích và ghi nguồn. Không copy cơ chế, đường dẫn, tài khoản, tên riêng, dữ liệu nhạy cảm hoặc kết luận chuyên ngành sang nơi không liên quan.

## 6. Phản hồi của người dùng

Khi người dùng nói “không phải như vậy”: sửa hành vi **trong phiên hiện tại trước**. Nếu được phép và có giá trị lâu dài, ghi `feedback-*.md` nêu: *đã làm sai gì, vì sao, hành vi mới, trigger, ngoại lệ, scope, nguồn*. Nếu người dùng yêu cầu không ghi hoặc không nhắc lại, tôn trọng điều đó.
