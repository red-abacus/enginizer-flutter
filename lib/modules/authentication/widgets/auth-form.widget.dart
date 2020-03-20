import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/authentication/models/http_exception.dart';
import 'package:enginizer_flutter/modules/authentication/models/user-type.model.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/utils/app_config.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login, ForgotPassword }

class AuthForm extends StatefulWidget {
  final Function authFailedHandler;

  const AuthForm({Key key, this.authFailedHandler}) : super(key: key);

  @override
  _AuthFormState createState() =>
      _AuthFormState(authFailedHandler: authFailedHandler);
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final double loginCardHeight = 350;
  double registerCardHeight(BuildContext context) {
    return AppConfig.of(context).enviroment == Enviroment.Dev ? 480 : 420;
}
  final double forgotPasswordCardHeight = 260;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _nameFieldFocus = FocusNode();
  final FocusNode _emailFieldFocus = FocusNode();

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
    'confirmPassword': '',
    'userType': UserType.Client,
  };
  var _isLoading = false;
  var _userTypeSwitch = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityShowAnimation;
  Animation<double> _opacityHideAnimation;
  Animation<double> _nullAnimation;
  Function authFailedHandler;

  _AuthFormState({this.authFailedHandler});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityShowAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _opacityHideAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _nullAnimation = Tween(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _getCardHeight(),
        // height: _heightAnimation.value.height,
        constraints: BoxConstraints(minHeight: _getCardHeight()),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _logoContainer(),
                _nameContainer(),
                _emailContainer(),
                _passwordContainer(),
                _confirmPasswordContainer(),
                _forgotPasswordContainer(),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text(_redButtonTitle()),
                      onPressed: () => _submit(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                Center(
                  child: FlatButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? S.of(context).auth_register.toUpperCase() : S.of(context).auth_login.toUpperCase()}'),
                    onPressed: () => {
                      if (_authMode == AuthMode.Login)
                        {_toggleRegisterMode()}
                      else if (_authMode == AuthMode.Signup)
                        {_toggleLoginMode()}
                      else if (_authMode == AuthMode.ForgotPassword)
                        {_toggleLoginMode()}
                    },
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _logoContainer() {
    return Container(
      height: 60,
      width: 60,
      child: SvgPicture.asset('assets/icons/autowasslogo_only.svg',
          color: Theme.of(context).accentColor,
          width: 60,
          height: 60,
          semanticsLabel: 'Autowass logo only'),
    );
  }

  _nameContainer() {
    return AnimatedContainer(
      constraints: BoxConstraints(
        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
        maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: FadeTransition(
        opacity: _opacityShowAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: TextFormField(
            focusNode: _nameFieldFocus,
            enabled: _authMode == AuthMode.Signup,
            decoration: InputDecoration(labelText: S.of(context).auth_name),
            obscureText: true,
            validator: _authMode == AuthMode.Signup
                ? (value) {
                    _authData['name'] = value;
                    if (value.isEmpty) {
                      return S.of(context).auth_error_nameRequired;
                    } else {
                      return null;
                    }
                  }
                : null,
          ),
        ),
      ),
    );
  }

  _emailContainer() {
    return TextFormField(
      decoration: InputDecoration(labelText: S.of(context).auth_email),
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFieldFocus,
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return S.of(context).auth_error_invalidEmail;
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _authData['email'] = value;
      },
    );
  }

  _passwordContainer() {
    Animation<double> animation = _nullAnimation;

    if (_authMode == AuthMode.ForgotPassword) {
      animation = _opacityHideAnimation;
    }

    double maxHeight = AppConfig.of(context).enviroment == Enviroment.Dev ? 125 : 60;

    return AnimatedContainer(
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.ForgotPassword ? 0 : 60,
          maxHeight: _authMode == AuthMode.ForgotPassword ? 0 : maxHeight,
        ),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: FadeTransition(
          opacity: animation,
          child: TextFormField(
            decoration: InputDecoration(labelText: S.of(context).auth_password),
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if ((value.isEmpty || value.length < 5) &&
                  _authMode != AuthMode.ForgotPassword) {
                return S.of(context).auth_error_passwordTooShort;
              } else {
                return null;
              }
            },
            onSaved: (value) {
              _authData['password'] = value;
            },
          ),
        ));
  }

  _confirmPasswordContainer() {
    double maxHeight = AppConfig.of(context).enviroment == Enviroment.Dev ? 125 : 60;
    return AnimatedContainer(
      constraints: BoxConstraints(
        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
        maxHeight: _authMode == AuthMode.Signup ? maxHeight : 0,
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: FadeTransition(
        opacity: _opacityShowAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              TextFormField(
                enabled: _authMode == AuthMode.Signup,
                decoration: InputDecoration(
                    labelText: S.of(context).auth_passwordConfirmation),
                obscureText: true,
                validator: _authMode == AuthMode.Signup
                    ? (value) {
                        _authData['confirmPassword'] = _passwordController.text;
                        if (value != _passwordController.text) {
                          return S.of(context).auth_error_passwordMismatch;
                        } else {
                          return null;
                        }
                      }
                    : null,
              ),
              _userTypeContainer(),
            ],
          ),
        ),
      ),
    );
  }

  _forgotPasswordContainer() {
    return Align(
        alignment: Alignment.centerRight,
        child: Visibility(
          visible: _authMode == AuthMode.Login,
          child: FlatButton(
            child: Text(
              S.of(context).auth_forgot_password,
              style: TextHelper.customTextStyle(
                  null, gray2, FontWeight.normal, 14),
            ),
            onPressed: () {
              _toggleForgotPasswordMode();
            },
          ),
        ));
  }

  _userTypeContainer() {
    return AppConfig.of(context).enviroment == Enviroment.Dev
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(S.of(context).auth_register_client,
                    style: Theme.of(context).textTheme.body1),
              ),
              Switch(
                  inactiveThumbColor: Theme.of(context).accentColor,
                  inactiveTrackColor: Theme.of(context).primaryColor,
                  activeTrackColor: Theme.of(context).primaryColor,
                  value: _userTypeSwitch,
                  onChanged: (value) => _toggleSwitch(value)),
              Expanded(
                child: Text(
                  S.of(context).auth_register_provider,
                  style: Theme.of(context).textTheme.body1,
                ),
              )
            ],
          )
        : Container();
  }

  double _getCardHeight() {
    switch (_authMode) {
      case AuthMode.Login:
        return loginCardHeight;
      case AuthMode.Signup:
        return registerCardHeight(context);
        break;
      case AuthMode.ForgotPassword:
        return forgotPasswordCardHeight;
    }

    return 0.0;
  }

  String _redButtonTitle() {
    switch (_authMode) {
      case AuthMode.Signup:
        return S.of(context).auth_register.toUpperCase();
      case AuthMode.Login:
        return S.of(context).auth_login.toUpperCase();
      case AuthMode.ForgotPassword:
        return S.of(context).auth_forgot_password_title.toUpperCase();
    }

    return '';
  }

  void _showErrorDialog(String message) {
    this.authFailedHandler(message);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else if (_authMode == AuthMode.Signup) {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['name'],
          _authData['email'],
          _authData['password'],
          _authData['confirmPassword'],
          _authData['userType'],
        );
      } else if (_authMode == AuthMode.ForgotPassword) {
        await Provider.of<Auth>(context).forgotPassword(_authData['email']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      } else if (error.toString().contains('INVALID_CREDENTIALS')) {
        errorMessage = 'Credențiale invalide';
      } else if (error.toString().contains("USER_NOT_FOUND")) {
        errorMessage = S.of(context).auth_forgot_password_user_not_find;
      } else if (error.toString().contains("PROBLEM_SENDING_EMAIL")) {
        errorMessage = S.of(context).auth_forgot_password_user_email_error;
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // TODO Handle focus on form change
  _toggleLoginMode() {
    setState(() {
      _authMode = AuthMode.Login;
      _formKey.currentState.reset();
      _emailFieldFocus.unfocus();
    });
    _controller.reverse();
  }

  _toggleRegisterMode() {
    setState(() {
      _authMode = AuthMode.Signup;
      _formKey.currentState.reset();
      _emailFieldFocus.unfocus();
    });
    _controller.forward();
  }

  _toggleForgotPasswordMode() {
    setState(() {
      _authMode = AuthMode.ForgotPassword;
      _formKey.currentState.reset();
      _emailFieldFocus.unfocus();
    });
    _controller.forward();
  }

  _toggleSwitch(value) {
    if (value == true) {
      _authData['userType'] = UserType.Provider;
    } else {
      _authData['userType'] = UserType.Client;
    }

    setState(() {
      _userTypeSwitch = value;
    });
  }
}
