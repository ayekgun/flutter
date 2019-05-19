import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  AddTask({this.email});
  final String email;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _tgl = new DateTime.now();
  String _dateText = '';
  String newtask ='';
  String note ='';

  Future<Null> _selectTgl(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _tgl,
      firstDate: new DateTime(2017),
      lastDate: new DateTime(2030)
    );
    if (picked!=null && picked != _tgl){
      print('Date Selected: ${_tgl.toString()}');
      setState(() {
        _tgl = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
    
  }
  void _addData(){
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection("task");
      await reference.add({
        "email" : widget.email,
        "title" : newtask,
        "tgl" : _tgl,
        "note" : note,
        
      });      
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    _dateText = "${_tgl.day}/${_tgl.month}/${_tgl.year}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        children: <Widget>[
          new Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/head.jpg"), fit: BoxFit.cover)),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "My Task",
                  style: new TextStyle(
                      fontSize: 28, fontFamily: "Pacif", color: Colors.white),
                ),
                new Text(
                  "Add Task",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                new Icon(
                  Icons.list,
                  size: 50,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new TextField(
              onChanged: (String str){
                setState(() {
                  newtask = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.dashboard),
                  hintText: "New Task",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Icon(Icons.date_range),
                ),
                new Expanded(
                    child: new Text(
                  "Tanggal",
                  style: new TextStyle(fontSize: 22, color: Colors.black),
                )),
                new FlatButton(
                    onPressed: () => _selectTgl(context),
                    child: new Text(
                      _dateText,
                      style: new TextStyle(fontSize: 22, color: Colors.black),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new TextField(
              onChanged: (String str){
                setState(() {
                  note = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.note),
                  hintText: "Note",
                  border: InputBorder.none),
              style: new TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.check, size: 40,),
                  onPressed: (){
                    _addData();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 40,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
