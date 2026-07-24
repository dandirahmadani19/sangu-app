# Contoh — Dual-encoding untung/rugi (R602.2)

Status untung/rugi tidak boleh dikodekan **warna saja** — user buta
warna tidak bisa membedakan merah dan hijau.

## ❌ Salah (warna saja)

```dart
Text(
  formatRupiah(tx.amount),
  style: TextStyle(
    color: tx.type == TxType.income ? Colors.green : Colors.red,
  ),
);
```

## ✅ Benar (ikon + tanda + warna)

```dart
final isIncome = tx.type == TxType.income;
Row(
  children: [
    Icon(isIncome ? Icons.arrow_upward : Icons.arrow_downward,
        color: theme.colorScheme.positiveOrNegative(isIncome)),
    Text(
      '${isIncome ? '+' : '−'}${formatRupiah(tx.amount)}',
      style: theme.textTheme.moneyTabular, // tabular figures (R602.3)
    ),
  ],
);
```

Tiga sinyal sekaligus: **ikon** (↑/↓), **tanda** (+/−), dan **warna**.
Warna dari `ColorScheme` (R600.2), bukan `Colors.red` hardcode.
