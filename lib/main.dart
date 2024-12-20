import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(Theme_change_main());
}
class Theme_change_main extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Theme_change_main> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeManager.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'Theme Changer',
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          themeMode: ThemeManager.instance.themeMode,
          home: ThemeChangerScreen(),
        );
      },
    );
  }
}


//-------




class ThemeManager with ChangeNotifier {
  static final ThemeManager instance = ThemeManager._internal();

  ThemeManager._internal();

  static const String themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _saveTheme();
  }

  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(themeKey, _themeMode.toString());
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString(themeKey);

    if (savedTheme != null) {
      if (savedTheme == ThemeMode.light.toString()) {
        _themeMode = ThemeMode.light;
      } else if (savedTheme == ThemeMode.dark.toString()) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    }
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(color: Colors.blue),
    textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(color: Colors.grey[900]),
    textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  );
}


//--------


class ThemeChangerScreen extends StatefulWidget {
  @override
  _ThemeChangerScreenState createState() => _ThemeChangerScreenState();
}

class _ThemeChangerScreenState extends State<ThemeChangerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Theme Changer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Theme: ${ThemeManager.instance.themeMode == ThemeMode.light ? "Light" : "Dark"}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  ThemeManager.instance.toggleTheme();
                });
              },
              child: Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
