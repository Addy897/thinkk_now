import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem {
  final String imageUrl;
  final String heading;
  final String content;
  final String articleUrl;
  final String genre;

  NewsItem({
    required this.imageUrl,
    required this.heading,
    required this.content,
    required this.articleUrl,
    required this.genre,
  });
}

Future<void> _launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news});

  final NewsItem news;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        color: Colors.white,
        depth: 5,
        intensity: 1.0,
      ),
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              news.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height:MediaQuery.of(context).size.height*0.30 ,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            news.heading,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                news.content,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            TextButton(
                onPressed: () {
                  _launchURL(news.articleUrl);
                },
                child: const Text("Read More")),
             Text(news.genre.toUpperCase(),
             style: const TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,fontFamily: "monospace"),)   
          ]),
        ],
    ),
    );
  }
}
