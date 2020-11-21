import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:language_pickers/language_picker_dialog.dart';
import 'package:language_pickers/language_pickers.dart';
import 'package:language_pickers/languages.dart';
import 'output.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:progress_dialog/progress_dialog.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  var myToLanguage = 'en';
  var myFromLanguage = 'en';
  var myFromLanguageName = 'English';
  var myToLanguageName = 'English';

  Language _selectedFromDialogLanguage =
      LanguagePickerUtils.getLanguageByIsoCode('en');
  Language _selectedToDialogLanguage =
      LanguagePickerUtils.getLanguageByIsoCode('en');

// It's sample code of Dialog Item.
  Widget _buildDialogItem(Language language) => Row(
        children: <Widget>[
          Text(
            language.name,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
          ),
          SizedBox(width: 4.0),
          Flexible(
              child: Text(
            "(${language.isoCode})",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            )),
          ))
        ],
      );

  void openFromLanguagePickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.deepOrange),
            child: LanguagePickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.deepOrangeAccent,
                searchInputDecoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
                ),
                isSearchable: true,
                title: Text(
                  'Select your language',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
                ),
                onValuePicked: (Language language) => setState(() {
                      _selectedFromDialogLanguage = language;
                      myFromLanguageName = _selectedFromDialogLanguage.name;
                      myFromLanguage = _selectedFromDialogLanguage.isoCode;
                    }),
                itemBuilder: _buildDialogItem)),
      );

  void openToLanguagePickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.deepOrange),
            child: LanguagePickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.deepOrangeAccent,
                searchInputDecoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
                ),
                isSearchable: true,
                title: Text(
                  'Select your language',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
                ),
                onValuePicked: (Language language) => setState(() {
                      _selectedToDialogLanguage = language;
                      myToLanguageName = _selectedToDialogLanguage.name;
                      myToLanguage = _selectedToDialogLanguage.isoCode;
                    }),
                itemBuilder: _buildDialogItem)),
      );

  parseTheText(ImageSource source) async {
    final imageFile = await ImagePicker()
        .getImage(source: source, maxWidth: 700, maxHeight: 1000);



    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(
        message: 'Translating...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progress: 0.0,
        maxProgress: 100.0,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    if(imageFile != null) {
      progressDialog.show();
    }


    var bytes = Io.File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apiKey": "ab1a430f1788957"};
    var post = await http.post(url, body: payload, headers: header);

    var result = jsonDecode(post.body);
    String parsedText = result['ParsedResults'][0]['ParsedText'];
    print(parsedText);

    final translator = GoogleTranslator();
    var translation = await translator.translate(parsedText,
        from: myFromLanguage, to: myToLanguage);
    print(translation);
    progressDialog.hide();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OutputScreen(img64.toString(), translation.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Translate',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          )),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  openFromLanguagePickerDialog();
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            myFromLanguageName,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  openToLanguagePickerDialog();
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            myToLanguageName,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 48),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          parseTheText(ImageSource.camera);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 16,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            'Camera',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          parseTheText(ImageSource.gallery);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 16,
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Text(
                            'Gallery',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 64)
            ],
          )),
    );
  }
}
