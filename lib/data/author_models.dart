class Author {
  Author({
    this.link,
    this.bio,
    this.description,
    this.id,
    this.name,
    this.quoteCount,
    this.slug,
  });

  final String? link;
  final String? bio;
  final String? description;
  final String? id;
  final String? name;
  final String? quoteCount;
  final String? slug;
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
}
