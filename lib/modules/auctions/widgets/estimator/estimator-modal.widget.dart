import 'package:enginizer_flutter/modules/auctions/models/estimator/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/providers/work-estimates.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'estimator-issue-details.widget.dart';

class EstimatorModal extends StatefulWidget {
  final EstimatorMode mode;
  final bool isContainer;
  final bool isLoading;

  final Function addIssueItem;
  final Function removeIssueItem;

  EstimatorModal(
      {this.mode = EstimatorMode.Readonly,
      this.isContainer = false,
      this.isLoading = false,
      this.addIssueItem,
      this.removeIssueItem});

  @override
  _EstimatorModalState createState() => _EstimatorModalState();
}

class _EstimatorModalState extends State<EstimatorModal> {
  int _currentStepIndex = 0;
  List<Step> steps = [];

  WorkEstimatesProvider workEstimatesProvider;

  @override
  Widget build(BuildContext context) {
    workEstimatesProvider = Provider.of<WorkEstimatesProvider>(context);

    steps = _buildSteps(context);

    return FractionallySizedBox(
      heightFactor: .8,
      child: Container(
        child: _buildStepper(context),
      ),
    );
  }

  Widget _buildStepper(BuildContext context) => ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0),
            ),
          ),
          child: Theme(
            data: ThemeData(
              accentColor: Theme.of(context).primaryColor,
              primaryColor: Theme.of(context).primaryColor,
            ),
            child: steps.isNotEmpty
                ? Stepper(
                    currentStep: _currentStepIndex,
                    onStepTapped: (stepIndex) => _showIssue(stepIndex),
                    type: StepperType.vertical,
                    steps: steps,
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return Row(
                        children: <Widget>[
                          Container(
                            child: null,
                          ),
                          Container(
                            child: null,
                          ),
                        ],
                      );
                    },
                  )
                : Container(),
          ),
        ),
      );

  List<Step> _buildSteps(BuildContext context) {
    List<Step> stepsList = [];
    List<Issue> issues = workEstimatesProvider?.workEstimateDetails?.issues ?? [];
    issues.asMap().forEach((index, issue) {
      stepsList.add(
        Step(
          isActive: _isStepActive(index),
          title: Text((issue.name?.isNotEmpty ?? false) ? issue.name : 'N/A'),
          content: EstimatorIssueDetails(
            issue: issue,
            addIssueItem: _addIssueItem,
            removeIssueItem: _removeIssueItem,
          ),
        ),
      );
    });
    return stepsList;
  }

  void _addIssueItem(Issue issue) {
    debugPrint(workEstimatesProvider.estimatorFormState.toString());
    var issueItem = IssueItem(
      typeId: workEstimatesProvider.estimatorFormState['type'].id,
      code: workEstimatesProvider.estimatorFormState['code'].code,
      name: workEstimatesProvider.estimatorFormState['name'].name,
      quantity: workEstimatesProvider.estimatorFormState['quantity'],
      price: workEstimatesProvider.estimatorFormState['price'],
      priceVAT: workEstimatesProvider.estimatorFormState['priceVAT'],
    );
//    widget.addIssueItem(issue, issueItem);
  }

  void _removeIssueItem(Issue issue, int issueItemId) {
//    widget.removeIssueItem(issue, issueItemId);
  }

  _showIssue(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
  }
}
