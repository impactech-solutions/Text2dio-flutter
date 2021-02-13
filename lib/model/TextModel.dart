import 'package:flutter/foundation.dart';

class TextModel {
  int id;
  String title;
  String body;
  // ignore: non_constant_identifier_names
  String date_created;

  // ignore: non_constant_identifier_names
  TextModel({@required this.title, @required this.body, @required this.date_created, this.id});

  Map<String, dynamic> toMap() {
    return {'title': title, 'body': body, 'date_created': date_created};
  }
}
