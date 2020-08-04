class CarTimetableRequest {
  String startDate;
  String endDate;
  int carId;

  CarTimetableRequest(
      {this.carId,
        this.startDate,
        this.endDate});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = new Map();

    if (startDate != null) {
      propMap['startDate'] = startDate;
    }

    if (endDate != null) {
      propMap['endDate'] = endDate;
    }

    return propMap;
  }
}
