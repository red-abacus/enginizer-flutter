import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleSelectDialogItem<V> {
  const SingleSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class SingleSelectDialog<V> extends StatefulWidget {
  SingleSelectDialog({Key key, this.items, this.initialSelectedValue, this.title}) : super(key: key);

  final List<SingleSelectDialogItem<V>> items;
  final V initialSelectedValue;
  final String title;

  @override
  State<StatefulWidget> createState() => _SingleSelectDialogState<V>();
}

class _SingleSelectDialogState<V> extends State<SingleSelectDialog<V>> {
  V _selectedValue;

  void initState() {
    super.initState();
    if (widget.initialSelectedValue != null) {
      _selectedValue = widget.initialSelectedValue;
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      _selectedValue = itemValue;
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(S.of(context).general_cancel),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text(S.of(context).general_ok),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(SingleSelectDialogItem<V> item) {
    final checked = _selectedValue == item.value;
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}