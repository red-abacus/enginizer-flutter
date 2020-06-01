class Roles {
  static const String Client = 'CLIENT';
  static const String ProviderAdmin = 'PROVIDER_ADMIN';
  static const String ProviderConsultant = 'PROVIDER_CONSULTANT';
  static const String ProviderPersonnel = 'PROVIDER_PRODUCTIVE_PERSONNEL';
  static const String ProviderAccountant = 'PROVIDER_ACCOUNTANT';
  static const String Super = 'SUPER_ADMIN';

  static const List<String> roles = [
    Roles.Client,
    Roles.ProviderAdmin,
    Roles.ProviderConsultant,
    Roles.ProviderPersonnel,
    Roles.ProviderAccountant,
    Roles.Super
  ];
}
