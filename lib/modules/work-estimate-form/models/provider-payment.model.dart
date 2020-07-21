class ProviderPayment {
  String url;
  String envKey;
  String data;

  ProviderPayment({this.url, this.envKey, this.data});

  factory ProviderPayment.fromJson(Map<String, dynamic> json) {
    return ProviderPayment(
        url: json['url'] != null ? json['url'] : '',
        envKey: json['envKey'] != null ? json['envKey'] : '',
        data: json['data'] != null ? json['data'] : '');
  }

  loadHTML() {
    return '''
    <!DOCTYPE html>
    <html>
    <body onload="document.f.submit();">
    <form id="f" name="f" method="post" action="http://sandboxsecure.mobilpay.ro">
    <input type="hidden" name="env_key" value="$envKey" />
    <input type="hidden" name="data" value="$data" />
    </form>
    </body>
    </html>
    ''';
  }
}
