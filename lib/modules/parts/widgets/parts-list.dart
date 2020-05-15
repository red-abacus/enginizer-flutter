import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cards/part.card.dart';

class PartsList extends StatelessWidget {
  final List<ProviderItem> parts;

  Function filterParts;
  Function selectPart;

  String nameString;
  String codeString;

  PartsList({this.parts,
    this.filterParts,
    this.selectPart,
    this.nameString,
    this.codeString});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSearchWidget(context),
            _buildList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            child: CustomTextFormField(
              currentValue: nameString != null ? nameString : '',
              labelText: S
                  .of(context)
                  .parts_search_name_title,
              listener: (value) {
                this.filterParts(value, '');
              },
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10),
            child: CustomTextFormField(
              currentValue: codeString != null ? codeString : '',
              labelText: S
                  .of(context)
                  .parts_search_code_title,
              listener: (value) {
                this.filterParts('', value);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return PartCard(
              providerItem: parts[index],
              selectProviderItem: selectPart,
            );
          },
          itemCount: parts.length,
        ),
      ),
    );
  }
}
