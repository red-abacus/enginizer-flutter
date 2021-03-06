import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateAddIssueModal extends StatefulWidget {
  final Function addIssueItem;
  final IssueRecommendation issueRecommendation;

  WorkEstimateAddIssueModal(
      {Key key, this.addIssueItem, this.issueRecommendation})
      : super(key: key);

  @override
  WorkEstimateAddIssueModalState createState() =>
      WorkEstimateAddIssueModalState();
}

class WorkEstimateAddIssueModalState extends State<WorkEstimateAddIssueModal> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Auth>(context);
    var provider = Provider.of<WorkEstimateProvider>(context);

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
      child: Form(
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
                      items: _buildTypeDropdownItems(provider.itemTypes),
                      value: provider.estimatorFormState['type'],
                      validator: (value) {
                        if (value == null) {
                          return S
                              .of(context)
                              .estimator_form_error_typeNotSelected;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (selectedType) async {
                        try {
                          await provider
                              .loadProviderItems(
                                  authProvider?.authUser?.providerId,
                                  IssueItemQuery(typeId: selectedType.id))
                              .then((_) => {
                                    setState(() {
                                      provider.estimatorFormState['type'] =
                                          selectedType;
                                      provider.estimatorFormState['code'] =
                                          null;
                                      provider.estimatorFormState['name'] =
                                          null;
                                      provider.estimatorFormState['price'] = '';
                                      provider.estimatorFormState['priceVAT'] =
                                          '';
                                    })
                                  });
                        } catch (error) {
                          if (error.toString().contains(
                              ProviderService.GET_PROVIDER_ITEMS_EXCEPTION)) {
                            FlushBarHelper.showFlushBar(
                                S.of(context).general_error,
                                S.of(context).exception_get_provider_items,
                                context);
                          }
                        }
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
                        items: provider.estimatorFormState['type'] != null
                            ? _buildCodeDropdownItems(provider.providerItems)
                            : [],
                        value: provider.estimatorFormState['code'],
                        validator: (value) {
                          if (value == null) {
                            return S
                                .of(context)
                                .estimator_form_error_codeNotSelected;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (selectedProviderItem) async {
                          try {
                            await provider
                                .loadProviderItems(
                                    authProvider?.authUser?.providerId,
                                    IssueItemQuery(
                                        typeId: provider
                                            .estimatorFormState['type'].id,
                                        code: selectedProviderItem))
                                .then((providerItems) => {
                                      setState(() {
                                        var foundProviderItem =
                                            providerItems.firstWhere(
                                                (provider) =>
                                                    provider.code ==
                                                    selectedProviderItem,
                                                orElse: () => null);
                                        provider.estimatorFormState['id'] =
                                            foundProviderItem;
                                        provider.estimatorFormState['code'] =
                                            foundProviderItem.code;
                                        provider.estimatorFormState['name'] =
                                            foundProviderItem.name;
                                        provider.estimatorFormState['price'] =
                                            '';
                                        provider.estimatorFormState[
                                            'priceVAT'] = '';
                                      })
                                    });
                          } catch (error) {
                            if (error.toString().contains(
                                ProviderService.GET_PROVIDER_ITEMS_EXCEPTION)) {
                              FlushBarHelper.showFlushBar(
                                  S.of(context).general_error,
                                  S.of(context).exception_get_provider_items,
                                  context);
                            }
                          }
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
                        items: provider.estimatorFormState['type'] != null
                            ? _buildNameDropdownItems(provider.providerItems)
                            : [],
                        value: provider.estimatorFormState['id']?.id,
                        validator: (value) {
                          if (value == null) {
                            return S
                                .of(context)
                                .estimator_form_error_nameNotSelected;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (selectedProviderItem) async {
                          try {
                            await provider
                                .loadProviderItems(
                                    authProvider?.authUser?.providerId,
                                    IssueItemQuery(
                                        typeId: provider
                                            .estimatorFormState['type'].id,
                                        code:
                                            provider.estimatorFormState['code'],
                                        name: provider
                                            .estimatorFormState['name']))
                                .then((providerItems) => {
                                      setState(() {
                                        var foundProviderItem =
                                            providerItems.firstWhere(
                                                (provider) =>
                                                    provider.id ==
                                                    selectedProviderItem,
                                                orElse: () => null);
                                        provider.estimatorFormState['id'] =
                                            foundProviderItem;
                                        provider.estimatorFormState['name'] =
                                            foundProviderItem.name;
                                        provider.estimatorFormState[
                                                'quantity'] =
                                            provider.defaultQuantity != null
                                                ? provider.defaultQuantity
                                                : 1.0;
                                        provider.estimatorFormState['price'] =
                                            foundProviderItem.price;
                                        provider.estimatorFormState[
                                                'priceVAT'] =
                                            foundProviderItem.priceVAT;
                                      })
                                    });
                          } catch (error) {
                            if (error.toString().contains(
                                ProviderService.GET_PROVIDER_ITEMS_EXCEPTION)) {
                              FlushBarHelper.showFlushBar(
                                  S.of(context).general_error,
                                  S.of(context).exception_get_provider_items,
                                  context);
                            }
                          }
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
                          text: provider.estimatorFormState['quantity']
                              .toString()),
                      onChanged: (newQuantity) {
                        provider.estimatorFormState['quantity'] =
                            double.parse(newQuantity);
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
                          text:
                              provider.estimatorFormState['price'].toString()),
                      onChanged: (newPrice) {
                        provider.estimatorFormState['price'] =
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
                          text: provider.estimatorFormState['priceVAT']
                              .toString()),
                      onChanged: (newPriceVAT) {
                        provider.estimatorFormState['priceVAT'] =
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
              if (provider.estimatorFormState['type'] != null &&
                  provider.estimatorFormState['type'].isProduct())
                Row(
                  children: <Widget>[
                    // PRICE
                    Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: '${S.of(context).general_addition} (%)',
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 14.5)),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                            text: provider.estimatorFormState['addition']
                                .toString()),
                        onChanged: (newPrice) {
                          provider.estimatorFormState['addition'] =
                              double.parse(newPrice);
                        },
                        validator: (value) {
                          if (value == null) {
                            return S.of(context).estimator_form_error_addition;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(vertical: 15),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () => {
                          if (valid())
                            {
                              Navigator.pop(context),
                              widget.addIssueItem(widget.issueRecommendation)
                            }
                        },
                    child: Icon(Icons.add)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<ItemType>> _buildTypeDropdownItems(
      List<ItemType> types) {
    List<DropdownMenuItem<ItemType>> typeDropdownList = [];
    types.forEach((type) => typeDropdownList.add(DropdownMenuItem(
        value: type, child: Text(type.name, overflow: TextOverflow.ellipsis))));
    return typeDropdownList;
  }

  List<DropdownMenuItem<String>> _buildCodeDropdownItems(
      List<ProviderItem> providerItems) {
    List<String> list = [];

    providerItems.forEach((element) {
      if (!list.contains(element.code)) {
        list.add(element.code);
      }
    });

    List<DropdownMenuItem<String>> codeDropdownList = [];
    list.forEach((providerItem) => codeDropdownList.add(DropdownMenuItem(
        value: providerItem,
        child: Text(providerItem, overflow: TextOverflow.ellipsis))));
    return codeDropdownList;
  }

  List<DropdownMenuItem<int>> _buildNameDropdownItems(
      List<ProviderItem> providerItems) {
    List<DropdownMenuItem<int>> nameDropdownList = [];
    providerItems.forEach((providerItem) {
      nameDropdownList.add(DropdownMenuItem(
          value: providerItem.id,
          child: Text(providerItem.name, overflow: TextOverflow.ellipsis)));
    });

    return nameDropdownList;
  }

  valid() {
    return _formKey.currentState.validate();
  }
}
