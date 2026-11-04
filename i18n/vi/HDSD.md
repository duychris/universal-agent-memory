# HƯỚNG DẪN SỬ DỤNG — Universal Agent Memory v3

**Dành cho người không biết code.** Cài một lần cho **mỗi môi trường** AI, rồi sử dụng công việc bình thường. Không cần server, tài khoản dịch vụ mới, cơ sở dữ liệu hay lệnh `memoryctl`.

## 1. Hiểu đúng trong 30 giây

- **Global Rules** = một đoạn chỉ dẫn ngắn mà AI đọc mỗi phiên tại môi trường được hỗ trợ.
- **Skill (`SKILL.md`)** = cách AI đọc ngữ cảnh, xác minh, học từ lỗi, checkpoint và bàn giao.
- **Memory (`MEMORY.md`, `feedback-*.md`...)** = những file thực tế được lưu ngoài hội thoại để phiên sau đọc lại.
- **Checkpoint** = ghi lại tiến độ **giữa chừng** sau mốc có giá trị; không cần chờ hết buổi làm việc.

> Skill không phải bộ nhớ tự động của hãng AI. Nếu agent không đọc được nơi lưu memory, nó **không thể nhớ xuyên phiên** dù cài Skill thành công.

## 2. Tải ZIP và giải nén

Giải nén `universal-agent-memory-v3.zip`. Bên trong có **một folder tên `universal-agent-memory`**. Không đổi tên `SKILL.md` hoặc bốc riêng file đó ra; giữ cả `references`, `rules`, `templates`.

**Mẹo cho Mac:** Trong Finder, bấm `Cmd + Shift + G` và dán đường dẫn có `~` để đến các thư mục ẩn.
**Windows:** Dán đường dẫn `%USERPROFILE%\...` vào thanh địa chỉ File Explorer.

## 3. Cài Skill — chọn AI đang dùng

| AI | Trên Mac / Linux: đưa *folder nguyên vẹn* vào | Windows: đặt dưới `%USERPROFILE%` |
|---|---|---|
| **Claude Code** | `~/.claude/skills/` | `.claude\skills\` |
| **Codex** | `~/.agents/skills/` | `.agents\skills\` |
| **Gemini CLI** | `~/.agents/skills/` (có thể dùng chung bản Codex) | `.agents\skills\` |
| **Antigravity** | `~/.gemini/config/skills/` | `.gemini\config\skills\` |

Sau khi đặt vào, tệp phải ở dạng `.../skills/universal-agent-memory/SKILL.md`. Không tạo nhầm hai cấp `universal-agent-memory/universal-agent-memory/`.

**Dùng nhiều AI:** Mac có thể copy folder sang 3 chỗ (`~/.agents/skills`, `~/.claude/skills`, `~/.gemini/config/skills`); **Codex và Gemini CLI có thể dùng chung bản đầu**. Nếu dùng symlink, chỉ làm khi biết cách kiểm tra; copy là dễ nhất và phải cập nhật các bản khi nâng cấp.

**Cloud, web hoặc sandbox:** Skill trên ổ cứng Mac không tự xuất hiện ở cloud. Cần cài/upload ở môi trường đó theo cách được nền tảng hỗ trợ. Không kỳ vọng ChatGPT chat thông thường tự đọc file `~/.agents/skills`.

## 4. Kích hoạt xuyên phiên bằng Global Rules — bước QUAN TRỌNG

Chỉ đặt Skill vào folder **chưa đủ**. Đọc [rules/README.md](rules/README.md), sau đó:

1. Chọn mẫu tương ứng: `rules/claude-code.md`, `rules/codex.md`, `rules/gemini.md` hoặc `rules/antigravity-alternative.md`.
2. Mở **file Global Rules đang có** trong bảng dưới (nếu chưa có, tạo file mới). Chỉ **copy khối giữa hai marker `UAM-V3`** từ mẫu vào cuối file; **không xóa** nội dung sẵn có. Nếu đã có marker thì cập nhật đúng phần trong marker, không nhân đôi.
3. Mở một phiên AI **mới** (hoặc reload rules theo khả năng của app) để kiểm tra.

| AI | Global Rules |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| Gemini CLI | `~/.gemini/GEMINI.md` |
| Antigravity | **Ưu tiên dùng chung `~/.gemini/GEMINI.md` với Gemini CLI**; nếu dùng độc lập, `~/.gemini/config/AGENTS.md` hoặc mục Global Rules trong app |

**Có cả Gemini CLI và Antigravity trên cùng máy:** Chỉ cài đoạn UAM vào `~/.gemini/GEMINI.md` trước, kiểm tra Antigravity có nạp không. Nếu có, **không** dán thêm vào file Antigravity khác, tránh lặp và tốn ngữ cảnh.

**Không muốn sửa tay?** Đưa folder ZIP đã giải nén cho Codex/Claude có quyền truy cập file local và dán câu này:

> Đọc HDSD.md và rules/README.md của bộ Universal Agent Memory v3 tôi vừa cung cấp. Hãy cài SKILL.md và các file đi kèm ở phạm vi user cho các agent đang có trên máy. Ghép đoạn UAM-V3 vào Global Rules đang tồn tại (không ghi đè, không tạo đoạn trùng). Nếu có Gemini CLI và Antigravity cùng đọc GEMINI.md thì chỉ neo một lần. Trước khi sửa, liệt kê vị trí và các file sẽ tác động; chỉ thao tác khi có quyền. Kiểm tra Skill được tìm thấy, Rules đã đọc và bộ nhớ canonical có thể đọc; báo trạng thái từng lớp, không nói đã đồng bộ nếu chưa kiểm. Không thay đổi project code, xóa dữ liệu hoặc cài dịch vụ ngoài phạm vi yêu cầu.

## 5. Memory thực sự nằm ở đâu?

Skill được cài **global** nhưng dữ liệu **không nên trộn mọi dự án thành một kho**. Với mỗi workspace/chủ đề, chọn **một kho canonical** mà AI có quyền truy cập, ví dụ:

```text
my-project/
├── AGENTS.md                  # nếu dự án dùng quy tắc riêng
├── memory/
│   ├── MEMORY.md              # mục lục, liên kết tới các thẻ
│   ├── feedback-....md
│   └── decision-....md
├── handoffs/
│   └── latest.md              # checkpoint/handoff mới nhất
└── CHANGELOG.md
```

- Dự án đã có kho memory: **giữ nguyên**, nói cho agent đường dẫn canonical; không tạo mới ở nơi khác.
- Dự án mới: yêu cầu agent tạo từ [templates/MEMORY.md](templates/MEMORY.md) nếu mày cho phép.
- Không có dự án/code: chọn thư mục cá nhân cho **chủ đề cụ thể** (ví dụ “Học tiếng Anh”), đặt index trong đó, rồi nói đường dẫn cho agent. Không bắt buộc dùng Git.
- Multi-agent khác tài khoản: các AI **phải cùng được cấp quyền** vào một nơi chung (thư mục chia sẻ/Git private/connector phù hợp). Khác tài khoản không tự đọc được ổ cứng hay bộ nhớ của nhau.

## 6. Một AI dùng xuyên phiên như thế nào?

**Lần đầu:**

> Dùng Universal Agent Memory v3 trong thư mục công việc này. Nếu chưa có bộ nhớ, tạo `memory/MEMORY.md` theo template và `handoffs/latest.md` sau khi kiểm tra không có kho khác. Ghi lại mục tiêu, cách làm và những quyết định thực sự được xác nhận.

**Trong khi làm:** Agent đọc memory đầu việc, làm, kiểm chứng. Sau mốc quan trọng nó cập nhật checkpoint, không đợi hết cuộc chat. Một câu hỏi đơn giản sẽ không sinh thêm file vô ích.

**Ngày hôm sau, mở chat mới:**

> Tiếp tục công việc ở đây. Hãy đọc Universal Agent Memory và checkpoint/handoff mới nhất, đối chiếu trạng thái hiện tại rồi nêu bước tiếp theo.

Nếu Global Rules đã nạp, agent nên chủ động làm những bước này cho công việc có trạng thái; câu lệnh trên là **cách kiểm tra/khôi phục** khi cần, không phải bắt buộc gõ mỗi lần.

## 7. Kiểm tra sau khi cài — đừng chỉ hỏi “đã hoạt động chưa?”

Mở một **phiên mới** rồi đưa yêu cầu này:

> Hãy kiểm tra Universal Agent Memory theo 4 lớp: (1) Global Rules đã đọc từ file nào? (2) SKILL.md v3 đã được nạp từ đường dẫn nào? (3) `MEMORY.md` canonical của workspace hiện tại nằm đâu, có đọc được không? (4) Đã ghi và đọc lại thành công checkpoint thử nghiệm trong thư mục thử được phép chưa? Nếu chưa test ghi thì trả `NOT VERIFIED`. Không tạo file hay sửa cấu hình ngoài thư mục thử. Liệt kê bằng chứng, không suy đoán.

Kết quả cần có bằng chứng tách biệt. Nếu agent chưa được phép ghi thử, **đừng** biến `NOT VERIFIED` thành `PASS`. Test lại ở phiên mới: nhờ nó đọc một bài học đã lưu trong workspace mà không đưa nội dung bài học vào prompt.

- Claude Code: xem `/memory` và khả năng gọi `/universal-agent-memory` (tùy phiên bản).
- Codex: yêu cầu gọi `$universal-agent-memory` và cho biết nguồn SKILL.md được tải.
- Gemini CLI: dùng `/skills list` và `/skills reload` nếu cần; kiểm tra prompt kích hoạt, xác nhận đồng ý khi app hỏi.
- Antigravity: vào **Customizations → Skills/Rules** hoặc gọi `/universal-agent-memory` nếu phiên bản hỗ trợ.

## 8. Sự cố thường gặp

| Triệu chứng | Việc cần kiểm tra |
|---|---|
| AI không tìm thấy Skill | Tên folder, chính xác `SKILL.md`, YAML `name/description`, đúng đường dẫn, restart/reload |
| Cài rồi mà AI không đọc | Chưa có Global Rules, Skill chưa được activate hoặc quyền đọc bị giới hạn |
| Phiên sau không nhớ | Chưa ghi file, kho canonical sai, checkpoint chưa persisted, hoặc phiên sau không đọc kho đó |
| Hai AI nhớ khác nhau | Quyền đọc/ghi khác, hai bản local không sync, symlink lỗi, chưa fetch hoặc nguồn có xung đột |
| Memory phình to | Dùng LIGHT cho việc nhỏ, chỉ ghi bài học bền vững; cập nhật thẻ cũ, không tạo trùng |
| Mất quota hoặc crash trước cuối phiên | Checkpoint sau mốc quan trọng giảm mất mát nhưng **không đảm bảo** cứu mọi công việc chưa lưu |
| Gemini + Antigravity nhắc quy tắc hai lần | Gỡ **chỉ khối UAM trùng** ở một file global sau khi đã kiểm tra nguồn được nạp, giữ các quy tắc khác |
| Agent nói đã sync nhưng không chỉ ra bằng chứng | Trạng thái thực tế là `UNKNOWN` hoặc `SYNC_PENDING`; xác minh ở kho đích |

## 9. Giới hạn quan trọng

- V3 là **instruction-only**; không tự chạy khi agent đã thoát, không tự bắt crash, không tự lên lịch, không có dịch vụ đồng bộ ngầm.
- Global Rules giúp tăng xác suất tuân thủ chứ **không bảo đảm 100%**; quyền filesystem, quy trình review và bảo vệ nhánh mới là lớp cưỡng chế.
- Mỗi tài khoản/host có thể phải cài riêng; cloud session không mặc định thừa hưởng cấu hình local.
- Không lưu mật khẩu, token, dữ liệu riêng tư chưa được phép vào repo memory hoặc file handoff chia sẻ.

**Bản ngắn nhất:** Cài Skill → ghép Global Rules → chọn kho nhớ chung → xác minh 4 lớp → dùng bình thường.

Tài liệu chi tiết: [references/platform-setup.md](references/platform-setup.md) và [references/activation-and-checkpoints.md](references/activation-and-checkpoints.md).
