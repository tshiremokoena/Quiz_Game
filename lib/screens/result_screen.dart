import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final String category;
  ResultScreen({required this.score, required this.category});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _high = 0;

  @override
  void initState() {
    super.initState();
    _loadHigh();
  }

  Future<void> _loadHigh() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() { _high = prefs.getInt('highscore_${widget.category}') ?? 0; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent])),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Result', style: GoogleFonts.poppins(fontSize: 34, color: Colors.white)),
                SizedBox(height: 12),
                Text('Score: ${widget.score}', style: GoogleFonts.poppins(fontSize: 22, color: Colors.white)),
                SizedBox(height: 8),
                Text('High Score: $_high', style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70)),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: Text('Back to Home', style: GoogleFonts.poppins()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
