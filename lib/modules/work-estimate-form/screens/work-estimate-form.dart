import 'dart:math';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/providers/auction-consultant.provider.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';
import 'package:app/modules/consultant-appointments/providers/appointments-consultant.provider.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/shared/widgets/alert-text-form-widget.dart';
import 'package:app/modules/shared/widgets/horizontal-stepper.widget.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/screens/appointments-details-consultant.dart';
import 'package:app/modules/work-estimate-form/widgets/assign-mechanic/estimate-assign-mechanic-modal.widget.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate/work-estimate-final-info-parts.widget.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate/work-estimate-final-info.widget.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate/work-estimate-sections-widget.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class WorkEstimateForm extends StatefulWidget {
  static const String route =
      '${AppointmentDetailsConsultant.route}/work-estimate-form';

  EstimatorMode mode;
  DateEntry dateEntry;

  WorkEstimateForm({this.mode, this.dateEntry});

  // TODO - check route
  @override
  State<StatefulWidget> createState() {
    return _WorkEstimateFormState(route: route);
  }
}

class _WorkEstimateFormState extends State<WorkEstimateForm> {
  String route;

  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;
  List<FAStep> steps = [];

  WorkEstimateProvider _workEstimateProvider;

  _WorkEstimateFormState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentConsultantProvider>(
      builder: (context, appointmentsProvider, _) => Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
        ),
        body: _buildContent(context),
        floatingActionButton: _floatingButtons(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _workEstimateProvider = Provider.of<WorkEstimateProvider>(context);

      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _workEstimateProvider.loadItemTypes().then((_) async {
        String startDate =
            DateUtils.stringFromDate(DateTime.now(), 'dd/MM/yyyy');
        String endDate = DateUtils.stringFromDate(
            DateUtils.addDayToDate(DateTime.now(), 7), 'dd/MM/yyyy');
        await _workEstimateProvider
            .loadServiceProviderSchedule(
                _workEstimateProvider.serviceProviderId, startDate, endDate)
            .then((_) async {
          if (widget.mode == EstimatorMode.ReadOnly ||
              widget.mode == EstimatorMode.CreateFinal ||
              widget.mode == EstimatorMode.Client ||
              widget.mode == EstimatorMode.ClientAccept) {
            await _workEstimateProvider
                .getWorkEstimateDetails(_workEstimateProvider.workEstimateId)
                .then((workEstimateDetails) {
              if (workEstimateDetails != null) {
                if (widget.mode == EstimatorMode.CreateFinal) {
                  _workEstimateProvider.createFinalWorkEstimateRequest(
                      workEstimateDetails, widget.mode);
                } else {
                  _workEstimateProvider.createWorkEstimateRequest(
                      workEstimateDetails, widget.mode);
                }
              }
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
      _handleError(error);
    }
  }

  _buildContent(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    steps = _buildSteps(context);

    return Container(
      child: Stack(
        children: <Widget>[
          _buildStepper(context),
          if (widget.mode == EstimatorMode.Client ||
              widget.mode == EstimatorMode.ReadOnly ||
              widget.mode == EstimatorMode.ClientAccept)
            _clientBottomContainer()
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context) => ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          padding: EdgeInsets.only(bottom: 60),
          child: steps.isNotEmpty
              ? Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: FAStepper(
                    stepNumberColor: red,
                    titleIconArrange: FAStepperTitleIconArrange.row,
                    type: FAStepperType.horizontal,
                    key: Key(Random.secure().nextDouble().toString()),
                    currentStep: _currentStepIndex,
                    onStepTapped: (stepIndex) => _showIssue(stepIndex),
                    steps: steps,
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return Container();
                    },
                  ),
                )
              : Container(),
        ),
      );

  List<FAStep> _buildSteps(BuildContext context) {
    List<FAStep> stepsList = [];
    List<Issue> issues = _workEstimateProvider?.workEstimateRequest?.issues;

    if (widget.mode == EstimatorMode.Client ||
        widget.mode == EstimatorMode.ClientAccept) {
      stepsList.add(FAStep(
          isActive: _isStepActive(0),
          title: Text(S.of(context).estimator_info),
          content: _costEstimateContainer()));
    }

    issues.asMap().forEach((index, issue) {
      stepsList.add(
        FAStep(
            isActive: _isStepActive(widget.mode == EstimatorMode.Client ||
                    widget.mode == EstimatorMode.ClientAccept
                ? index + 1
                : index),
            title: Text((issue.name?.isNotEmpty ?? false) ? issue.name : 'N/A'),
            content: WorkEstimateSectionsWidget(
                issue: issues[index],
                addIssueItem: _addIssueItem,
                expandSection: _expandSection,
                removeIssueItem: _removeIssueItem,
                selectIssueSection: _selectIssueSection,
                showSectionName: _showSectionName,
                estimatorMode: widget.mode)),
      );
    });

    //    if (widget.mode != EstimatorMode.ReadOnly) {
    //      stepsList.add(FAStep(
    //        isActive: _isStepActive(widget.mode == EstimatorMode.Client
    //            ? issues.length + 1
    //            : issues.length),
    //        title: Text(S.of(context).auction_proposed_date),
    //        content: WorkEstimateDateWidget(
    //            dateEntry: _workEstimateProvider.workEstimateRequest.dateEntry,
    //            estimateDateSelect: _estimateDateSelect,
    //            estimatorMode: widget.mode),
    //      ));
    //    }

    return stepsList;
  }

  _costEstimateContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            S.of(context).estimator_cost_estimate,
            style: TextHelper.customTextStyle(null, red, FontWeight.normal, 22),
          ),
          Text(
            '${S.of(context).estimator_percent}: ${_workEstimateProvider.selectedAppointmentDetail?.forwardPaymentPercent}',
            style:
                TextHelper.customTextStyle(null, gray, FontWeight.normal, 14),
          ),
          Text(
            '${S.of(context).estimator_max_time}: ${_workEstimateProvider.selectedAppointmentDetail?.timeToRespond}',
            style:
                TextHelper.customTextStyle(null, gray, FontWeight.normal, 14),
          ),
        ],
      ),
    );
  }

  _floatingButtons() {
    switch (widget.mode) {
      case EstimatorMode.Client:
      case EstimatorMode.ReadOnly:
      case EstimatorMode.ClientAccept:
        return Container();
      default:
        break;
    }

    var buttons = List<SpeedDialChild>();

    if (widget.mode != EstimatorMode.ReadOnly) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.save),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).general_save,
          labelStyle: TextHelper.customTextStyle(
              null, Colors.grey, FontWeight.bold, 16),
          onTap: () => _save()));
    }

    if (widget.mode == EstimatorMode.ReadOnly) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.schedule),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).auction_proposed_date,
          labelStyle: TextHelper.customTextStyle(
              null, Colors.grey, FontWeight.bold, 16),
          onTap: () => print('schedule')));
    }

    if (widget.mode == EstimatorMode.Create) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.assignment),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).estimator_assign_mechanic,
          labelStyle: TextHelper.customTextStyle(
              null, Colors.grey, FontWeight.bold, 16),
          onTap: () => _assignMechanic()));
    }

    if (widget.mode != EstimatorMode.Create &&
        widget.mode != EstimatorMode.CreatePart) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.history),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).estimator_operations_history,
          labelStyle: TextHelper.customTextStyle(
              null, Colors.grey, FontWeight.bold, 16),
          onTap: () => print('operation history')));
    }

    if (widget.mode == EstimatorMode.Client) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.create),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).estimator_create_from_selection,
          labelStyle: TextHelper.customTextStyle(
              null, Colors.grey, FontWeight.bold, 16),
          onTap: () => print('create from selection')));
    }

    return SpeedDial(
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      closeManually: false,
      curve: Curves.linear,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: S.of(context).estimator_open_menu,
      heroTag: 'open-menu-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: buttons,
    );
  }

  _clientBottomContainer() {
    double totalCost = widget.mode == EstimatorMode.Client
        ? _workEstimateProvider.selectedRecommendationTotalCost()
        : _workEstimateProvider.workEstimateDetails?.totalCost;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _bottomContainerButton(),
            Container(
              child: Text(
                '${S.of(context).estimator_total}: $totalCost RON',
                style:
                    TextHelper.customTextStyle(null, red, FontWeight.bold, 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  _bottomContainerButton() {
    if (widget.mode == EstimatorMode.ReadOnly ||
        _workEstimateProvider.workEstimateDetails.status !=
            WorkEstimateStatus.Pending) {
      return Container();
    }

    return Row(
      children: <Widget>[
        FlatButton(
          child: Text(
            S.of(context).general_decline,
            style: TextHelper.customTextStyle(null, gray3, FontWeight.bold, 14),
          ),
          onPressed: () {
            _declineEstimateAlert();
          },
        ),
        FlatButton(
          child: Text(
            S.of(context).general_accept,
            style: TextHelper.customTextStyle(null, red, FontWeight.bold, 14),
          ),
          onPressed: () {
            _acceptEstimateAlert();
          },
        )
      ],
    );
  }

  _showIssue(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
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
            return EstimateAssignMechanicModal(
                appointment: _workEstimateProvider.selectedAppointment,
                appointmentDetail:
                    _workEstimateProvider.selectedAppointmentDetail,
                refreshState: _refreshState,
                assignEmployee: _assignEmployee);
          });
        });
  }

  _assignEmployee(EmployeeTimeSerie timeSerie) {
    _workEstimateProvider.workEstimateRequest.employeeTimeSerie = timeSerie;
  }

  _refreshState() {}

  _setSectionName(Issue issue, IssueRecommendation issueSection, String name) {
    setState(() {
      for (IssueRecommendation section in issue.recommendations) {
        section.expanded = false;
      }

      issueSection.isNew = false;
      issueSection.expanded = true;
      issueSection.name = name;
    });
  }

  _expandSection(Issue issue, IssueRecommendation issueSection) {
    setState(() {
      if (issueSection.expanded) {
        issueSection.expanded = false;
      } else {
        for (IssueRecommendation recommendation in issue.recommendations) {
          recommendation.expanded = false;
        }

        issueSection.expanded = true;
      }
    });
  }

  _addIssueItem(Issue issue, IssueRecommendation issueRecommendation) {
    setState(() {
      _workEstimateProvider.addRequestToIssueSection(
          issue, issueRecommendation);
    });
  }

  _removeIssueItem(Issue issue, IssueRecommendation issueRecommendation,
      IssueItem issueItem) {
    setState(() {
      _workEstimateProvider.removeIssueItem(
          issue, issueRecommendation, issueItem);
    });
  }

  _selectIssueSection(Issue issue, IssueRecommendation issueRecommendation) {
    setState(() {
      if (!_workEstimateProvider.selectedRecommendations
          .contains(issueRecommendation)) {
        _workEstimateProvider.selectedRecommendations.add(issueRecommendation);
      } else {
        _workEstimateProvider.selectedRecommendations
            .remove(issueRecommendation);
      }
    });
  }

  _save() {
    String validationString =
        _workEstimateProvider.workEstimateRequest.isValid(context, widget.mode);

    if (validationString != null) {
      AlertWarningDialog.showAlertDialog(
          context, S.of(context).general_warning, validationString);
    } else {
      DateTime maxResponseTime = widget.mode == EstimatorMode.Create
          ? _workEstimateProvider.workEstimateRequest.employeeTimeSerie
              .getDate()
          : new DateTime(DateTime.now().year + 1, DateTime.now().month,
              DateTime.now().day);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (widget.mode == EstimatorMode.CreatePart) {
            return WorkEstimateFinalInfoPartsWidget(
                infoAdded: _partsInfoAdded,
                maxResponseTime: DateUtils.dateFromString(
                    _workEstimateProvider
                        .selectedAuctionDetails.scheduledDateTime,
                    'dd/MM/yyyy HH:mm'));
          } else {
            return WorkEstimateFinalInfoWidget(
              infoAdded: _infoAdded,
              maxResponseTime: maxResponseTime,
              estimatorMode: widget.mode,
            );
          }
        },
      );
    }
  }

  _infoAdded(int percentage, DateTime time) async {
    _workEstimateProvider.workEstimateRequest.percent = percentage;
    _workEstimateProvider.workEstimateRequest.timeToRespond = time;

    setState(() {
      _isLoading = true;
    });

    try {
      await _workEstimateProvider
          .createWorkEstimate(_workEstimateProvider.workEstimateRequest,
          appointmentId: _workEstimateProvider.selectedAppointment.id)
          .then((workEstimateDetails) async {
        if (workEstimateDetails != null) {
          Provider.of<AppointmentConsultantProvider>(context).initDone =
          false;
          Provider.of<AppointmentsConsultantProvider>(context).initDone =
          false;

          Navigator.pop(context);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _partsInfoAdded(DateTime deliveryDate, DateTime maxResponseDate) async {
    _workEstimateProvider.workEstimateRequest.percent = 0;
    _workEstimateProvider.workEstimateRequest.timeToRespond = deliveryDate;
    _workEstimateProvider.workEstimateRequest.timeToRespond = maxResponseDate;

    setState(() {
      _isLoading = true;
    });

    try {
      await _workEstimateProvider
          .createWorkEstimate(_workEstimateProvider.workEstimateRequest,
          auctionId: _workEstimateProvider.selectedAuctionDetails.id)
          .then((workEstimateDetails) async {
        if (workEstimateDetails != null) {
          Provider.of<AuctionConsultantProvider>(context).initDone = false;

          Navigator.pop(context);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _showSectionName(Issue issue, IssueRecommendation issueRecommendation) {
    if (widget.mode != EstimatorMode.ReadOnly) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertTextFormWidget(
            title: S.of(context).estimator_add_section_name,
            placeholder: issueRecommendation.isNew
                ? S.of(context).estimator_section_name
                : issueRecommendation.name,
            buttonName: S.of(context).general_add,
            addTextFunction: (name) {
              _setSectionName(issue, issueRecommendation, name);
            },
          );
        },
      );
    }
  }

  _declineEstimateAlert() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AlertConfirmationDialogWidget(
                confirmFunction: (confirm) => {
                      if (confirm) {_declineWorkEstimate()}
                    },
                title: S.of(context).estimator_decline_alert_body);
          });
        });
  }

  _declineWorkEstimate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _workEstimateProvider
          .rejectWorkEstimate(_workEstimateProvider.workEstimateDetails.id)
          .then((success) {
        Provider.of<AppointmentProvider>(context).initDone = false;
        Navigator.pop(context);
      });
    } catch (error) {
      _handleError(error);
    }
  }

  _acceptEstimateAlert() {
    if (widget.mode == EstimatorMode.Client) {
      if (_workEstimateProvider.selectedRecommendations.length == 0) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).estimator_no_recommendation_selected, context);
      } else {
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter state) {
                return AlertConfirmationDialogWidget(
                    confirmFunction: (confirm) => {
                          if (confirm) {_acceptWorkEstimate()}
                        },
                    title: S
                        .of(context)
                        .estimator_accept_recommendations_alert_body);
              });
            });
      }
    } else {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return AlertConfirmationDialogWidget(
                  confirmFunction: (confirm) => {
                        if (confirm) {_acceptWorkEstimate()}
                      },
                  title: S.of(context).estimator_accept_alert_body);
            });
          });
    }
  }

  _acceptWorkEstimate() async {
    if (widget.mode == EstimatorMode.Client) {
      try {
        await _workEstimateProvider
            .acceptBid(_workEstimateProvider.selectedAppointmentDetail.bidId)
            .then((_) {
          setState(() {
            Provider.of<AppointmentProvider>(context).initDone = false;
            _initDone = false;
          });
        });
      } catch (error) {
        if (error
            .toString()
            .contains(WorkEstimatesService.ACCEPT_WORK_ESTIMATE_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_accept_work_estimate, context);
        }
      }
    } else if (widget.mode == EstimatorMode.ClientAccept) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _workEstimateProvider
            .acceptBid(_workEstimateProvider.selectedAppointmentDetail.bidId)
            .then((_) {
          setState(() {
            Provider.of<AppointmentProvider>(context).initDone = false;
            Provider.of<AppointmentsProvider>(context).initDone = false;

            Navigator.pop(context);
          });
        });
      } catch (error) {
        if (error
            .toString()
            .contains(WorkEstimatesService.ACCEPT_WORK_ESTIMATE_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_accept_work_estimate, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _handleError(dynamic error) {
    if (error
        .toString()
        .contains(WorkEstimatesService.ADD_NEW_WORK_ESTIMATE_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_add_new_work_estimate, context);
    } else if (error
        .toString()
        .contains(ProviderService.GET_PROVIDER_TIMETABLE_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_provider_timetable, context);
    } else if (error
        .toString()
        .contains(ProviderService.GET_ITEM_TYPES_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_item_types, context);
    } else if (error
        .toString()
        .contains(WorkEstimatesService.GET_WORK_ESTIMATE_DETAILS_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_work_estimate_details, context);
    } else if (error
        .toString()
        .contains(AppointmentsService.GET_APPOINTMENT_DETAILS_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_get_appointment_details, context);
    } else if (error
        .toString()
        .contains(WorkEstimatesService.REJECT_WORK_ESTIMATE_EXCEPTION)) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_reject_work_estimate, context);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
