import 'dart:math';

import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-refactor.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/providers/appointment-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/screens/appointments-details-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/work-estimate/create-work-estimate-final-info.widget.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/work-estimate/create-work-estimate-sections-widget.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/widgets/estimator/create-work-estimate-date.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateWorkEstimateConsultant extends StatefulWidget {
  static const String route =
      '${AppointmentDetailsConsultant.route}/create-work-estimate-consultant';

  @override
  State<StatefulWidget> createState() {
    return _CreateWorkEstimateConsultantState(route: route);
  }
}

class _CreateWorkEstimateConsultantState
    extends State<CreateWorkEstimateConsultant> {
  String route;

  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;
  List<Step> steps = [];

  CreateWorkEstimateProvider _createWorkEstimateProvider;

  _CreateWorkEstimateConsultantState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentConsultantProvider>(
        builder: (context, appointmentsProvider, _) => Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).general_save,
                      style: TextHelper.customTextStyle(
                          null, Colors.white, FontWeight.bold, 16)),
                  onPressed: () {
                    _save();
                  },
                )
              ],
              iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
            ),
            body: _buildContent(context)));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _createWorkEstimateProvider =
          Provider.of<CreateWorkEstimateProvider>(context);
      _createWorkEstimateProvider.loadItemTypes().then((_) {
        String startDate =
            DateUtils.stringFromDate(DateTime.now(), 'dd/MM/yyyy');
        String endDate = DateUtils.stringFromDate(
            DateUtils.addDayToDate(DateTime.now(), 7), 'dd/MM/yyyy');

        _createWorkEstimateProvider
            .loadServiceProviderSchedule(
                Provider.of<Auth>(context).authUserDetails.userProvider.id,
                startDate,
                endDate)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
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
          new Align(
              alignment: Alignment.bottomCenter,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      child: FlatButton(
                        color: yellow,
                        child: Text(
                          S.of(context).estimator_create_from_selection,
                          textAlign: TextAlign.center,
                          style: TextHelper.customTextStyle(
                              null, Colors.white, FontWeight.bold, 16),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      child: FlatButton(
                        color: green,
                        child: Text(
                          S.of(context).estimator_operations_history,
                          textAlign: TextAlign.center,
                          style: TextHelper.customTextStyle(
                              null, Colors.white, FontWeight.bold, 16),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
    return _buildStepper(context);
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
              ? Stepper(
                  key: Key(Random.secure().nextDouble().toString()),
                  currentStep: _currentStepIndex,
                  onStepTapped: (stepIndex) => _showIssue(stepIndex),
                  type: StepperType.horizontal,
                  steps: steps,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _newOperationContainer(),
                      ],
                    );
                  },
                )
              : Container(),
        ),
      );

  List<Step> _buildSteps(BuildContext context) {
    List<Step> stepsList = [];
    List<IssueRefactor> issues =
        _createWorkEstimateProvider?.workEstimateRequestRefactor?.issues;

    issues.asMap().forEach((index, issueRefactor) {
      stepsList.add(
        Step(
            isActive: _isStepActive(index),
            title: Text((issueRefactor.name?.isNotEmpty ?? false)
                ? issueRefactor.name
                : 'N/A'),
            content: CreateWorkEstimateSectionsWidget(
              issueRefactor: issues[index],
              addIssueItem: _addIssueItem,
              setSectionName: _setSectionName,
              expandSection: _expandSection,
              removeIssueItem: _removeIssueItem,
              selectIssueSection: _selectIssueSection,
            )),
      );
    });

    stepsList.add(Step(
      isActive: _isStepActive(issues.length),
      title: Text(S.of(context).auction_proposed_date),
      content: CreateWorkEstimateDateWidget(),
    ));

    return stepsList;
  }

  _newOperationContainer() {
    return _currentStepIndex == steps.length - 1
        ? Container()
        : RaisedButton(
            elevation: 0,
            child: Text(S.of(context).estimator_add_new_operation),
            textColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _addOperation();
            },
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
      List<IssueRefactor> issues =
          _createWorkEstimateProvider.workEstimateRequestRefactor.issues;

      if (_currentStepIndex < issues.length) {
        IssueRefactor issue = issues[_currentStepIndex];

        IssueSection section = IssueSection.defaultSection();
        issue.sections.add(section);
      }
    });
  }

  _setSectionName(
      IssueRefactor issueRefactor, String name, IssueSection issueSection) {
    setState(() {
      for (IssueSection section in issueRefactor.sections) {
        section.expanded = false;
      }

      issueSection.isNew = false;
      issueSection.expanded = true;
      issueSection.name = name;
    });
  }

  _expandSection(IssueRefactor issueRefactor, IssueSection issueSection) {
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

  _addIssueItem(IssueRefactor issueRefactor, IssueSection issueSection) {
    setState(() {
      _createWorkEstimateProvider.addRequestToIssueSection(
          issueRefactor, issueSection);
    });
  }

  _removeIssueItem(IssueRefactor issueRefactor, IssueSection issueSection,
      IssueItem issueItem) {
    setState(() {
      _createWorkEstimateProvider.removeIssueRefactorItem(
          issueRefactor, issueSection, issueItem);
    });
  }

  _selectIssueSection(IssueRefactor issueRefactor, IssueSection issueSection) {
    setState(() {
      _createWorkEstimateProvider.selectIssueSection(
          issueRefactor, issueSection);
    });
  }

  _save() {
    String validationString = _createWorkEstimateProvider
        .workEstimateRequestRefactor
        .isValid(context);

    if (validationString != null) {
      AlertWarningDialog.showAlertDialog(
          context, S.of(context).general_warning, validationString);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateWorkEstimateFinalInfoWidget(
            infoAdded: _infoAdded,
          );
        },
      );
    }
  }

  _infoAdded(String percentage, String time) {
  }
}
