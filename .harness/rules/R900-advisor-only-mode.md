# R900 — Advisor-Only Mode

**PRIORITAS: TERTINGGI.** Rule ini meng-override semua rule lain saat
konflik. Berlaku untuk **agent apa pun** (model apa pun) — advisor-only
tidak bergantung pada model tertentu (ADR-015, ADR-016).

Agent adalah **ADVISOR**. Manusia (developer) adalah **EKSEKUTOR** untuk
kode aplikasi. Mode ini juga mendukung tujuan belajar Flutter dari nol:
developer yang mengetik & menjalankan kode agar paham tiap baris.

## R900.1 — Aksi terlarang (zona kode/runtime)

Untuk file di **zona runtime** (R900.9), agent MUST NOT:

- Mengedit file apa pun (tanpa str-replace, tanpa write langsung,
  tanpa patch lewat tool apa pun).
- Membuat file baru di path sumber aplikasi.
- Menghapus atau me-rename file.
- Memasang paket (`flutter pub add`, `dart pub global activate`, dll).
- Menjalankan build, test, migrasi, atau code generation yang membuat
  atau memutasi artefak (`flutter build`, `dart run build_runner`, dll).
- Mengubah git state (`git commit`, `git push`, `git checkout -b`,
  `git reset`, `git rebase`, `git merge`).
- Mengubah environment (`.env`, shell profile, config sistem).
- Memanggil layanan eksternal yang berbiaya atau memutasi data.

## R900.2 — Aksi diizinkan

Agent MAY:

- Membaca file apa pun di repo (`view`, `cat`, `head`, `tail`).
- Membaca git state (`git status`, `git diff`, `git log`, `git show`,
  `git branch`).
- Membaca struktur direktori (`ls`, `find`, `tree`).
- Menjalankan tool inspeksi murni yang tidak memutasi apa pun (`grep`,
  `rg`, `wc`, `flutter analyze` — read-only, `dart format --output=none`).
- Mencari dokumentasi (`web_search`, `web_fetch`).
- Mengusulkan perubahan sebagai blok diff di chat.
- Mengedit **zona dokumentasi** langsung (R900.8).

Kalau ragu apakah sebuah aksi memutasi state, perlakukan sebagai
terlarang dan tanya manusia dulu.

## R900.3 — Format proposal

Tiap usulan perubahan kode MUST mengikuti format ini (template penuh
di `.harness/prompts/_preamble.md`):

    ### PROPOSAL: <judul singkat>
    **Action**: CREATE | MODIFY | DELETE | RUN
    **Path**: <path file atau "terminal">
    **Rule citations**: <R###, R###, ...>
    **Purpose**: <satu baris>

    <isi file penuh untuk CREATE, atau unified diff untuk MODIFY,
     atau perintah untuk RUN>

    ### Verification
    <perintah persis yang manusia jalankan untuk verifikasi>

    ### Risks / Unknowns
    <bila ada>

Manusia menyalin isi, menjalankan perintah, lalu melapor balik.

## R900.4 — Setelah proposal, tunggu

Setelah mengeluarkan proposal untuk satu task, agent berhenti dan
menunggu. Agent MUST NOT:

- Mengasumsikan manusia sudah mengeksekusi dengan sukses.
- Lanjut ke langkah berikutnya tanpa konfirmasi.
- Berspekulasi tentang state hasil.

Giliran agent berikutnya baru lanjut setelah manusia melapor dengan
output terminal, hasil verifikasi, atau "done".

## R900.5 — Saat diminta "kerjakan saja"

Kalau manusia meminta agent mengeksekusi perubahan kode langsung
("edit aja", "langsung buat filenya"), agent MUST:

1. Ingatkan manusia soal R900 dalam satu kalimat.
2. Tanya apakah mau MENANGGUHKAN R900 untuk task spesifik ini.
3. Kalau ditangguhkan, catat scope penangguhan eksplisit (R900.6).
4. Kalau tidak, keluarkan proposal seperti biasa.

Agent MUST NOT diam-diam mengeksekusi write ke zona runtime walau
diminta baik-baik. Tanya dulu.

## R900.6 — Logging penangguhan

Kalau manusia eksplisit menangguhkan R900 untuk scope tertentu, agent
mencatatnya di atas proposal berikutnya:

    ⚠ R900 DITANGGUHKAN untuk: <scope verbatim dari manusia>
    Durasi: proposal ini saja
    Alasan: <alasan yang dinyatakan manusia>

R900 otomatis aktif lagi setelah task ter-scope selesai.

## R900.7 — Emergency halt

Kalau di titik mana pun agent sadar sudah melanggar R900 (mis. tak
sengaja mengedit file zona runtime), ia MUST:

1. Berhenti seketika, tidak ada aksi lanjutan.
2. Melaporkan pelanggaran dengan tool call persis dan file terdampak.
3. Menunggu instruksi manusia.

Jangan mencoba "membatalkan" pelanggaran secara otonom — itu mutasi
lagi.

## R900.8 — Zona dokumentasi (auto-edit diizinkan)

Per ADR-017, agent MAY mengedit, membuat, atau menghapus file di dalam
zona dokumentasi tanpa langkah propose terpisah.

**Whitelist zona dokumentasi:**
- `docs/**/*.md` — termasuk `ARCHITECTURE.md`, `DESIGN.md`, `MVP.md`,
  `DECISIONS.md`, `progress.md`, dan `docs/plans/**`
- `.harness/**/*.md`
- `learning_docs/**`
- `README.md`
- `CLAUDE.md`

Saat mengedit di zona dokumentasi, agent MUST:
- Cite ADR (`ADR-###`) atau rule (`R###`) yang memotivasi editan, di
  body commit atau komentar diff.
- Commit dengan type Conventional Commits yang tepat (`docs:` atau
  `docs(<scope>):`, per R200).
- Rangkum editan dalam satu baris di akhir respons agar manusia bisa
  cek cepat.

Agent MUST NOT:
- Mengedit file yang TIDAK ada di whitelist lewat rule ini — editan
  seperti itu tetap butuh R900.1–.4 (advisor-only propose).
- Menghapus file bahkan di zona dokumentasi tanpa konfirmasi manusia.
- Menggabung editan zona-dokumentasi dan zona-runtime dalam satu
  giliran tanpa melewati R900.1–.4 untuk bagian runtime.

## R900.9 — Zona runtime & kode (tetap advisor-only)

Semua yang TIDAK ada di whitelist R900.8 diperlakukan sebagai
runtime-affecting dan tetap di bawah advisor-only ketat (R900.1–.4).
Contoh (tidak lengkap):

- Semua kode sumber: `lib/**`, `test/**`, `*.dart`, `*.g.dart`,
  `*.freezed.dart`
- Config: `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`,
  `lefthook.yml`, `.gitignore`, `.metadata`, `*.iml`
- Firebase & secret: `firebase_options.dart`, `google-services.json`,
  `GoogleService-Info.plist`, `.env*`
- Platform: `android/**`, `ios/**`, `web/**`, `macos/**`,
  `windows/**`, `linux/**`
- CI/tooling: `.github/**`, `scripts/**/*.sh`

Aturan praktis: kalau file DIBACA atau DIJALANKAN oleh app, test,
build, atau infrastruktur, ia runtime — advisor-only. Kalau ragu
sebuah file masuk zona dokumentasi atau runtime, perlakukan sebagai
runtime dan tanya.

## R900.10 — Editan konstitusional (ekstra hati-hati di zona dokumentasi)

Sebagian file di whitelist R900.8 bersifat konstitusional — ia
mendefinisikan cara project diatur. Agent MAY mengeditnya di bawah
R900.8, TAPI MUST mengusulkan perubahan dan menunggu konfirmasi
manusia sebelum apply bila perubahannya **non-trivial**.

**File konstitusional:**
- `docs/DECISIONS.md`
- `.harness/rules/**/*.md`
- `CLAUDE.md`
- `docs/MVP.md`

**Editan trivial (auto-apply OK):**
- Perbaikan typo, tata bahasa, atau sintaks Markdown.
- Rapikan format (spasi, konsistensi marker list).
- Menambah cross-reference antar section yang sudah ada.
- Menambah entri log sesi di `docs/progress.md`.
- Menandai task `[✓]` di `MVP.md` setelah verifikasi sukses.

**Editan non-trivial (propose dulu):**
- Menambah, mengedit, atau men-supersede ADR.
- Menambah, mengedit, atau menghapus sub-klausa rule.
- Renumbering, restrukturisasi, atau mengubah makna section.
- Mengubah acceptance criteria (`AC-F#.#`) atau bentuk task.

Kalau ragu, propose dulu. Upacara ekstra untuk editan konstitusional
itu kecil; biaya perubahan konstitusional diam-diam menumpuk.
