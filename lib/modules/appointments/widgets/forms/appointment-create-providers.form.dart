import 'package:enginizer_flutter/modules/appointments/model/service-provider.model.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentCreateProvidersForm extends StatefulWidget {
  final List<ServiceProvider> serviceProviders;

  AppointmentCreateProvidersForm({Key key, this.serviceProviders = const []})
      : super(key: key);

  @override
  AppointmentCreateProvidersFormState createState() {
    return AppointmentCreateProvidersFormState();
  }
}

class AppointmentCreateProvidersFormState
    extends State<AppointmentCreateProvidersForm> {
  ProviderServiceProvider providerServiceProvider;

  @override
  Widget build(BuildContext context) {
    providerServiceProvider = Provider.of<ProviderServiceProvider>(context);
    var providers = providerServiceProvider.serviceProviders;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, int) {
          return _buildListItem(int, providers);
        },
      ),
    );
  }

  Widget _buildListItem(int index, List<ServiceProvider> providers) {
    var currentService = providers[index];
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            onTap: () => _selectService(currentService),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    '${currentService.image}',
                    fit: BoxFit.fitHeight,
                    height: 100,
                    width: 100,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("${currentService.name}",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.5)),
                              ),
                              if (providerServiceProvider.selectedProvider ==
                                  currentService)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).accentColor,
                                  size: 24.0,
                                  semanticLabel: 'Selected provider check',
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("@${currentService.address}",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 12))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _selectService(ServiceProvider currentService) {
    setState(() {
      if (providerServiceProvider.selectedProvider == currentService) {
        providerServiceProvider.selectedProvider = null;
      } else {
        providerServiceProvider.selectedProvider = currentService;
      }
    });
  }

  bool valid() {
    return providerServiceProvider.selectedProvider != null;
  }
}
