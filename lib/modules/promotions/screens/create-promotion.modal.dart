import 'dart:math';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/image-selection.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/promotions/providers/create-promotion.provider.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:app/modules/promotions/widgets/forms/create-promotion-info-form.widget.dart';
import 'package:app/modules/promotions/widgets/forms/create-promotion-select-car.widget.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final createPromotionSelectCarKey =
    new GlobalKey<CreatePromotionSelectCarWidgetState>();

class CreatePromotionModal extends StatefulWidget {
  final Function refreshState;

  CreatePromotionModal({Key key, this.refreshState}) : super(key: key);

  @override
  _CreatePromotionModalState createState() => _CreatePromotionModalState();
}

class _CreatePromotionModalState extends State<CreatePromotionModal> {
  bool _initDone = false;
  bool _isLoading = false;
  int _currentStepIndex = 0;

  CreatePromotionProvider _provider;

  List<Step> steps = [];

  Key _stepperKey = Key(Random.secure().nextDouble().toString());

  @override
  Widget build(BuildContext context) {
    steps = _buildSteps(context);

    return FractionallySizedBox(
        heightFactor: .8,
        child: Scaffold(
          body: Container(
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0))),
                child: Theme(
                  data: ThemeData(
                      accentColor: Theme.of(context).primaryColor,
                      primaryColor: Theme.of(context).primaryColor),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [_buildStepper(), _bottomButtonsWidget()],
                        ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<CreatePromotionProvider>(context);
      _loadData();
    }

    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    if (_provider.serviceProviderItemsResponse == null) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .getServiceProviderItems(
                Provider.of<Auth>(context).authUser.providerId)
            .then((itemsResponse) async {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        if (error
            .toString()
            .contains(ProviderService.GET_PROVIDER_SERVICE_ITEMS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_get_provider_service_items, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildStepper() => Stepper(
      currentStep: _currentStepIndex,
      onStepContinue: _next,
      onStepCancel: _back,
      key: _stepperKey,
      type: StepperType.horizontal,
      steps: steps,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[],
        );
      });

  _bottomButtonsWidget() {
    bool isLastStep = false;
    if (_currentStepIndex == 1 &&
        !_provider.createPromotionRequest.hasSellerService() &&
        !_provider.createPromotionRequest.hasRentService()) {
      isLastStep = true;
    } else if (_currentStepIndex == 2) {
      isLastStep = true;
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(S.of(context).general_back),
              onPressed: _back,
            ),
            RaisedButton(
              elevation: 0,
              child: Text(isLastStep
                  ? S.of(context).general_add
                  : S.of(context).general_continue),
              textColor: Theme.of(context).cardColor,
              onPressed: _next,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }

  Future _addImage(int index) async {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) => ImagePickerWidget(imageSelected: (file) async {
              if (file != null) {
                if (_provider.createPromotionRequest.promotionId == null) {
                  setState(() {
                    if (index < _provider.createPromotionRequest.files.length) {
                      _provider.createPromotionRequest.files[index] = file;
                      _provider.createPromotionRequest.checkAddImage();
                    }
                  });
                } else {
                  try {
                    await _provider.addPromotionImages(
                        _provider.createPromotionRequest.providerId,
                        _provider.createPromotionRequest.promotionId,
                        [file]).then((value) {
                      setState(() {
                        _provider.createPromotionRequest.images.addAll(value);
                        _provider.createPromotionRequest.checkAddImage();
                        _provider.createPromotionRequest.promotion?.images =
                            _provider.createPromotionRequest.images;
                        _isLoading = false;
                      });
                    });
                  } catch (error) {
                    if (error.toString().contains(
                        PromotionService.ADD_PROMOTION_IMAGES_EXCEPTION)) {
                      FlushBarHelper.showFlushBar(
                          S.of(context).general_error,
                          S.of(context).exception_add_promotion_images,
                          context);
                    }

                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              }
            }));
  }

  _removeImage(GenericModel image) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AlertConfirmationDialogWidget(
                confirmFunction: (confirm) {
                  if (confirm) {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      _provider
                          .deletePromotionImage(
                              _provider.createPromotionRequest.providerId,
                              _provider.createPromotionRequest.promotionId,
                              image.id)
                          .then((success) {
                        setState(() {
                          _provider.createPromotionRequest.images.remove(image);
                          _provider.createPromotionRequest.promotion?.images =
                              _provider.createPromotionRequest.images;
                          _provider.createPromotionRequest.checkAddImage();
                          _isLoading = false;
                        });
                      });
                    } catch (error) {
                      if (error.toString().contains(
                          PromotionService.DELETE_PROMOTION_IMAGE_EXCEPTION)) {
                        FlushBarHelper.showFlushBar(
                            S.of(context).general_error,
                            S.of(context).exception_remove_promotion_image,
                            context);
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                title: S.of(context).promotions_remove_image_alert);
          });
        });
  }

  List<Step> _buildSteps(BuildContext context) {
    List<Step> steps = [
      Step(
          isActive: _currentStepIndex == 0,
          title: Text(_currentStepIndex == 0
              ? S.of(context).promotions_create_step_1
              : ''),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S.of(context).promotions_create_step_1_upload_image_title,
                  style: TextHelper.customTextStyle(
                      color: red, weight: FontWeight.bold, size: 16),
                ),
                ImageSelectionWidget(
                    addImage: _addImage,
                    removeImage: _removeImage,
                    images: _provider.createPromotionRequest.images,
                    files: _provider.createPromotionRequest.files),
              ],
            ),
          ),
          state: StepState.indexed),
      Step(
          isActive: _currentStepIndex == 1,
          title: Text(_currentStepIndex == 1
              ? S.of(context).promotions_create_step_2
              : ''),
          content: CreatePromotionInfoForm(refreshState: _refreshState),
          state: StepState.indexed)
    ];

    if (_provider.createPromotionRequest.hasSellerService() ||
        _provider.createPromotionRequest.hasRentService()) {
      steps.add(Step(
          isActive: _currentStepIndex == 2,
          title: Text(_currentStepIndex == 2
              ? S.of(context).promotions_create_step_3
              : ''),
          content: CreatePromotionSelectCarWidget(
            key: createPromotionSelectCarKey,
          ),
          state: StepState.indexed));
    }

    return steps;
  }

  _next() {
    switch (_currentStepIndex) {
      case 0:
        _goTo(1);
        break;
      case 1:
        if (_provider.informationFormState.currentState.validate()) {
          if (_provider.createPromotionRequest.hasSellerService() ||
              _provider.createPromotionRequest.hasRentService()) {
            _goTo(2);
          } else if (_provider.createPromotionRequest.car != null &&
              _provider.createPromotionRequest.presetServiceProviderItem !=
                  null &&
              _provider.createPromotionRequest.presetServiceProviderItem
                  .isSellerService()) {
            _sellCar();
          } else if (_provider.createPromotionRequest.car != null &&
              _provider.createPromotionRequest.presetServiceProviderItem !=
                  null &&
              _provider.createPromotionRequest.presetServiceProviderItem
                  .isRentService()) {
            _rentCar();
          } else {
            if (_provider.createPromotionRequest.promotionId == null) {
              _createPromotion();
            } else {
              _editPromotion();
            }
          }
        }
        break;
      case 2:
        if (createPromotionSelectCarKey.currentState.valid()) {
          _sellCar();
        }
        break;
    }
  }

  _back() {
    if (_currentStepIndex > 0) {
      _goTo(_currentStepIndex - 1);
    }
  }

  _goTo(stepIndex) {
    setState(() {
      _currentStepIndex = stepIndex;
    });
  }

  _createPromotion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .addPromotion(_provider.createPromotionRequest)
          .then((promotion) async {
        if (_provider.createPromotionRequest.getImages().length > 0) {
          await _provider
              .addPromotionImages(_provider.createPromotionRequest.providerId,
                  promotion.id, _provider.createPromotionRequest.getImages())
              .then((value) {
            if (widget.refreshState != null) {
              widget.refreshState();
            }
            Navigator.pop(context);
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          if (widget.refreshState != null) {
            widget.refreshState();
          }
          Navigator.pop(context);
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      if (error.toString().contains(PromotionService.ADD_PROMOTION_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_add_promotion, context);
      } else if (error
          .toString()
          .contains(PromotionService.ADD_PROMOTION_IMAGES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_add_promotion_images, context);

        if (widget.refreshState != null) {
          widget.refreshState();
        }
        Navigator.pop(context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _editPromotion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .editPromotion(_provider.createPromotionRequest)
          .then((promotion) async {
        if (_provider.createPromotionRequest.getImages().length > 0) {
          await _provider
              .addPromotionImages(_provider.createPromotionRequest.providerId,
                  promotion.id, _provider.createPromotionRequest.getImages())
              .then((value) {
            if (widget.refreshState != null) {
              widget.refreshState();
            }
            Navigator.pop(context);
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          if (widget.refreshState != null) {
            widget.refreshState();
          }
          Navigator.pop(context);
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      if (error
          .toString()
          .contains(PromotionService.EDIT_PROMOTION_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_edit_promotion, context);
      } else if (error
          .toString()
          .contains(PromotionService.ADD_PROMOTION_IMAGES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_add_promotion_images, context);

        if (widget.refreshState != null) {
          widget.refreshState();
        }
        Navigator.pop(context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _sellCar() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.sellCar(_provider.createPromotionRequest).then((car) {
        if (widget.refreshState != null) {
          widget.refreshState();
        }
        Navigator.pop(context);
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_SELL_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_sell, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _rentCar() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.rentCar(_provider.createPromotionRequest).then((car) {
        if (widget.refreshState != null) {
          widget.refreshState();
        }
        Navigator.pop(context);
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_RENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_rent, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _refreshState() {
    setState(() {
      _stepperKey = Key(Random.secure().nextDouble().toString());
    });
  }
}
