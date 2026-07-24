# _preamble — Task Preamble

Muat atau rujuk ini di awal tiap task. Ini me-re-prime agent walau
sesi panjang atau modelnya kecil. Berlaku untuk **model apa pun**.

## 1. Identity check (agent nyatakan ini dulu)

> "Saya dalam Advisor-Only mode (R900). Untuk kode aplikasi saya
> mengusulkan diff & perintah, tidak mengeksekusi. Untuk dokumentasi
> (R900.8) saya boleh mengedit langsung. Kamu yang review & jalankan
> kode."

## 2. Konfirmasi rule termuat

Agent konfirmasi sudah membaca:

- [ ] `.harness/rules/R900-advisor-only-mode.md`
- [ ] `.harness/rules/R000-meta.md`
- [ ] `CLAUDE.md`
- [ ] `docs/DECISIONS.md`
- [ ] Rule spesifik task: <daftar, mis. R100, R500>

Kalau ada file hilang, agent berhenti dan bertanya.

## 3. Restate task

Agent menyatakan ulang task dengan kata sendiri, ≤3 kalimat. Manusia
konfirmasi/koreksi sebelum agent lanjut.

## 4. Deklarasi scope

Agent mendaftar:

- File yang akan disentuh (+ alasan tiap file)
- File yang TIDAK disentuh (berdekatan tapi di luar scope)
- Zona tiap file: **dokumentasi** (auto-edit, R900.8) atau **runtime**
  (advisor-only, R900.9)
- Dependency baru yang dibutuhkan (atau "tidak ada")
- Asumsi yang dibuat

Kalau ada asumsi tidak aman, agent bertanya sebelum mengusulkan.

## 5. Format output proposal (untuk zona runtime)

Untuk tiap perubahan file kode:

    ### PROPOSAL <N>: <judul singkat>
    **Action**: CREATE | MODIFY | DELETE
    **Path**: <path file>
    **Rule citations**: <R###, R###>
    **Purpose**: <satu baris>

    ```dart
    <isi penuh untuk CREATE, atau unified diff untuk MODIFY>
    ```

    ### Verification
    ```bash
    <perintah persis yang manusia jalankan>
    ```
    **Expected**: <output yang diharapkan>

Untuk tiap perintah terminal:

    ### PROPOSAL <N>: <judul singkat>
    **Action**: RUN
    **Location**: terminal
    **Purpose**: <satu baris>

    ```bash
    <perintah>
    ```

    ### Verification
    <cara tahu berhasil>

## 6. Risks & Unknowns

Akhiri tiap task dengan:

    ### Risks / Unknowns
    - <risiko/ketidakpastian 1>
    (atau "tidak ada")

    ### Rollback
    <cara membatalkan bila verifikasi gagal>

## 7. Pengingat stop conditions

Agent berhenti dan menunggu manusia setelah:

- Tiap batch proposal (jangan lanjut ke langkah berikutnya).
- Ambiguitas apa pun.
- Konflik rule apa pun.
- File/dependency/kredensial yang hilang.

## 8. Bahasa output

- Isi file dokumentasi (docs/, .harness/, learning_docs): **Bahasa
  Indonesia** (konvensi Sangu).
- Komentar kode: **English**.
- Penjelasan chat ke manusia: **Bahasa Indonesia** sederhana; jelaskan
  tiap baris kode (aturan Sangu).
