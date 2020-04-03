import 'package:app/modules/authentication/widgets/auth-form.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  static const route = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Function authFailedHandler;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.9),
                  Theme.of(context).primaryColor.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          bottom: 20, top: deviceSize.height * .15),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      child: SvgPicture.asset(
                          'assets/icons/autowasslogo_white.svg',
                          color: Colors.white,
                          semanticsLabel: 'Autowass logo')),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthForm(
                        authFailedHandler: _handleAuthenticationFailure),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _handleAuthenticationFailure(String message) {
    SnackBar snackBar = new SnackBar(
      content: new Text(message),
      action: SnackBarAction(
        label: 'Eroare!',
        onPressed: () {},
      ),
    );

    this.scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
