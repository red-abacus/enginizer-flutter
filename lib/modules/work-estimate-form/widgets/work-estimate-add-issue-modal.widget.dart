import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/item-type.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:enginizer_flutter/modules/authentication/providers/auth.provider.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue-section.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateAddIssueModalWidget extends StatefulWidget {
  Function addIssueItem;
  IssueSection issueSection;

  WorkEstimateAddIssueModalWidget(
      {Key key, this.addIssueItem, this.issueSection})
      : super(key: key);

  @override
  WorkEstimateAddIssueModalWidgetState createState() =>
      WorkEstimateAddIssueModalWidgetState();
}

class WorkEstimateAddIssueModalWidgetState
    extends State<WorkEstimateAddIssueModalWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Auth>(context);
    var provider = Provider.of<WorkEstimateProvider>(context);

    return Container(
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
                      onChanged: (selectedType) {
                        provider
                            .loadProviderItems(
                                authProvider?.authUser?.providerId,
                                IssueItemQuery(typeId: selectedType.id))
                            .then((_) => {
                                  setState(() {
                                    provider.estimatorFormState['type'] =
                                        selectedType;
                                    provider.estimatorFormState['code'] = null;
                                    provider.estimatorFormState['name'] = null;
                                    provider.estimatorFormState['price'] = '';
                                    provider.estimatorFormState['priceVAT'] =
                                        '';
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
                        onChanged: (selectedProviderItem) {
                          provider
                              .loadProviderItems(
                                  authProvider?.authUser?.providerId,
                                  IssueItemQuery(
                                      typeId: selectedProviderItem.itemType.id,
                                      code: selectedProviderItem.code))
                              .then((providerItems) => {
                                    setState(() {
                                      var foundProviderItem =
                                          providerItems.firstWhere(
                                              (provider) =>
                                                  provider.id ==
                                                  selectedProviderItem.id,
                                              orElse: () => null);
                                      provider.estimatorFormState['code'] =
                                          foundProviderItem;
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
                        items: provider.estimatorFormState['type'] != null
                            ? _buildNameDropdownItems(provider.providerItems)
                            : [],
                        value: provider.estimatorFormState['name'],
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
                          provider
                              .loadProviderItems(
                                  authProvider?.authUser?.providerId,
                                  IssueItemQuery(
                                      typeId: selectedProviderItem.itemType.id,
                                      code: selectedProviderItem.code,
                                      name: selectedProviderItem.name))
                              .then((providerItems) => {
                                    setState(() {
                                      var foundProviderItem =
                                          providerItems.firstWhere(
                                              (provider) =>
                                                  provider.id ==
                                                  selectedProviderItem.id,
                                              orElse: () => null);
                                      provider.estimatorFormState['code'] =
                                          foundProviderItem;
                                      provider.estimatorFormState['name'] =
                                          foundProviderItem;
                                      provider.estimatorFormState['quantity'] =
                                          1;
                                      provider.estimatorFormState['price'] =
                                          foundProviderItem.price;
                                      provider.estimatorFormState['priceVAT'] =
                                          foundProviderItem.priceVAT;
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
                          text: provider.estimatorFormState['quantity']
                              .toString()),
                      onChanged: (newQuantity) {
                        provider.estimatorFormState['quantity'] =
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
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(vertical: 15),
                child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () => {
                          if (valid())
                            {
                              Navigator.pop(context),
                              widget.addIssueItem(widget.issueSection)
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

  List<DropdownMenuItem<ProviderItem>> _buildCodeDropdownItems(
      List<ProviderItem> providerItems) {
    List<DropdownMenuItem<ProviderItem>> codeDropdownList = [];
    providerItems.forEach((providerItem) => codeDropdownList.add(
        DropdownMenuItem(
            value: providerItem,
            child: Text(providerItem.code, overflow: TextOverflow.ellipsis))));
    return codeDropdownList;
  }

  List<DropdownMenuItem<ProviderItem>> _buildNameDropdownItems(
      List<ProviderItem> providerItems) {
    List<DropdownMenuItem<ProviderItem>> nameDropdownList = [];
    providerItems.forEach((providerItem) => nameDropdownList.add(
        DropdownMenuItem(
            value: providerItem,
            child: Text(providerItem.name, overflow: TextOverflow.ellipsis))));
    return nameDropdownList;
  }

  valid() {
    return _formKey.currentState.validate();
  }
}
