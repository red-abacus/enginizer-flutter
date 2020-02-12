import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
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

    return SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            var serviceName =
                _translateServiceName(services[index].name.toString());

            bool visibility = services[index].name.toString() == "PICKUP_RETURN"
                && providerServiceProvider.containsPickUpService();

            return Column(
              children: <Widget>[
                Visibility(
                  visible: visibility,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                        decoration: InputDecoration(
                            labelText: S.of(context).appointment_create_add_pickup_address),
                        onChanged: (value) {
                          setState(() {
                            providerServiceProvider.pickupAddress = value;
                          });
                        },
                        initialValue: providerServiceProvider.pickupAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return S
                                .of(context)
                                .appointment_create_error_pickupAddressCannotBeEmpty;
                          } else {
                            return null;
                          }
                        }
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: Text(serviceName),
                  value: providerServiceProvider.selectedServiceItems
                      .contains(services[index]),
                  onChanged: (bool value) {
                    onChanged(services[index], value);
                  },
                ),
              ],
            );
          },
          itemCount: services.length,
        ));
  }

  ValueChanged<bool> onChanged(ServiceItem serviceItem, bool value) {
    setState(() {
      if (value) {
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
    bool servicesSelected = providerServiceProvider.selectedServiceItems.length > 0;
    bool pickupAddressCompleted = providerServiceProvider.pickUpServiceValidation();

    return servicesSelected && pickupAddressCompleted;
  }

  String _translateServiceName(String serviceName) {
    switch (serviceName) {
      case 'SERVICE':
        return S.of(context).SERVICE;
      case 'CAR_WASHING':
        return S.of(context).CAR_WASHING;
      case 'PAINT_SHOP':
        return S.of(context).PAINT_SHOP;
      case 'TIRE_SHOP':
        return S.of(context).TIRE_SHOP;
      case 'TOW_SERVICE':
        return S.of(context).TOW_SERVICE;
      case 'PICKUP_RETURN':
        return S.of(context).PICKUP_RETURN;
      default:
        return '';
    }
  }
}
