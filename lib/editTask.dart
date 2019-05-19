import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTask extends StatefulWidget {
  EditTask({this.title, this.tgl, this.note, this.index});
  final String title;
  final DateTime tgl;
  final String note;
  final index;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  DateTime _tgl;
  String _dateText = '';
  String newtask ='';
  String note ='';

  TextEditingController controllerTitle;
  TextEditingController controllerNote;

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
  void _editTask(){
    Firestore.instance.runTransaction((Transaction transaction)async{
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "title" : newtask,
        "note" : note,
        "tgl" : _tgl,
      });
    });
    Navigator.pop(context);
  }
  @override
  void initState() {
    _tgl = widget.tgl;

    newtask = widget.title;
    note = widget.note;

    controllerTitle = new TextEditingController(text: widget.title);
    controllerNote = new TextEditingController(text: widget.note);
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
              controller: controllerTitle,
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
              controller: controllerNote,
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
                    _editTask();
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
