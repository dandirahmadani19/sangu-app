# Checklist — Pre-Commit

Dijalankan sebelum tiap commit (juga di-enforce `lefthook.yml`).

- [ ] `dart format --set-exit-if-changed .` → bersih (R100.1)
- [ ] `flutter analyze` → nol error, nol warning (R100.1)
- [ ] `flutter test` → semua hijau (R300.7)
- [ ] Bila ubah model/provider/Drift: `dart run build_runner build -d`
      sudah dijalankan, file generate ikut ter-stage (R100.14)
- [ ] Uang disimpan sebagai `int` Rupiah (R100.3)
- [ ] Tidak ada teks tampilan hardcode (R100.4)
- [ ] Tidak ada secret / API key ter-commit (R400.1)
- [ ] Pesan commit sesuai Conventional Commits + scope valid (R200)
- [ ] Commit atomik (satu perubahan logis) (R200.8)

> Doc-zone (docs/, .harness/, learning_docs) MAY di-commit terpisah
> dengan type `docs:` + cite ADR/rule (R900.8, R200.11).
