import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentCreateServicesForm extends StatefulWidget {
  List<ServiceProviderItem> serviceItems;

  AppointmentCreateServicesForm({Key key, this.serviceItems}) : super(key: key);

  @override
  AppointmentCreateServicesFormState createState() =>
      AppointmentCreateServicesFormState();
}

class AppointmentCreateServicesFormState
    extends State<AppointmentCreateServicesForm> {
  ProviderServiceProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ProviderServiceProvider>(context, listen: false);
    List<ServiceProviderItem> services = widget.serviceItems;

    return Container(
      padding: EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              var serviceName =
                  services[index].getTranslatedServiceName(context);

              return Column(
                children: [
                  CheckboxListTile(
                    title: Text(serviceName),
                    value: _provider.selectedServiceItems
                        .contains(services[index]),
                    onChanged: (bool value) {
                      onChanged(services[index], value);
                    },
                  ),
                  if (services[index].isPickUpAndReturnService() &&
                      _provider.needSetupLocation())
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        S.of(context).appointment_create_step1_location_alert,
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 14),
                      ),
                    ),
                ],
              );
            },
            itemCount: services.length,
          ),
        ],
      ),
    );
  }

  ValueChanged<bool> onChanged(ServiceProviderItem serviceItem, bool value) {
    setState(() {
      if (value) {
        if (serviceItem.isPickUpAndReturnService()) {
          ServiceProviderItem towService = _provider.selectedServiceItems.firstWhere(
              (element) => element.isTowService(),
              orElse: () => null);

          if (towService != null) {
            _provider.selectedServiceItems.remove(towService);
          }
        } else if (serviceItem.isTowService()) {
          ServiceProviderItem prService = _provider.selectedServiceItems.firstWhere(
              (element) => element.isPickUpAndReturnService(),
              orElse: () => null);

          if (prService != null) {
            _provider.selectedServiceItems.remove(prService);
          }
        }

        if (!_provider.selectedServiceItems.contains(serviceItem)) {
          _provider.selectedServiceItems.add(serviceItem);
        }
      } else {
        if (_provider.selectedServiceItems.contains(serviceItem)) {
          _provider.selectedServiceItems.remove(serviceItem);
        }
      }
    });
  }

  bool valid() {
    bool servicesSelected = _provider.selectedServiceItems.length > 0;
    bool pickupAddressCompleted = _provider.pickUpServiceValidation();

    return servicesSelected && pickupAddressCompleted;
  }
}
