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
    providerServiceProvider = Provider.of<ProviderServiceProvider>(context);

    List<ServiceItem> services = widget.serviceItems;
    for (int i = 0; i < services.length; i++) {
      providerServiceProvider.providerServiceFormState
          .putIfAbsent(services[i].name.toString(), () => false);
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          // TODO service name should be translated
          var serviceName = services[index].name.toString();

          return CheckboxListTile(
            title: Text(serviceName),
            value:
                providerServiceProvider.providerServiceFormState[serviceName],
            onChanged: (bool value) {
              onChanged(serviceName, value);
            },
          );
        },
        itemCount: services.length,
      ),
    );
  }

  ValueChanged<bool> onChanged(String serviceName, bool value) {
    setState(() {
      providerServiceProvider.providerServiceFormState[serviceName] = value;
    });
  }

  bool valid() {
    for (bool checked in providerServiceProvider
        .providerServiceFormState.values) if (checked) return true;
    return false;
  }
}
