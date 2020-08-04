class ShopAppointmentIssue {
  String name;
  int id;

  ShopAppointmentIssue({this.name, this.id});

  static ShopAppointmentIssue defaultIssue() {
    return ShopAppointmentIssue(name: '', id: -1);
  }
}