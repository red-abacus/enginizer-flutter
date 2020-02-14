class CarFuelConsumption {
  int price;
  int quantity;
  String createdDate;
  int nrOfKms;

  CarFuelConsumption({this.price = -1,this.quantity = -1,  this.createdDate = '',this.nrOfKms=-1});

  factory CarFuelConsumption.fromJson(Map<String, dynamic> json) {
    return CarFuelConsumption(price: json['price'], quantity: json['quantity'],createdDate: json['createdDate'],nrOfKms: json['nrOfKms']);
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'price': price,
    'createdDate':createdDate,
    'nrOfKms':nrOfKms
      };


}
