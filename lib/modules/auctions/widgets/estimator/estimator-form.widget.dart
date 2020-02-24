import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/item-type.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/providers/auction-provider.dart';
import 'package:enginizer_flutter/modules/auctions/providers/work-estimates.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EstimatorForm extends StatefulWidget {
  EstimatorForm({Key key}) : super(key: key);

  @override
  EstimatorFormState createState() => EstimatorFormState();
}

class EstimatorFormState extends State<EstimatorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var auctionProvider = Provider.of<AuctionProvider>(context);
    var providerServiceProvider = Provider.of<ProviderServiceProvider>(context);
    var workEstimatesProvider = Provider.of<WorkEstimatesProvider>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // TYPE
                Flexible(
                  child: DropdownButtonFormField(
                    isDense: true,
                    isExpanded: true,
                    decoration: InputDecoration(
                        labelText: S.of(context).estimator_form_type),
                    items: _buildTypeDropdownItems(providerServiceProvider.itemTypes),
                    value: workEstimatesProvider.estimatorFormState['type'],
                    validator: (value) {
                      if (value == null) {
                        return S.of(context).estimator_form_error_typeNotSelected;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedType) {
                      providerServiceProvider.loadProviderItems(auctionProvider?.selectedBid?.serviceProvider,
                          IssueItemQuery(typeId: selectedType.id))
                          .then((_) => {
                        setState(() {
                          workEstimatesProvider.estimatorFormState['type'] = selectedType;
                          workEstimatesProvider.estimatorFormState['code'] = null;
                          workEstimatesProvider.estimatorFormState['name'] = null;
                          workEstimatesProvider.estimatorFormState['price'] = '';
                          workEstimatesProvider.estimatorFormState['priceVAT'] = '';
                        })
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                // CODE
                Flexible(
                  child: DropdownButtonFormField(
                      isDense: true,
                      isExpanded: true,
                      decoration: InputDecoration(
                          labelText: S.of(context).estimator_form_code),
                      items: workEstimatesProvider.estimatorFormState['type'] != null
                          ? _buildCodeDropdownItems(providerServiceProvider.providerItems)
                          : [],
                      value: workEstimatesProvider.estimatorFormState['code'],
                      validator: (value) {
                        if (value == null) {
                          return S
                              .of(context)
                              .estimator_form_error_codeNotSelected;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (selectedProviderItem) {
                        providerServiceProvider
                            .loadProviderItems(auctionProvider?.selectedBid?.serviceProvider,
                            IssueItemQuery(
                                typeId: selectedProviderItem.itemType.id,
                                code: selectedProviderItem.code))
                            .then((providerItems) => {
                          setState(() {
                            var foundProviderItem = providerItems.firstWhere((provider) => provider.id == selectedProviderItem.id, orElse: () => null);
                            workEstimatesProvider.estimatorFormState['code'] = foundProviderItem;
                            workEstimatesProvider.estimatorFormState['name'] = foundProviderItem;
                            workEstimatesProvider.estimatorFormState['quantity'] = 1;
                            workEstimatesProvider.estimatorFormState['price'] = foundProviderItem.price;
                            workEstimatesProvider.estimatorFormState['priceVAT'] = foundProviderItem.priceVAT;
                          })
                        });
                      }),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                // NAME
                Flexible(
                  child: DropdownButtonFormField(
                      isDense: true,
                      isExpanded: true,
                      decoration: InputDecoration(
                          labelText: S.of(context).estimator_form_name),
                      items: workEstimatesProvider.estimatorFormState['type'] != null
                          ? _buildNameDropdownItems(providerServiceProvider.providerItems)
                          : [],
                      value: workEstimatesProvider.estimatorFormState['name'],
                      validator: (value) {
                        if (value == null) {
                          return S
                              .of(context)
                              .estimator_form_error_nameNotSelected;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (selectedProviderItem) {
                        providerServiceProvider
                            .loadProviderItems(auctionProvider?.selectedBid?.serviceProvider,
                            IssueItemQuery(
                                typeId: selectedProviderItem.itemType.id,
                                code: selectedProviderItem.code,
                                name: selectedProviderItem.name))
                            .then((providerItems) => {
                          setState(() {
                            var foundProviderItem = providerItems.firstWhere((provider) => provider.id == selectedProviderItem.id, orElse: () => null);
                            workEstimatesProvider.estimatorFormState['code'] = foundProviderItem;
                            workEstimatesProvider.estimatorFormState['name'] = foundProviderItem;
                            workEstimatesProvider.estimatorFormState['quantity'] = 1;
                            workEstimatesProvider.estimatorFormState['price'] = foundProviderItem.price;
                            workEstimatesProvider.estimatorFormState['priceVAT'] = foundProviderItem.priceVAT;
                          })
                        });
                      }),
                ),
                SizedBox(width: 10),
                // QUANTITY
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: S.of(context).estimator_form_quantity,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.5)),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                        text: workEstimatesProvider
                            .estimatorFormState['quantity']
                            .toString()),
                    onChanged: (newQuantity) {
                      workEstimatesProvider.estimatorFormState['quantity'] =
                          int.parse(newQuantity);
                    },
                    validator: (value) {
                      if (value == null) {
                        return S
                            .of(context)
                            .estimator_form_error_quantityIsEmpty;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                // PRICE
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: S.of(context).estimator_form_price,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.5)),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                        text: workEstimatesProvider
                            .estimatorFormState['price']
                            .toString()),
                    onChanged: (newPrice) {
                      workEstimatesProvider.estimatorFormState['price'] =
                          double.parse(newPrice);
                    },
                    validator: (value) {
                      if (value == null) {
                        return S
                            .of(context)
                            .estimator_form_error_priceIsEmpty;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(width: 10),
                // PRICE VAT
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: S.of(context).estimator_form_priceVAT,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.5)),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(
                        text: workEstimatesProvider
                            .estimatorFormState['priceVAT']
                            .toString()),
                    onChanged: (newPriceVAT) {
                      workEstimatesProvider.estimatorFormState['priceVAT'] =
                          double.parse(newPriceVAT);
                    },
                    validator: (value) {
                      if (value == null) {
                        return S
                            .of(context)
                            .estimator_form_error_priceVATIsEmpty;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<ItemType>> _buildTypeDropdownItems(
      List<ItemType> types) {
    List<DropdownMenuItem<ItemType>> typeDropdownList = [];
    types.forEach((type) => typeDropdownList
        .add(DropdownMenuItem(value: type, child: Text(type.name, overflow: TextOverflow.ellipsis))));
    return typeDropdownList;
  }

  List<DropdownMenuItem<ProviderItem>> _buildCodeDropdownItems(
      List<ProviderItem> providerItems) {
    List<DropdownMenuItem<ProviderItem>> codeDropdownList = [];
    providerItems.forEach((providerItem) => codeDropdownList.add(
        DropdownMenuItem(value: providerItem, child: Text(providerItem.code, overflow: TextOverflow.ellipsis))));
    return codeDropdownList;
  }

  List<DropdownMenuItem<ProviderItem>> _buildNameDropdownItems(
      List<ProviderItem> providerItems) {
    List<DropdownMenuItem<ProviderItem>> nameDropdownList = [];
    providerItems.forEach((providerItem) => nameDropdownList.add(
        DropdownMenuItem(value: providerItem, child: Text(providerItem.name, overflow: TextOverflow.ellipsis))));
    return nameDropdownList;
  }

  valid() {
    return _formKey.currentState.validate();
  }
}
