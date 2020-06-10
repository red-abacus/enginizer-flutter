import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/image-selection.widget.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/promotions/providers/create-promotion.provider.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:app/modules/promotions/widgets/forms/create-promotion-info-form.widget.dart';
import 'package:app/modules/shared/widgets/image-picker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  child: _getContent(),
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
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .getServiceProviderItems(
              Provider.of<Auth>(context).authUser.providerId)
          .then((itemsResponse) async {
        int serviceId = _provider.createPromotionRequest.serviceId;

        if (serviceId != null) {
          for (ServiceProviderItem item in itemsResponse.items) {
            if (item.id == serviceId) {
              _provider.createPromotionRequest.serviceProviderItem = item;
              break;
            }
          }
        }

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

  _getContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [_buildStepper(), _bottomButtonsWidget()],
          );
  }

  Widget _buildStepper() => Stepper(
      currentStep: _currentStepIndex,
      onStepContinue: _next,
      onStepCancel: _back,
      onStepTapped: (step) => _goTo(step),
      type: StepperType.horizontal,
      steps: steps,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[],
        );
      });

  _bottomButtonsWidget() {
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
              child: Text(_currentStepIndex == 1
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

                      if (_provider.createPromotionRequest.files.length <
                          _provider.maxFiles) {
                        _provider.createPromotionRequest.files.add(null);
                      }
                    }
                  });
                } else {
                  try {
                    await _provider.addPromotionImages(
                        _provider.createPromotionRequest.providerId,
                        _provider.createPromotionRequest.promotionId,
                        [file]).then((value) {
                      setState(() {
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

  List<Step> _buildSteps(BuildContext context) {
    return [
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
                      null, red, FontWeight.bold, 16),
                ),
                ImageSelectionWidget(
                    addImage: _addImage,
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
          content: CreatePromotionInfoForm(),
          state: StepState.indexed)
    ];
  }

  _next() {
    switch (_currentStepIndex) {
      case 0:
        _goTo(1);
        break;
      case 1:
        if (_provider.informationFormState.currentState.validate()) {
          if (_provider.createPromotionRequest.promotionId == null) {
            _createPromotion();
          } else {
            _editPromotion();
          }
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
            widget.refreshState();
            Navigator.pop(context);
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          widget.refreshState();
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

        widget.refreshState();
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
            widget.refreshState();
            Navigator.pop(context);
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          widget.refreshState();
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

        widget.refreshState();
        Navigator.pop(context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
