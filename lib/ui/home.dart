import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_login/ui/addpost.dart';
import 'package:firebase_login/ui/login.dart';
import 'package:firebase_login/ui/postscreen.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final searchcontroller = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('Post');
  final editcontroller = TextEditingController();

  Future<void> updateDialog(String title, String id) async {
    editcontroller.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              child: TextFormField(
                decoration: InputDecoration(),
                controller: editcontroller,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ref.child(id).update(
                        {'post': editcontroller.text.toString()}).then((value) {
                      Toast().toastMessage("updated successfully");
                    }).onError((error, stackTrace) {
                      Toast().toastMessage(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Update")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Toast().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout_rounded)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostScreen()));
              },
              icon: Icon(Icons.local_post_office_rounded))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: searchcontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Search"),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('post').value.toString();

                    if (searchcontroller.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('post').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: ListTile(
                                    title: Text("Edit"),
                                    trailing: Icon(Icons.edit),
                                    onTap: () {
                                      Navigator.pop(context);
                                      updateDialog(
                                          title,
                                          snapshot
                                              .child('id')
                                              .value
                                              .toString());
                                    },
                                  )),
                                  PopupMenuItem(
                                    child: ListTile(
                                      title: Text("Delete"),
                                      trailing: Icon(Icons.delete),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ref
                                            .child(snapshot
                                                .child('id')
                                                .value
                                                .toString())
                                            .remove();
                                      },
                                    ),
                                  ),
                                ]),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchcontroller.text.toLowerCase())) {
                      return ListTile(
                        title: Text(snapshot.child('post').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    } else {
                      return Container();
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
