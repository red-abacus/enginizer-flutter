import 'dart:math';

import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/shared/widgets/alert-text-form-widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/horizontal-stepper.widget.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue-section.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue.model.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/screens/appointments-details-consultant.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/widgets/work-estimate-final-info.widget.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/widgets/work-estimate-sections-widget.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/widgets/work-estimate-date.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WorkEstimateForm extends StatefulWidget {
  static const String route =
      '${AppointmentDetailsConsultant.route}/work-estimate-form';

  final EstimatorMode mode;
  final Function createWorkEstimateFinished;

  WorkEstimateForm({this.mode, this.createWorkEstimateFinished});

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
      setState(() {
        _isLoading = true;
      });

      _workEstimateProvider = Provider.of<WorkEstimateProvider>(context);
      _workEstimateProvider.loadItemTypes().then((_) {
        String startDate =
            DateUtils.stringFromDate(DateTime.now(), 'dd/MM/yyyy');
        String endDate = DateUtils.stringFromDate(
            DateUtils.addDayToDate(DateTime.now(), 7), 'dd/MM/yyyy');

        _workEstimateProvider
            .loadServiceProviderSchedule(
                _workEstimateProvider.serviceProviderId, startDate, endDate)
            .then((_) {
          if (widget.mode == EstimatorMode.ReadOnly ||
              widget.mode == EstimatorMode.Edit) {
            _workEstimateProvider
                .getWorkEstimateDetails(_workEstimateProvider.workEstimateId)
                .then((workEstimateDetails) {
              if (workEstimateDetails != null) {
                _workEstimateProvider
                    .createWorkEstimateRequest(workEstimateDetails);
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
    }

    _initDone = true;

    super.didChangeDependencies();
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

    issues.asMap().forEach((index, issueRefactor) {
      stepsList.add(
        FAStep(
            isActive: _isStepActive(index),
            title: Text((issueRefactor.name?.isNotEmpty ?? false)
                ? issueRefactor.name
                : 'N/A'),
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

    stepsList.add(FAStep(
      isActive: _isStepActive(issues.length),
      title: Text(S.of(context).auction_proposed_date),
      content: WorkEstimateDateWidget(estimatorMode: widget.mode),
    ));

    return stepsList;
  }

  _floatingActionButtonContainer() {
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

    buttons.add(SpeedDialChild(
        child: Icon(Icons.history),
        foregroundColor: red,
        backgroundColor: Colors.white,
        label: S.of(context).estimator_operations_history,
        labelStyle:
            TextHelper.customTextStyle(null, Colors.grey, FontWeight.bold, 16),
        onTap: () => print('operation history')));

    if (widget.mode != EstimatorMode.ReadOnly) {
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

        IssueSection section = IssueSection.defaultSection();
        issue.sections.add(section);

        _showSectionName(issue, section);
      }
    });
  }

  _setSectionName(Issue issue, IssueSection issueSection, String name) {
    setState(() {
      for (IssueSection section in issue.sections) {
        section.expanded = false;
      }

      issueSection.isNew = false;
      issueSection.expanded = true;
      issueSection.name = name;
    });
  }

  _expandSection(Issue issueRefactor, IssueSection issueSection) {
    setState(() {
      if (issueSection.expanded) {
        issueSection.expanded = false;
      } else {
        for (IssueSection section in issueRefactor.sections) {
          section.expanded = false;
        }

        issueSection.expanded = true;
      }
    });
  }

  _addIssueItem(Issue issueRefactor, IssueSection issueSection) {
    setState(() {
      _workEstimateProvider.addRequestToIssueSection(
          issueRefactor, issueSection);
    });
  }

  _removeIssueItem(
      Issue issueRefactor, IssueSection issueSection, IssueItem issueItem) {
    setState(() {
      _workEstimateProvider.removeIssueRefactorItem(
          issueRefactor, issueSection, issueItem);
    });
  }

  _selectIssueSection(Issue issueRefactor, IssueSection issueSection) {
    setState(() {
      _workEstimateProvider.selectIssueSection(issueRefactor, issueSection);
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

  _infoAdded(String percentage, String time) {
    _workEstimateProvider
        .createWorkEstimate(
            _workEstimateProvider.selectedAppointment.id,
            _workEstimateProvider.selectedAppointmentDetail.car.id,
            _workEstimateProvider.selectedAppointmentDetail.user.uid,
            _workEstimateProvider.workEstimateRequest)
        .then((workEstimateDetails) {
      if (workEstimateDetails != null) {
        Navigator.of(context).pop();

        if (widget.createWorkEstimateFinished != null) {
          widget.createWorkEstimateFinished();
        }
      }
    });
  }

  _showSectionName(Issue issue, IssueSection issueSection) {
    if (widget.mode != EstimatorMode.ReadOnly) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertTextFormWidget(
            title: S.of(context).estimator_add_section_name,
            placeholder: issueSection.isNew
                ? S.of(context).estimator_section_name
                : issueSection.name,
            buttonName: S.of(context).general_add,
            addTextFunction: (name) {
              _setSectionName(issue, issueSection, name);
            },
          );
        },
      );
    }
  }
}
