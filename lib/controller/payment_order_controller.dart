import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/send_notification.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/model/coupon_model.dart';
import 'package:customer/model/driver_user_model.dart';
import 'package:customer/model/order_model.dart';
import 'package:customer/model/payment_model.dart';
import 'package:customer/model/stripe_failed_model.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/model/wallet_transaction_model.dart';
import 'package:customer/payment/MercadoPagoScreen.dart';
import 'package:customer/payment/PayFastScreen.dart';
import 'package:customer/payment/getPaytmTxtToken.dart';
import 'package:customer/payment/paystack/pay_stack_screen.dart';
import 'package:customer/payment/paystack/pay_stack_url_model.dart';
import 'package:customer/payment/paystack/paystack_url_genrater.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentOrderController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    getPaymentData();
    super.onInit();
  }

  Rx<OrderModel> orderModel = OrderModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
    }
    update();
  }

  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;

  RxString selectedPaymentMethod = "".obs;

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;

        Stripe.publishableKey = paymentModel.value.strip!.clientpublishableKey.toString();
        Stripe.merchantIdentifier = 'GoRide';
        Stripe.instance.applySettings();
        setRef();
        selectedPaymentMethod.value = orderModel.value.paymentType.toString();

        razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
        razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
        razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      }
    });

    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });
    await FireStoreUtils.getDriver(orderModel.value.driverId.toString()).then((value) {
      if (value != null) {
        driverUserModel.value = value;
      }
    });
    isLoading.value = false;
    update();
  }

  completeOrder() async {
    ShowToastDialog.showLoader("Please wait..");
    orderModel.value.paymentStatus = true;
    orderModel.value.paymentType = selectedPaymentMethod.value;
    orderModel.value.status = Constant.rideComplete;
    orderModel.value.coupon = selectedCouponModel.value;
    orderModel.value.updateDate = Timestamp.now();

    WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: calculateAmount().toString(),
        createdDate: Timestamp.now(),
        paymentType: selectedPaymentMethod.value,
        transactionId: orderModel.value.id,
        userId: orderModel.value.driverId.toString(),
        orderType: "city",
        userType: "driver",
        note: "Ride amount credited");

    await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateDriverWallet(amount: calculateAmount().toString(), driverId: orderModel.value.driverId.toString());
      }
    });

    WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
        id: Constant.getUuid(),
        amount:
            "-${Constant.calculateOrderAdminCommission(amount: (double.parse(orderModel.value.finalRate.toString()) - double.parse(couponAmount.value.toString())).toString(), adminCommission: orderModel.value.adminCommission)}",
        createdDate: Timestamp.now(),
        paymentType: selectedPaymentMethod.value,
        transactionId: orderModel.value.id,
        orderType: "city",
        userType: "driver",
        userId: orderModel.value.driverId.toString(),
        note: "Admin commission debited");

    await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateDriverWallet(
            amount:
                "-${Constant.calculateOrderAdminCommission(amount: (double.parse(orderModel.value.finalRate.toString()) - double.parse(couponAmount.value.toString())).toString(), adminCommission: orderModel.value.adminCommission)}",
            driverId: orderModel.value.driverId.toString());
      }
    });

    if (driverUserModel.value.fcmToken != null) {
      Map<String, dynamic> playLoad = <String, dynamic>{"type": "city_order_payment_complete", "orderId": orderModel.value.id};

      await SendNotification.sendOneNotification(
          token: driverUserModel.value.fcmToken.toString(),
          title: 'Payment Received',
          body: '${userModel.value.fullName}  has paid ${Constant.amountShow(amount: calculateAmount().toString())} for the completed ride.Check your earnings for details.',
          payload: playLoad);
    }

    await FireStoreUtils.getFirestOrderOrNOt(orderModel.value).then((value) async {
      if (value == true) {
        await FireStoreUtils.updateReferralAmount(orderModel.value);
      }
    });

    await FireStoreUtils.setOrder(orderModel.value).then((value) {
      if (value == true) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Ride Complete successfully");
      }
    });
  }

  completeCashOrder() async {
    orderModel.value.paymentType = selectedPaymentMethod.value;
    orderModel.value.status = Constant.rideComplete;
    orderModel.value.coupon = selectedCouponModel.value;

    await SendNotification.sendOneNotification(
        token: driverUserModel.value.fcmToken.toString(), title: 'Payment changed.', body: '${userModel.value.fullName} has changed payment method.', payload: {});

    FireStoreUtils.setOrder(orderModel.value).then((value) {
      if (value == true) {
        ShowToastDialog.showToast("Payment method update successfully");
      }
    });
  }

  Rx<CouponModel> selectedCouponModel = CouponModel().obs;
  RxString couponAmount = "0.0".obs;

  double calculateAmount() {
    RxString taxAmount = "0.0".obs;
    if (orderModel.value.taxList != null) {
      for (var element in orderModel.value.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) +
                Constant().calculateTax(amount: (double.parse(orderModel.value.finalRate.toString()) - double.parse(couponAmount.value.toString())).toString(), taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(orderModel.value.finalRate.toString()) - double.parse(couponAmount.value.toString())) + double.parse(taxAmount.value);
  }

  // Strip
  Future<void> stripeMakePayment({required String amount}) async {
    log(double.parse(amount).toStringAsFixed(0));
    try {
      Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: amount);
      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData['client_secret'],
                allowsDelayedPaymentMethods: false,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  testEnv: true,
                  currencyCode: "USD",
                ),
                style: ThemeMode.system,
                appearance: const PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    primary: AppColors.primary,
                  ),
                ),
                merchantDisplayName: 'GoRide'));
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        Get.back();
        ShowToastDialog.showToast("Payment successfully");
        completeOrder();
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": userModel.value.fullName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      log(paymentModel.value.strip!.stripeSecret.toString());
      var stripeSecret = paymentModel.value.strip!.stripeSecret;
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body, headers: {'Authorization': 'Bearer $stripeSecret', 'Content-Type': 'application/x-www-form-urlencoded'});

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  //mercadoo
  mercadoPagoMakePayment({required BuildContext context, required String amount}) {
    makePreference(amount).then((result) async {
      if (result.isNotEmpty) {
        var preferenceId = result['response']['id'];
        log(result.toString());
        log(preferenceId);

        Get.to(MercadoPagoScreen(initialURl: result['response']['init_point']))!.then((value) {
          log(value);

          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            completeOrder();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
        // final bool isDone = await Navigator.push(context, MaterialPageRoute(builder: (context) => MercadoPagoScreen(initialURl: result['response']['init_point'])));
      } else {
        ShowToastDialog.showToast("Error while transaction!");
      }
    });
  }

  Future<Map<String, dynamic>> makePreference(String amount) async {
    final mp = MP.fromAccessToken(paymentModel.value.mercadoPago!.accessToken);
    var pref = {
      "items": [
        {"title": "Wallet TopUp", "quantity": 1, "unit_price": double.parse(amount)}
      ],
      "auto_return": "all",
      "back_urls": {"failure": "${Constant.globalUrl}payment/failure", "pending": "${Constant.globalUrl}payment/pending", "success": "${Constant.globalUrl}payment/success"},
    };

    var result = await mp.createPreference(pref);
    return result;
  }

  //paypal

  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  void initPayPal() async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode = paymentModel.value.paypal!.isSandbox == true ? true : false;

    //initiate payPal plugin
    await _flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: "com.parkme://paypalpay",
      //client id from developer dashboard
      clientID: paymentModel.value.paypal!.paypalClient.toString(),
      //sandbox, staging, live etc
      payPalEnvironment: paymentModel.value.paypal!.isSandbox == true ? FPayPalEnvironment.sandbox : FPayPalEnvironment.live,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          //user canceled the payment
          ShowToastDialog.showToast("Payment canceled");
        },
        onSuccess: (data) {
          //successfully paid
          //remove all items from queue
          // _flutterPaypalNativePlugin.removeAllPurchaseItems();
          ShowToastDialog.showToast("Payment Successful!!");
          completeOrder();
        },
        onError: (data) {
          //an error occured
          ShowToastDialog.showToast("error: ${data.reason}");
        },
        onShippingChange: (data) {
          //the user updated the shipping address
          ShowToastDialog.showToast("shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
        },
      ),
    );
  }

  paypalPaymentSheet(String amount) {
    //add 1 item to cart. Max is 4!
    if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      _flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          // random prices
          amount: double.parse(amount),

          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: FPayPalStrHelper.getRandomString(16),
        ),
      );
    }
    // initPayPal();
    _flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
  }

  ///PayStack Payment Method
  payStackPayment(String totalAmount) async {
    await PayStackURLGen.payStackURLGen(
            amount: (double.parse(totalAmount) * 100).toString(), currency: "NGN", secretKey: paymentModel.value.payStack!.secretKey.toString(), userModel: userModel.value)
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        Get.to(PayStackScreen(
          secretKey: paymentModel.value.payStack!.secretKey.toString(),
          callBackUrl: paymentModel.value.payStack!.callbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            completeOrder();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      }
    });
  }

  //flutter wave Payment Method
  flutterWaveInitiatePayment({required BuildContext context, required String amount}) async {
    final flutterWave = Flutterwave(
      amount: amount.trim(),
      currency: "NGN",
      customer: Customer(name: userModel.value.fullName, phoneNumber: userModel.value.phoneNumber, email: userModel.value.email.toString()),
      context: context,
      publicKey: paymentModel.value.flutterWave!.publicKey.toString().trim(),
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(title: "GoRide"),
      txRef: _ref!,
      isTestMode: paymentModel.value.flutterWave!.isSandbox!,
      redirectUrl: '${Constant.globalUrl}success',
      paymentPlanId: _ref!,
    );
    final ChargeResponse response = await flutterWave.charge();

    if (response.success!) {
      ShowToastDialog.showToast("Payment Successful!!");
      completeOrder();
    } else {
      ShowToastDialog.showToast(response.status!);
    }
  }

  String? _ref;

  setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  // payFast
  payFastPayment({required BuildContext context, required String amount}) {
    PayStackURLGen.getPayHTML(payFastSettingData: paymentModel.value.payfast!, amount: amount.toString(), userModel: userModel.value).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(htmlData: value!, payFastSettingData: paymentModel.value.payfast!));
      if (isDone) {
        Get.back();
        ShowToastDialog.showToast("Payment successfully");
        completeOrder();
      } else {
        Get.back();
        ShowToastDialog.showToast("Payment Failed");
      }
    });
  }

  ///Paytm payment function
  getPaytmCheckSum(context, {required double amount}) async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    String getChecksum = "${Constant.globalUrl}payments/getpaytmchecksum";

    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paymentModel.value.paytm!.paytmMID.toString(),
          "order_id": orderId,
          "key_secret": paymentModel.value.paytm!.merchantKey.toString(),
        });

    final data = jsonDecode(response.body);
    print(paymentModel.value.paytm!.paytmMID.toString());

    await verifyCheckSum(checkSum: data["code"], amount: amount, orderId: orderId).then((value) {
      initiatePayment(amount: amount, orderId: orderId).then((value) {
        String callback = "";
        if (paymentModel.value.paytm!.isSandbox == true) {
          callback = "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        } else {
          callback = "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
        }

        if (value.head.version.isEmpty) {
          ShowToastDialog.showToast("Payment Failed");
        } else {
          GetPaymentTxtTokenModel result = value;
          startTransaction(context, txnTokenBy: result.body.txnToken, orderId: orderId, amount: amount, callBackURL: callback, isStaging: paymentModel.value.paytm!.isSandbox);
        }
      });
    });
  }

  Future<void> startTransaction(context, {required String txnTokenBy, required orderId, required double amount, required callBackURL, required isStaging}) async {
    try {
      var response = AllInOneSdk.startTransaction(
        paymentModel.value.paytm!.paytmMID.toString(),
        orderId,
        amount.toString(),
        txnTokenBy,
        callBackURL,
        isStaging,
        true,
        true,
      );

      response.then((value) {
        if (value!["RESPMSG"] == "Txn Success") {
          print("txt done!!");
          ShowToastDialog.showToast("Payment Successful!!");
          completeOrder();
        }
      }).catchError((onError) {
        if (onError is PlatformException) {
          Get.back();

          ShowToastDialog.showToast(onError.message.toString());
        } else {
          print("======>>2");
          Get.back();
          ShowToastDialog.showToast(onError.message.toString());
        }
      });
    } catch (err) {
      Get.back();
      ShowToastDialog.showToast(err.toString());
    }
  }

  Future verifyCheckSum({required String checkSum, required double amount, required orderId}) async {
    String getChecksum = "${Constant.globalUrl}payments/validatechecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        headers: {},
        body: {
          "mid": paymentModel.value.paytm!.paytmMID.toString(),
          "order_id": orderId,
          "key_secret": paymentModel.value.paytm!.merchantKey.toString(),
          "checksum_value": checkSum,
        });
    final data = jsonDecode(response.body);
    return data['status'];
  }

  Future<GetPaymentTxtTokenModel> initiatePayment({required double amount, required orderId}) async {
    String initiateURL = "${Constant.globalUrl}payments/initiatepaytmpayment";
    String callback = "";
    if (paymentModel.value.paytm!.isSandbox == true) {
      callback = "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    } else {
      callback = "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    }
    final response = await http.post(Uri.parse(initiateURL), headers: {}, body: {
      "mid": paymentModel.value.paytm!.paytmMID,
      "order_id": orderId,
      "key_secret": paymentModel.value.paytm!.merchantKey,
      "amount": amount.toString(),
      "currency": "INR",
      "callback_url": callback,
      "custId": FireStoreUtils.getCurrentUid(),
      "issandbox": paymentModel.value.paytm!.isSandbox == true ? "1" : "2",
    });
    print(response.body);
    final data = jsonDecode(response.body);
    if (data["body"]["txnToken"] == null || data["body"]["txnToken"].toString().isEmpty) {
      Get.back();
      ShowToastDialog.showToast("something went wrong, please contact admin.");
    }
    return GetPaymentTxtTokenModel.fromJson(data);
  }

  ///RazorPay payment function
  final Razorpay razorPay = Razorpay();

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': paymentModel.value.razorpay!.razorpayKey,
      'amount': amount * 100,
      'name': 'GoRide',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': userModel.value.phoneNumber,
        'email': userModel.value.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Successful!!");
    completeOrder();
  }

  void handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Processing!! via");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    // RazorPayFailedModel lom = RazorPayFailedModel.fromJson(jsonDecode(response.message!.toString()));
    ShowToastDialog.showToast("Payment Failed!!");
  }
}
