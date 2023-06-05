class SliderModel {
  String? id;
  String? author;
  int? width;
  int? height;
  String? url;
  String? downloadUrl;

  SliderModel(
      {this.id,
      this.author,
      this.width,
      this.height,
      this.url,
      this.downloadUrl});

  SliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    downloadUrl = json['download_url'];
  }

}
