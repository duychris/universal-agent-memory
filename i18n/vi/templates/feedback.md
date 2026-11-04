---
id: "feedback-<slug>"
name: "<quy tắc AI không được quên>"
scope: "<global hoặc workspace/chủ đề>"
kind: feedback
status: proposed  # dùng active nếu đã có chỉ dẫn trực tiếp, hợp lệ trong đúng scope
created: "<YYYY-MM-DD>"
updated: "<YYYY-MM-DD>"
observed_at: "<YYYY-MM-DD hoặc unknown>"
last_verified: "unknown"
review_after: null  # tùy chọn, nhắc xem lại; không auto-xóa
source:
  - "<phản hồi trực tiếp của người có quyền, trong ngữ cảnh được phép lưu>"
owner: "<người ra chỉ dẫn>"
agent: "<agent-id ghi thẻ>"
confidence: supported  # chỉ verified nếu đúng lời xác nhận và có nguồn
supersedes: []
---

# <Tên phản hồi / quy tắc>

## Sai lầm gốc

<AI đã làm gì sai? Nêu sự kiện chứ không suy đoán động cơ.>

## Quy tắc từ nay

**Phải:** <mô tả bằng động từ cụ thể>.

**Không được:** <điều cấm cụ thể>.

## Why

<Vì sao cách cũ gây hại, lỗi nào sẽ tái diễn nếu không nhớ.>

## How to apply

- Khi gặp: <tình huống kích hoạt>.
- Trước khi hành động: <kiểm tra bắt buộc>.
- Kết quả đúng: <đầu ra hoặc hành vi mong muốn>.
- Ngoại lệ: <điều kiện được phép khác đi, nếu có>.

## Evidence / scope boundary

<Liên kết tới sự việc gốc; chỉ rõ đây là quy tắc chung hay chỉ áp dụng một chủ đề.>
