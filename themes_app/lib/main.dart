import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variable to track if dark mode is enabled
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Apply the chosen theme based on isDarkMode flag
      theme: isDarkMode ? ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ) : ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: MyHomePage(
        // Pass the current theme state and a method to toggle it
        isDarkMode: isDarkMode,
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  MyHomePage({required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material 3 Theme Example'),
        actions: [
          // Switch to toggle between light and dark themes
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Hello, Flutter!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
