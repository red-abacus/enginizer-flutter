class ProcedureInfoProvider {
  String providerName;
  String userName;

  ProcedureInfoProvider({this.providerName, this.userName});

  factory ProcedureInfoProvider.fromJson(Map<String, dynamic> json) {
    return ProcedureInfoProvider(
        providerName: json['providerName'] != null ? json['providerName'] : '',
        userName: json['userName'] != null ? json['userName'] : '');
  }
}
