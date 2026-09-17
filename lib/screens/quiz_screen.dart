import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question.dart';
import '../data/questions.dart';
import 'result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  QuizScreen({required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _questions;
  int _index = 0;
  int _score = 0;
  Timer? _timer;
  int _seconds = 15;
  int _timerLength = 15;
  bool _soundEnabled = true;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _questions = questionsByCategory[widget.category] ?? [];
    _loadSettingsAndStart();
  }

  Future<void> _loadSettingsAndStart() async {
    final prefs = await SharedPreferences.getInstance();
    _timerLength = prefs.getInt('setting_timer') ?? 15;
    _soundEnabled = prefs.getBool('setting_sound') ?? true;
    _audioPlayer = AudioPlayer();
    setState(() { _seconds = _timerLength; });
    _startTimer();
  }

  void _startTimer() {
    _seconds = _timerLength;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _seconds--;
        if (_seconds <= 0) _nextQuestion();
      });
    });
  }

  void _answer(int choice) {
    final q = _questions[_index];
    final correct = choice == q.correctIndex;
    if (correct) _score++;
    // feedback: sound and haptic
    try {
      if (_soundEnabled && _audioPlayer != null) {
        final asset = correct ? 'sounds/correct.mp3' : 'sounds/wrong.mp3';
        _audioPlayer!.play(AssetSource(asset));
      }
    } catch (_) {}
    HapticFeedback.lightImpact();
    _nextQuestion();
  }

  void _nextQuestion() {
    _timer?.cancel();
    if (_index + 1 < _questions.length) {
      setState(() {
        _index++;
      });
      _startTimer();
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'highscore_${widget.category}';
    final prev = prefs.getInt(key) ?? 0;
    if (_score > prev) await prefs.setInt(key, _score);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(score: _score, category: widget.category)));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return Scaffold(body: Center(child: Text('No questions')));
    final q = _questions[_index];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black87, Colors.indigoAccent])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${_index+1}/${_questions.length}', style: GoogleFonts.poppins(color: Colors.white)),
                  Text('Time: $_seconds', style: GoogleFonts.poppins(color: Colors.white))
                ]),
                SizedBox(height: 10),
                LinearProgressIndicator(value: _seconds/15, backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation(Colors.greenAccent)),
                SizedBox(height: 24),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: Container(
                      key: ValueKey(_index),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                          SizedBox(height: 20),
                          ...List.generate(q.options.length, (i) => Padding(
                            padding: const EdgeInsets.symmetric(vertical:6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(14), backgroundColor: Colors.white10),
                              onPressed: () => _answer(i),
                              child: Align(alignment: Alignment.centerLeft, child: Text(q.options[i], style: GoogleFonts.poppins(color: Colors.white))),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
