class ShopCategory {
  String name;

  ShopCategory(
      {this.name});

  static List<ShopCategory> defaultCategories() {
    return [ShopCategory(name: 'Spalatorii'),
      ShopCategory(name: 'Vopsitorii'),
      ShopCategory(name: 'Service Auto'),
      ShopCategory(name: 'Tractari'),
      ShopCategory(name: 'Pickup & Return'),
      ShopCategory(name: 'RCA'),
      ShopCategory(name: 'ITP'),
      ShopCategory(name: "Vanzari autoturisme"),
      ShopCategory(name: "Inchierieri autoturisme")];
  }
}