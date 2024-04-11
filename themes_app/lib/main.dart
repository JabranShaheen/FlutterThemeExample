import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThemeDataModel {
  final String name;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color secondaryColor;
  final Color onSecondaryColor;

  ThemeDataModel({
    required this.name,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.secondaryColor,
    required this.onSecondaryColor,
  });
}

late List<ThemeDataModel> _themeDataModels;

Future<void> fetchAndSetThemes() async {
  _themeDataModels = await fetchThemes();
}

Future<List<ThemeDataModel>> fetchThemes() async {
  final response = await http.get(Uri.parse('https://themeapi.azurewebsites.net/theme'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    
    return data.map((json) => ThemeDataModel(
      name: json['name'],
      primaryColor: Color(int.parse(json['primaryColor'].replaceAll('#', '0xFF'))),
      onPrimaryColor: Color(int.parse(json['onPrimaryColor'].replaceAll('#', '0xFF'))),
      secondaryColor: Color(int.parse(json['secondaryColor'].replaceAll('#', '0xFF'))),
      onSecondaryColor: Color(int.parse(json['onSecondaryColor'].replaceAll('#', '0xFF'))),
    )).toList();
  } else {
    throw Exception('Failed to load themes');
  }
}

void main() async {
  await fetchAndSetThemes();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? darkThemeData(context) : lightThemeData(context),
      home: MyHomePage(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

ColorScheme lightThemeColors(BuildContext context) {
  
    return ColorScheme.light(
      primary: _themeDataModels[0].primaryColor,
      onPrimary: _themeDataModels[0].onPrimaryColor,
      secondary: _themeDataModels[0].secondaryColor,
      onSecondary: _themeDataModels[0].onSecondaryColor,
    );
  
}

ColorScheme darkThemeColors(BuildContext context) {

    return ColorScheme.dark(
      primary: _themeDataModels[0].primaryColor,
      onPrimary: _themeDataModels[0].onPrimaryColor,
      secondary: _themeDataModels[0].secondaryColor,
      onSecondary: _themeDataModels[0].onSecondaryColor,
    );
}

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    scaffoldBackgroundColor: lightThemeColors(context).background,
    textTheme: textTheme(context),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkThemeColors(context).background,
    textTheme: textTheme(context),
  );
}

TextTheme textTheme(BuildContext context) {
  return Theme.of(context).textTheme.copyWith(
        headline6: TextStyle(fontSize: 24),
      );
}

class MyHomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  MyHomePage({
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, Flutter!',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleTheme,
              child: Text(isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 100,
              color: Theme.of(context).colorScheme.secondary,
              child: Center(
                child: Text(
                  'Custom Container',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.star,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}