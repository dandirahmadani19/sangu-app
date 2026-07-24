# review-diff — Review diff terhadap rule

Muat `_preamble.md` dulu. Mode read-only.

## Input (isi manusia)

- **Diff:** <tempel `git diff` atau path file>
- **Task terkait:** <T-### bila ada>

## Output yang diminta ke agent

Untuk tiap temuan:

    ### TEMUAN <N>: <judul singkat>
    **Severity**: blocker | mayor | minor | nit
    **Rule**: <R###.N yang dilanggar>
    **Lokasi**: <file:line>
    **Masalah**: <apa yang salah>
    **Usulan**: <perbaikan konkret>

Cek minimal:
- R100 (int Rupiah, no hardcode teks, Notifier→Repository, async, error handling)
- R200 (pesan commit)
- R300 (ada test untuk jalur kritis?)
- R400/R500 (secret, App Check, responseSchema, taksonomi) bila menyentuh AI
- R600/R601/R602 (token, spring, dual-encoding, WCAG) bila menyentuh UI

Kalau bersih: nyatakan "Tidak ada pelanggaran rule" + hal yang patut
diapresiasi (opsional).

## Aturan

- Hanya review — jangan mengedit kode (advisor-only).
- Cite ID rule di tiap temuan (R000.2).
