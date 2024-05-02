class AndroidVersion {
  AndroidVersion({
    this.id,
    this.title,
  });

  int? id;
  String? title;

  factory AndroidVersion.fromJson(Map<String, dynamic> json) {
    return AndroidVersion(
      id: json['id'],
      title: json['title'],
    );
  }
}