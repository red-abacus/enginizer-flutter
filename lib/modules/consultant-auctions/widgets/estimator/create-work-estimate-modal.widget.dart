import 'dart:math';

import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/widgets/estimator/create-work-estimate-date.widget.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create-work-estimator-issue-details.widget.dart';

class CreateEstimatorModal extends StatefulWidget {
  Function createBid;

  CreateEstimatorModal({this.createBid});

  @override
  _CreateEstimatorModalState createState() => _CreateEstimatorModalState();
}

class _CreateEstimatorModalState extends State<CreateEstimatorModal> {
  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;
  List<Step> steps = [];

  bool _popped = false;

  CreateWorkEstimateProvider _createWorkEstimateProvider;

  @override
  Widget build(BuildContext context) {
    if (_createWorkEstimateProvider.getAppointmentDetails() == null ||
        Provider.of<Auth>(context).authUserDetails == null ||
        Provider.of<Auth>(context).authUserDetails.userProvider == null) {
      if (!_popped) {
        Navigator.pop(context);
        _popped = true;
      }
    }

    return Consumer<CreateWorkEstimateProvider>(
      builder: (context, provider, _) => ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0))),
          child: Theme(
            data: ThemeData(
                accentColor: Theme.of(context).primaryColor,
                primaryColor: Theme.of(context).primaryColor),
            child: FractionallySizedBox(
              heightFactor: .8,
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      _createWorkEstimateProvider =
          Provider.of<CreateWorkEstimateProvider>(context);
      _createWorkEstimateProvider.initValues();
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
    return _buildStepper(context);
  }

  Widget _buildStepper(BuildContext context) => ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
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
                        RaisedButton(
                          elevation: 0,
                          child: Text(S.of(context).auction_create_estimate),
                          textColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            _createBid();
                          },
                        ),
                      ],
                    );
                  },
                )
              : Container(),
        ),
      );

  List<Step> _buildSteps(BuildContext context) {
    List<Step> stepsList = [];
    List<Issue> issues = _createWorkEstimateProvider?.issues;

    issues.asMap().forEach((index, issue) {
      stepsList.add(
        Step(
          isActive: _isStepActive(index),
          title: Text((issue.name?.isNotEmpty ?? false) ? issue.name : 'N/A'),
          content: CreateWorkEstimatorIssueDetails(
            issue: issue,
            addIssueItem: _addIssueItem,
            removeIssueItem: _removeIssueItem,
          ),
        ),
      );
    });

    stepsList.add(Step(
      isActive: _isStepActive(issues.length),
      title: Text(S.of(context).auction_proposed_date),
      content: CreateWorkEstimateDateWidget(),
    ));

    return stepsList;
  }

  _addIssueItem(Issue issue) {
    setState(() {
      _createWorkEstimateProvider.addRequestToIssue(issue);
      _createWorkEstimateProvider.initValues();
    });
  }

  _removeIssueItem(Issue issue, IssueItem issueItem) {
    setState(() {
      _createWorkEstimateProvider.removeIssueItem(issue, issueItem);
    });
  }

  _showIssue(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
  }

  _createBid() {
    if (_createWorkEstimateProvider.isValid()) {
      widget.createBid(_createWorkEstimateProvider.createBidContent());
    } else {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).general_warning,
                style: TextHelper.customTextStyle(
                    null, null, FontWeight.bold, 16)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    S.of(context).auction_create_bid_validation_error,
                    style: TextHelper.customTextStyle(null, null, null, 16),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(S.of(context).general_ok),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
