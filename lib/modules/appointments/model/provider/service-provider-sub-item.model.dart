class ServiceProviderSubItem {
  int id;
  String name;
  double rate;

  ServiceProviderSubItem({this.id, this.name, this.rate});

  factory ServiceProviderSubItem.fromJson(Map<String, dynamic> json) {
    return ServiceProviderSubItem(
        id: json['id'], name: json['name'], rate: json['rate']);
  }
}
