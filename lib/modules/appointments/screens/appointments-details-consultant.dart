import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/car-receive-form-state.enum.dart';
import 'package:app/modules/appointments/enum/pick-up-form-state.enum.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/screens/appointment-camera.modal.dart';
import 'package:app/modules/appointments/screens/appointments.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details-availability.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/cars/widgets/car-general-details.widget.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-car-receive-form.widget.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details-documents.widget.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details-consultant.widget.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-form.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsConsultant extends StatefulWidget {
  static const String route =
      '${Appointments.route}/appointment-details-consultant';
  static const String notificationsRoute =
      '${Notifications.route}/appointment-details-consultant';

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailsConsultantState(route: route);
  }
}

class AppointmentDetailsConsultantState
    extends State<AppointmentDetailsConsultant> with TickerProviderStateMixin {
  AppointmentConsultantProvider _provider;

  String route;

  var _isLoading = false;

  AppointmentDetailsConsultantState({this.route});

  TabController _tabController;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AppointmentConsultantProvider>(context);

    if (!_provider.initDone) {
      if (_provider.selectedAppointment != null) {
        setState(() {
          _isLoading = true;
        });
        _loadData();
      }

      _provider.initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider
          .getAppointmentDetails(_provider.selectedAppointment)
          .then((value) async {
        _provider.selectedAppointmentDetail = value;
        await _provider
            .getProviderServices(
                _provider.selectedAppointment.serviceProvider.id)
            .then((_) async {
          int lastWorkEstimate =
              _provider.selectedAppointmentDetail.lastWorkEstimate();

          if (lastWorkEstimate != 0) {
            await _provider.getWorkEstimateDetails(lastWorkEstimate).then((_) {
              setState(() {
                _isLoading = false;
              });
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_appointment_details, context);
      } else if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_SERVICE_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_service_items, context);
      } else if (error
          .toString()
          .contains(WorkEstimatesService.GET_WORK_ESTIMATE_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_work_estimate_details, context);
      } else if (error
          .toString()
          .contains(ProviderService.GET_PROVIDERS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_providers, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_provider != null && _provider.selectedAppointment == null ||
        _provider != null && _provider.selectedAppointmentDetail == null) {
      return Container();
    }

    if (_tabController == null) {
      _tabController =
          new TabController(vsync: this, length: 3, initialIndex: 0);
    }

    return Consumer<AppointmentConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                isScrollable: _tabController.length > 3,
                controller: _tabController,
                tabs: _getTabs(),
              ),
              title: Text(
                _provider.selectedAppointment?.name,
                style: TextHelper.customTextStyle(
                    color: Colors.white, weight: FontWeight.bold, size: 20),
              ),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: _contentWidget()));
  }

  _getTabs() {
    List<Tab> tabs = [
      Tab(text: S.of(context).appointment_details_request),
      Tab(text: S.of(context).appointment_details_car),
    ];

    if (_provider.selectedAppointmentDetail.rentServiceItem() != null) {
      tabs.add(Tab(text: S.of(context).appointment_availability));
    } else {
      tabs.add(Tab(
          text: S.of(context).appointment_consultant_provider_documents_title));
    }

    return tabs;
  }

  _contentWidget() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<Widget> list = [
      _getAppointmentDetailsScreen(),
      CarGeneralDetailsWidget(car: _provider.selectedAppointmentDetail.car),
    ];

    if (_provider.selectedAppointmentDetail.rentServiceItem() != null) {
      list.add(AppointmentDetailsAvailabilityWidget());
    }
    else {
      list.add(AppointmentDetailsDocumentsWidget());
    }

    return TabBarView(
      controller: _tabController,
      children: list,
    );
  }

  _getAppointmentDetailsScreen() {
    switch (_provider.selectedAppointmentDetail.status.getState()) {
      case AppointmentStatusState.SUBMITTED:
      case AppointmentStatusState.PENDING:
      case AppointmentStatusState.SCHEDULED:
      case AppointmentStatusState.IN_UNIT:
      case AppointmentStatusState.IN_WORK:
      case AppointmentStatusState.ON_HOLD:
      case AppointmentStatusState.CANCELED:
      case AppointmentStatusState.DONE:
      case AppointmentStatusState.IN_REVIEW:
      case AppointmentStatusState.READY_FOR_PICKUP:
        return AppointmentDetailsConsultantWidget(
          appointmentDetail: _provider.selectedAppointmentDetail,
          serviceProviderItems: _provider.serviceProviderItems,
          declineAppointment: _declineAppointment,
          createEstimate: _createEstimate,
          viewEstimate: _viewEstimate,
          assignMechanic: _assignMechanic,
          createPickUpCarForm: _createPickUpCarForm,
          createHandoverCarForm: _createHandoverCarForm,
          workEstimateDetails: _provider.workEstimateDetails,
          finishAppointment: _finishAppointment,
          seeCamera: _seeCamera,
        );
      default:
        return Container();
    }
  }

  _declineAppointment() {
    if (_provider.selectedAppointment != null) {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return AlertConfirmationDialogWidget(
                  confirmFunction: (confirm) => {
                        if (confirm)
                          {_cancelAppointment(_provider.selectedAppointment)}
                      },
                  title: S
                      .of(context)
                      .appointment_details_cancel_appointment_title);
            });
          });
    }
  }

  _cancelAppointment(Appointment appointment) async {
    try {
      await _provider.cancelAppointment(appointment).then((appointment) {
        Provider.of<AppointmentsProvider>(context).initDone = false;

        setState(() {
          _provider.initDone = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CANCEL_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_cancel_appointment, context);
      }

      setState(() {
        _provider.initDone = false;
      });
    }
  }

  _createEstimate() {
    if (_provider.selectedAppointmentDetail != null) {
      EstimatorMode estimatorMode =
          _provider.selectedAppointmentDetail.rentServiceItem() == null
              ? EstimatorMode.Create
              : EstimatorMode.CreateRent;

      Provider.of<WorkEstimateProvider>(context).refreshValues(estimatorMode);
      Provider.of<WorkEstimateProvider>(context)
          .setIssues(context, _provider.selectedAppointmentDetail.issues);
      Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
          _provider.selectedAppointmentDetail;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _provider.selectedAppointment.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(mode: estimatorMode)),
      );
    }
  }

  _viewEstimate() {
    int lastWorkEstimateId =
        _provider.selectedAppointmentDetail.lastWorkEstimate();

    if (lastWorkEstimateId != 0) {
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.ReadOnly);
      Provider.of<WorkEstimateProvider>(context).workEstimateId =
          lastWorkEstimateId;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _provider.selectedAppointment.serviceProvider.id;
      Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
          _provider.selectedAppointmentDetail;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(
                mode: _provider.selectedAppointmentDetail.canEditWorkEstimate()
                    ? EstimatorMode.Edit
                    : EstimatorMode.ReadOnly,
                dateEntry: _provider.selectedAppointmentDetail
                    .getWorkEstimateDateEntry())),
      );
    }
  }

  _assignMechanic() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Container();
          });
        });
  }

  _createPickUpCarForm() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCarReceiveFormModal(
              carReceiveFormState: CarReceiveFormState.Service,
              appointmentDetail: _provider.selectedAppointmentDetail,
              refreshState: _refreshState,
              pickupFormState: PickupFormState.Receive,
            );
          });
        });
  }

  _createHandoverCarForm() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCarReceiveFormModal(
              carReceiveFormState: CarReceiveFormState.ServiceReturnCar,
              appointmentDetail: _provider.selectedAppointmentDetail,
              refreshState: _refreshState,
              pickupFormState: PickupFormState.Return,
            );
          });
        });
  }

  _refreshState() {
    setState(() {
      _isLoading = true;
    });

    _loadData();
  }

  _seeCamera() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCameraModal();
          });
        });
  }

  _finishAppointment() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AlertConfirmationDialogWidget(
                confirmFunction: (confirm) => {
                      if (confirm) {_finishAppointmentConfirmed()}
                    },
                title: S.of(context).appointment_finish_appointment_alert);
          });
        });
  }

  _finishAppointmentConfirmed() {
    setState(() {
      _isLoading = true;
    });

    try {
      _provider
          .finishAppointment(_provider.selectedAppointmentDetail.id)
          .then((value) {
        Provider.of<AppointmentsProvider>(context).initDone = false;

        setState(() {});
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.FINISH_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_finish_appointment, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
