import 'package:Text2dio/controller/FileChooser.dart';
import 'package:Text2dio/databases/DbHelper.dart';
import 'package:Text2dio/model/TextModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddText extends StatefulWidget {
  @override
  _AddTextState createState() => _AddTextState();
}

class _AddTextState extends State<AddText> {
  final _titleController = TextEditingController();
  final _startPageController = TextEditingController();
  final _endPageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FileChooser fc = FileChooser();
  String filePath;
  String text = "";
  final DbHelper helper = new DbHelper();
  TextModel textModel;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var _edge = width * 0.05;

    return Scaffold(
        appBar: AppBar(
          title: Text('Extract Text'),
          titleSpacing: -0.2,
          leading: Icon(Icons.my_library_add),
          backgroundColor: Colors.red[800],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: new EdgeInsets.all(_edge),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText:
                                      'Enter the title of the text(all text formats)',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red[400])),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent))),
                              controller: _titleController,
                              validator: (val) => val.isNotEmpty
                                  ? null
                                  : 'Title should not be empty',
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: 'start page for pdf',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red[400],
                                              width: 1.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent))),
                                  controller: _startPageController,
                                )),
                                SizedBox(
                                  width: _edge,
                                ),
                                Expanded(
                                    child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: 'end page for pdf',
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red[400])),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent))),
                                  controller: _endPageController,
                                ))
                              ],
                            ),
                            SizedBox(height: _edge * 0.7),
                            Row(
                              children: [
                                Container(
                                  width: width * 0.425,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      text = await fc.extractText();

                                      if (text != null) {
                                        _saveText(context);
                                      }
                                    },
                                    child: Text('Extract .txt and save'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[400],
                                      onPrimary: Colors.white,
                                      elevation: 7.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: _edge),
                                Container(
                                  width: width * 0.425,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            text = null;
                                          });

                                          int sp = 9;
                                          int ep;

                                          if (_startPageController.text.isEmpty)
                                            sp = 0;
                                          else
                                            sp = int.parse(
                                                _startPageController.text);

                                          if (_endPageController.text.isEmpty)
                                            ep = 0;
                                          else
                                            ep = int.parse(
                                                _endPageController.text);

                                          print("$sp and $ep");
                                          fc
                                              .extractPDF(sp: sp, ep: ep)
                                              .then((value) {
                                            setState(() {
                                              text = value;
                                              if (text != null &&
                                                  text.isNotEmpty) {
                                                _saveTextPDF(context, sp, ep);
                                              }
                                            });
                                          });
                                        }
                                      },
                                      child: Text('Extract .pdf and save'),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red[400],
                                          onPrimary: Colors.white,
                                          elevation: 7.0)),
                                )
                              ],
                            ),
                            Center(
                              child: text == null
                                  ? new CircularProgressIndicator(
                                      backgroundColor: Colors.red[400],
                                      strokeWidth: 2.0,
                                    )
                                  : new Container(),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> _saveText(BuildContext context) async {
    String dt;
    if (_formKey.currentState.validate()) {
      if (textModel == null) {
        dt = DateTime.now().toString();
        textModel = TextModel(
            body: text, title: _titleController.text, date_created: dt);
        _titleController.clear();
        print('THE VALUE OF DATE: ${textModel.date_created}');
        int res = await helper.saveText(textModel);

        setState(() {
          if (res < 0) {
            Fluttertoast.showToast(
                msg: '${_titleController.text} already exists in the database',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                textColor: Colors.red,
                backgroundColor: Colors.white,
                fontSize: 16.0);
          } else {
            Fluttertoast.showToast(
                msg: 'successfully extracted',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                textColor: Colors.red,
                backgroundColor: Colors.white,
                fontSize: 16.0);
          }
        });
      }
    }
  }

  Future<void> _saveTextPDF(BuildContext context, int sp, int ep) async {
    String dt;
    if (textModel == null) {
      dt = DateTime.now().toString();
      String title;
      if (sp == ep && sp != 0)
        title = "${_titleController.text} page $sp";
      else if (sp == ep && sp == 0)
        title = "${_titleController.text}";
      else
        title = "${_titleController.text} page $sp to page $ep";

      textModel = TextModel(body: text, title: title, date_created: dt);
      _titleController.clear();
      print('THE VALUE OF DATE: ${textModel.date_created}');
      int res = await helper.saveText(textModel);

      setState(() {
        if (res < 0) {
          Fluttertoast.showToast(
              msg: '${_titleController.text} already exists in the database',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              textColor: Colors.red,
              backgroundColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: 'successfully extracted',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              textColor: Colors.red,
              backgroundColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }
}
