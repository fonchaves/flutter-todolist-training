import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoController = TextEditingController();
  List _todoList = [];

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = _todoController.text;
      _todoController.text = "";
      newTodo["ok"] = false;
      _todoList.add(newTodo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        labelText: "New Task",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  onPressed: _addTodo,
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    onChanged: (isPress) {
                      setState(() {
                        _todoList[index]["ok"] = isPress;
                      });
                    },
                    title: Text(_todoList[index]),
                    value: _todoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(
                          _todoList[index]["ok"] ? Icons.check : Icons.error),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveDataToFile() async {
    String data = await json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readDataFromFile() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (error) {
      print(error);
      return null;
    }
  }
}
