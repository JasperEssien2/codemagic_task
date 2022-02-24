import 'package:flutter/material.dart';

class AuthorDetailScreen extends StatefulWidget {
  static const screenName = 'detail-screen';

  const AuthorDetailScreen({Key? key}) : super(key: key);

  @override
  _AuthorDetailScreenState createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jasper Essien"),
        elevation: 4,
      ),
      body: Container(
        height: size.height * 0.35,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              "https://www.gannett-cdn.com/media/USATODAY/USATODAY/2013/03/22/ap-obit-achebe-16_9.jpg?width=2164&height=1223&fit=crop&format=pjpg&auto=webp",
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        constraints: BoxConstraints.expand(height: size.height * 0.6),
        child: const _BottomSheet(),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Text(
        """What is Lorem Ipsum?
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
      """,
        textAlign: TextAlign.left,
        style: TextStyle(
          letterSpacing: 0.5,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
