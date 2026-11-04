# Release notes — Universal Agent Memory v3.0

**2026-11-05** — Mở rộng từ v2; giữ nguyên nguyên tắc human-first, instruction-only, bổ sung bộ cài an toàn đa nền tảng và hỗ trợ song ngữ Anh – Việt.

## Mới trong v3.0

1. **Global Rules anchors (`rules/`)**: 4 mẫu neo hướng dẫn cho Claude, Codex, Gemini, Antigravity bọc trong marker `<!-- UAM-V3:BEGIN --> ... <!-- UAM-V3:END -->` để ghép an toàn mà không đè hướng dẫn cũ.
2. **Startup/activation contract (4 lớp)**: tách rõ `RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`. Không đánh đồng skill discovery với activation.
3. **Checkpoint giữa phiên**: lưu trạng thái sau mốc quan trọng, quyết định, trước chuyển agent/bước rủi ro; không phụ thuộc chốt cuối phiên.
4. **Interrupted recovery**: phiên sau đối chiếu nguồn hiện hành, không chạy lại bước có side-effect dựa trên checkpoint chưa kiểm chứng.
5. **Chống trùng đường dẫn Gemini/Antigravity & Codex**: tránh dán Global Rules hai lần vào `~/.gemini/GEMINI.md`; cài Skill cho Codex vào đúng đường dẫn canonical `~/.agents/skills/universal-agent-memory` (và cảnh báo nếu phát hiện bản trùng cũ trong `~/.codex/skills/`).
6. **Bộ cài đặt an toàn (`install.sh` & `install.ps1`)**:
   - Đóng gói đầy đủ toàn bộ tài liệu được tham chiếu (`SKILL.md`, `README.md`, `HDSD.md`, `RELEASE-NOTES.md`, `TEST-CASES.md`, `LICENSE`, `references/`, `rules/`, `templates/`, `examples/`) đồng nhất theo ngôn ngữ (`--lang en` hoặc `--lang vi`).
   - Kiểm tra preflight (`python3`, `git`, quyền ghi, tính toàn vẹn gói nguồn) và kiểm tra cân bằng/chống trùng marker `UAM-V3` trước khi chạm vào bất kỳ file nào.
   - Tự động tạo bản backup có timestamp trước khi sửa Global Rules hoặc file Skill đã thay đổi; giữ nguyên các file riêng do người dùng tự thêm vào thư mục Skill; hỗ trợ `--dry-run`, `--platform` (`all`, `claude`, `codex`, `gemini`, `antigravity`) và `--ref`.
7. **Không runtime**: không hook hay lệnh `memoryctl`, chỉ file hướng dẫn và template.

## Giữ từ v2.0

- Memory index, feedback cards, chống trùng ngữ nghĩa, promotion có duyệt, stale/superseded.
- Kiểm chứng trước kết luận; trạng thái `completed` khác `verified`/`published`.
- Scope boundaries (`no-unscoped-delete`), review chéo, Git path-specific staging và bảo toàn WIP.
- Chế độ `LIGHT` / `STANDARD` / `COLLAB` / `LEARN`.

## Trạng thái xác minh & Giới hạn

- **Kiểm tra tĩnh (`PASS`)**: Toàn bộ liên kết Markdown tương đối (trên repo và trong thư mục Skill sau cài cho cả bản EN và VI), YAML frontmatter, khối marker `UAM-V3`.
- **Installer macOS/Linux (`install.sh` — `PASS`)**: Đã chạy kiểm thử thực tế trên môi trường `$HOME` giả lập (sandbox) cho cả bản EN và VI, cài lại lần 2 (idempotent), bảo toàn nội dung Global Rules + tạo backup, bảo toàn file riêng trong thư mục Skill, chặn marker lỗi/trùng, và bắt lỗi thiếu dependency (`git`/`python3`/clone lỗi).
- **Installer Windows PowerShell (`install.ps1` — `STATIC VALIDATED` / `NOT TESTED` runtime trên Windows)**: Đã đồng bộ logic với `install.sh` (kiểm tra `$LASTEXITCODE`, backup, marker validation, đóng gói đủ file), nhưng chưa chạy thực tế trên máy Windows (`pwsh` không cài trên máy test macOS).
- **Bộ kịch bản nghiệm thu (`TEST-CASES.md`)**: Gồm 28 kịch bản thiết kế để đánh giá hành vi AI. Đã chạy thực tế kiểm tra 4 lớp (`RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`) và thử nghiệm kế thừa qua 2 phiên theo `examples/DEMO-README.md` trên Antigravity/Gemini; chưa chạy hết 28 kịch bản end-to-end trên cả 4 nền tảng AI (`NOT TESTED`).
