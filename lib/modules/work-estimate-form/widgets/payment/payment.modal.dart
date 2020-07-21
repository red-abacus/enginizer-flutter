import 'dart:convert';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/work-estimate-form/providers/payment.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentModal extends StatefulWidget {
  @override
  _PaymentModalState createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  var _initDone = false;
  var _isLoading = false;
  var _webviewIsLoading = false;
  PaymentProvider _provider;
  final _key = UniqueKey();

//  InAppWebViewController _inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: new BorderRadius.circular(5.0),
      child: Container(
        decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Theme(
            data: ThemeData(
                accentColor: Theme.of(context).primaryColor,
                primaryColor: Theme.of(context).primaryColor),
            child: _buildContent(context, _isLoading)),
      ),
    );
  }

  _buildContent(BuildContext context, bool isLoading) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: _provider.providerPayment.loadHTML(),
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (url) {
                print('on page started $url');
                setState(() {
                  _webviewIsLoading = true;
                });
              },
              onWebResourceError: (error) {
                print('error $error');
              },
              onPageFinished: (url) {
                print('on page finished $url');
                setState(() {
                  _webviewIsLoading = false;
                });
              },
              onWebViewCreated: (controller) async {
                final String contentBase64 = base64Encode(const Utf8Encoder()
                    .convert(_provider.providerPayment.loadHTML()));
                await controller
                    .loadUrl('data:text/html;base64,$contentBase64');
              },
            ),
            _webviewIsLoading ? Center( child: CircularProgressIndicator(),)
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<PaymentProvider>(context);
      _provider.initialise();

      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider
          .getPaymentProvider(PaymentProvider.RETURN_URL, _provider.appointmentId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.PAYMENT_PROVIDER_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_payment_provider, context);
      }

      Navigator.pop(context);
    }
  }
}
