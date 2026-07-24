# R602 — Accessibility & Anti-Generic Look

Aksesibilitas adalah gate, bukan opsional. Sekaligus menjaga app tidak
terlihat generik/"AI default". Rujukan: `docs/DESIGN.md`.

## R602.1 — Kontras WCAG AA

Semua teks MUST memenuhi kontras minimal **WCAG AA** (4.5:1 untuk teks
normal). Audit kontras SHOULD jadi gate pre-PR (lihat
`.harness/checklists/pre-pr.md`).

## R602.2 — Dual-encoding untung/rugi

Status untung/rugi MUST NOT dikodekan warna saja. MUST pakai
**dual-encoding**: ikon (↑/↓) + tanda (+/−) + warna. Alasan: user buta
warna tetap paham.

**Salah:**
```dart
Text('40000', style: TextStyle(color: red)); // warna saja
```
**Benar:**
```dart
Row(children: [Icon(Icons.arrow_downward), Text('−Rp40.000')]); // ikon + tanda + warna
```

## R602.3 — Tabular figures untuk uang

Angka uang MUST pakai **tabular figures** (lebar digit seragam) agar
kolom nominal rapi & mudah dibandingkan.

## R602.4 — Target sentuh ≥ 48dp

Semua elemen interaktif MUST punya target sentuh minimal 48dp.

## R602.5 — Dukung teks besar

App MUST menghormati skala font sistem. MUST NOT mengunci `textScaleFactor`
atau memakai ukuran font absolut yang merusak layout saat teks
diperbesar.

## R602.6 — Hierarki trust-first

Layar utama MUST menampilkan info terpenting tanpa scroll, urutan (per
`DESIGN.md`): saldo (hero) → kartu AI insight → item butuh perhatian →
transaksi terakhir → streak/progress.

## R602.7 — Anti-generic look

MUST NOT memakai tampilan default Material yang generik (ungu default,
warna fintech dingin). Ikuti arah warm-earthy-editorial + shape
organik (R600). Tujuan: terasa dewasa, tenang, tepercaya — bukan
template.
