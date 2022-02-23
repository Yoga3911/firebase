import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/views/create.dart';
import 'package:firebase/views/update.dart';
import 'package:flutter/material.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../repository/firebase.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserC? userC;

  @override
  void initState() {
    userC = UserC();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddUser())),
          child: const Icon(Icons.add)),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Firebase"),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: Repository.users.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: snapshot.data!.docs.map((e) {
                  final user = Users.fromJson(e.data() as Map<String, dynamic>);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(e["gambar"]),
                    ),
                    title: Text(user.nama),
                    subtitle: Text(user.umur),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateUser(
                                  users: user,
                                  uid: e.id,
                                ))),
                    trailing: IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        userC!.delete(e.id);
                        setState(() {});
                      },
                    ),
                  );
                }).toList(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
