import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_text_field_underline.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:longa_lotto/wallet/deposit/StatusTimerDialog.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_bloc.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_event.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_state.dart';
import 'package:longa_lotto/wallet/deposit/deposit_webview.dart';
import 'package:longa_lotto/wallet/deposit/model/response/PaymentOptionsResponse.dart';
import 'package:velocity_x/velocity_x.dart';

import 'model/response/ConvertToPgCurrencyResponse.dart';

class DepositScreen extends StatefulWidget {

  Function(bool) mCallback;
  Function scrollInitCallBack;
  DepositScreen({Key? key, required this.mCallback, required this.scrollInitCallBack}) : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {

  TextEditingController amountController  = TextEditingController();
  ShakeController amountShakeController   = ShakeController();
  TextEditingController mobileNumberController  = TextEditingController();
  ShakeController mobileNumberShakeController   = ShakeController();
  int? selectedIndex = 0;
  int? selectedPaymentIndex;
  String? selectedSubTypeId;
  String? selectedPayTypeId;
  String? subTypeMapTextValue;
  String? currencyCode;
  Map<String,dynamic>? payTypeMapResponse;
  List<PaymentOptionsResponse>? paymentOptionList = [];
  bool isButtonPressed     = false;
  var autoValidate         = AutovalidateMode.disabled;
  final _depositForm       = GlobalKey<FormState>();
  double minValue = 0.0;
  double maxValue = 0.0;
  bool isPaymentOptionError = false;
  bool showAmountDetails = false;
  bool showOtherOptions = false;

  List<String> amountList = [
    '100',
    '200',
    '500',
    '1000',
  ];
  bool afterNetGone = false;
  String? _selectedPaymentType;
  Data? currencyConverterResponse;

  double mAnimatedButtonSize              = 300.0;
  bool mButtonTextVisibility              = true;
  ButtonShrinkStatus mButtonShrinkStatus  = ButtonShrinkStatus.notStarted;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  int currentSeconds                    = 0;
  static const interval                 = Duration(seconds: 1);
  Timer timer                           = Timer(interval, () {});
  final int timerMaxSeconds             = 90;
  bool showTimer                        = false;

  @override
  void initState() {
    print("--------------------->deposit");
    NetworkSingleton().setNetworkListener(context);
    mobileNumberController.text = UserInfo.mobNumber;
    // amountController.text = amountList[selectedIndex ?? 0];
    BlocProvider.of<DepositBloc>(context).add(PaymentOptionsApiEvent(context: context));
    amountController.addListener(() {
      if(amountController.text.isEmpty) {
        setState(() {
          selectedIndex = null;
          showAmountDetails = false;
        });
      } else if (!amountList.contains(amountController.text)){
        setState(() {
          selectedIndex = null;
        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if(state is NetWorkConnected) {
          setState(() {
            if (afterNetGone) {
              afterNetGone = false;

              ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
              BlocProvider.of<DepositBloc>(context).add(PaymentOptionsApiEvent(context: context));
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: BlocListener<DepositBloc, DepositState>(
        listener: (context, state) {
          if( state is DepositLoading) {
            setState(() {
              widget.mCallback(true);
            });
          }
          if( state is PaymentOptionsSuccess) {
            try {
              setState((){
                paymentOptionList?.clear();
                payTypeMapResponse = state.response["payTypeMap"];
                if (payTypeMapResponse != null && payTypeMapResponse?.isNotEmpty == true){
                  for(var key in payTypeMapResponse!.keys) {
                    Map<String, dynamic> subTypeMaps = payTypeMapResponse?[key]["subTypeMap"];

                    List<SubTypeMap> subTypeMapList  = [];
                    for(var subTypeKey in subTypeMaps.keys) {
                      subTypeMapList.add(
                          SubTypeMap(
                            id: subTypeKey,
                            value: subTypeMaps[subTypeKey],
                          )
                      );
                    }

                    for(var i=0; i< subTypeMaps.length ; i++ ) {
                      Map<String, dynamic> currencyMap = payTypeMapResponse?[key]["currencyMap"][subTypeMapList[i].id];
                      for ( var currencyKey in currencyMap.keys ) {
                        subTypeMapList[i].currency = currencyMap[currencyKey];
                      }
                    }

                    paymentOptionList?.add(
                        PaymentOptionsResponse(
                            payTypeId: payTypeMapResponse?[key]["payTypeId"],
                            payTypeCode: payTypeMapResponse?[key]["payTypeCode"],
                            payTypeDispCode: payTypeMapResponse?[key]["payTypeDispCode"],
                            maxValue: payTypeMapResponse?[key]["maxValue"],
                            minValue: payTypeMapResponse?[key]["minValue"],
                            subTypeMap: subTypeMapList

                        )
                    );
                    _selectedPaymentType = paymentOptionList?[0].payTypeDispCode ?? "By Card";
                    isPaymentOptionError = false;
                  }
                }
                widget.mCallback(false);
              });
            } catch(e){
              setState(() {
                isPaymentOptionError = true;
                widget.mCallback(false);
                ShowToast.showToast(context, context.l10n.something_went_wrong, type: ToastType.ERROR);
              });
            }

          }
          else if ( state is PaymentOptionsError) {
            setState(() {
              widget.mCallback(false);
              isPaymentOptionError = true;
              if(state.errorCode != 1109) {
                ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
              }
            });
          }
          else if ( state is ConvertToPgCurrencySuccess) {
            setState(() {
              resetLoaderBtn();
              _depositDialog();
              currencyConverterResponse = state.response?.data;
              showAmountDetails = true;
              showOtherOptions  = true;
              widget.mCallback(false);
            });
          }
          else if ( state is ConvertToPgCurrencyError) {
            setState(() {
              resetLoaderBtn();
              showOtherOptions  = false;
              widget.mCallback(false);
              /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errorMessage.toString()),
              duration: const Duration(seconds: 1),

            ));*/
              if(state.errorCode != 1109) {
                ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
              }
            });
          }

          if(state is GetStatusFromProviderTxnSuccess) {
            setState(() {
              widget.mCallback(false);
            });
            if((state.response?.status ?? "").toLowerCase() == 'success') {// SUCCESS
              fetchHeaderInfo(context);
              Navigator.pop(context);
              ShowToast.showToast(context, context.l10n.deposit_successful, type: ToastType.SUCCESS);
            } else if (state.response?.status ==  "FAILED") {//976386084
              Navigator.pop(context);
              ShowToast.showToast(context, context.l10n.deposit_failed, type: ToastType.ERROR);
            }

          } else if (state is GetStatusFromProviderTxnError) {
            //Navigator.pop(context);
            setState(() {
              widget.mCallback(false);
            });
          }
        },
        child: SingleChildScrollView(

          physics: NeverScrollableScrollPhysics(),
          child: Form(
            key: _depositForm,
            autovalidateMode: autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (paymentOptionList?.isNotEmpty == true && paymentOptionList != null)
                    ? Column(
                  children: [
                    HeightBox(MediaQuery.of(context).size.width * 0.05),
                    _paymentType((paymentOptionList?.isNotEmpty == true) ? paymentOptionList ?? [] : []),
                    _paymentOptionList(),
                    HeightBox(MediaQuery.of(context).size.width * 0.02),
                    //showAmountDetails ? _chargesDetailCard() : Container(),
                  ],
                )
                    : isPaymentOptionError
                    ? Center(child: Text(context.l10n.deposit_option_not_available, style: TextStyle(fontSize: 16),))
                    : Center(child: CircularProgressIndicator()),

                (paymentOptionList?.isNotEmpty == true)
                    ? UserInfo.getAliasNameScan.contains("scan")
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Image.asset(
                                "assets/icons/pgic_orange-money.png",
                                width: 320,
                                height: 47,
                                fit: BoxFit.fill
                            ),
                          ),
                          WidthBox(20),
                          Expanded(
                            child: Image.asset(
                                "assets/icons/pgic_airtel-money.png",
                                width: 320,
                                height: 47,
                                fit: BoxFit.fill
                            ),
                          ),
                          WidthBox(20),
                          Expanded(
                            child: Image.asset(
                                "assets/icons/pgic_afri-money.png",
                                width: 320,
                                height: 47,
                                fit: BoxFit.fill
                            ),
                          ),
                          /*Center(
                            child: Image.asset(
                                "assets/icons/payment-money-icons.png",
                                width: 320,
                                height: 47,
                                fit: BoxFit.fill
                            ),
                          ).pOnly(bottom: 20)*/
                        ],
                      ).pSymmetric(h: isMobileDevice() ? 20 : 40)
                    : Container(),

                HeightBox(20),
                showOtherOptions
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (subTypeMapTextValue != null && subTypeMapTextValue!.toLowerCase().contains("visa") != true)
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.mobile_number, textAlign: TextAlign.start, style: TextStyle(color:Colors.black, fontWeight: FontWeight.w600, fontSize: 18)).pOnly(left: 10),
                        _mobileNumberTextField(),
                      ],
                    ).pOnly(bottom: 20)
                        : Container(),

                    Text(context.l10n.choose_your_amount, textAlign: TextAlign.start, style: TextStyle(color:Colors.black, fontWeight: FontWeight.w600, fontSize: 18)).pOnly(left: 10),
                    _amountTextField(),
                    //_amountList(),
                    HeightBox(MediaQuery.of(context).size.width * 0.08),
                    Center(child: _submitButton(),),
                    HeightBox(MediaQuery.of(context).size.width * 0.08),
                  ],
                )
                    : Container(),
              ],
            ).pOnly(top: 30),
          ),
        ),
      ),
    );
  }

  _mobileNumberTextField() {
    return ShakeWidget(
      controller: mobileNumberShakeController,
      child: LongaTextFieldUnderline(
        maxLength: 9,
        inputType: TextInputType.number,
        hintText: "+243",
        controller: mobileNumberController,
        validator: (value) {
          if (validateInput(TotalTextFields.mobileNumber).isNotEmpty) {
            if (isButtonPressed) {
              mobileNumberShakeController.shake();
            }
            return validateInput(TotalTextFields.mobileNumber);
          } else {
            return null;
          }
        },
      ).pSymmetric(v: 8,h: 20),
    );
  }

  _amountTextField() {
    return ShakeWidget(
      controller: amountShakeController,
      child: LongaTextFieldUnderline(
        maxLength: 6,
        labelRow: currencyCode,
        labelFontSize: 18,
        inputType: TextInputType.number,
        hintText: context.l10n.enter_amount,
        controller: amountController,
        validator: (value) {
          if (validateInput(TotalTextFields.amount).isNotEmpty) {
            if (isButtonPressed) {
              amountShakeController.shake();
            }
            return validateInput(TotalTextFields.amount);
          } else {
            return null;
          }
        },
      ).pSymmetric(v: 8,h: 20),
    );
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.amount:
        var amountText = amountController.text.trim();
        if (amountText.isEmpty) {
          return context.l10n.please_enter_a_amount;
        }
        break;

      case TotalTextFields.mobileNumber:
        var mobText = mobileNumberController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_mobile_number;
        } else if (mobText.length < 8) {
          return context.l10n.please_enter_valid_mobile_no_8_16;
        } else if (mobText.length > 16) {
          return context.l10n.please_enter_valid_mobile_no_8_16;
        }
        /*else if (!RegExp("^^[0-9]{9}\$").hasMatch(mobText)) {
          return context.l10n.please_provide_valid_mobile_number;
        }*/
        break;
      default:
    }
    return "";
  }

  _amountList() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 3
            ),
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            itemCount: amountList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  print("click start");
                  setState(() {
                    selectedIndex = index;
                    amountController.text = amountList[index];
                    amountController.selection = TextSelection.fromPosition(TextPosition(offset: amountController.text.length));
                    hideKeyboard();
                  });
                  print("click end");
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selectedIndex == index ? Colors.red : Colors.grey,
                        width: 2
                    ),
                  ),
                  child: FittedBox(
                    child: Center(
                      child: Text(
                        "$currencyCode ${amountList[index]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: selectedIndex == index ? Colors.red : Colors.grey
                        ),
                      ).pSymmetric(v: 6,h: 20),
                    ),
                  ),
                ).pOnly(left: 5, right: 5),
              );
            },
          ),
        ),
      ],
    );
  }

  _paymentType(List<PaymentOptionsResponse> list) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.l10n.choose_payment_mode, textAlign: TextAlign.start, style: TextStyle(color:Colors.black, fontWeight: FontWeight.w600, fontSize: 18)).pOnly(left: 10),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              )
          ),
          margin: const EdgeInsets.all(10),
          child: SizedBox(
            height: 48,
            child: DropdownButtonFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[300],
              ),
              isExpanded: true,
              isDense: true,
              value: _selectedPaymentType,
              selectedItemBuilder: (BuildContext context) {
                return list.map((item) {
                  return DropdownMenuItem(value: item.payTypeDispCode ?? "", child: Text(item.payTypeDispCode ?? "NA"));
                }).toList();
              },
              items: list.map(( item) {
                if (_selectedPaymentType == item.payTypeDispCode) {
                  return DropdownMenuItem(
                    value: item.payTypeDispCode,
                    child: Container(
                        height: 48.0,
                        width: double.infinity,
                        color: LongaColor.white_five,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.payTypeDispCode.toString(),
                          ),
                        )),
                  );
                } else {
                  return DropdownMenuItem(
                    value: item.payTypeDispCode,
                    child: Text(item.payTypeDispCode.toString()),
                  );
                }
              }).toList(),
              validator: (value) {
                value?.isEmpty ??  true ? "cannot empty" : null;
              },
              onChanged: (selectedItem) => setState(
                    () {
                  amountController.text = "";
                  selectedIndex = null;
                  showOtherOptions = false;
                  showAmountDetails = false;
                  selectedPaymentIndex = null;
                  showAmountDetails = false;
                  _selectedPaymentType = selectedItem.toString();
                  showAmountDetails = false;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  _paymentOptionList() {
    PaymentOptionsResponse? newPaymentOptionList = PaymentOptionsResponse();
    if ( paymentOptionList?.isNotEmpty == true && paymentOptionList != null) {
      var a = paymentOptionList?.where((element) => element.payTypeDispCode == _selectedPaymentType).toList();
      if (a?.isNotEmpty == true && a != null){
        newPaymentOptionList = a[0];
      }
    } else {
      print("_paymentOptionList>>>>>>>>>>>>>>>>>>${paymentOptionList}");
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4,
                crossAxisSpacing: 8
            ),
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            itemCount: newPaymentOptionList.subTypeMap?.length ?? 0,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    // amountController.text   = "";
                    selectedIndex           = null;
                    showOtherOptions        = true;
                    selectedSubTypeId       = newPaymentOptionList?.subTypeMap?[index].id ?? "";
                    selectedPayTypeId       = (newPaymentOptionList?.payTypeId.toString() ?? "");
                    currencyCode            = newPaymentOptionList?.subTypeMap?[index].currency ?? "CDF";
                    selectedPaymentIndex    = int.parse("$index");
                    maxValue                = newPaymentOptionList?.maxValue ?? 0;
                    minValue                = newPaymentOptionList?.minValue ?? 0;
                    subTypeMapTextValue     = newPaymentOptionList?.subTypeMap?[index].value?.replaceAll("_", " ");
                    hideKeyboard();
                    if (currencyCode != "CDF") {
                      amountList = [ '1','2','3','4','5','6'];
                    } else {
                      amountList = [
                        '100',
                        '200',
                        '500',
                        '1000'
                      ];
                    }
                  });

                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:Border.all(
                        width: 2,
                        color: (selectedPaymentIndex == int.parse("$index")) ? Colors.red : Colors.grey
                    ),
                  ),
                  child:FittedBox(
                    child: Row(
                      children: [
                        Image.asset(
                            "assets/icons/${(newPaymentOptionList?.payTypeCode ?? "").toLowerCase()}.png",
                          width: 45,
                          height: 45,
                          errorBuilder: (context, exception, stackTrace) {
                            return Container();},
                        ).pOnly(left: 10),

                        Text(
                          newPaymentOptionList?.subTypeMap?[index].value?.replaceAll("_", " ") ?? "" ,
                          style: TextStyle(
                              fontSize: 18,
                              color: (selectedPaymentIndex == int.parse("$index")) ? Colors.red : Colors.grey,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ).p(12),
                      ],
                    ),
                  ),
                ).p(3),
              );
            },
          ),
        ),
      ],
    );
  }

  paymentOptionIcons() {

  }

  Future<bool> checkImage (String imagePath) async{
    try {
      final bundle = DefaultAssetBundle.of(context);
      await bundle.load(imagePath);
      AssetImage(imagePath);
      return true; /// Exist
    } catch (e) {
      return false; //Not Exist
    }
  }

  _submitButton() {
    return InkWell(
      onTap: () {

        setState(() {
          isButtonPressed = true;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            isButtonPressed = false;
          });
        });

        if (_depositForm.currentState!.validate()) {
          if (selectedSubTypeId?.isNotEmpty == true) {
            if ((int.parse(amountController.text.trim()) >= minValue) && (int.parse(amountController.text.trim()) <= maxValue) ) {
              setState(() {
                mAnimatedButtonSize   = 50.0;
                mButtonTextVisibility = false;
              });
              callConvertToPgCurrencyApi();
            } else {
              /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${context.l10n.amount_range_should_be_in_between} $minValue to $maxValue"),
                duration: const Duration(seconds: 1),

              ));*/
              ShowToast.showToast(context, "${context.l10n.amount_range_should_be_in_between} $minValue to $maxValue", type: ToastType.ERROR);
            }
          } else {
            ShowToast.showToast(context, context.l10n.please_select_payment_type, type: ToastType.ERROR);
          }

        }
        else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }

      },
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [LongaColor.butter_scotch, LongaColor.orangey_red,
              ]),
              borderRadius: BorderRadius.circular(67)
          ),
          child: AnimatedContainer(
            width: mAnimatedButtonSize,
            height: 50,
            onEnd: () {
              print("completed");
              setState(() {
                if (mButtonShrinkStatus != ButtonShrinkStatus.over) {
                  mButtonShrinkStatus = ButtonShrinkStatus.started;

                } else {
                  mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
                }
              });
            },
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
                width: mAnimatedButtonSize,
                height: 50,
                child: mButtonShrinkStatus == ButtonShrinkStatus.started
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: LongaColor.white_two),
                )
                    : Center(child:
                Visibility(
                  visible: mButtonTextVisibility,
                  child: Text(context.l10n.proceed.toUpperCase(),
                    style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: LongaColor.white,
                    ),
                  ),
                ))
            ),
          )
      ),
    );
  }

  _chargesDetailCard() {
    double creditedAmount = (int.parse(amountController.text.trim()) - (currencyConverterResponse?.processChargeValue ?? 0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          context.l10n.amount_to_be_credited_in_wallet,
          style: TextStyle(
              fontSize: 15,
              color: LongaColor.warm_grey_three,
              fontWeight: FontWeight.w600
          ),
          maxLines: 3,
        ),
        Text(
          "${currencyConverterResponse?.reqCurrencyCode} $creditedAmount (${currencyConverterResponse?.plrCurrencyCode} ${(creditedAmount * (currencyConverterResponse?.plrCurrExchangeRate ?? 0).toInt())})",
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
          maxLines: 3,
          textAlign: TextAlign.right,
        ).pOnly(top: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: Colors.grey,
        ).pOnly(top: 6, bottom: 3),
        Text(
          context.l10n.exchange_conversion_rate,
          style: TextStyle(
              fontSize: 15,
              color: LongaColor.warm_grey_three,
              fontWeight: FontWeight.w600
          ),
          maxLines: 3,
        ),
        Text(
          "${(currencyConverterResponse?.plrCurrExchangeRate ?? 0)}",
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
          maxLines: 3,
          textAlign: TextAlign.right,
        ).pOnly(top: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: Colors.grey,
        ).pOnly(top: 6, bottom: 3),
        Text(
          context.l10n.process_charges,
          style: TextStyle(
              fontSize: 15,
              color: LongaColor.warm_grey_three,
              fontWeight: FontWeight.w600
          ),
          maxLines: 2,
        ),
        Text(
          "$currencyCode ${currencyConverterResponse?.processChargeValue}",
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
          maxLines: 2,
          textAlign: TextAlign.right,
        ).pOnly(top: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: Colors.grey,
        ).pOnly(top: 6, bottom: 3),

        Text(
          context.l10n.amount_to_be_debited,
          style: TextStyle(
              fontSize: 15,
              color: LongaColor.warm_grey_three,
              fontWeight: FontWeight.w600
          ),
          maxLines: 2,
        ),
        Text(
          "$currencyCode ${amountController.text.trim()}",
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
          textAlign: TextAlign.right,
        ).pOnly(top: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: Colors.grey,
        ).pOnly(top: 6, bottom: 3),

      ],
    ).pOnly(left: 20, bottom: 20, top: 20, );
  }

  void callConvertToPgCurrencyApi() {
    BlocProvider.of<DepositBloc>(context).add(
        ConvertToPgCurrencyApiEvent(
            context: context,
            amount: int.parse(amountController.text.trim()),
            reqAmtCurrencyCode: currencyCode ?? "",
            paymentTypeId: int.parse(selectedPayTypeId ?? "0"),
            subTypeId: int.parse(selectedSubTypeId ?? "0"),
        )
    );
  }

  _depositDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx){
          return Container(
            child: Dialog(
              elevation: 5.0,
              insetPadding: EdgeInsets.symmetric(horizontal: isMobileDevice() ? 32.0 : 94.0, vertical: 24.0),
              backgroundColor: LongaColor.white_five,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _gradientLine(),
                    const HeightBox(10),
                    Column(
                      children: [
                        _depositDialogTitle(),
                        const HeightBox(20),
                        _chargesDetailCard()
                      ],
                    ).pOnly(right: 10),
                    const HeightBox(10),
                    _dialogButtons(context),
                    const HeightBox(10),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  _gradientLine() {
    return const GradientLine(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }

  _depositDialogTitle() {
    return Text(
      context.l10n.deposit_amount,
      style: TextStyle(
        color: LongaColor.black_four,
        fontWeight: FontWeight.w600,
        fontFamily: "Roboto",
        fontStyle: FontStyle.normal,
        fontSize: 25.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  _dialogButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text(context.l10n.cancel, style: TextStyle(color: Colors.red),).p(10)),
            ).p(10),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap:() {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepositWebView(
                      amount:int.parse(amountController.text.trim()).toString(),     //currencyConverterResponse?.netConvertedAmount.toString() ?? "",
                      currencyCode: currencyCode,
                      paymentTypeId: selectedPayTypeId,
                      subTypeId: selectedSubTypeId,
                      mobileNumber: mobileNumberController.text.trim()
                    ),
                  )
              ).then((value) => {
                setState((){
                  widget.scrollInitCallBack();
                  amountController.text = "";
                  showOtherOptions = false;
                  selectedSubTypeId = null;
                  selectedIndex = null;
                  selectedPaymentIndex = null;
                  amountController.text = "";
                  mobileNumberController.text = UserInfo.mobNumber;

                  if (value != null) {
                    // open timer Dialog
                    _depositTimerDialog(int.parse(value));
                  }
                })
              });
              /*if(UserInfo.emailVerified == "N") {
                ShowToast.showToast(context, "${context.l10n.please_verify_your_email}", type: ToastType.ERROR);

              } else {

              }*/

            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)

              ),
              child: Center(child: Text(context.l10n.continues, style: TextStyle(color: Colors.white),).p(10)),
            ).p(10),
          ),
        )
      ],
    );
  }

  _depositTimerDialog(int txnId) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) => StatusTimerDialog(
          callback: () {
            BlocProvider.of<DepositBloc>(context).add(
                GetStatusFromProviderApiEvent(
                    context: context,
                    txnId: txnId
                )
            );
          },
        )
    );
  }

  resetLoaderBtn() {
    mAnimatedButtonSize   = 300.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus   = ButtonShrinkStatus.over;
  }

}
