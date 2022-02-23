// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase/views/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key, required this.users, required this.uid})
      : super(key: key);

  final Users users;
  final String uid;

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController nama = TextEditingController();
  TextEditingController umur = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

  int time = DateTime.now().millisecondsSinceEpoch;

  UserC? userC;

  File? img;
  String? imgName;
  String? imgUrl;

  Future<void> pilihGambar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      img = File(result.files.single.path.toString());
      imgName = result.files.first.name;
    } else {
      print(">>> Tidak ada gambar yang dipilih <<<");
    }
    setState(() {});
  }

  Future<void> uploadFile(String name, File file) async {
    try {
      await storage.ref(name).putFile(file);
      print(">>> Gambar berhasil diupload <<<");
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> getUrl(String imgName) async {
    imgUrl = await storage.ref(imgName).getDownloadURL();
  }

  @override
  void initState() {
    userC = UserC();
    nama.text = widget.users.nama;
    umur.text = widget.users.umur;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update User"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (img != null)
                Container(
                  width: MediaQuery.of(context).size.height * 0.15,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: FileImage(img as File)),
                      color: Colors.grey,
                      shape: BoxShape.circle),
                )
              else
                Container(
                  width: MediaQuery.of(context).size.height * 0.15,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.users.gambar)),
                      color: Colors.grey,
                      shape: BoxShape.circle),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: nama,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: const Text("Nama")),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: umur,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: const Text("Umur")),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Pilih Gambar"),
                onPressed: () => pilihGambar(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'loading...');
                    await uploadFile(
                        time.toString() + imgName.toString(), img as File);

                    await getUrl(time.toString() + imgName.toString());

                    userC!.update(
                        widget.uid, nama.text, umur.text, imgUrl.toString());

                    EasyLoading.dismiss();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false);
                  },
                  child: const Text("Ubah"))
            ],
          ),
        ),
      ),
    );
  }
}
