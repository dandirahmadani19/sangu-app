# .harness/ — Harness Engineering untuk Sangu

Folder ini adalah lingkungan terekayasa yang memandu AI agent saat
mengerjakan Sangu. Dirancang **model-agnostic** — aturan dan prompt
harus menghasilkan output andal walau memakai model kecil (DeepSeek,
Gemini Flash, Haiku, model lokal), bukan hanya model frontier. Tidak
ada aturan yang mengunci "fase X wajib model Y".

## Struktur

```
.harness/
├── README.md      # File ini
├── rules/         # Aturan bernomor (R###)
├── prompts/       # Template task (paste ke chat)
├── checklists/    # Pre-commit / pre-PR / rilis
└── examples/      # Contoh output baik/buruk
```

## Penomoran rule

Rule dinomori per kategori. Tiap rule punya ID stabil (`R###`) supaya
bisa dicite ringkas di review, commit, dan diff.

| Rentang    | Kategori                          |
| ---------- | --------------------------------- |
| R000–R099  | Meta (cara pakai harness)         |
| R100–R199  | Coding standards (Dart/Flutter)   |
| R200–R299  | Commit & git                      |
| R300–R399  | Testing                           |
| R400–R499  | Security                          |
| R500–R599  | AI integration                    |
| R600–R699  | Design system                     |
| R700–R899  | Cadangan                          |
| R900–R999  | Role & mode (prioritas tertinggi) |

Kategori bernomor lebih tinggi menang saat konflik (R900 > R500 >
R100). Rule tertentu bisa meng-override ini lewat klausa "OVERRIDES"
eksplisit.

### Daftar rule aktif

| ID   | Judul                                    |
| ---- | ---------------------------------------- |
| R000 | Meta — cara rule dibaca & diterapkan     |
| R100 | Coding standards (Dart/Flutter)          |
| R200 | Commit & git conventions                 |
| R300 | Testing standards (realistis MVP)        |
| R400 | Security baseline (client app, ringan)   |
| R500 | AI integration (Firebase AI + Gemini)    |
| R600 | Design tokens                            |
| R601 | Motion & haptics                         |
| R602 | Accessibility & anti-generic look        |
| R900 | Advisor-Only Mode (prioritas tertinggi)  |

## Cara pakai

- **Tiap task baru:** agent baca `CLAUDE.md`, lalu file yang ditunjuk,
  lalu rule apa pun yang disentuh task.
- **Review manusia:** cite ID rule saat memberi feedback ("melanggar
  R100.3", "lihat R602.2").
- **Mengubah rule:** jangan pernah edit diam-diam. Tambah ADR di
  `docs/DECISIONS.md` dulu, lalu update rule di commit yang sama
  (R000.5).

## Kata kunci normatif

Rule memakai kata kunci gaya RFC-2119 (dalam huruf besar) supaya
model kecil bisa mengikuti tanpa menebak: **MUST / MUST NOT / SHOULD
/ SHOULD NOT / MAY**. Prosa penjelas ditulis Bahasa Indonesia;
identifier kode, keyword bahasa, dan kata kunci normatif dibiarkan
apa adanya.

## Prompt templates

`prompts/` berisi template siap-paste untuk task umum:

- `_preamble.md` — WAJIB dimuat konseptual di awal task
- `plan-feature.md` — ubah deskripsi fitur jadi daftar task
- `implement-feature.md` — usulkan diff untuk task ter-scope
- `review-diff.md` — review diff terhadap rule
- `debug-error.md` — alur debugging terstruktur (Flutter/Dart)
- `design-ai-schema.md` — desain schema & prompt Gemini

Salin template ke chat, isi placeholder, kirim.

## Advisor-Only Mode

Project ini berjalan dalam **advisor-only mode**: agent mengusulkan,
manusia mengeksekusi kode aplikasi. Pengecualian: file dokumentasi
boleh diedit agent langsung. Lihat `rules/R900-advisor-only-mode.md`.
