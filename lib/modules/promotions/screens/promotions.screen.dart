import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/promotions/enum/promotion-status.enum.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/modules/promotions/providers/promotions.provider.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:app/modules/promotions/widgets/promotions-list.widget.dart';
import 'package:app/modules/shop/enums/shop-category-type.enum.dart';
import 'package:app/presentation/custom_icons.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Promotions extends StatefulWidget {
  static const String route = '/promotions';
  static final IconData icon = Custom.discount;

  @override
  State<StatefulWidget> createState() {
    return PromotionsState(route: route);
  }
}

class PromotionsState extends State<Promotions> {
  String route;
  var _initDone = false;
  var _isLoading = false;

  PromotionsProvider _provider;

  PromotionsState({this.route});

  ShopCategoryType shopCategoryType = ShopCategoryType.SERVICES;

  @override
  Widget build(BuildContext context) {
    return Consumer<PromotionsProvider>(
      builder: (context, promotionsProvider, _) => Scaffold(
        body: Center(
          child: _renderList(_isLoading),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 1,
          onPressed: () => _openPromotionCreateModal(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<PromotionsProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _provider.initialise();
      _provider.promotionsRequest.providerId =
          Provider.of<Auth>(context).authUser.providerId;

      setState(() {
        _isLoading = true;
      });

      _loadData();
    }

    _initDone = true;
    _provider.initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.getPromotions().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(PromotionService.GET_PROMOTIONS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_promotions, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _renderList(bool _isLoading) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : PromotionsList(
            promotions: _provider.promotions,
            selectPromotion: _selectPromotion,
            filterPromotions: _filterPromotions,
            searchString: _provider.promotionsRequest.searchString,
            promotionStatus: _provider.promotionsRequest.status,
            downloadNextPage: _loadData,
            shouldDownload: _provider.shouldDownload());
  }

  _filterPromotions(String value, PromotionStatus status) {
    _provider.filterPromotions(
        _provider.promotionsRequest.providerId =
            Provider.of<Auth>(context).authUser.providerId,
        value,
        status);
    _loadData();
  }

  _selectPromotion(Promotion promotion) {}

  _openPromotionCreateModal() {
  }
}
