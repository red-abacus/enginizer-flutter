import 'package:app/generated/l10n.dart';
import 'package:app/modules/extra-services/enums/extra-service.enum.dart';
import 'package:app/modules/shared/widgets/single-select-dialog.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExtraServices extends StatefulWidget {
  static const String route = '/extraServices';
  static final IconData icon = Icons.map;

  @override
  _ExtraServicesState createState() => _ExtraServicesState();
}

class _ExtraServicesState extends State<ExtraServices> {
  ExtraService _extraService;
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 60),
            child: WebView(
              initialUrl: 'https://www.google.com/maps',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 0.5, color: gray),
                ),
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_filterText()],
                ),
              ),
              onTap: () => _showFilterPicker(),
            ),
          )
        ],
      ),
    );
  }

  _filterText() {
    String title = (_extraService == null)
        ? S.of(context).map_services_select_extra_service
        : ExtraServiceUtils.title(_extraService, context);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/images/icons/filter.svg'.toLowerCase(),
            color: red,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
        )
      ],
    );
  }

  _showFilterPicker() async {
    List<SingleSelectDialogItem<ExtraService>> items = [];

    ExtraServiceUtils.getList().forEach((service) {
      items.add(SingleSelectDialogItem(
          service, ExtraServiceUtils.title(service, context)));
    });

    ExtraService selectedService = await showDialog<ExtraService>(
      context: context,
      builder: (BuildContext context) {
        return SingleSelectDialog(
          items: items,
          initialSelectedValue: _extraService,
          title: S.of(context).map_services_select_extra_service,
        );
      },
    );

    setState(() {
      _extraService = selectedService;
    });

    String url = 'https://www.google.com/maps';

    if (_extraService != null) {
      url = url + '/search/${ExtraServiceUtils.value(_extraService)}';
    }

    _webViewController.loadUrl(url);
  }
}
