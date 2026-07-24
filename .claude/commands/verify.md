Verifikasi hasil pekerjaan sesi ini terhadap rencana + rule:

1. Bandingkan hasil dengan plan (`docs/plans/<slug>.md`) yang diapprove.
2. Jalankan checklist `.harness/checklists/pre-pr.md` (atau
   `pre-commit.md` bila belum tahap PR).
3. Ingatkan menjalankan: `dart format .` && `flutter analyze`
   (nol warning, R100.1) && `flutter test` (R300.7).
4. Cek pelanggaran rule R### pada perubahan (pakai
   `.harness/prompts/review-diff.md`).
5. Catat temuan sebagai blocker/catatan di `docs/progress.md`.

Kode tetap advisor-only (usul perbaikan, jangan eksekusi).
Sampaikan dalam Bahasa Indonesia.
