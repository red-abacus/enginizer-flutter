import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/authentication/providers/user.provider.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  static const String route = '/user-details';

  String title;

  @override
  State<StatefulWidget> createState() {
    return UserDetailsState();
  }
}

class UserDetailsState extends State<UserDetails> {
  var _initDone = false;
  var _isLoading = false;

  UserProvider userProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
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
      userProvider = Provider.of<UserProvider>(context);

      setState(() {
        _isLoading = true;
      });

      Provider.of<UserProvider>(context).initialiseParams();
      Provider.of<UserProvider>(context).getUserDetails().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _userDetailsContainer() {
    return Form(
      child: SingleChildScrollView(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _avatarContainer(),
            _nameContainer(),
            _emailContainer(),
            _saveButtonContainer(),
            _currentPasswordContainer(),
            _newPasswordContainer(),
            _confirmPasswordContainer(),
            _savePasswordButtonContainer(),
          ],
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
        child: CircleAvatar(),
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
                initialValue: userProvider.name,
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
                  userProvider.name = val;
                },
              ),
            ))
          ],
        ));
  }

  _emailContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).auth_email} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: userProvider.email,
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return S.of(context).auth_error_invalidEmail;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  userProvider.email = val;
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

  _currentPasswordContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_current_password} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                obscureText: true,
                initialValue: 'password',
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
              ),
            ))
          ],
        ));
  }

  _newPasswordContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_new_password} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                obscureText: true,
                initialValue: 'password',
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
              ),
            ))
          ],
        ));
  }

  _confirmPasswordContainer() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_profile_confirm_password} : ',
                style: TextHelper.customTextStyle(
                    null, gray2, FontWeight.normal, 16),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                obscureText: true,
                initialValue: 'password',
                style: TextHelper.customTextStyle(
                    null, black_text, FontWeight.bold, 16),
              ),
            ))
          ],
        ));
  }

  _savePasswordButtonContainer() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, top: 20),
        child: FlatButton(
          onPressed: () {},
          color: red,
          textColor: Colors.white,
          child: Text(S.of(context).user_profile_save_password),
        ),
      ),
    );
  }

  _saveDetails() {
    userProvider.updateUserDetails(userProvider.email, userProvider.name).then((_) {
    });
  }
}
