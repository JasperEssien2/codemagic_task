import 'package:flutter/foundation.dart';

class Author {
  Author({
    this.link,
    this.bio,
    this.description,
    this.id,
    this.name,
    this.quoteCount,
    this.slug,
    this.image,
  });

  final String? link;
  final String? bio;
  final String? description;
  final String? id;
  final String? name;
  final String? quoteCount;
  final String? slug;
  final String? image;

  factory Author.fromMap(Map<String, dynamic> map, String image) {
    return Author(
      link: map['link'],
      bio: map['bio'],
      description: map['description'],
      id: map['id'],
      name: map['name'],
      quoteCount: map['quoteCount'],
      slug: map['slug'],
      image: image,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Author &&
        other.link == link &&
        other.bio == bio &&
        other.description == description &&
        other.id == id &&
        other.name == name &&
        other.quoteCount == quoteCount &&
        other.slug == slug &&
        other.image == image;
  }

  @override
  int get hashCode {
    return link.hashCode ^
        bio.hashCode ^
        description.hashCode ^
        id.hashCode ^
        name.hashCode ^
        quoteCount.hashCode ^
        slug.hashCode ^
        image.hashCode;
  }
}

class AuthorList {
  AuthorList({
    this.authors,
    this.count,
    this.totalCount,
    this.page,
    this.totalPages,
    this.lastItemIndex,
  });

  final List<Author>? authors;
  final int? count;
  final int? totalCount;
  final int? page;
  final int? totalPages;
  final int? lastItemIndex;

  factory AuthorList.fromMap(
      Map<String, dynamic> map, String Function(String slug) imageUrlBuilder) {
    return AuthorList(
      authors: map['authors'] != null
          ? List<Author>.from(
              map['authors']?.map(
                (x) => Author.fromMap(x, imageUrlBuilder(x['slug'])),
              ),
            )
          : null,
      count: map['count']?.toInt(),
      totalCount: map['totalCount']?.toInt(),
      page: map['page']?.toInt(),
      totalPages: map['totalPages']?.toInt(),
      lastItemIndex: map['lastItemIndex']?.toInt(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AuthorList &&
      listEquals(other.authors, authors) &&
      other.count == count &&
      other.totalCount == totalCount &&
      other.page == page &&
      other.totalPages == totalPages &&
      other.lastItemIndex == lastItemIndex;
  }

  @override
  int get hashCode {
    return authors.hashCode ^
      count.hashCode ^
      totalCount.hashCode ^
      page.hashCode ^
      totalPages.hashCode ^
      lastItemIndex.hashCode;
  }
}
