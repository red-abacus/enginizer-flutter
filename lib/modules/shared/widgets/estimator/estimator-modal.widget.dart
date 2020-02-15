import 'package:enginizer_flutter/modules/shared/widgets/estimator/models/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/shared/widgets/estimator/models/issue-item.model.dart';
import 'package:enginizer_flutter/modules/shared/widgets/estimator/models/issue.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'estimator-issue-details.widget.dart';

class EstimatorModal extends StatefulWidget {
  final List<Issue> issues;
  final EstimatorMode mode;
  final bool isContainer;
  final bool isLoading;

  final Function issuesChange;
  final Function issueChange;

  EstimatorModal(
      {this.issues = const [],
      this.mode = EstimatorMode.Edit,
      this.isContainer = false,
      this.isLoading = false,
      this.issuesChange,
      this.issueChange});

  @override
  _EstimatorModalState createState() => _EstimatorModalState();
}

class _EstimatorModalState extends State<EstimatorModal> {
  int _currentStepIndex = 0;
  List<Step> steps = [];

  @override
  Widget build(BuildContext context) {
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
            child: Stepper(
              currentStep: _currentStepIndex,
              onStepTapped: (stepIndex) => _showIssue(stepIndex),
              type: StepperType.vertical,
              steps: steps,
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
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
            ),
          ),
        ),
      );

  List<Step> _buildSteps(BuildContext context) {
    List<Step> stepsList = [];
    List<Issue> issues = widget.issues;
    issues.asMap().forEach((index, issue) {
      stepsList.add(
        Step(
          isActive: _isStepActive(index),
          title: Text(issue.description),
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

  void _addIssueItem(Issue issue, IssueItem issueItem) {}

  void _removeIssueItem(Issue issue, int issueItemIndex) {}

  _showIssue(int stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  bool _isStepActive(int stepIndex) {
    return _currentStepIndex == stepIndex;
  }
}
