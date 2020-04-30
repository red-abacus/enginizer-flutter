import 'dart:math';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/consultant-appointments/providers/appointments-consultant.provider.dart';
import 'package:app/modules/shared/widgets/alert-text-form-widget.dart';
import 'package:app/modules/shared/widgets/horizontal-stepper.widget.dart';
import 'package:app/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/screens/appointments-details-consultant.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-final-info.widget.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-sections-widget.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-date.widget.dart';
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

  final EstimatorMode mode;
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
        floatingActionButton: _floatingActionButtonContainer(),
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
              widget.mode == EstimatorMode.Edit ||
              widget.mode == EstimatorMode.Client) {
            await _workEstimateProvider
                .getWorkEstimateDetails(_workEstimateProvider.workEstimateId)
                .then((workEstimateDetails) {
              if (workEstimateDetails != null) {
                _workEstimateProvider
                    .createWorkEstimateRequest(workEstimateDetails);
                _workEstimateProvider.workEstimateRequest.dateEntry = widget.dateEntry;
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
      if (error
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
      }

      setState(() {
        _isLoading = false;
      });
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
        ],
      ),
    );
  }

  _clientWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TODO - hardcoded value
          Text(
            S.of(context).estimator_cost_estimate,
            style: TextHelper.customTextStyle(null, red, FontWeight.normal, 24),
          ),
          // TODO - hardcoded value
          Text(
            '${S.of(context).estimator_percent}: 20%',
            style:
                TextHelper.customTextStyle(null, gray, FontWeight.normal, 16),
          ),
          // TODO - what happens if client does not responde in this time?
          Text(
            '${S.of(context).estimator_max_time}: 24h',
            style:
                TextHelper.customTextStyle(null, gray, FontWeight.normal, 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context) => ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          padding: EdgeInsets.only(bottom: 40),
          decoration: new BoxDecoration(
//            color: Theme.of(context).cardColor,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
            ),
          ),
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

    if (widget.mode == EstimatorMode.Client) {
      stepsList.add(FAStep(
          isActive: _isStepActive(0),
          title: Text(S.of(context).estimator_info),
          content: _clientWidget()));
    }

    issues.asMap().forEach((index, issue) {
      stepsList.add(
        FAStep(
            isActive: _isStepActive(
                widget.mode == EstimatorMode.Client ? index + 1 : index),
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

    if (widget.mode != EstimatorMode.ReadOnly) {
      stepsList.add(FAStep(
        isActive: _isStepActive(widget.mode == EstimatorMode.Client
            ? issues.length + 1
            : issues.length),
        title: Text(S.of(context).auction_proposed_date),
        content: WorkEstimateDateWidget(
            dateEntry: _workEstimateProvider.workEstimateRequest.dateEntry,
            estimateDateSelect: _estimateDateSelect,
            estimatorMode: widget.mode),
      ));
    }

    return stepsList;
  }

  _floatingActionButtonContainer() {
    if (widget.mode == EstimatorMode.Client || widget.mode == EstimatorMode.ReadOnly) {
      return Container();
    }

    var buttons = List<SpeedDialChild>();

    if (widget.mode != EstimatorMode.ReadOnly) {
      String buttonTitle = widget.mode == EstimatorMode.Create
          ? S.of(context).general_save
          : S.of(context).general_edit;

      buttons.add(SpeedDialChild(
          child: Icon(Icons.save),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: buttonTitle,
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

    if (widget.mode != EstimatorMode.ReadOnly &&
        _currentStepIndex < steps.length - 1) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.add),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).estimator_add_new_operation,
          labelStyle: TextHelper.customTextStyle(
              null, Colors.grey, FontWeight.bold, 16),
          onTap: () => _addOperation()));
    }

    if (widget.mode != EstimatorMode.Create) {
      buttons.add(SpeedDialChild(
          child: Icon(Icons.history),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).estimator_operations_history,
          labelStyle: TextHelper.customTextStyle(
              null, Colors.grey, FontWeight.bold, 16),
          onTap: () => print('operation history')));
    }

    if (widget.mode == EstimatorMode.Edit) {
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

  _showIssue(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
  }

  _addOperation() {
    setState(() {
      List<Issue> issues = _workEstimateProvider.workEstimateRequest.issues;

      if (_currentStepIndex < issues.length) {
        Issue issue = issues[_currentStepIndex];

        IssueRecommendation section =
            IssueRecommendation.defaultRecommendation();
        issue.recommendations.add(section);

        _showSectionName(issue, section);
      }
    });
  }

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
      _workEstimateProvider.selectIssueSection(issue, issueRecommendation);
    });
  }

  _save() {
    String validationString =
        _workEstimateProvider.workEstimateRequest.isValid(context);

    if (validationString != null) {
      AlertWarningDialog.showAlertDialog(
          context, S.of(context).general_warning, validationString);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WorkEstimateFinalInfoWidget(
            infoAdded: _infoAdded,
          );
        },
      );
    }
  }

  _infoAdded(String percentage, String time) async {
    // TODO - API doesn't support percentage and time
    try {
      await _workEstimateProvider
          .createWorkEstimate(
              _workEstimateProvider.selectedAppointment.id,
              _workEstimateProvider.selectedAppointmentDetail.car.id,
              _workEstimateProvider.selectedAppointmentDetail.user.uid,
              _workEstimateProvider.workEstimateRequest)
          .then((workEstimateDetails) {
        if (workEstimateDetails != null) {
          Provider.of<AppointmentConsultantProvider>(context).initDone = false;
          Provider.of<AppointmentsConsultantProvider>(context).initDone = false;
          Navigator.of(context).pop();
        }
      });
    } catch (error) {
      if (error
          .toString()
          .contains(WorkEstimatesService.ADD_NEW_WORK_ESTIMATE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_add_new_work_estimate, context);
      }
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

  _estimateDateSelect(DateEntry dateEntry) {
    setState(() {
      _workEstimateProvider.workEstimateRequest.dateEntry = dateEntry;
    });
  }
}
