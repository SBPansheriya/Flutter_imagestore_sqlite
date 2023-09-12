class Item {
  final int id;
  final String title;
  final String description;
  final String imagePath;

  Item({required this.id, required this.title, required this.description, required this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
    };
  }
}
