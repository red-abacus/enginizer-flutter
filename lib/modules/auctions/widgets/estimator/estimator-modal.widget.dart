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
      {this.mode = EstimatorMode.ReadOnly,
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

  bool _isLoading = false;
  bool _initDone = false;

  WorkEstimatesProvider workEstimatesProvider;

  @override
  Widget build(BuildContext context) {
    workEstimatesProvider = Provider.of<WorkEstimatesProvider>(context);

    return Consumer<WorkEstimatesProvider>(
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

      WorkEstimatesProvider provider =
          Provider.of<WorkEstimatesProvider>(context);
      provider.getWorkEstimateDetails(provider.workEstimateId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _initDone = true;

    super.didChangeDependencies();
  }

  _buildContent(BuildContext context) {
    steps = _buildSteps(context);

    return Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildStepper(context));
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
                  currentStep: _currentStepIndex,
                  onStepTapped: (stepIndex) => _showIssue(stepIndex),
                  type: StepperType.horizontal,
                  steps: steps,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
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
      );

  List<Step> _buildSteps(BuildContext context) {
    List<Step> stepsList = [];
    List<Issue> issues =
        workEstimatesProvider?.workEstimateDetails?.issues ?? [];

    issues.asMap().forEach((index, issue) {
      stepsList.add(
        Step(
          isActive: _isStepActive(index),
          title: Text((issue.name?.isNotEmpty ?? false) ? issue.name : 'N/A'),
          content: EstimatorIssueDetails(
            mode: widget.mode,
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
    Issue estimateIssueRequest =
        workEstimatesProvider.estimateIssueRequest(issue);
    widget.addIssueItem(estimateIssueRequest);
  }

  void _removeIssueItem(Issue issue, IssueItem issueItem) {
    widget.removeIssueItem(issue, issueItem);
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
