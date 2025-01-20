# **Parola Yönetim Sistemi**

### **📋 Proje Açıklaması**
**Parola Yönetim Sistemi**, kullanıcıların şifrelerini güvenli bir şekilde saklamalarına ve yönetmelerine olanak tanıyan bir uygulamadır. Bu proje, Flutter kullanılarak geliştirilmiştir ve Firebase desteği ile verilerin güvenli bir şekilde saklanmasını sağlar.

---

### **📦 Özellikler**
- Kullanıcılar için **Kayıt Olma** ve **Giriş Yapma** özelliği.
- Kullanıcıya ait şifrelerin:
  - **Ekleme**
  - **Güncelleme**
  - **Silme**
  - **Listeleme** işlemleri.
- Şifreler için ek bilgiler: URL, kullanıcı adı, not.
- Şifre kopyalama özelliği: Şifreye tıklanarak panoya kopyalanabilir.
- Şifre güncelleme ve sıfırlama işlemleri.
- Modern ve kullanıcı dostu tasarım.
- Firebase ile entegre **gerçek zamanlı veri tabanı**.

---

### **🔧 Kullanılan Teknolojiler**
- **Flutter**: Uygulama geliştirme.
- **Dart**: Programlama dili.
- **Firebase Authentication**: Kullanıcı doğrulama.
- **Firebase Firestore**: Şifre verilerinin saklanması.
- **Firebase Hosting** (isteğe bağlı): Uygulama barındırma.
- **Git**: Sürüm kontrolü.
- **Android Studio**: Geliştirme ortamı.

---

### **📂 Proje Yapısı**
plaintext
lib/
├── Models/
│   └── Sifre.dart          # Şifre model dosyası
├── Services/
│   └── sifre_service.dart  # Şifre yönetim servisleri
├── screens/
│   ├── giris_sayfasi.dart               # Giriş ekranı
│   ├── kayit_sayfasi.dart               # Kayıt ekranı
│   ├── sifre_yonetim_sayfasi.dart       # Şifre yönetim ekranı
│   ├── sifre_sifirlama_sayfasi.dart     # Şifre sıfırlama ekranı
│   └── kullanici_sifre_guncelleme.dart  # Şifre güncelleme ekranı
├── main.dart              # Ana giriş dosyası

---

### **🚀 Kurulum**

---

### **🛠️ Önemli Notlar**

1. **Firebase Yapılandırması**:
   - Proje, Firebase Authentication ve Firestore ile çalışmaktadır.
   - Firebase yapılandırma dosyası (`google-services.json`) projeye dahil edilmelidir.

2. **Android Keystore**:
   - Uygulamayı **release modunda** çalıştırmak için bir Android keystore dosyası eklemeniz gerekmektedir.

3. **Debug ve Release Modu**:
   - Debug modunda test için `flutter run` kullanabilirsiniz.
   - Release APK oluşturmak için şu komutu çalıştırın:
     ```bash
     flutter build apk --release
     ```

---
### **📸 Ekran Görüntüleri**

| **Giriş Ekranı**  | **Şifre Yönetim Ekranı** |
|--------------------|--------------------------|
| ![WhatsApp Görsel 2025-01-20 saat 23 30 56_a2492880](https://github.com/user-attachments/assets/4d0ae35f-4c6d-4256-a84a-02f47bb466fc)
![Giriş](https://via.placeholder.com/200x400?text=Giriş+Ekranı) | ![WhatsApp Görsel 2025-01-20 saat 23 30 56_a2492880](https://github.com/user-attachments/assets/6288c4b8-3e2c-4e3d-abcd-f8d4bb742f83)
![Şifre Yönetimi](https://via.placeholder.com/200x400?text=Şifre+Yönetimi) |
---

### **📬 İletişim**

Herhangi bir sorunuz veya öneriniz varsa, benimle iletişime geçebilirsiniz:

- **GitHub**: [haticezulalzengin](https://github.com/haticezulalzengin)

---
