# Release notes — Universal Agent Memory v3.0

**2026-11-05** — Mở rộng từ v2; giữ nguyên nguyên tắc human-first, instruction-only.

## Mới

1. **Global Rules anchors**: 4 mẫu neo hướng dẫn cho Claude, Codex, Gemini, Antigravity; kèm marker để ghép không đè hướng dẫn cũ.
2. **Startup/activation contract**: tách rõ `RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`. Không đánh đồng skill discovery với activation.
3. **Checkpoint giữa phiên**: lưu trạng thái sau mốc quan trọng, quyết định, trước chuyển agent/bước rủi ro; không phụ thuộc chốt cuối phiên.
4. **Interrupted recovery**: phiên sau đối chiếu nguồn hiện hành, không chạy lại bước có side-effect dựa trên checkpoint chưa kiểm chứng.
5. **HDSD Việt hóa**: cài Mac/Windows, cho người không code, ví dụ 1-agent xuyên phiên và multi-agent; checklist kiểm chứng/sự cố.
6. **Quy tắc Gemini + Antigravity dùng chung**: tránh dán Global Rules hai lần vào các file cùng được nạp.
7. **Không runtime**: không hook hay lệnh memoryctl, chỉ file hướng dẫn và template.

## Giữ từ v2

- Memory index, feedback cards, chống trùng/ngữ nghĩa, promotion có duyệt, stale/superseded.
- Kiểm chứng trước kết luận; trạng thái `completed` khác `verified`/`published`.
- Scope boundaries, review chéo, Git path-specific staging và bảo toàn WIP.
- Chế độ LIGHT / STANDARD / COLLAB / LEARN.

## Điều chưa chứng minh

- **Chưa kiểm thực tế** v3 trên Claude Code, Codex, Gemini CLI, Antigravity; khác nhau theo host/version/quyền.
- Đã kiểm **tĩnh** liên kết Markdown, YAML, marker, cấu trúc ZIP và trạng thái không tạo runtime (chi tiết xem báo cáo kiểm trong câu trả lời phát hành).
- Global Rules không thể bảo đảm model luôn tuân thủ; checkpoint không chạy khi AI đã crash/không có quyền ghi.
