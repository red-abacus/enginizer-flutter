import 'package:app/generated/l10n.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';

class UserDetailsIndexConsultantWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              S.of(context).user_profile_index_time,
              style: TextHelper.customTextStyle(
                  color: gray3, size: 24),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                '80%',
                style: TextHelper.customTextStyle(
                    color: gray3, weight: FontWeight.bold, size: 40),
              ),
            )
          ],
        ),
      ),
    );
//    return Align(
//      alignment: Alignment.center,
//      child: Container(
//        color: red,
//        child: ,
//      ),
//    );
  }
}
