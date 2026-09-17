import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  CategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blueGrey, Colors.indigo])),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  Text(category, style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
                ],
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal:40, vertical:16)),
                    child: Text('Start', style: GoogleFonts.poppins(fontSize: 20)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(category: category))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
