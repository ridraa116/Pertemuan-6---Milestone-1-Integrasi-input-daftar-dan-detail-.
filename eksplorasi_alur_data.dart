// ============================================================================
//  PENUGASAN KELAS SI 5C – Pengantar Integrasi Navigasi, Form, dan State
//  Cara pakai: buka https://dartpad.dev, hapus isi editor, tempel SELURUH
//  isi file ini, lalu klik Run.
// ============================================================================
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DaftarPage()));

// ---------------- HALAMAN 1: DAFTAR (memegang data) ----------------
class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  // STATE: daftar nama yang bisa bertambah.
  final List<String> _daftar = ['Rina Amelia', 'Budi Santoso'];

  Future<void> _bukaForm() async {
    // (1) Buka halaman form, lalu TUNGGU (await) sampai form ditutup.
    final hasil = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const FormPage()),
    );

    // (2) Halaman ini mungkin sudah ditutup selama menunggu.
    if (!mounted) return;

    // (3) null artinya pengguna kembali tanpa menyimpan.
    if (hasil == null) return;

    // (4) Tambahkan nama baru, lalu minta layar digambar ulang.
    setState(() {
      _daftar.add(hasil);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Mahasiswa (${_daftar.length})')),
      body: ListView(
        children: [
          for (final nama in _daftar)
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(nama),
              // (5) Kirim nama yang diketuk ke halaman Detail.
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage(nama: nama)),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---------------- HALAMAN 2: FORM (mengembalikan data) ----------------
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      // KEMBALIKAN data ke halaman sebelumnya.
      Navigator.pop(context, _namaController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (nilai) => (nilai == null || nilai.trim().isEmpty)
                    ? 'Nama wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _simpan, child: const Text('Simpan')),
              TextButton(
                // Batal: kembali TANPA data.
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- HALAMAN 3: DETAIL (menerima data) ----------------
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.nama});

  final String nama;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(child: Text(nama, style: const TextStyle(fontSize: 24))),
    );
  }
}
