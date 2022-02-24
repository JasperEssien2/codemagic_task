import 'package:codemagic_task/services/author_models.dart';
import 'package:codemagic_task/widgets/author_detail_screen.dart';
import 'package:flutter/material.dart';

class AuthorItem extends StatelessWidget {
  const AuthorItem({Key? key, required this.author}) : super(key: key);

  final Author author;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            AuthorDetailScreen.screenName,
            arguments: author,
          );
        },
        leading: Hero(
          tag: author.slug ?? '${author.id}',
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(author.image!),
          ),
        ),
        title: Text(author.name!),
        subtitle: Text(author.description!),
      ),
    );
  }
}
