class Category {
  String categoryId;
  String name;
  String key;
  String path;
  String? parent;
  List<Category>? children;

  Category({
    required this.categoryId,
    required this.name,
    required this.key,
    required this.path,
    this.parent,
    this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Category>? children;
    if (json['child'] != null && json['child']['data'] != null) {
      final childData = json['child']['data'] as List;
      children = childData.map((child) {
        // Recursively process child categories
        if (child['child'] != null && child['child']['data'] != null) {
          return Category.fromJson(child);
        }
        return Category.fromJson(child);
      }).toList();
    }

    return Category(
      categoryId: json['category_id'].toString(),
      name: json['name'],
      key: json['key'],
      path: json['path'],
      parent: json['parent']?['data']?.toString(),
      children: children,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'key': key,
      'path': path,
      'parent': parent,
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }
}
