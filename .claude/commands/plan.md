Susun rencana kerja detail untuk tugas berikut: $ARGUMENTS

Sebelum mulai: muat `.harness/prompts/_preamble.md` (advisor-only, R900)
dan cek `docs/DECISIONS.md` (ADR terkunci).

Rencana harus mencakup:
- File yang dibuat/diubah (path lengkap) + ZONA tiap file: doc
  (auto-edit, R900.8) atau runtime (advisor-only, R900.9)
- Isi tiap file: class, method, struktur data
- Urutan pengerjaan aman (yang tanpa dependency dulu)
- Rule R### & ADR-### yang relevan tiap langkah
- Edge case yang perlu dihandle
- Test minimal (R300)
- Verify: perintah persis + hasil yang diharapkan

Aturan:
- Jangan tulis kode implementasi (hanya rencana); kode = advisor-only.
- Pastikan tidak bertabrakan dengan ADR di `docs/DECISIONS.md`.
- Simpan plan final ke `docs/plans/<slug>.md` sebelum eksekusi.
- Tunggu approval sebelum lanjut ke eksekusi.
- Sampaikan dalam Bahasa Indonesia.
