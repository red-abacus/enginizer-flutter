class CarFuelGraphicResponse {

  List labels;
  List datasets;


  CarFuelGraphicResponse({
    this.labels,
    this.datasets,
  });

  factory CarFuelGraphicResponse.fromJson(Map<String, dynamic> json) {
    return CarFuelGraphicResponse(
        labels: mapData(json['labels']),
        datasets: mapData(json['datasets']));
  }

  Map<String, dynamic> toJson() => {
        'labels': labels,
        'datasets': datasets
      };


  static mapData(List<dynamic> response) {
    List list = [];
    response.forEach((item) {
     list.add(item);
    });
    return list;
  }
}

