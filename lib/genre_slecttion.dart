import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenreSelectionPage extends StatefulWidget {
  const GenreSelectionPage({super.key});

  @override
  _GenreSelectionPageState createState() => _GenreSelectionPageState();
}

class _GenreSelectionPageState extends State<GenreSelectionPage> {
  final List<String> _genres = ['Business','India','Sports','Entertainment','TV','Lifestyle','World','Elections'];
  Set<String> _selectedGenres = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedGenres();
  }

  void _loadSelectedGenres() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedGenres = prefs.getStringList('selected_genres')?.toSet() ?? {};
    });
  }

  void _saveSelectedGenres() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_genres', _selectedGenres.toList());
  }

  void _onDone() {
    _saveSelectedGenres();
    Navigator.pushReplacementNamed(context, '/home'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('Select Your News Genres'),
      ),
      body: ListView(
        children: _genres.map((genre) {
          return CheckboxListTile(
            title: Text(genre),
            value: _selectedGenres.contains(genre),
            onChanged: (bool? selected) {
              setState(() {
                if (selected == true) {
                  _selectedGenres.add(genre);
                } else {
                  _selectedGenres.remove(genre);
                }
              });
              _saveSelectedGenres();
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=>_onDone(),child: const Icon(Icons.done),),
    );
  }
}
