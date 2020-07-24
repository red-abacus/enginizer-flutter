class CarFuelGraphicMonth {
  String month;
  List<dynamic> labels;
  List<dynamic> datasets;

  CarFuelGraphicMonth({this.month, this.labels, this.datasets});

  factory CarFuelGraphicMonth.fromJson(String key, Map<String, dynamic> json) {
    return CarFuelGraphicMonth(
        month: key,
        labels: json['labels'] != null ? json['labels'] : [],
        datasets: json['datasets'] != null ? json['datasets'] : []);
  }
}
