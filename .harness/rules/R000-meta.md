# R000 — Meta Rules

Rule ini mengatur bagaimana semua rule lain dibaca dan diterapkan.
Berlaku untuk **agent apa pun** (model apa pun) yang mengerjakan Sangu.

## R000.1 — Rule dibaca di awal task

Tiap task dimulai dengan membaca `CLAUDE.md`, yang menunjuk file
wajib. Agent MUST NOT mengandalkan rule yang "diingat" dari awal
sesi. Baca ulang.

## R000.2 — Cite ID rule di proposal

Tiap diff atau proposal MUST menyebut ID rule yang jadi dasarnya.

**Benar:**
> Pakai `int` untuk amount (per R100.3, uang selalu int Rupiah).

**Salah:**
> Pakai `int` karena lebih pas.

## R000.3 — Ambiguitas → tanya, jangan berimprovisasi

Kalau rule ambigu atau dua rule bertabrakan tanpa override eksplisit,
agent MUST berhenti dan bertanya ke manusia. MUST NOT memilih satu
tafsir lalu jalan sendiri.

## R000.4 — Kategori lebih tinggi menang saat seri

Kalau rule dari kategori berbeda memberi arahan bertabrakan dan tidak
ada override eksplisit, kategori bernomor lebih tinggi menang
(R900 > R500 > R100). Rule tertentu bisa override dengan klausa
"OVERRIDES: R###".

## R000.5 — Ubah rule wajib lewat ADR

Agent MUST NOT mengedit file rule diam-diam. Tambah dulu entri ADR di
`docs/DECISIONS.md` yang menjelaskan:

- Rule mana yang berubah
- Kenapa (masalah apa yang diselesaikan)
- Perilaku lama vs baru

Lalu update file rule di commit yang sama.

## R000.6 — Rule untuk agent DAN manusia

Rule bersifat self-descriptive. Kalau manusia mengabaikan rule saat
review, agent tetap menerapkan rule. Kalau manusia mau pengecualian,
ia menambah komentar inline `// waives: R###` beserta alasannya.

## R000.7 — Wording model-agnostic

Rule MUST ditulis dalam kalimat pendek dan eksplisit yang bisa
diikuti model kecil tanpa menebak. Utamakan:

- **MUST / MUST NOT / SHOULD / SHOULD NOT / MAY** (arti RFC-2119)
- Contoh konkret (positif dan negatif)
- Sub-rule bernomor untuk citation granular (R100.2, R100.3)

Hindari:

- Kata kerja kabur ("pertimbangkan", "coba", "biasanya")
- Rule yang butuh "membaca yang tersirat"
- Rule yang hanya masuk akal dengan pengetahuan di luar repo

## R000.8 — Tidak ada penguncian model

Harness ini model-agnostic (ADR-016). Rule MUST NOT mensyaratkan
model tertentu untuk fase mana pun. Rekomendasi model (mis. model
kuat untuk Plan/Verify) bersifat saran, bukan aturan yang di-enforce.
