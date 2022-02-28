import 'package:codemagic_task/services/author_models.dart';
import 'package:flutter/material.dart';

class AuthorDetailScreen extends StatefulWidget {
  static const screenName = 'detail-screen';

  const AuthorDetailScreen({Key? key}) : super(key: key);

  @override
  _AuthorDetailScreenState createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  late final Author _author;

  @override
  void didChangeDependencies() {
    _author = ModalRoute.of(context)!.settings.arguments as Author;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("${_author.name}"),
        elevation: 4,
      ),
      body: Hero(
        tag: _author.slug ?? "${_author.id}",
        child: Container(
          height: size.height * 0.35,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                _author.image ?? '',
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        constraints: BoxConstraints.expand(height: size.height * 0.6),
        child: _BottomSheet(author: _author),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    Key? key,
    required this.author,
  }) : super(key: key);

  final Author author;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: Text(
        author.bio ?? '',
        textAlign: TextAlign.left,
        style: const TextStyle(
          letterSpacing: 0.5,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
