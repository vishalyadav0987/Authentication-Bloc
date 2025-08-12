class ImageModel {
  final String id;
  final String author;
  final int width;
  final int height;
  final String downloadUrl;

  ImageModel({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.downloadUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'].toString(),
      author: json['author'] ?? '',
      width: json['width'] ?? 1,
      height: json['height'] ?? 1,
      downloadUrl: json['download_url'] ?? '',
    );
  }
}
