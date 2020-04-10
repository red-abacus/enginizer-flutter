import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/details/service-provider/service-details-widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceDetailsModal extends StatefulWidget {
  @override
  _ServiceDetailsModalState createState() => _ServiceDetailsModalState();
}

class _ServiceDetailsModalState extends State<ServiceDetailsModal> {
  var _initDone = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProviderDetailsProvider>(
      builder: (context, provider, _) => ClipRRect(
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
      ),
    );
  }

  _buildContent(BuildContext context, bool isLoading) {
    return isLoading == true
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : ServiceDetailsWidget();
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
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
      ServiceProviderDetailsProvider provider =
          Provider.of<ServiceProviderDetailsProvider>(context);
      await provider
          .getServiceProviderDetails(provider.serviceProviderId)
          .then((_) async {
        await provider
            .getServiceProviderItems(provider.serviceProviderId)
            .then((_) {
          provider
              .getServiceProviderReviews(provider.serviceProviderId)
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_details, context);
      } else if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_SERVICE_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_service_items, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
