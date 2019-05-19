import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/editTask.dart';
import 'package:flutter_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'addTask.dart';

class MyTask extends StatefulWidget {
  MyTask({this.user, this.gsi});
  final FirebaseUser user;
  final GoogleSignIn gsi;
  @override
  _MyTaskState createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  void _signOut() {
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 215,
        child: new Column(
          children: <Widget>[
            new ClipOval(
                child: Image.network(
              widget.user.photoUrl,
              height: 120,
            )),
            new Padding(
                padding: EdgeInsets.all(10),
                child: new Text(
                  "Sign Out ?",
                  style: new TextStyle(fontSize: 15, color: Colors.red),
                )),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.gsi.signOut();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new MyHomePage()));
                  },
                  child: new Column(
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: new Text("Yes"),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Column(
                    children: <Widget>[
                      Icon(Icons.close),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: new Text("Cancel"),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.purple[700],
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => AddTask(
                      email: widget.user.email,
                    )));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: new BottomAppBar(
          color: Colors.purple[700],
          child: ButtonBar(
            children: <Widget>[],
          ),
        ),
        //bikin background yang diatas
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 160),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("task")
                    .where("email", isEqualTo: widget.user.email)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return new TaskList(document: snapshot.data.documents);
                  }
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            new Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage("img/head.jpg"), fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(color: Colors.black, blurRadius: 8)
                  ]),
              //bikin photo, welcome, nama, button exit dalam satu row
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.all(10),
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  image: NetworkImage(widget.user.photoUrl))),
                        ),
                        new Expanded(
                          child: new Padding(
                            padding: EdgeInsets.all(10),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("Welcome",
                                    style: new TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: "Pacif")),
                                new Text(
                                  widget.user.displayName,
                                  style: new TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: "Pacif"),
                                )
                              ],
                            ),
                          ),
                        ),
                        new IconButton(
                          icon: Icon(Icons.exit_to_app,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            _signOut();
                          },
                        )
                      ],
                    ),
                  ),
                  new Text(
                    "My Task",
                    style: new TextStyle(
                        fontSize: 28, fontFamily: "Pacif", color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String title = document[i].data['title'].toString();
        String note = document[i].data['note'].toString();
        DateTime tgls = document[i].data['tgl'].toDate();
        String tgl = "${tgls.day}/${tgls.month}/${tgls.year}";
        return new Dismissible(
            key: new Key(document[i].documentID),
            onDismissed: (direction){
              Firestore.instance.runTransaction((transaction)async{
                DocumentSnapshot snapshot = await transaction.get(document[i].reference);
                await transaction.delete(snapshot.reference);
              });
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text("Data berhasil dihapus"),
                )
              );
            },

                  child: Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            title,
                            style: new TextStyle(fontSize: 20, letterSpacing: 1),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.note,
                                color: Colors.purple,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              note,
                              style: new TextStyle(
                                fontSize: 18,
                              ),
                            )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.date_range,
                                color: Colors.purple,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tgl,
                                style: new TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                new IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => EditTask(
                              title: title,
                              note: note,
                              tgl: document[i].data['tgl'].toDate(),
                              index: document[i].reference,
                            )));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
