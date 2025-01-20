import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/sifre_service.dart';
import '../Models/Sifre.dart';
import 'package:flutter/services.dart';

class SifreYonetimSayfasi extends StatefulWidget {
  @override
  State<SifreYonetimSayfasi> createState() => _SifreYonetimSayfasiState();
}

class _SifreYonetimSayfasiState extends State<SifreYonetimSayfasi> {
  final SifreServis _sifreServis = SifreServis();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Yönetimi'),
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/kullaniciSifreGuncellemeSayfasi");
            },
            icon: const Icon(Icons.edit),
            tooltip: "Kullanıcı Şifre Güncelleme",
          ),
          IconButton(
            onPressed: () => cikisYap(context),
            icon: const Icon(Icons.logout),
            tooltip: "Çıkış Yap",
          )
        ],
      ),
      body: StreamBuilder(
          stream: _sifreServis.kullaniciSifreleri(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Şifre Bulunamadı.",
                  style: TextStyle(color: Colors.indigo),
                ),
              );
            }

            final sifreListesi = snapshot.data!;

            return ListView.builder(
                padding: const EdgeInsets.only(bottom: 50.0),
                itemCount: sifreListesi.length,
                itemBuilder: (context, index) {
                  final sifre = sifreListesi[index];
                  return Card(
                    color: Colors.indigo[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        sifre.isim,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTruncatedText(
                              label: "URL: ", value: sifre.url, isim: "URL"),
                          _buildTruncatedText(
                            label: "K. Adı: ",
                            value: sifre.kullaniciAdi,
                            isim: "Kullanıcı Adı"
                          ),
                          _buildTruncatedText(
                              label: "Şifre: ", value: sifre.sifre, isim: "Şifre"),
                          _buildTruncatedText(label: "Not: ", value: sifre.not, isim: "İsim"),
                        ],
                      ),
                      leading: const Icon(
                        Icons.lock,
                        color: Colors.indigo,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                _guncelle(context, sifre, _sifreServis),
                            icon: const Icon(Icons.edit, color: Colors.amber),
                            tooltip: "Şifre Güncelle",
                          ),
                          IconButton(
                            onPressed: () => _sil(context, sifre, _sifreServis),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Şifre Sil",
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _sifreEkle(context, _sifreServis),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: "Şifre Ekle",
      ),
    );
  }

  Widget _buildTruncatedText(
      {required String label, required String value, required String isim}) {
    const int maxChars = 30;
    final bool isTruncated = value.length > maxChars;

    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$isim kopyalandı: $value')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Tooltip(
          message: value,
          child: Text(
            "$label${isTruncated ? "${value.substring(0, maxChars)}..." : value}",
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

void _sifreEkle(BuildContext context, SifreServis servis) {
  final TextEditingController isimDenetleyici = TextEditingController();
  final TextEditingController urlDenetleyici = TextEditingController();
  final TextEditingController kullaniciAdiDenetleyici = TextEditingController();
  final TextEditingController sifreDenetleyici = TextEditingController();
  final TextEditingController notDenetleyici = TextEditingController();

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              "Yeni Şifre Ekle",
              style: TextStyle(color: Colors.indigo),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(controller: isimDenetleyici, label: "İsim"),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: kullaniciAdiDenetleyici,
                      label: "Kullanıcı Adı"),
                  const SizedBox(height: 8),
                  _buildTextField(controller: sifreDenetleyici, label: "Şifre"),
                  const SizedBox(height: 8),
                  _buildTextField(controller: urlDenetleyici, label: "URL"),
                  const SizedBox(height: 8),
                  _buildTextField(controller: notDenetleyici, label: "Not"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("İptal", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () async {
                  final isim = isimDenetleyici.text.trim();
                  final url = urlDenetleyici.text.trim();
                  final kullaniciAdi = kullaniciAdiDenetleyici.text.trim();
                  final sifre = sifreDenetleyici.text.trim();
                  final not = notDenetleyici.text.trim();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  try {
                    await servis.sifreEkleme(Sifre(
                      id: '',
                      isim: isim,
                      url: url,
                      kullaniciAdi: kullaniciAdi,
                      sifre: sifre,
                      not: not,
                      kullaniciId: FirebaseAuth.instance.currentUser!.uid,
                    ));

                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Şifre başarıyla eklendi.")),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Şifre eklenirken bir hata oluştu.")),
                    );
                  }
                },
                child: const Text(
                  "Kaydet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ));
}

Widget _buildTextField(
    {required TextEditingController controller, required String label}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.indigo, width: 2),
      ),
    ),
  );
}

void _guncelle(BuildContext context, Sifre sifre, SifreServis servis) {
  final TextEditingController isimController =
      TextEditingController(text: sifre.isim);
  final TextEditingController urlController =
      TextEditingController(text: sifre.url);
  final TextEditingController kullaniciAdiController =
      TextEditingController(text: sifre.kullaniciAdi);
  final TextEditingController sifreController =
      TextEditingController(text: sifre.sifre);
  final TextEditingController notController =
      TextEditingController(text: sifre.not);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Şifre Güncelle",
        style: TextStyle(color: Colors.indigo),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(controller: isimController, label: "İsim"),
            const SizedBox(height: 8),
            _buildTextField(controller: urlController, label: "URL"),
            const SizedBox(height: 8),
            _buildTextField(
                controller: kullaniciAdiController, label: "Kullanıcı Adı"),
            const SizedBox(height: 8),
            _buildTextField(controller: sifreController, label: "Şifre"),
            const SizedBox(height: 8),
            _buildTextField(controller: notController, label: "Not"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          onPressed: () async {
            final yeniSifre = Sifre(
              id: sifre.id,
              isim: isimController.text.trim(),
              url: urlController.text.trim(),
              kullaniciAdi: kullaniciAdiController.text.trim(),
              sifre: sifreController.text.trim(),
              not: notController.text.trim(),
              kullaniciId: sifre.kullaniciId,
            );

            try {
              await servis.sifreGuncelleme(yeniSifre);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Şifre başarıyla güncellendi.")),
              );
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Güncelleme sırasında hata: $e")),
              );
            }
          },
          child: const Text(
            "Kaydet",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

void _sil(BuildContext context, Sifre sifre, SifreServis servis) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Şifre Sil"),
      content: const Text("Bu şifreyi silmek istediğinizden emin misiniz?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("İptal", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () async {
            try {
              await servis.sifreSilme(sifre);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Şifre başarıyla silindi.")),
              );
            } catch (e) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Silme sırasında hata: $e")),
              );
            }
          },
          child: const Text(
            "Sil",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

void cikisYap(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(context, '/anaSayfa', (route) => false);
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Çıkış sırasında bir hata ile karşılaşıldı.')),
    );
  }
}
