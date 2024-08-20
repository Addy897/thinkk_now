import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkk_now/home_page.dart';
import 'package:thinkk_now/genre_slecttion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final List<String> genres=prefs.getStringList("selected_genres") ?? [];
  runApp(MyApp(genres:genres));
}

class MyApp extends StatelessWidget {
  final List<String> genres; 
  final String title="Thinkk Now";
  const MyApp({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: genres.isEmpty ?  const GenreSelectionPage() : MyHomePage(title: title,genres:genres),
      routes: {
        '/home': (context) => MyHomePage(title: title,genres:genres),
        '/preferences': (context) => const GenreSelectionPage(),
        
      },
    );
  }
}
