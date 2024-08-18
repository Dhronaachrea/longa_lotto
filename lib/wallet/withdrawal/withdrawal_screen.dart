import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_text_field.dart';
import 'package:longa_lotto/common/widget/longa_text_field_underline.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:longa_lotto/wallet/deposit/model/response/PaymentOptionsResponse.dart';
import 'package:longa_lotto/wallet/withdrawal/bloc/Withdrawal_bloc.dart';
import 'package:longa_lotto/wallet/withdrawal/bloc/withdrawal_event.dart';
import 'package:longa_lotto/wallet/withdrawal/bloc/withdrawal_state.dart';
import 'package:velocity_x/velocity_x.dart';

import '../deposit/model/response/ConvertToPgCurrencyResponse.dart';

class WithdrawalScreen extends StatefulWidget {
  Function(bool) mCallback;
  Function scrollInitCallBack;
  WithdrawalScreen({Key? key, required this.mCallback, required this.scrollInitCallBack}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  TextEditingController amountController      = TextEditingController();
  ShakeController amountShakeController       = ShakeController();
  TextEditingController accountNoController   = TextEditingController();
  ShakeController accountNoShakeController    = ShakeController();
  var autoValidate                      = AutovalidateMode.disabled;
  final _withdrawalForm                 = GlobalKey<FormState>();
  final _withdrawalAccountNoForm        = GlobalKey<FormState>();
  bool isButtonPressed    = false;
  bool afterNetGone       = false;
  Map<String,dynamic>? payTypeMapResponse;
  List<PaymentOptionsResponse>? paymentOptionList = [];
  String? selectedSubTypeId;
  String? selectedPayTypeId;
  String? currencyCode;
  int? selectedIndex;
  int? selectedPaymentIndex;
  double minValue = 0.0;
  double maxValue = 0.0;
  late String _selectedPaymentType;
  bool isLoading = false;
  bool isDialogLoading = false;
  double mAnimatedButtonSize              = 300.0;
  bool mButtonTextVisibility              = true;
  ButtonShrinkStatus mButtonShrinkStatus  = ButtonShrinkStatus.notStarted;
  Data? currencyConverterResponse;
  bool showAmountDetails    = false;
  bool showOtherOptions     = false;
  bool isPaymentOptionError = false;
  bool absorber = false;

  final FocusNode focusNode = FocusNode();
  TextEditingController withdrawalAmountController = TextEditingController();
  double mAnimatedButtonSize2 = 280.0;
  double mAnimatedButtonHeight = 50.0;
  bool isLoggingIn = false;
  bool mButtonTextVisibility2 = true;
  ButtonShrinkStatus mButtonShrinkStatus2 = ButtonShrinkStatus.notStarted;
  var scrollController = ScrollController();

  @override
  void initState() {

    print("--------------------->withdrawal");
    NetworkSingleton().setNetworkListener(context);
    BlocProvider.of<WithdrawalBloc>(context).add(PaymentOptionsApiEvent(context: context));
    amountController.addListener(() {
      if(amountController.text.isEmpty) {
        setState(() {
          selectedIndex = null;
          showAmountDetails = false;
        });
      } else {
        if (amountController.text.isNotEmpty && selectedPaymentIndex != null) {
          // callConvertToPgCurrencyApi();
        }
      }
    });
    withdrawalAmountController.text = UserInfo.totalBalance.toString();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(focusNode);
    /*String? withdrawalBal = UserInfo.withdrawalBalance.toString();// total balance
    withdrawalAmountController.text = withdrawalBal;*/
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
              BlocProvider.of<WithdrawalBloc>(context).add(PaymentOptionsApiEvent(context: context));
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: BlocListener<WithdrawalBloc, WithdrawalState>(
        listener: (context, state) {
          setState(() {
            if(state is WithdrawalLoading){
              absorber = true;
              widget.mCallback(true);
              isLoading = true;
            }
            else if (state is PaymentOptionsSuccess) {
              try{
                isLoading = false;
                absorber = false;
                widget.mCallback(false);
                paymentOptionList = [];
                accountNoController.text = UserInfo.mobNumber;
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
                    _selectedPaymentType = paymentOptionList?[0].payTypeDispCode ?? "Mobile Money";
                    isPaymentOptionError = false;
                  }

                }
              } catch(e){
                setState(() {
                  isLoading = false;
                  isPaymentOptionError = true;
                  ShowToast.showToast(context, context.l10n.something_went_wrong, type: ToastType.ERROR);
                });
              }

            }
            else if (state is PaymentOptionsError) {
              isLoading = false;
              isPaymentOptionError = true;
              absorber = false;
              widget.mCallback(false);
              if(state.errorCode != 1109) {
                ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
              }
            }

            else if ( state is ConvertToPgCurrencySuccess) {
              withdrawalDialog();
              setState(() {
                resetLoaderBtn();
                currencyConverterResponse = state.response?.data;
                showAmountDetails = true;
                absorber = false;
                widget.mCallback(false);
              });
            }
            else if ( state is ConvertToPgCurrencyError) {
              resetLoaderBtn();
              absorber = false;
              widget.mCallback(false);
              if(state.errorCode != 1109) {
                ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
              }
            }

            else if( state is ScanWithdrawalRequestError) {
              resetLoader();
              setState(() {
                isLoggingIn = false;
              });
              ShowToast.showToast(context, state.errorMessage ?? "", type: ToastType.ERROR);
            }
            else if ( state is ScanWithdrawalRequestSuccess) {
              resetLoader();
              /*setState(() {
                isLoggingIn = false;
              });*/
              if (UserInfo.isLoggedIn()) {
                fetchHeaderInfo(navigatorKey.currentContext ?? context);
              }
              withdrawalAmountController.text = "0.0";
              Navigator.of(context).pop();
              BlocProvider.of<AuthBloc>(context).add(UserLogout(),);
              ShowToast.showToast(context, context.l10n.withdrawal_request_initiated_successfully, type: ToastType.SUCCESS);

            }
          });
        },
        child: AbsorbPointer(
          absorbing: absorber,
          child: Column(
            children: [
              HeightBox(20),
              (paymentOptionList?.isNotEmpty == true && paymentOptionList != null)
                  ? Column(
                children: [
                  _paymentType((paymentOptionList?.isNotEmpty == true) ? paymentOptionList ?? [] : []),
                  _paymentOptionList(),
                  //showAmountDetails ? _chargesDetailCard() : Container(),
                ],
              )
                  : isPaymentOptionError
                  ? Center(child: Text(context.l10n.withdrawal_option_not_available, style: TextStyle(fontSize: 16),))
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

              showOtherOptions
                  ? (UserInfo.getAliasNameScan.contains("scan"))
                    ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: LongaTextField(
                                maxLength: 8,
                                inputType: TextInputType.number,
                                hintText: context.l10n.withdrawal_amount,
                                focusNode: focusNode,
                                autoFocus: true,
                                readOnly: true,
                                enabled: false,
                                fillColor: LongaColor.warm_grey.withOpacity(0.2),
                                controller: withdrawalAmountController,
                                obscureText: false,
                                showCursor: false,
                                prefix: const Icon(
                                  Icons.wallet,
                                  color: LongaColor.shamrock_green,
                                ),
                              ).pSymmetric(v: 8),
                            ),
                          ),

                          //_submitButton()
                          InkWell(
                            onTap: () {
                              setState(() {
                                mAnimatedButtonSize2 = 50.0;
                                mButtonTextVisibility2 = false;
                                mButtonShrinkStatus2 = ButtonShrinkStatus.notStarted;
                              });
                              // ShowToast.showToast(context, "checking");
                              BlocProvider.of<WithdrawalBloc>(context).add(
                                  ScanWithdrawalInitiateRequestApiEvent(
                                  context: context,
                                  amount: double.parse(withdrawalAmountController.text.trim()).toString(),        // currencyConverterResponse?.netConvertedAmount.toString().trim() ?? "",
                                  pgCurrencyCode: currencyCode ?? "CDF",//currencyCode
                                  paymentTypeId: int.parse(selectedPayTypeId ?? "0"),
                                  subTypeId: int.parse(selectedSubTypeId ?? "0"),
                                  accNum: accountNoController.text.trim()
                              ));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: LongaColor.tangerine,
                                    borderRadius: BorderRadius.circular(60),
                                ),
                                child: AnimatedContainer(
                                  width: mAnimatedButtonSize2,
                                  height: 50,
                                  onEnd: () {
                                    setState(() {
                                      if (mButtonShrinkStatus2 != ButtonShrinkStatus.over) {
                                        mButtonShrinkStatus2 = ButtonShrinkStatus.started;
                                      } else {
                                        mButtonShrinkStatus2 = ButtonShrinkStatus.notStarted;
                                      }
                                    });
                                  },
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 200),
                                  child: SizedBox(
                                      width: mAnimatedButtonSize2,
                                      height: mAnimatedButtonHeight,
                                      child: mButtonShrinkStatus2 == ButtonShrinkStatus.started
                                          ? Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: CircularProgressIndicator(color: LongaColor.white),
                                            )
                                          : Center(
                                                  child: Visibility(
                                                    visible: mButtonTextVisibility2,
                                                    child: Text(
                                                      context.l10n.proceed,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w800,
                                                        color: LongaColor.white,
                                                      ),
                                                    ),
                                                  )
                                              )
                                          ),
                                )),
                          ).pOnly(top: 30)
                        ],
                      ).pOnly(top: 90),
                    )
                    : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _accountNoField(),
                    HeightBox(20),
                    _amountField(),
                    HeightBox(40),
                    _submitButton()

                  ],
                ),
              ).pOnly(top: 30)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.accountNo:
        var amountText = accountNoController.text.trim();
        if (amountText.isEmpty) {
          return context.l10n.please_enter_your_account_no;
        }
        break;
      case TotalTextFields.amount:
        var amountText = amountController.text.trim();
        if (amountText.isEmpty) {
          return context.l10n.please_enter_a_amount;
        }
        break;
      case TotalTextFields.mobileNumber:
      // TODO: Handle this case.
        break;
      case TotalTextFields.password:
      // TODO: Handle this case.
        break;
      case TotalTextFields.confirmPassword:
      // TODO: Handle this case.
        break;
      case TotalTextFields.oldPassword:
      // TODO: Handle this case.
        break;
      case TotalTextFields.otp:
      // TODO: Handle this case.
        break;
      case TotalTextFields.userName:
      // TODO: Handle this case.
        break;
    }
    return "";
  }

  _amountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            context.l10n.withdrawal_amount,
            textAlign: TextAlign.start,
            style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18
            )
        ).pOnly(left: 10),
        Form(
          key: _withdrawalForm,
          autovalidateMode: autoValidate,
          child: ShakeWidget(
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
          ),
        ),
      ],
    );
  }

  _accountNoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            context.l10n.withdrawal_account_no,
            textAlign: TextAlign.start,
            style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18
            )
        ).pOnly(left: 10),
        Form(
          key: _withdrawalAccountNoForm,
          autovalidateMode: autoValidate,
          child: ShakeWidget(
            controller: accountNoShakeController,
            child: LongaTextFieldUnderline(
              maxLength: 20,
              labelFontSize: 18,
              inputType: TextInputType.number,
              hintText: "+243",
              controller: accountNoController,
              enabled: false,
              validator: (value) {
                if (validateInput(TotalTextFields.accountNo).isNotEmpty) {
                  if (isButtonPressed) {
                    accountNoShakeController.shake();
                  }
                  return validateInput(TotalTextFields.accountNo);
                } else {
                  return null;
                }
              },
            ).pSymmetric(v: 8,h: 20),
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
                  showOtherOptions = false;
                  currencyCode = "CDF";
                  selectedPaymentIndex = null;
                  showAmountDetails = false;
                  _selectedPaymentType = selectedItem.toString();
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
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            itemCount: newPaymentOptionList.subTypeMap?.length ?? 0,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    showOtherOptions = true;
                    selectedSubTypeId = newPaymentOptionList?.subTypeMap?[index].id ?? "";
                    selectedPayTypeId = (newPaymentOptionList?.payTypeId.toString() ?? "");
                    currencyCode = newPaymentOptionList?.subTypeMap?[index].currency ?? "USD";
                    selectedPaymentIndex = int.parse("$index");
                    maxValue = newPaymentOptionList?.maxValue ?? 0;
                    minValue = newPaymentOptionList?.minValue ?? 0;
                    amountController.text = "";
                    hideKeyboard();
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
                          "assets/icons/${(newPaymentOptionList?.payTypeCode ?? "mobile_money").toLowerCase()}.png",
                          width: 45,
                          height: 45,
                        ).pOnly(left: 10),
                        Text(
                          newPaymentOptionList?.subTypeMap?[index].value?.replaceAll("_", " ") ?? "" ,
                          style: TextStyle(
                              fontSize: 18,
                              color: (selectedPaymentIndex == int.parse("$index")) ? Colors.red : Colors.grey,
                              fontWeight: FontWeight.w500
                          ),
                          textAlign: TextAlign.center,
                        ).p(12),
                      ],
                    ),
                  ),
                ).p(4),
              );
            },
          ),
        ),
      ],
    );
  }

  _submitButton() {
    return Column(
      children: [
        AbsorbPointer(
          absorbing: !mButtonTextVisibility,
          child: InkWell(
            onTap: () {
              setState(() {
                isButtonPressed = true;
              });
              Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  isButtonPressed = false;
                });
              });

              if (_withdrawalAccountNoForm.currentState!.validate() && _withdrawalForm.currentState!.validate() ) {
                if (selectedSubTypeId?.isNotEmpty == true) {
                    if ((int.parse(amountController.text.trim()) >= minValue) && (int.parse(amountController.text.trim()) <= maxValue) ) {
                      setState((){
                        mAnimatedButtonSize   = 50.0;
                        mButtonTextVisibility = false;
                      });
                      callConvertToPgCurrencyApi();
                    } else {
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
          ),
        )
      ],
    );
  }

  _chargesDetailCard() {
    double creditedAmount = (int.parse(amountController.text.trim()) + (currencyConverterResponse?.processChargeValue ?? 0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          context.l10n.amount_to_be_deduct,
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
          "$currencyCode ${(currencyConverterResponse?.processChargeValue ?? 0.0)}",
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
          context.l10n.amount_to_be_credited,
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
    BlocProvider.of<WithdrawalBloc>(context).add(
        ConvertToPgCurrencyApiEvent(
            context: context,
            amount: int.parse(amountController.text.trim()),
            reqAmtCurrencyCode: currencyCode ?? "",
            paymentTypeId: int.parse(selectedPayTypeId ?? "0"),
            subTypeId: int.parse(selectedSubTypeId ?? "0"),
        )
    );
  }

  resetLoaderBtn() {
    mAnimatedButtonSize   = 300.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus   = ButtonShrinkStatus.over;
  }

  resetLoader() {// scanner login
    setState(() {
      mAnimatedButtonSize2 = 280.0;
      mButtonTextVisibility2 = true;
      mButtonShrinkStatus2 = ButtonShrinkStatus.over;
    });
  }

  resetFields() {
    selectedSubTypeId         = null;
    selectedIndex             = null;
    selectedPaymentIndex      = null;
    amountController.text     = "";
    // accountNoController.text  = "";
  }

  withdrawalDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => BlocProvider<WithdrawalBloc>(
          create: (context) => WithdrawalBloc(),
          child: StatefulBuilder(
            builder: (BuildContext context,  StateSetter setState) {
              return BlocListener<WithdrawalBloc, WithdrawalState>(
                listener: (context, state) {
                  if (state is WithdrawalRequestLoading){
                    setState((){
                      isDialogLoading = true;
                    });
                    setState(() {
                      mAnimatedButtonSize2 = 50.0;
                      mButtonTextVisibility2 = false;
                      mButtonShrinkStatus2 = ButtonShrinkStatus.notStarted;
                    });
                  }
                  else if (state is WithdrawalRequestSuccess) {
                    resetFields();
                    if (UserInfo.isLoggedIn()) {
                      fetchHeaderInfo(navigatorKey.currentContext ?? context);
                    }
                    setState(() {
                      widget.scrollInitCallBack();
                      Navigator.pop(context);
                      isDialogLoading = false;
                      showOtherOptions = false;
                      ShowToast.showToast(context, context.l10n.successfully_withdrawal, type: ToastType.SUCCESS);
                    });
                  }
                  else if (state is WithdrawalRequestError) {
                    resetFields();
                    if (UserInfo.isLoggedIn()) {
                      fetchHeaderInfo(navigatorKey.currentContext ?? context);
                    }
                    setState(() {
                      widget.scrollInitCallBack();
                      isDialogLoading = false;
                      showOtherOptions = false;
                    });
                    Navigator.pop(context);
                    ShowToast.showToast(context, context.l10n.withdrawal_failed, type: ToastType.ERROR);
                  }
                },
                child: Container(
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
                              _withdrawalDialogTitle(),
                              const HeightBox(20),
                              _chargesDetailCard()
                            ],
                          ).pOnly(right: 10),
                          const HeightBox(10),

                          isDialogLoading ? CircularProgressIndicator() : _withdrawalButtons(context),
                          const HeightBox(10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
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

  _withdrawalDialogTitle() {
    return Text(
      context.l10n.withdrawal_amount,
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

  _withdrawalButtons(BuildContext context) {
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

              if (UserInfo.totalBalance < (int.parse(amountController.text.trim()) + (currencyConverterResponse?.processChargeValue ?? 0))) {
                ShowToast.showToast(context, context.l10n.insufficient_balance, type: ToastType.ERROR);
              } else {
                BlocProvider.of<WithdrawalBloc>(context).add(
                    WithdrawalRequestApiEvent(
                        context: context,
                        amount: int.parse(amountController.text.trim()).toString(),        // currencyConverterResponse?.netConvertedAmount.toString().trim() ?? "",
                        pgCurrencyCode: currencyCode ?? "CDF",//currencyCode
                        paymentTypeId: int.parse(selectedPayTypeId ?? "0"),
                        subTypeId: int.parse(selectedSubTypeId ?? "0"),
                        accNum: accountNoController.text.trim()
                    )
                );
              }

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

}
