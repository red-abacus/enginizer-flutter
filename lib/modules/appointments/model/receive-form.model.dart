class ReceiveForm {
  String appointmentProcedureType;
  int fuel;
  bool hasClientComponents;
  bool hasClientKeepComponents;
  int id;
  String missingOrDamagedComponents;
  String observations;
  String oilReplacementConvention;
  String paymentMethod;
  List<String> photos;
  int realKms;

  ReceiveForm(
      {this.appointmentProcedureType,
      this.fuel,
      this.hasClientComponents,
      this.hasClientKeepComponents,
      this.id,
      this.missingOrDamagedComponents,
      this.observations,
      this.oilReplacementConvention,
      this.paymentMethod,
      this.photos,
      this.realKms});

  factory ReceiveForm.fromJson(Map<String, dynamic> json) {
    return ReceiveForm(
        appointmentProcedureType: json['appointmentProcedureType'] != null
            ? json['appointmentProcedureType']
            : '',
        fuel: json['fuel'] != null ? json['fuel'] : 0,
        hasClientComponents: json['hasClientComponents'] != null
            ? json['hasClientComponents']
            : false,
        hasClientKeepComponents: json['hasClientKeepComponents'] != null
            ? json['hasClientKeepComponents']
            : false,
        id: json['id'] != null ? json['id'] : 0,
        missingOrDamagedComponents: json['missingOrDamagedComponents'] != null
            ? json['missingOrDamagedComponents']
            : '',
        observations: json['observations'] != null ? json['observations'] : '',
        oilReplacementConvention: json['oilReplacementConvention'] != null
            ? json['oilReplacementConvention']
            : '',
        paymentMethod:
            json['paymentMethod'] != null ? json['paymentMethod'] : '',
        photos: json['photos'] != null ? _mapPhotos(json['photos']) : [],
        realKms: json['realKms'] != null ? json['realKms'] : 0);
  }

  static _mapPhotos(List<dynamic> response) {
    List<String> photos = [];
    response.forEach((photo) {
      if (photos is String) {
        photos.add(photo);
      }
    });
    return photos;
  }
}
