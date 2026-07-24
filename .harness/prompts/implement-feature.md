# implement-feature — Usulkan diff untuk task ter-scope

Muat `_preamble.md` dulu. Ini menghasilkan **proposal** (advisor-only),
bukan eksekusi.

## Input (isi manusia)

- **Task:** <T-###>
- **Plan:** <link `docs/plans/<slug>.md`>

## Output yang diminta ke agent

1. Konfirmasi task + Deps sudah selesai (baca `progress.md`).
2. Deklarasi scope (R900.4 `_preamble` bagian 4).
3. Untuk tiap file: keluarkan PROPOSAL sesuai format `_preamble.md`
   bagian 5 (CREATE/MODIFY/DELETE/RUN).
4. **Jelaskan tiap baris kode** dalam Bahasa Indonesia sederhana
   (aturan Sangu) — terutama istilah teknis.
5. Cite R### yang jadi dasar tiap keputusan (mis. R100.3 uang int).
6. Sertakan Verification (`flutter analyze`, `flutter test`, atau
   `dart run build_runner build -d` bila perlu).
7. Risks / Unknowns + Rollback.

## Aturan

- Kode = zona runtime → **usul, jangan eksekusi** (R900.1).
- Nol warning `flutter analyze` (R100.1).
- Setelah proposal, **berhenti & tunggu** (R900.4).
