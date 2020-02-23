import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/scheduler.widget.dart';
import 'package:enginizer_flutter/modules/authentication/providers/user.provider.dart';
import 'package:enginizer_flutter/modules/consultant-user-details/provider/user-consultant.provider.dart';
import 'package:enginizer_flutter/modules/consultant-user-details/widgets/user-details-services-consultant.dart';
import 'package:enginizer_flutter/modules/consultant-user-details/widgets/user-details-timetable-consultant.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsConsultant extends StatefulWidget {
  static const String route = '/user-details-consultant';

  String title;

  @override
  State<StatefulWidget> createState() {
    return UserDetailsConsultantState();
  }
}

class UserDetailsConsultantState extends State<UserDetailsConsultant> {
  var _initDone = false;
  var _isLoading = false;

  UserConsultantProvider userConsultantProvider;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Consumer<UserConsultantProvider>(
      builder: (context, userProvider, _) => Scaffold(
        key: scaffoldKey,
        body: _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _userDetailsContainer(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {
        _isLoading = true;
      });

      userConsultantProvider = Provider.of<UserConsultantProvider>(context);
      userConsultantProvider.getUserDetails().then((_) {
        userConsultantProvider
            .getServiceProvider(
                userConsultantProvider.userDetails.userProvider.id)
            .then((_) {
          userConsultantProvider
              .getProviderServices(
                  userConsultantProvider.userDetails.userProvider.id)
              .then((_) {
            userConsultantProvider.initialiseParams();
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _userDetailsContainer() {
    return Form(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _avatarContainer(),
              _nameContainer(),
              _fiscalNameContainer(),
              _registrationNumberContainer(),
              _vtaPayerContainer(),
              _cuiContainer(),
              _saveButtonContainer(),
              UserDetailsTimetableConsultant(
                  schedules: userConsultantProvider
                      .serviceProvider.userProviderSchedules),
              UserDetailsServicesConsultant(
                  response: userConsultantProvider.serviceProviderItemsResponse),
            ],
          ),
        ),
      ),
    );
  }

  _avatarContainer() {
    return Center(
      child: Container(
        width: 140,
        height: 140,
        margin: EdgeInsets.only(top: 20),
        child: CircleAvatar(
          child: Image.network(
            '${userConsultantProvider.serviceProvider?.image}',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  _nameContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).auth_name} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.name,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).auth_error_nameRequired;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.name = val;
                },
              ),
            ))
          ],
        ));
  }

  _fiscalNameContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_fiscal_name} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.fiscalName,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).auth_error_nameRequired;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.fiscalName = val;
                },
              ),
            ))
          ],
        ));
  }

  _registrationNumberContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_registration_number} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.registrationNumber,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).user_profile_fiscal_name_error;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.fiscalName = val;
                },
              ),
            ))
          ],
        ));
  }

  _vtaPayerContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_vta_payer} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Container(
              width: 60,
              margin: EdgeInsets.only(left: 20),
              child: Switch(
                onChanged: (value) {
                  userConsultantProvider.vtaPayer = value;
                },
                value: userConsultantProvider.vtaPayer,
              ),
            )
          ],
        ));
  }

  _cuiContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_cui} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userConsultantProvider.cui,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).user_profile_cui_error;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userConsultantProvider.cui = val;
                },
              ),
            ))
          ],
        ));
  }

  _saveButtonContainer() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, top: 20),
        child: FlatButton(
          onPressed: () {
            _saveDetails();
          },
          color: red,
          textColor: Colors.white,
          child: Text(S.of(context).general_save_changes),
        ),
      ),
    );
  }

  _saveDetails() {}
}
