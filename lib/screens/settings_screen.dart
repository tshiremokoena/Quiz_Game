import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = true;
  int _timer = 15;
  final List<int> _timerOptions = [10,15,20,30];

  @override
  void initState(){
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState((){
      _sound = prefs.getBool('setting_sound') ?? true;
      _timer = prefs.getInt('setting_timer') ?? 15;
    });
  }

  Future<void> _saveSound(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setting_sound', v);
    setState(() => _sound = v);
  }

  Future<void> _saveTimer(int v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('setting_timer', v);
    setState(() => _timer = v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: GoogleFonts.poppins())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Sound', style: GoogleFonts.poppins()),
              value: _sound,
              onChanged: (v) => _saveSound(v),
            ),
            SizedBox(height: 12),
            Align(alignment: Alignment.centerLeft, child: Text('Timer length', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600))),
            ..._timerOptions.map((opt) => RadioListTile<int>(
              title: Text('$opt seconds', style: GoogleFonts.poppins()),
              value: opt,
              groupValue: _timer,
              onChanged: (v) { if (v!=null) _saveTimer(v); },
            )),
          ],
        ),
      ),
    );
  }
}
