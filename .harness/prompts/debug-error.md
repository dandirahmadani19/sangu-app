# debug-error — Alur debugging terstruktur (Flutter/Dart)

Muat `_preamble.md` dulu. Mode read-only sampai ada usulan perbaikan.

## Input (isi manusia)

- **Error / gejala:** <pesan error, stack trace, atau perilaku salah>
- **Kapan muncul:** <langkah reproduksi>
- **Yang sudah dicoba:** <bila ada>

## Alur yang diminta ke agent

1. **Restate** gejala + hipotesis awal (≤3 kalimat).
2. **Lokalisasi**: baca file relevan (read-only), tunjuk `file:line`
   yang dicurigai. Pertimbangkan penyebab khas Flutter:
   - Lupa `dart run build_runner` setelah ubah model/provider/Drift.
   - Null-safety (`!` di nilai null).
   - `Future` tak di-`await` / state Riverpod tak rebuild.
   - Stream Drift tak ter-listen.
   - Parse AI gagal (JSON tak sesuai `responseSchema`).
3. **Konfirmasi hipotesis** dengan bukti dari kode/log (bukan tebakan).
4. **Usulkan perbaikan** sebagai PROPOSAL (format `_preamble.md`) —
   jangan langsung edit kode.
5. Sertakan Verification + cara mencegah regresi (test? lihat R300).

## Aturan

- Perbaikan kode = zona runtime → usul, jangan eksekusi (R900.1).
- Cek dulu penyebab paling murah (build_runner, import) sebelum
  menyalahkan logika dalam.
