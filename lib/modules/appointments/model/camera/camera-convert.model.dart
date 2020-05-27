class CameraConvert {
  String fileUrl;
  String outputFilename;
  int pid;

  CameraConvert({this.fileUrl, this.outputFilename, this.pid});

  factory CameraConvert.fromJson(Map<String, dynamic> json) {
    return CameraConvert(
        fileUrl: json['fileUrl'],
        outputFilename: json['outputFilename'],
        pid: json['pid']);
  }
}
