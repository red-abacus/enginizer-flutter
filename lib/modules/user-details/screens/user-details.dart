import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) => Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _avatarContainer(),
            _detailsContainer(),
            _cardContainer(),
            _changePasswordContainer()
//            _nameContainer(),
//            _emailContainer(),
//            _saveButtonContainer(),
//            _currentPasswordContainer(),
//            _newPasswordContainer(),
//            _confirmPasswordContainer(),
//            _savePasswordButtonContainer(),
          ],
        ),
      ),
    );
  }

  _avatarContainer() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: red,
            height: 90,
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    child: CircleAvatar(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  userProvider.name,
                  style: TextHelper.customTextStyle(
                      null, gray3, FontWeight.bold, 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _detailsContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: <Widget>[
          _getEmailDetails(Icons.email, userProvider.email),
          _getEmailDetails(Icons.pin_drop,
              'Str. Memorandumului, nr. 7, bl. H, sc. 2, ap. 6, Cluj-Napoca'),
          _getEmailDetails(Icons.perm_identity, 'Persoana fizica'),
        ],
      ),
    );
  }

  _cardContainer() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${S.of(context).user_profile_payment_method}:',
            style: TextHelper.customTextStyle(null, gray3, FontWeight.bold, 15),
          ),
          _cardDetailsContainer(),
        ],
      ),
    );
  }

  _cardDetailsContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Material(
        elevation: 2,
        borderRadius: new BorderRadius.circular(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  width: 60,
                  height: 60,
                  child: SvgPicture.asset(
                    'assets/images/icons/visa.svg',
                    semanticsLabel: 'Visa Icon',
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Visa •••• 0033',
                          style: TextHelper.customTextStyle(
                              null, gray3, FontWeight.bold, 13),
                        ),
                        Text(
                          '${S.of(context).user_profile_expires_in} Ianuarie / 2022',
                          maxLines: 3,
                          style: TextHelper.customTextStyle(
                              null, gray3, FontWeight.bold, 13),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Opacity(
              opacity: 0.2,
              child: Container(
                height: 1,
                color: gray3,
              ),
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        S.of(context).user_profile_add_new_card,
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 13),
                      ),
                      onPressed: () {},
                    ),
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        S.of(context).general_delete,
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 13),
                      ),
                      onPressed: () {},
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  _getEmailDetails(dynamic icon, String title) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: gray3,
            size: 24.0,
            semanticLabel: 'Selected car check',
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 30),
              child: Text(
                title,
                style: TextHelper.customTextStyle(
                    null, gray3, FontWeight.bold, 15),
              ),
            ),
          )
        ],
      ),
    );
  }

  _changePasswordContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Align(
        alignment: Alignment.center,
        child: FlatButton(
          child: Text(
            S.of(context).user_profile_change_password,
            style: TextHelper.customTextStyle(
                null, Colors.blue, FontWeight.bold, 16),
          ),
          onPressed: () {},
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
            Expanded(
              flex: 4,
              child: Container(
                child: Text(
                  '${S.of(context).user_profile_current_password} : ',
                  style: TextHelper.customTextStyle(
                      null, gray2, FontWeight.normal, 16),
                ),
              ),
            ),
            Expanded(
                flex: 6,
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
            Expanded(
              flex: 4,
              child: Container(
                child: Text(
                  '${S.of(context).user_profile_new_password} : ',
                  style: TextHelper.customTextStyle(
                      null, gray2, FontWeight.normal, 16),
                ),
              ),
            ),
            Expanded(
                flex: 6,
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
            Expanded(
              flex: 4,
              child: Container(
                child: Text(
                  '${S.of(context).user_profile_confirm_password} : ',
                  style: TextHelper.customTextStyle(
                      null, gray2, FontWeight.normal, 16),
                ),
              ),
            ),
            Expanded(
                flex: 6,
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
    userProvider
        .updateUserDetails(userProvider.email, userProvider.name)
        .then((_) {});
  }
}
