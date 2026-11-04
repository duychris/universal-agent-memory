# An toàn Git và đồng bộ bộ nhớ

**Chỉ áp dụng khi workspace/kho memory sử dụng Git hoặc symlink/junction.** Đây là hướng dẫn thao tác an toàn, không phải một dịch vụ đồng bộ tự động.

## 1. Kiểm tra đầu phiên

Trong repo hoặc bản sao memory:

```bash
pwd
git rev-parse --show-toplevel
git branch --show-current
git status --short
git remote -v
```

- Xác minh đường dẫn repo, nhánh và remote là nơi dự định dùng.
- Trước khi coi dữ liệu mới nhất, dùng `git fetch` nếu có quyền/kết nối, so phiên bản local/remote và commit mới nhất. **Chỉ `git pull --ff-only` khi working tree sạch, nhánh phù hợp và không có thay đổi chưa được bảo vệ**.
- Nếu không có mạng/quyền, ghi rõ đang đọc snapshot local ở commit nào, **không tuyên bố đã cập nhật**.
- Nếu có sửa dở, không rebase/pull/reset để ép sync. Ghi lại trạng thái và xử lý xung đột có kiểm soát.

## 2. Kiểm tra link của bộ nhớ

Dấu hiệu hỏng: agent ghi file nhưng repo không thấy thay đổi; index xuất hiện bản cũ; đường dẫn tới thư mục memory không còn tồn tại; hai máy có số/tên thẻ khác nhau.

macOS/Linux:

```bash
ls -ld memory
readlink memory                 # nếu memory là symlink
realpath memory                 # nếu có realpath
```

Windows PowerShell:

```powershell
Get-Item -Force .\memory | Format-List FullName,LinkType,Target
Test-Path .\memory\MEMORY.md
```

**Bắt buộc kiểm tra đích** có đúng thư mục canonical và chứa index mong đợi. Một đường dẫn tồn tại chưa đủ chứng minh đang trỏ đúng kho. Với một bản sao khác, so index, commit và các thẻ vừa cập nhật.

Nếu link đứt hoặc memory bị chia hai:
1. **Dừng ghi** vào cả hai bên; không xóa/move/thay link ngay.
2. Ghi lại hai đường dẫn thực, tên/mtime và phiên bản Git liên quan.
3. Sao lưu nội dung mỗi bên theo quyền được cấp; diff từng file và giải quyết mâu thuẫn.
4. Chỉ sau khi xác minh bản hợp nhất đúng, tạo lại link nếu có quyền; kiểm test bằng một file an toàn hoặc đọc trạng thái.
5. Ghi lại bài học và kết quả, không nói “đã sync” trước khi verified.

**Tuyệt đối không** dùng `rm -rf` để thay một thư mục memory đang chứa dữ liệu chưa hợp nhất.

## 3. CẤM lệnh stage và hủy hàng loạt

Trong workflow này, không dùng:

```bash
git add -A
git add .
git commit -am "..."
git reset --hard
git checkout -- some-file
git clean -fd
```

Cũng không được mặc nhiên dùng `git restore`, `git push --force`, xóa thư mục hoặc `stash` của người khác. Những lệnh trên có thể nuốt hoặc xóa WIP của agent cùng workspace.

## 4. Commit chính xác phần mình làm

Ví dụ agent chỉ sửa **hai file**:

```bash
git status --short
git diff --name-only
git add -- memory/MEMORY.md memory/feedback-research-source.md
git diff --cached --name-only
git diff --cached
git diff --cached --check
```

**Nếu index đã staged thay đổi từ trước không thuộc task:** không chạy `git commit` thông thường; dùng workspace/worktree riêng hoặc trao đổi để bảo vệ phần staged của agent khác. Không tự unstage hay reset. Bằng chứng commit đúng scope là staged diff đã xem **ngay trước commit**, không phải status kiểm từ đầu phiên.

Chỉ khi staged diff đúng scope và kết quả kiểm tra đạt, mới commit:

```bash
git commit -m "[AgentName] record source-verification lesson"
```

- Nếu file của agent khác đã staged từ trước, **không commit** vào chung; phải làm sạch sự chồng lấn một cách có chủ đích, bảo tồn WIP.
- Nếu không thể phân biệt phạm vi thay đổi, đừng đoán: báo coordinator, tách patch hoặc worktree mới.
- Không push lên nhánh đang triển khai/publish nếu chưa được cấp quyền rõ. Push chỉ khi cấu hình workflow cho phép.
- Nếu push thất bại vì remote có thay đổi: fetch → so sánh → hợp nhất có ý thức; không force push.

## 5. Đa agent

Nếu nhiều agent cùng làm, mặc định chọn **worktree/branch riêng**, mỗi agent chịu trách nhiệm về file đã giao. Một nhánh dùng chung chỉ an toàn khi có cơ chế bàn giao quyền sửa rõ ràng. Nếu cần kiểm tra đồng bộ: ngoài việc đọc đúng URL/path, kiểm xem thay đổi mới thực sự tới kho đích mà agent khác được quyền đọc; **không tự tạo bản sao public** để giải quyết vấn đề truy cập. Thẻ memory xung đột phải được giải quyết dựa trên nguồn và thời gian hiệu lực, không theo chiến lược “last writer wins”.

## 6. Git có phải điều kiện dùng Skill?

Không. Nếu workspace không có Git, vẫn áp dụng đọc đầu phiên, truy xuất bằng chứng, ghi memory có nguồn, handoff, phân quyền và tránh đè file. Khi đó thay `commit SHA` bằng revision/đường dẫn/ngày và xác nhận lưu của hệ thống đang dùng.
