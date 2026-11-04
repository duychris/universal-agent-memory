# Demo 2 phiên — không yêu cầu lập trình

**Mục tiêu:** Kiểm tra một người dùng làm việc với một AI, không chỉ multi-agent.

### Phiên 1

Tạo workspace thử (hoặc cho agent làm với quyền được cấp). Nhờ AI:

> Tôi đang chuẩn bị một bài thuyết trình. Mục tiêu 10 phút, dành cho người không chuyên. Trong workspace thử này, hãy tạo bộ nhớ Universal Agent Memory từ templates nếu chưa có; ghi yêu cầu trên thành một quyết định/điều kiện. Viết một dàn ý ngắn và checkpoint sau khi tôi duyệt.

Xác minh thư mục có `memory/MEMORY.md`, decision/card và `handoffs/latest.md`; kiểm ngày, nguồn, trạng thái.

### Phiên 2 (mở hội thoại mới, KHÔNG nhắc lại chi tiết 10 phút)

> Tiếp tục dàn ý từ phiên trước. Hãy tự đọc memory và checkpoint; nói lại giới hạn đã chốt, điều còn chờ và bước tiếp theo. Đừng sửa file ngoài workspace thử.

**PASS khi:** AI đọc đúng thông tin từ file, chỉ rõ nguồn và không nói đã kiểm những gì chưa kiểm. **FAIL khi:** AI đoán từ prompt, không truy xuất file nhưng nói “đã nhớ”, hoặc tự tạo bộ nhớ song song.

### Kiểm tra checkpoint giữa chừng

Nhờ AI viết một phần dàn ý, xác minh rồi checkpoint. Mở chat mới giữa lúc chưa hoàn tất và hỏi bước tiếp theo. Nếu checkpoint đã lưu, phiên sau phải tiếp tục được mà không lệ thuộc tóm tắt cuộc chat cũ.
