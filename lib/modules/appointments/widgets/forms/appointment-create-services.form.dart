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

    providerServiceProvider = Provider.of<ProviderServiceProvider>(context, listen: false);

    List<ServiceItem> services = widget.serviceItems;

    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          // TODO service name should be translated
          var serviceName = services[index].name.toString();

          return CheckboxListTile(
            title: Text(serviceName),
            value:
                providerServiceProvider.selectedServiceItems.contains(services[index]),
            onChanged: (bool value) {
              onChanged(services[index], value);
            },
          );
        },
        itemCount: services.length,
      ),
    );
  }

  ValueChanged<bool> onChanged(ServiceItem serviceItem, bool value) {
    setState(() {
      if (value) {
        if (!providerServiceProvider.selectedServiceItems.contains(serviceItem)) {
          providerServiceProvider.selectedServiceItems.add(serviceItem);
        }
      }
      else {
        if (providerServiceProvider.selectedServiceItems.contains(serviceItem)) {
          providerServiceProvider.selectedServiceItems.remove(serviceItem);
        }
      }
    });
  }

  bool valid() {
    return providerServiceProvider.selectedServiceItems.length > 0;
  }
}
