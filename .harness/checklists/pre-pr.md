# Checklist — Pre-PR

Semua item pre-commit, ditambah:

- [ ] Semua item `pre-commit.md` lolos
- [ ] CI GitHub Actions hijau (Ratchet: sekali hijau, tetap hijau)
- [ ] `build_runner build -d` bersih tanpa konflik
- [ ] **Audit aksesibilitas** (gate `DESIGN.md`, R602):
  - [ ] Kontras teks WCAG AA (4.5:1) (R602.1)
  - [ ] Untung/rugi pakai dual-encoding ikon+tanda+warna (R602.2)
  - [ ] Angka uang tabular figures (R602.3)
  - [ ] Target sentuh ≥ 48dp (R602.4)
  - [ ] Layout tahan teks diperbesar (R602.5)
- [ ] Bila menyentuh AI: `responseSchema` ada, kategori dari taksonomi,
      parse aman (R500)
- [ ] Bila menyentuh UI: warna dari `ColorScheme`, motion spring (R600, R601)
- [ ] `docs/progress.md` terupdate (Current Task + Session Log)
- [ ] Task `T-###` ditandai `[✓]` di `MVP.md` bila selesai
