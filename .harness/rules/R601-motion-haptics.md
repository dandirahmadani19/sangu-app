# R601 — Motion & Haptics

Motion di Sangu adalah **feedback fungsional**, bukan hiasan. Semua
gerak pakai fisika spring (nuansa M3E). Rujukan: `docs/DESIGN.md`.

## R601.1 — Spring, bukan durasi tetap

Semua transisi MUST pakai **spring (fisika)**, MUST NOT durasi tetap
(`Duration(milliseconds: 300)` sebagai kurva utama gerak layout).
Spring "spatial" untuk perpindahan posisi/layout; spring "effects"
untuk fade/scale.

## R601.2 — Library standar

Pakai `flutter_animate` untuk animasi + `HapticFeedback` untuk getar.
MUST NOT menumpuk banyak library animasi berbeda tanpa alasan.

## R601.3 — Token motion konsisten

Parameter spring (stiffness/damping) MUST diambil dari token motion
terpusat (`lib/core/theme/`), dipakai sama di seluruh app. MUST NOT
menulis nilai spring acak per widget.

## R601.4 — Microinteraction fungsional

Momen berikut MUST punya feedback (per `DESIGN.md`):

| Momen | Feedback |
|---|---|
| Transaksi tersimpan | konfirmasi singkat + haptic ringan |
| Scan/parse struk | progress → reveal form pra-isi |
| Target budget tercapai | animasi rayakan + haptic sukses |
| Budget terlewat | peringatan (warna + ikon) + haptic beda |
| Streak bertambah | angka streak "naik" dengan spring |

Haptic MUST membedakan sukses vs peringatan (jenis getar beda).

## R601.5 — Hormati reduce-motion

Bila OS user mengaktifkan reduce-motion, app SHOULD menurunkan
intensitas animasi (bukan menghapus feedback sepenuhnya). Aksesibilitas
> estetika.
