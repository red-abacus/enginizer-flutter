import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/car-receive-form-state.enum.dart';
import 'package:app/modules/appointments/enum/pick-up-form-state.enum.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/screens/appointment-camera.modal.dart';
import 'package:app/modules/appointments/screens/appointments.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/appointments/providers/select-parts-provider.provider.dart';
import 'package:app/modules/notifications/screens/notifications.dart';
import 'package:app/modules/shared/widgets/locator/locator.manager.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/cars/widgets/car-general-details.widget.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-car-receive-form.widget.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details-documents.widget.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details-generic-consultant.widget.dart';
import 'package:app/modules/appointments/screens/appointment-details-parts-provider-estimate.modal.dart';
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
                    null, Colors.white, FontWeight.bold, 20),
              ),
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: _contentWidget()));
  }

  _getTabs() {
    List<Tab> tabs = [
      Tab(text: S.of(context).appointment_details_request),
      Tab(text: S.of(context).appointment_details_car),
      Tab(text: S.of(context).appoontment_consultant_provider_documents_title)
    ];

//    if (_provider.selectedAppointmentDetail.status.getState() ==
//        AppointmentStatusState.IN_REVIEW) {
////      tabs.add(Tab(
////          text: S.of(context).appointment_consultant_provider_estimate_title));
//    }

    return tabs;
  }

  _contentWidget() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    List<Widget> list = [
      _getAppointmentDetailsScreen(),
      CarGeneralDetailsWidget(car: _provider.selectedAppointmentDetail.car),
      AppointmentDetailsDocumentsWidget()
    ];

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
        return AppointmentDetailsGenericConsultantWidget(
          appointmentDetail: _provider.selectedAppointmentDetail,
          serviceProviderItems: _provider.serviceProviderItems,
          declineAppointment: _declineAppointment,
          createEstimate: _createEstimate,
          viewEstimate: _viewEstimate,
          assignMechanic: _assignMechanic,
          createPickUpCarForm: _createPickUpCarForm,
          workEstimateDetails: _provider.workEstimateDetails,
          requestPartsProvider: _requestPartsProvider,
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
      Provider.of<WorkEstimateProvider>(context)
          .refreshValues(EstimatorMode.Create);
      Provider.of<WorkEstimateProvider>(context)
          .setIssues(context, _provider.selectedAppointmentDetail.issues);
      Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
          _provider.selectedAppointmentDetail;
      Provider.of<WorkEstimateProvider>(context).serviceProviderId =
          _provider.selectedAppointment.serviceProvider.id;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkEstimateForm(mode: EstimatorMode.Create)),
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

  _requestPartsProvider() {
    Provider.of<SelectPartsProviderProvider>(context).resetParams();
    Provider.of<SelectPartsProviderProvider>(context)
        .selectedAppointmentDetails = _provider.selectedAppointmentDetail;

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentDetailsPartsProviderEstimateModal();
          });
        });
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

  _refreshState() {
    setState(() {
      _isLoading = true;
    });

    _loadData();
  }

//  _createFinalEstimate() {
//    Provider.of<WorkEstimateProvider>(context).refreshValues();
//    Provider.of<WorkEstimateProvider>(context)
//        .setIssues(_provider.selectedAppointmentDetail.issues);
//    Provider.of<WorkEstimateProvider>(context).selectedAppointment =
//        _provider.selectedAppointment;
//    Provider.of<WorkEstimateProvider>(context).selectedAppointmentDetail =
//        _provider.selectedAppointmentDetail;
//    Provider.of<WorkEstimateProvider>(context).workEstimateId =
//        _provider.selectedAppointmentDetail.lastWorkEstimate();
//    Provider.of<WorkEstimateProvider>(context).serviceProviderId =
//        _provider.selectedAppointment.serviceProvider.id;
//
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => WorkEstimateForm(mode: EstimatorMode.CreateFinal)),
//    );
//  }

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
}
