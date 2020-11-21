import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OutputScreen extends StatefulWidget {
  final String image64, outputText;

  OutputScreen(this.image64, this.outputText);

  @override
  _OutputScreenState createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(widget.image64.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Result',
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
              Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: (MediaQuery.of(context).size.width - 32) * 3 / 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.deepOrange, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.memory(bytes),
                  )),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'OUTPUT',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: MediaQuery.of(context).size.width / 1.8,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.outputText,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
