class CarFuelConsumptionResponse {
  int price;
  int quantity;
  int carId;
  int id;
  String createdDate;

  CarFuelConsumptionResponse({
    this.price = -1,
    this.quantity = -1,
    this.createdDate = '',
    this.carId = -1,
    this.id = -1,
  });

  factory CarFuelConsumptionResponse.fromJson(Map<String, dynamic> json) {
    return CarFuelConsumptionResponse(
        price: int.tryParse('${json['price']}'),
        quantity: int.tryParse('${json['quantity']}'),
        createdDate: json['createdDate'],
        carId: json['carId'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'price': price,
        'createdDate': createdDate,
        'carId': carId,
        'id': id
      };
}
