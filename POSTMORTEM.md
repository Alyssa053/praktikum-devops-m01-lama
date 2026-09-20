# Blameless Postmortem - Insiden Kegagalan Deployment Manual

## Ringkasan Insiden

Pada JOB 2 dilakukan simulasi deployment manual dari lingkungan Developer
ke lingkungan Operations.

Proses dimulai pada pukul 21.55 WIB dan berakhir pada pukul 22.00 WIB.
Deployment mengalami kegagalan dengan jumlah failed attempts sebanyak 1 kali.
Selain itu, terdapat 2 pertanyaan atau informasi yang perlu diklarifikasi
kepada Developer selama proses deployment.

Insiden ini menunjukkan bahwa proses deployment masih memiliki ketergantungan
pada serah-terima manual antara Developer dan Operations.

## Kronologi (timeline)

| Waktu | Kejadian |
|---|---|
| 21.55 WIB | Operations memulai proses deployment manual. |
| Selama proses | Operations mengalami kendala dalam menjalankan deployment dan terdapat informasi yang perlu diklarifikasi kepada Developer. |
| Selama proses | Terjadi 1 failed attempt. |
| 22.00 WIB | Proses deployment dinyatakan gagal. |

## Dampak (waktu terbuang, jumlah kegagalan)

Berdasarkan hasil JOB 2, proses deployment manual memiliki Lead Time
sebesar 5 menit, dengan 1 failed attempt dan 2 pertanyaan yang perlu
diklarifikasi kepada Developer.

Kegagalan tersebut menyebabkan proses deployment tidak dapat diselesaikan
sesuai tujuan simulasi dan menunjukkan adanya aktivitas serta ketergantungan
komunikasi yang masih dilakukan secara manual.

Hasil JOB 4 kemudian menunjukkan perubahan setelah dilakukan otomasi:

- Lead Time: 15 menit menjadi 2 menit
- Langkah manual: 8 menjadi 1
- Kegagalan: 1 menjadi 0
- Komunikasi Dev-Ops: 2 menjadi 1

## Akar Masalah pada SISTEM (bukan pada orang)

Akar masalah tidak diletakkan pada kelalaian individu Developer maupun
Operations, melainkan pada desain proses deployment yang masih bergantung
pada serah-terima manual.

Proses tersebut belum memiliki mekanisme yang cukup untuk memastikan
kesiapan environment, dependency, dan proses deployment dapat dilakukan
secara konsisten oleh Operations.

Akibatnya, keberhasilan deployment masih bergantung pada informasi dan
langkah manual yang dilakukan oleh personel yang terlibat.

Perbaikan sistem dilakukan dengan menerapkan otomasi deployment melalui
`setup.sh`. Script tersebut digunakan untuk membantu proses pengecekan
environment, pemasangan dependency, menjalankan aplikasi, dan melakukan
health check.

## Tindakan Perbaikan (action items) + penanggung jawab peran

| No. | Tindakan Perbaikan | Penanggung Jawab |
|---|---|---|
| 1 | Menstandarkan kebutuhan dan dependency aplikasi sebelum deployment. | Developer |
| 2 | Menggunakan `setup.sh` untuk mengotomasi proses setup dan deployment. | Developer |
| 3 | Melakukan health check setelah aplikasi dijalankan. | Developer / Operations |
| 4 | Melakukan validasi hasil deployment sebelum proses dinyatakan selesai. | Operations |
| 5 | Menyimpan artefak dan perubahan menggunakan version control. | Developer / Operations |

## Pelajaran yang Diambil

Kegagalan pada deployment manual menunjukkan bahwa proses yang bergantung
pada serah-terima dan langkah manual dapat menimbulkan kegagalan serta
kebutuhan komunikasi tambahan.

Hasil JOB 4 menunjukkan bahwa otomasi dapat mengurangi Lead Time, jumlah
langkah manual, jumlah kegagalan, dan kebutuhan komunikasi antara Developer
dan Operations.

Oleh karena itu, perbaikan proses tidak hanya berfokus pada individu yang
melakukan pekerjaan, tetapi pada perancangan sistem kerja yang lebih
terstandar dan dapat diulang.
