# plan-feature — Ubah deskripsi fitur jadi daftar task

Muat `_preamble.md` dulu.

## Input (isi manusia)

- **Fitur:** <deskripsi 1–3 kalimat>
- **Milestone target:** <M#, mis. M3>
- **Batasan:** <bila ada>

## Output yang diminta ke agent

1. **Restate** fitur + kaitkan ke `AC-F#.#` di `MVP.md` (buat baru bila
   belum ada).
2. **Pecah** jadi task `T-###` (counter global, lanjut dari terakhir di
   `MVP.md`) dengan shape:
   ```
   ### T-###: judul
   - Deps: T-### (atau "none")
   - Est: S | M | L
   - Files: file utama yang disentuh
   - Rules: R### yang relevan
   - AC: AC-F#.# yang dipenuhi
   - Verify: perintah persis + hasil yang diharapkan
   ```
3. **Urutkan** task dari yang tak punya dependency dulu.
4. **Tandai** tiap task: zona dokumentasi atau runtime.
5. Cek tidak bertabrakan dengan ADR terkunci di `DECISIONS.md`.

## Aturan

- Jangan tulis kode implementasi di fase plan (hanya rencana).
- Tunggu approval sebelum lanjut ke `implement-feature.md`.
- Simpan plan final ke `docs/plans/<slug>.md` sebelum eksekusi.
