import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf_text/pdf_text.dart';

class FileChooser {
  String filePath;
  File file;

  Future<String> fileChooser(String fileType) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [fileType],
    );
    filePath = null;
    if (result != null) {
      file = File(result.files.single.path);
    } else {
      Fluttertoast.showToast(
          msg: "cancelled",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          backgroundColor: Colors.white,
          fontSize: 16.0);
    }
    return file.path;
  }

  Future<String> extractText() async {
    String text;
    String path = await fileChooser("txt");
    try {
      if (path != null) {
        final File file = File(path);
        text = await file.readAsString();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "could not extract text",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          backgroundColor: Colors.white,
          fontSize: 16.0);
    }
    return text;
  }

  Future<String> extractPDF({int sp, int ep}) async {
    if (sp > ep) {
      Fluttertoast.showToast(
          msg: "start page cannot be greater than end page",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.red,
          backgroundColor: Colors.white,
          fontSize: 16.0);
      return "";
    }
    String text;
    String path = await fileChooser("pdf");
    PDFDoc doc = await PDFDoc.fromFile(File(path));
    //return "${doc.length}";
    if (ep == 0) {
      if (sp == 0) {
        text = await doc.text;
      } else {
        text = "";
        for (int i = sp; i <= doc.length; i++) {
          PDFPage page = doc.pageAt(i);

          text = text + "\n\n" + await page.text;
        }
        text.replaceRange(0, 1, "");
      }
    } else {
      text = "";
      if (sp == 0) {
        sp = 1;
      }
      for (int i = sp; i <= ep; i++) {
        PDFPage page = doc.pageAt(i);
        text = text + "\n\n" + await page.text;
      }
      text.replaceRange(0, 1, "");
    }
    return text;
  }
}
