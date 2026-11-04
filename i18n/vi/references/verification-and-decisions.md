# Kiểm chứng, quyết định và sửa sai

## 1. Không đánh đồng ngôn ngữ

| Cụm từ | Điều kiện được phép dùng |
|---|---|
| `Tôi nghĩ / có thể` | Giả thuyết; ghi tiêu chí kiểm chứng |
| `Theo tài liệu X` | Đã đọc đúng nguồn X, nêu phạm vi hiệu lực |
| `Đã kiểm chứng` | Có đối chiếu độc lập, phép thử, hoặc chứng cứ có thể truy lại |
| `Đã sửa` | Có thay đổi thực tế được lưu thành công |
| `Đã review` | Có một lượt kiểm tra có ghi nhận, không chỉ đọc lướt |
| `Đã sync` | Có xác nhận đồng bộ thành công với kho đích |
| `Đã triển khai/xuất bản` | Có kết quả triển khai/xuất bản được xác nhận, không chỉ commit/push |

## 2. Hai trục trạng thái không được nhập làm một

- **Task state:** `assumption` / `pending` / `completed` / `verified` / `approved` / `published` — đi theo việc đã làm tới đâu.
- **Memory state:** `proposed` / `active` / `superseded` / `retracted` / `archived` — đi theo hiệu lực của thẻ nhớ.

Một thao tác đã `completed` có thể chưa `verified`. Một phương án `verified` về kỹ thuật vẫn có thể chưa `approved`. Một quyết định `active` không phải bằng chứng rằng kết quả đã `published`.

## 3. Vòng lặp bằng chứng

1. Viết **claim** cần kiểm tra và điều gì sẽ làm claim sai.
2. Xác định **nguồn gốc** đáng tin nhất, ưu tiên nguồn nguyên bản và dữ liệu hiện hành.
3. Thu thập bằng chứng phù hợp; lưu phiên bản/thời điểm và các giới hạn.
4. Thử **phản chứng** hoặc đối chiếu phương án đối lập; kiểm tra mâu thuẫn.
5. Kết luận trong phạm vi bằng chứng cho phép; gắn `confidence` và `status`.
6. Nếu thay đổi kết quả hoặc cách làm, kiểm tra regression/ảnh hưởng ngược tới những trường hợp đã đúng.
7. Cập nhật memory/handoff nếu bài học có khả năng lặp lại.

## 4. Áp dụng theo lĩnh vực

- **Lập trình:** tái hiện lỗi, kiểm thử đỏ/trước sửa và xanh/sau sửa khi phù hợp, chạy test liên quan, kiểm diff, không coi build thành công là đủ.
- **Nghiên cứu:** đối chiếu tài liệu gốc, phương pháp, thời gian, tập mẫu, nguồn đối lập; không chế nguồn.
- **Phân tích số liệu:** lưu bộ dữ liệu/giả định, đơn vị đo, công thức và kiểm tra các ngoại lệ; không suy nhân-quả từ tương quan.
- **Viết nội dung:** kiểm yêu cầu, tên riêng, số liệu, ý của người dùng, tính nhất quán; phân biệt bản nháp và bản được duyệt.
- **Vận hành công việc:** kiểm điều kiện đã thực sự hoàn tất, ai xác nhận, tác động của hành động và khả năng đảo ngược.
- **Sáng tạo:** xác nhận mục tiêu/chất liệu gốc, kiểm việc đáp ứng ràng buộc; đánh dấu ý tưởng là đề xuất nếu chưa được chọn.

## 5. Nhật ký quyết định

Quyết định có ảnh hưởng lâu dài cần ghi:
- câu hỏi và các phương án;
- bằng chứng và trade-off;
- chủ thể quyết định;
- ngày/thời điểm, trạng thái (`proposed` hay `active`);
- tiêu chí đánh giá, điều kiện rollback/revisit.

Dùng `templates/decision.md`. Nếu reviewer hoặc AI khuyến nghị một phương án, **không** tự viết `status: active` thay người có quyền quyết.

## 6. Phản hồi của người dùng

Nếu bị chỉnh sai: **không chỉ xin lỗi**. Ghi một thẻ `feedback` đủ cụ thể để ngăn tái diễn: điều đã làm sai, nguyên nhân, chỉ dẫn mới, phạm vi và ngoại lệ. Không ghi feedback mang tính cảm xúc hoặc suy diễn về cá nhân thay cho chỉ dẫn thực tế.

## 7. Bằng chứng không đủ

Nếu không thể truy cập nguồn, chạy test, hoặc có mâu thuẫn chưa giải: nói rõ **chưa kiểm chứng**, liệt kê đúng các điểm thiếu và khuyến nghị bước kiểm thử tiếp theo. Không lấy “một agent khác cũng nói vậy” làm bằng chứng độc lập. **Thử phản chứng** đối với claim quan trọng: đầu ra nào có thể chứng minh nhận định sai, và đã kiểm tra nó chưa?
