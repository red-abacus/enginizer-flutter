import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentCreateServicesForm extends StatefulWidget {
  List<ServiceItem> serviceItems;

  AppointmentCreateServicesForm({Key key, this.serviceItems}) : super(key: key);

  @override
  AppointmentCreateServicesFormState createState() =>
      AppointmentCreateServicesFormState();
}

class AppointmentCreateServicesFormState
    extends State<AppointmentCreateServicesForm> {
  ProviderServiceProvider providerServiceProvider;

  @override
  Widget build(BuildContext context) {
    providerServiceProvider =
        Provider.of<ProviderServiceProvider>(context, listen: false);
    List<ServiceItem> services = widget.serviceItems;

    return Container(
      child: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 60),
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              var serviceName =
                  services[index].getTranslatedServiceName(context);

              return CheckboxListTile(
                title: Text(serviceName),
                value: providerServiceProvider.selectedServiceItems
                    .contains(services[index]),
                onChanged: (bool value) {
                  onChanged(services[index], value);
                },
              );
            },
            itemCount: services.length,
          )
        ],
      ),
    );
  }

  ValueChanged<bool> onChanged(ServiceItem serviceItem, bool value) {
    setState(() {
      if (value) {
        if (serviceItem.isPickUpAndReturnService()) {
          ServiceItem towService = providerServiceProvider.selectedServiceItems
              .firstWhere((element) => element.isTowService(),
                  orElse: () => null);

          if (towService != null) {
            providerServiceProvider.selectedServiceItems.remove(towService);
          }
        } else if (serviceItem.isTowService()) {
          ServiceItem prService = providerServiceProvider.selectedServiceItems
              .firstWhere((element) => element.isPickUpAndReturnService(),
                  orElse: () => null);

          if (prService != null) {
            providerServiceProvider.selectedServiceItems.remove(prService);
          }
        }

        if (!providerServiceProvider.selectedServiceItems
            .contains(serviceItem)) {
          providerServiceProvider.selectedServiceItems.add(serviceItem);
        }
      } else {
        if (providerServiceProvider.selectedServiceItems
            .contains(serviceItem)) {
          providerServiceProvider.selectedServiceItems.remove(serviceItem);
        }
      }
    });
  }

  bool valid() {
    bool servicesSelected =
        providerServiceProvider.selectedServiceItems.length > 0;
    bool pickupAddressCompleted =
        providerServiceProvider.pickUpServiceValidation();

    return servicesSelected && pickupAddressCompleted;
  }
}
