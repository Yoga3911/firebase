import '../repository/firebase.dart';

class UserC {
  Future<void> add(String nama, String umur, String gambar) async {
    await Repository.users.add({
      "nama": nama,
      "umur": umur,
      "gambar": gambar,
    });
  }

  Future<void> delete(String id) async {
    await Repository.users.doc(id).delete();
  }

  Future<void> update(String id, String nama, String umur, String gambar) async {
    await Repository.users.doc(id).update({
      "nama": nama,
      "umur": umur,
      "gambar": gambar,
    });
  }
}
