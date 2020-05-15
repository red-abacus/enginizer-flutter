import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/multi-select-dialog.widget.dart';
import 'package:app/modules/shared/widgets/single-select-dialog.widget.dart';
import 'package:app/modules/shop/enums/shop-category-sort.enum.dart';
import 'package:app/modules/shop/enums/shop-category-type.enum.dart';
import 'package:app/modules/shop/enums/shop-list-type.enum.dart';
import 'package:app/modules/shop/models/shop-category.model.dart';
import 'package:app/modules/shop/widgets/cards/shop-item-grid.card.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'cards/shop-item.card.dart';

class ShopListWidget extends StatelessWidget {
  final Function filterShopItems;
  final Function selectCategoryType;
  final Function selectShopItem;
  final Function selectListType;
  final ShopCategorySort searchCategorySort;
  final ShopListType shopListType;

  String searchString;
  List<ShopCategory> searchShopCategories;
  List<ShopCategory> categories;
  ShopCategoryType shopCategoryType;

  ShopListWidget(
      {this.searchShopCategories,
      this.searchString,
      this.filterShopItems,
      this.categories,
      this.searchCategorySort,
      this.shopCategoryType,
      this.selectCategoryType,
      this.selectShopItem,
      this.shopListType,
      this.selectListType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildSearchWidget(context),
              _buildFilterWidget(context),
              _buildListingWidget(context),
              _buildTabBar(context),
              _buildList(context)
//            _buildList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget(BuildContext context) {
    return Container(
      child: TextField(
        key: Key('searchBar'),
        autofocus: false,
        decoration: InputDecoration(
            labelText: S.of(context).online_shop_search_title,
            suffixIcon: Icon(Icons.search)),
        onChanged: (val) {
          this.filterShopItems(val, this.searchShopCategories);
        },
      ),
    );
  }

  _showCategoryPicker(BuildContext context) async {
    List<MultiSelectDialogItem<ShopCategory>> items = [];

    this.categories.forEach((category) {
      items.add(MultiSelectDialogItem(category, category.name));
    });

    Set<ShopCategory> categories = await showDialog<Set<ShopCategory>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: searchShopCategories.toSet(),
          title: S.of(context).online_shop_search_category_select_title,
        );
      },
    );

    this.filterShopItems(
        this.searchString, categories.toList(), searchCategorySort);
  }

  _showOrderPicker(BuildContext context) async {
    List<SingleSelectDialogItem<ShopCategorySort>> items = [];

    ShopCategorySortUtils.getList().forEach((sort) {
      items.add(SingleSelectDialogItem(
          sort, ShopCategorySortUtils.title(context, sort)));
    });

    ShopCategorySort selectedSort = await showDialog<ShopCategorySort>(
      context: context,
      builder: (BuildContext context) {
        return SingleSelectDialog(
          items: items,
          initialSelectedValue: searchCategorySort,
          title: S.of(context).online_shop_search_sort_select_title,
        );
      },
    );

    this.filterShopItems(
        this.searchString, this.searchShopCategories, selectedSort);
  }

  Widget _buildFilterWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 0.5, color: gray),
                ),
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_categoryText(context)],
                ),
              ),
              onTap: () => _showCategoryPicker(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 0.5, color: gray),
                ),
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_orderText(context)],
                ),
              ),
              onTap: () => _showOrderPicker(context),
            ),
          ),
        ],
      ),
    );
  }

  _buildListingWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      height: 40,
      child: Row(
        children: <Widget>[
          Text(
            '${S.of(context).online_shop_list_title}:',
            style: TextHelper.customTextStyle(null, gray3, null, 16),
          ),
          FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Icon(
              shopListType == ShopListType.List
                  ? Icons.grid_off
                  : Icons.grid_on,
              color: red,
            ),
            onPressed: () {
              selectListType(shopListType == ShopListType.List
                  ? ShopListType.Grid
                  : ShopListType.List);
            },
          ),
        ],
      ),
    );
  }

  _categoryText(BuildContext context) {
    String title = (this.searchShopCategories.isEmpty)
        ? S.of(context).online_shop_search_category_title
        : _titleFromCategories(this.searchShopCategories);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/images/icons/filter.svg'.toLowerCase(),
            color: red,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextHelper.customTextStyle(null, gray3, null, 16),
            ),
          ),
        )
      ],
    );
  }

  _orderText(BuildContext context) {
    String title = (this.searchCategorySort == null)
        ? S.of(context).online_shop_search_sort_title
        : ShopCategorySortUtils.title(context, searchCategorySort);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: 20,
          height: 20,
          child: Icon(
            Icons.filter_list,
            color: red,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextHelper.customTextStyle(null, gray3, null, 16),
            ),
          ),
        )
      ],
    );
  }

  _titleFromCategories(List<ShopCategory> categories) {
    String title = '';

    categories.forEach((category) {
      title = title.isEmpty ? category.name : '$title, ${category.name}';
    });

    return title;
  }

  _buildTabBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 40,
      child: new Row(
        children: <Widget>[
          _buildTabBarButton(context, ShopCategoryType.SERVICES),
          _buildTabBarButton(context, ShopCategoryType.PRODUCTS)
        ],
      ),
    );
  }

  _buildTabBarButton(BuildContext context, ShopCategoryType state) {
    Color bottomColor = (shopCategoryType == state) ? red : gray_80;

    return Expanded(
      flex: 1,
      child: Container(
          child: Center(
            child: FlatButton(
              child: Text(
                ShopCategoryTypeUtils.title(context, state),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              onPressed: () {
                selectCategoryType(state);
              },
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1.0, color: bottomColor),
          ))),
    );
  }

  Widget _buildList(BuildContext context) {
    int gridCount = MediaQuery.of(context).size.width.toDouble() ~/ 150.0;
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: shopListType == ShopListType.List
          ? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return ShopItemCard(
                    index: index, selectShopItem: selectShopItem);
              },
              itemCount: 10,
            )
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ShopItemGrid(
                    index: index, selectShopItem: selectShopItem);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCount,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.5,
              ),
            ),
    );
  }
}
