import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/parts/providers/parts.provider.dart';
import 'package:app/modules/parts/screens/part.dart';
import 'package:app/modules/parts/widgets/create/part-create.modal.dart';
import 'package:app/modules/parts/widgets/parts-list.dart';
import 'package:app/presentation/custom_icons.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Parts extends StatefulWidget {
  static const String route = '/parts';
  static final IconData icon = Custom.car;

  @override
  State<StatefulWidget> createState() {
    return PartsState(route: route);
  }
}

class PartsState extends State<Parts> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  PartsProvider _provider;

  PartsState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<PartsProvider>(
      builder: (context, partsProvider, _) =>
          Scaffold(
            body: Center(
              child: _renderParts(),
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 1,
              onPressed: () => {_createPart()},
              child: Icon(Icons.add),
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

      _provider = Provider.of<PartsProvider>(context);
      _provider.initialise();
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      int providerId = Provider
          .of<Auth>(context)
          .authUser
          .providerId;
      await _provider.loadProviderItems(providerId).then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S
            .of(context)
            .general_error,
            S
                .of(context)
                .exception_get_provider_items, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _renderParts() {
    return _isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : PartsList(
        parts: _provider.parts,
        filterParts: _filterParts,
        selectPart: _selectPart,
        nameString: _provider.issueItemQuery.name,
        codeString: _provider.issueItemQuery.code);
  }

  _filterParts(String nameString, String codeString) {
    _provider.issueItemQuery.name = nameString;
    _provider.issueItemQuery.code = codeString;
    _loadData();
  }

  _selectPart(ProviderItem providerItem) {
    _provider.selectedPart = providerItem;
    Navigator.of(context).pushNamed(Part.route);
  }

  _createPart() {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return PartCreateModal();
              });
        });
  }

  _refreshState() {
    _initDone = false;
    _loadData();
  }
}
