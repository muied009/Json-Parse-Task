class AndroidVersion {
  final int id;
  final String title;

  AndroidVersion({required this.id, required this.title});

  factory AndroidVersion.fromJson(Map<String, dynamic> json) {
    return AndroidVersion(
      id: json['id'],
      title: json['title'],
    );
  }
}