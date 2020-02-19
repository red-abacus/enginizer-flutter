import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/details/service-details-widget.dart';
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
            child: _buildContent(context, _isLoading),
          ),
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

      ServiceProviderDetailsProvider provider = Provider.of<ServiceProviderDetailsProvider>(context);
      provider.getServiceProviderDetails(provider.serviceProviderId).then((_) {
        provider.getServiceProviderItems(provider.serviceProviderId).then((_) {
          provider.getServiceProviderReviews(provider.serviceProviderId).then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
    }
    _initDone = true;
    super.didChangeDependencies();
  }
}
