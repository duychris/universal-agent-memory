# Activation & Checkpoint Protocol (v3)

## Không được nhầm tên gọi

- **Discovered**: host nhận thấy metadata `name/description`; chưa phải đã chạy Skill.
- **Activated / loaded**: agent đã đọc nội dung `SKILL.md` trong phiên này.
- **Memory available**: agent đọc được đúng kho canonical; không phải chỉ nhìn thấy đường dẫn.
- **Persisted**: sau khi ghi, nội dung có thể đọc lại tại nguồn đích hoặc có xác nhận tin cậy từ công cụ ghi.
- **Synced**: nguồn đích chung đã có bản sửa đổi có thể kiểm tra; *không đồng nghĩa* máy khác đã fetch hoặc agent khác đã đọc.

Không báo 4 trạng thái này như một trạng thái `on` duy nhất.

## Startup anchor (Global Rules)

Global Rules chỉ chứa **giao kèo ngắn**, không copy cả Skill vào file global. Với tác vụ nhiều bước / có ngữ cảnh lâu dài:

1. Định vị đúng Skill và nạp (theo cơ chế host). Nếu host không cho nạp theo tên nhưng cho đọc file, đọc trực tiếp.
2. Xác định workspace và nguồn canonical của memory (theo tài liệu được phép); tránh tạo kho thứ hai. Đọc hướng dẫn hiện hành, index và handoff liên quan.
3. Xác định trạng thái thực tế / quyền và phạm vi. Tránh áp dụng một ghi chú lỗi thời thành luật mới.
4. Nếu thiếu nguồn, nói rõ và tiếp tục trong khả năng cho phép, **không bịa đã khôi phục đầy đủ ngữ cảnh**.

Với tác vụ LIGHT, không bắt buộc bật Skill, không ghi nhớ chỉ vì người dùng hỏi một câu đơn giản.

## Checkpoint thời điểm nào?

Điểm chuyển tự nhiên, **không phải theo timer**:

- Sau một mốc thành công hoặc test có chứng cứ.
- Trước và sau bước có rủi ro cao, nhiều tài nguyên hoặc kéo dài; chỉ ghi điều đã xảy ra.
- Khi có quyết định hoặc sửa lỗi bền vững.
- Trước handoff sang agent khác, nhánh khác, máy khác.
- Khi chuẩn bị kết thúc/thu gọn hoặc thấy nguy cơ bị gián đoạn.

Một mốc nhỏ không phát sinh hiểu biết/tiến độ hữu ích => có thể không checkpoint. Giữ **một bản snapshot mới nhất**, mọi lịch sử đáng kể nằm trong changelog/decision/feedback; không tạo file mỗi lượt chat.

## Checkpoint phải có tối thiểu

- `task`, `scope`, `owner/agent`, `workspace`, `last_updated`.
- `VERIFIED` + source, phép kiểm, kết quả.
- `COMPLETED_UNVERIFIED`, `PENDING`, `ASSUMPTION`, `BLOCKED`.
- `next_action` cụ thể; nguồn/tệp cần mở để tiếp tục.
- `sync_status`: `LOCAL_ONLY`, `PERSISTED`, `SYNC_PENDING`, `SYNC_VERIFIED`, `UNKNOWN`; bằng chứng nếu có.

Mẫu: [../templates/checkpoint.md](../templates/checkpoint.md).

## Khôi phục sau ngắt (restart-safe)

1. Đọc checkpoint/handoff mới nhất + memory có liên quan; xem có ghi `FINAL` hay `INTERRUPTED`.
2. Đối chiếu **thực trạng nguồn**: Git status, file hiện hành, bằng chứng chạy test, tài liệu/quyết định mới, quyền truy cập.
3. Các bước đã lên kế hoạch nhưng không có chứng cứ = `PENDING/UNKNOWN`, **không chạy lại giao dịch, xuất bản, xóa hoặc deploy** chỉ vì checkpoint ghi “đang thực hiện”.
4. Nếu có thay đổi từ agent khác hoặc hai bản checkpoint mâu thuẫn: **giữ nguyên cả hai**, báo xung đột, xác minh nguồn trước khi quyết định.
5. Thực hiện từ bước tiếp theo đã kiểm, cập nhật checkpoint sau mốc kế tiếp.

## Giới hạn không hứa quá mức

- Không có file thì không có bảo đảm nhớ xuyên phiên.
- Không cài runtime/hook: Skill không hoạt động sau khi phiên đã chết và không bảo đảm bắt được quota/crash.
- Global Rules cũng là chỉ dẫn cho AI, không phải cơ chế cưỡng chế tuyệt đối. Quyền hệ thống, filesystem protections, branch protection và kiểm thử độc lập mới là hàng rào cứng.
- ChatGPT web thuần / cloud hosted thường không tự nhìn thấy `~/.agents/skills` trên máy cá nhân.
