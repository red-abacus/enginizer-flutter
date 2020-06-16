import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/create-appointment-state.enum.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/forms/appointment-create-modal.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/cars/screens/car-create-modal.dart';
import 'package:app/modules/cars/widgets/cars-list.dart';
import 'package:app/modules/promotions/providers/create-promotion.provider.dart';
import 'package:app/modules/promotions/screens/create-promotion.modal.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cars extends StatefulWidget {
  static const String route = '/cars';
  static final IconData icon = Icons.directions_car;

  @override
  State<StatefulWidget> createState() {
    return CarsState(route: route);
  }
}

class CarsState extends State<Cars> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  CarsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarsProvider>(
      builder: (context, carsProvider, _) => Scaffold(
          body: Center(child: _renderCars(_isLoading, carsProvider.cars)),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
            onPressed: () => _openCarCreateModal(context),
            child: Icon(Icons.add),
          )),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await Provider.of<CarsProvider>(context).loadCars().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_GET_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_get, context);

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openAppointmentCreateModal(
      BuildContext ctx, Car selectedCar) async {
    Provider.of<ProviderServiceProvider>(context).initFormValues();
    Provider.of<ProviderServiceProvider>(context).createAppointmentState =
        CreateAppointmentState.Default;
    Provider.of<ProviderServiceProvider>(context).selectedCar = selectedCar;

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCreateModal();
          });
        });
  }

  Future<void> _filterCars(BuildContext ctx, String filterValue) async {
    try {
      await Provider.of<CarsProvider>(ctx).loadCars(filterValue: filterValue);
    } catch (error) {
      if (error.toString() == CarService.CAR_GET_EXCEPTION) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_get, context);
      }
    }
  }

  void _selectCar(BuildContext ctx, Car selectedCar) {
    Provider.of<CarProvider>(ctx).selectCar(selectedCar);
    Navigator.of(ctx).pushNamed(
      '/cars/details',
    );
  }

  _renderCars(bool _isLoading, List<Car> cars) {
    return _isLoading
        ? CircularProgressIndicator()
        : CarList(
            cars: cars,
            filterCars: _filterCars,
            selectCar: _selectCar,
            openAppointmentCreateModal: _openAppointmentCreateModal,
            sellCar: _sellCar,
            rentCar: _rentCar,
          );
  }

  _openCarCreateModal(BuildContext ctx) {
    Provider.of<CarsMakeProvider>(context).initParams();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return CarCreateModal();
          });
        });
  }

  _sellCar(Car car) async {
    setState(() {
      _isLoading = true;
    });

    CreatePromotionProvider provider =
        Provider.of<CreatePromotionProvider>(context);

    int providerId = Provider.of<Auth>(context).authUser.providerId;

    if (providerId != null) {
      try {
        await provider
            .getServiceProviderItems(
                Provider.of<Auth>(context).authUser.providerId)
            .then((response) {
          setState(() {
            _isLoading = false;
          });

          ServiceProviderItem sellProviderItem;

          for (ServiceProviderItem item in response.items) {
            if (item.isSellerService()) {
              sellProviderItem = item;
            }
          }

          if (sellProviderItem != null) {
            Provider.of<CreatePromotionProvider>(context).initialise(
                Provider.of<Auth>(context).authUser.providerId,
                car: car,
                serviceProviderItem: sellProviderItem);
            Provider.of<CreatePromotionProvider>(context)
                .serviceProviderItemsResponse = response;

            showModalBottomSheet<void>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter state) {
                    return CreatePromotionModal(
                      refreshState: null,
                    );
                  });
                });
          }
        });
      } catch (error) {
        if (error
            .toString()
            .contains(ProviderService.GET_PROVIDER_SERVICE_ITEMS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_provider_service_items, context);

          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      try {
        await provider.loadServices(null).then((value) {
          setState(() {
            _isLoading = false;
          });

          ServiceProviderItem sellProviderItem;

          for (ServiceProviderItem providerItem in value.items) {
            if (providerItem.isSellerService()) {
              sellProviderItem = providerItem;
              break;
            }
          }

          if (sellProviderItem != null) {
            Provider.of<CreatePromotionProvider>(context).initialise(null,
                car: car, serviceProviderItem: sellProviderItem);
            Provider.of<CreatePromotionProvider>(context).serviceProviderItemsResponse = value;

            showModalBottomSheet<void>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter state) {
                    return CreatePromotionModal(
                      refreshState: null,
                    );
                  });
                });
          }
        });
      } catch (error) {
        if (error.toString().contains(ProviderService.GET_SERVICES_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_services, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _rentCar(Car car) {}
}
