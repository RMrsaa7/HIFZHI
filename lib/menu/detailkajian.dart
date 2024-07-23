import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome

class KajianDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String detail;

  const KajianDetailPage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kajian'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                detail,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.youtube,
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Adi Hidayat Official',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
