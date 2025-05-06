class Category {
  String categoryId;
  String name;
  String key;
  String path;
  String? parent;

  Category({
    required this.categoryId,
    required this.name,
    required this.key,
    required this.path,
    this.parent,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      name: json['name'],
      key: json['key'],
      path: json['path'],
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'key': key,
      'path': path,
      'parent': parent,
    };
  }
}
