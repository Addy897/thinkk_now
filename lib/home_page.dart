import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'news_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.genres});

  final String title;
  final List<String> genres;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NewsItem> items = [];
  bool isLoading = true;
  bool hasError = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final PageController _scrollController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    for (var genre in widget.genres) {
      fetch(currentPage, genre.toLowerCase());
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (hasMoreData && !isLoading) {
          for (var genre in widget.genres) {
            fetch(currentPage + 1, genre);
          }
        }
      }
    });
  }

  void fetch(int page, String genre) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    String baseUrl = "https://timesofindia.indiatimes.com";

    http.get(Uri.parse("$baseUrl/briefs/$genre?page=$page")).then((response) {
      if (response.statusCode == 200) {
        var doc = parse(response.body);
        var elements = doc.getElementsByClassName("brief_box");
        List<NewsItem> parsedItems = [];
        for (var element in elements) {
          var imgElements = element.getElementsByTagName("img");
          String imageUrl = imgElements.isNotEmpty
              ? imgElements.first.attributes['data-src'] ?? ''
              : '';
          var a = element.getElementsByTagName("a");
          String articleUrl =
              a.isNotEmpty ? a.first.attributes['href'] ?? '' : '';
          var headingElements = element.getElementsByTagName("h2");
          String heading = headingElements.isNotEmpty
              ? headingElements.first.text.trim()
              : 'No Heading';
          var contentElements = element.getElementsByTagName("p");
          String content = contentElements.isNotEmpty
              ? contentElements.first.text.trim()
              : 'No Content';
          if (content == "No Content") {
            continue;
          }
          parsedItems.add(NewsItem(
            imageUrl: imageUrl,
            heading: heading,
            content: content,
            articleUrl: baseUrl + articleUrl,
            genre: genre,
          ));
        }

        setState(() {
          items.addAll(parsedItems);
          isLoading = false;
          if (parsedItems.isEmpty) {
            hasMoreData = false;
          } else {
            currentPage = page;
          }
        });
      } else {
        throw Exception("Failed to load data");
      }
    }).catchError((err) {
      print("Error fetching data: $err");
    });
  }

  void _onBottomNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/preferences');
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget homePage() {
    return isLoading && items.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : hasError
            ? const Center(child: Text("Error loading data"))
            : PageView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: items.length + (hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final item = items[index];
                  return NewsCard(news: item);
                },
              );
  }

  Widget infoPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the News App!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'This app provides you with the latest news from various genres including Business, Technology, and more. Browse through the latest headlines, read more about your favorite topics, and stay updated with the world around you.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget showPage() {
    if (_selectedIndex == 2) {
      return infoPage();
    } else {
      return homePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("images/icon.png",width: 35,),
      ),
      body: showPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavBarTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Preferences'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }
}
