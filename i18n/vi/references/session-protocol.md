# Giao thức phiên làm việc (session lifecycle)

Dùng cho mọi nhiệm vụ cần duy trì ngữ cảnh. **Không mặc định nhiệm vụ có code hoặc Git.**

## A. Khởi động / resume

1. Xác nhận **đề bài đang làm**, kết quả mong đợi, phạm vi được sửa, hạn chế, tiêu chí hoàn thành và quyền được cấp.
2. Đọc hướng dẫn có hiệu lực: các file quy định của workspace (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md` nếu có), yêu cầu hiện tại, bản thiết kế/cấu hình chuẩn. Ghi rõ nếu hai tài liệu trái nhau; ưu tiên tài liệu hiện hành và quyết định của người phụ trách, không tự chọn theo cảm tính.
3. Tìm `memory/MEMORY.md` hoặc index tương đương từ cấu hình của workspace. Nếu không thấy, tìm vị trí nguồn canonical; **không tự tạo kho thứ hai** trước khi xác minh.
4. Nếu index lưu qua symlink/junction hoặc Git, kiểm tra trạng thái theo `git-sync.md`; xác nhận dữ liệu thực sự truy cập được.
5. Đọc các ghi chú theo phạm vi hiện tại: feedback, quyết định còn hiệu lực, phát hiện liên quan, handoff mới nhất. **Không đọc tất cả thẻ** chỉ vì chúng tồn tại.
6. Kiểm tra công việc dở của các agent khác. Nếu giao nhau, khóa scope hoặc chia file/nhánh. Không ghi đè WIP.
7. Tạo kế hoạch rất ngắn: những gì làm, nguồn phải kiểm chứng, sản phẩm dự kiến, bước cần xin duyệt.

### Mẫu trạng thái đầu phiên (nội bộ hoặc handoff)

```markdown
- Task: ...
- Workspace/owner: ...
- Agent: ...
- Canonical docs: ...
- Memory index: ... (verified: yes/no)
- Last handoff: ...
- In-progress changes by others: ...
- Allowed writes: ...
- Needs approval: ...
- Unknowns/blockers: ...
```

**Không tạo file trạng thái chỉ để tăng giấy tờ.** Dùng biểu mẫu nội bộ nếu việc ngắn. Tạo file nếu công việc dài, nhiều agent, hoặc có khả năng bị ngắt quãng.

## B. Trong phiên

- Xử lý theo phạm vi đã xác định. Nếu phát sinh phát hiện ngoài scope, **ghi riêng, không tự hành động**.
- Phân biệt `observed`, `inferred`, `proposed`, `decided`, `implemented`, `verified`, `released`. Những trạng thái này không tương đương.
- Lưu chứng cứ ở nơi có thể truy vết: tài liệu, dòng/đoạn, phiên bản, thời điểm, phương pháp, phép thử.
- Trước thay đổi đáng kể, bảo đảm có cách đối chiếu và phục hồi phù hợp.
- Dừng trước hành động yêu cầu quyền chưa có: xóa dữ liệu, thay đổi chia sẻ, xuất bản, deploy, giao dịch, gửi thông điệp ra ngoài.
- Nếu phát hiện sai, sửa ghi chú cũ và nêu sự thay đổi; đừng để cả hai mô tả như đều đúng.

## C. Chốt phiên / khi bàn giao

Đánh giá theo checklist sau:

- [ ] Yêu cầu ban đầu đã được đối chiếu với kết quả.
- [ ] Điều gì hoàn tất, điều gì chưa, điều gì được đề xuất nhưng chưa làm được tách rõ.
- [ ] Bằng chứng và kiểm thử có nguồn, kết quả thật.
- [ ] Thẻ nhớ bền vững được ghi/cập nhật, index có liên kết và không trùng.
- [ ] Changelog cập nhật với tác giả, thay đổi, lý do, trạng thái.
- [ ] Đã kiểm tra xung đột và commit/push **nếu được cho phép**; không gọi là đã sync khi chưa thấy thành công.
- [ ] Handoff nêu các bước thực hiện tiếp theo và quyền còn thiếu.
- [ ] Người dùng nhận bản tóm tắt tự đủ hiểu, không phải lần mò lịch sử chat.

Nếu không thể ghi hoặc đồng bộ được: **gửi bản handoff có thể sao chép** và nói rõ chưa được lưu ở kho dùng chung.

## D. Phiên rất ngắn

Không bắt người dùng chịu một quy trình rườm rà cho câu hỏi đơn giản. Với việc không có trạng thái cần kế thừa, không cần tạo ghi chú hay changelog. Quy tắc kiểm chứng, tôn trọng scope và không bịa kết quả **vẫn luôn áp dụng**.
