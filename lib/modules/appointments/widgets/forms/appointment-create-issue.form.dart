import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/shared/widgets/alert-info.widget.dart';
import 'package:app/modules/shared/widgets/issues/issues-list.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentCreateIssueForm extends StatefulWidget {
  AppointmentCreateIssueForm({Key key}) : super(key: key);

  @override
  AppointmentCreateIssueFormState createState() {
    return AppointmentCreateIssueFormState();
  }
}

class AppointmentCreateIssueFormState
    extends State<AppointmentCreateIssueForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var providerServiceProvider = Provider.of<ProviderServiceProvider>(context);
    var issues = providerServiceProvider.issuesFormState;

    return Container(
      padding: EdgeInsets.only(bottom: 60),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AlertInfoWidget(S.of(context).appointment_create_step2_alert),
            IssuesListWidget(
              issues: issues,
              removeIssue: _removeAt,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: _addIssue,
                child: Icon(Icons.add),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool valid() {
    return _formKey.currentState.validate();
  }

  _addIssue() {
    setState(() {
      Provider.of<ProviderServiceProvider>(context)
          .issuesFormState
          .add(Issue(name: ''));
    });
  }

  _removeAt(int index) {
    setState(() {
      Provider.of<ProviderServiceProvider>(context)
          .issuesFormState
          .removeAt(index);
    });
  }
}
