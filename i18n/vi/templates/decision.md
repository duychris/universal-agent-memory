---
id: "decision-<YYYY-MM-DD>-<slug>"
name: "<tên quyết định>"
scope: "<workspace/chủ đề>"
kind: decision
status: proposed
created: "<YYYY-MM-DD>"
updated: "<YYYY-MM-DD>"
observed_at: "<YYYY-MM-DD hoặc unknown>"
last_verified: "unknown"
review_after: null  # tùy chọn, nhắc xem lại; không auto-xóa
source:
  - "<tài liệu/phiên xác nhận>"
owner: "<người có quyền chốt>"
agent: "<agent-id ghi thẻ>"
confidence: supported
supersedes: []
---

# Quyết định: <tên>

## Câu hỏi / mục tiêu

<Đang quyết điều gì, tại sao?>

## Các phương án và trade-off

| Phương án | Lợi ích | Rủi ro | Bằng chứng |
|---|---|---|---|
| A | ... | ... | ... |
| B | ... | ... | ... |

## Quyết định thực tế

- **Trạng thái:** proposed / active / blocked / superseded.
- **Được chốt bởi:** <người hoặc hội đồng>.
- **Hiệu lực từ:** <ngày hoặc chưa có>.
- **Phương án đã chọn:** <nếu active; nếu proposed ghi “chưa chọn”>.
- **Vì sao:** <bằng chứng và ràng buộc>.

## Điều kiện đánh giá lại / rollback

<Điều kiện khiến quyết định hết đúng, cách kiểm tra và hoàn tác nếu phù hợp.>

## Liên quan

<Link tài liệu, review, các quyết định bị thay thế.>
