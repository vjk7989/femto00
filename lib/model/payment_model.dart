class PaymentModel {
  FlutterWave? flutterWave;
  PayStack? payStack;
  Strip? strip;
  Wallet? wallet;
  MercadoPago? mercadoPago;
  RazorpayModel? razorpay;
  Paytm? paytm;
  Payfast? payfast;
  Wallet? cash;
  Paypal? paypal;

  PaymentModel({this.flutterWave, this.payStack, this.strip, this.wallet, this.mercadoPago, this.razorpay, this.paytm, this.payfast, this.cash, this.paypal});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    flutterWave = json['flutterWave'] != null ? FlutterWave.fromJson(json['flutterWave']) : null;
    payStack = json['payStack'] != null ? PayStack.fromJson(json['payStack']) : null;
    strip = json['strip'] != null ? Strip.fromJson(json['strip']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    mercadoPago = json['mercadoPago'] != null ? MercadoPago.fromJson(json['mercadoPago']) : null;
    razorpay = json['razorpay'] != null ? RazorpayModel.fromJson(json['razorpay']) : null;
    paytm = json['paytm'] != null ? Paytm.fromJson(json['paytm']) : null;
    payfast = json['payfast'] != null ? Payfast.fromJson(json['payfast']) : null;
    cash = json['cash'] != null ? Wallet.fromJson(json['cash']) : null;
    paypal = json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (flutterWave != null) {
      data['flutterWave'] = flutterWave!.toJson();
    }
    if (payStack != null) {
      data['payStack'] = payStack!.toJson();
    }
    if (strip != null) {
      data['strip'] = strip!.toJson();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (mercadoPago != null) {
      data['mercadoPago'] = mercadoPago!.toJson();
    }
    if (razorpay != null) {
      data['razorpay'] = razorpay!.toJson();
    }
    if (paytm != null) {
      data['paytm'] = paytm!.toJson();
    }
    if (payfast != null) {
      data['payfast'] = payfast!.toJson();
    }
    if (cash != null) {
      data['cash'] = cash!.toJson();
    }
    if (paypal != null) {
      data['paypal'] = paypal!.toJson();
    }
    return data;
  }
}

class FlutterWave {
  String? secretKey;
  bool? enable;
  String? name;
  String? publicKey;
  String? encryptionKey;
  bool? isSandbox;

  FlutterWave({this.secretKey, this.enable, this.name, this.publicKey, this.encryptionKey, this.isSandbox});

  FlutterWave.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    encryptionKey = json['encryptionKey'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['encryptionKey'] = encryptionKey;
    data['isSandbox'] = isSandbox;
    return data;
  }
}

class PayStack {
  String? secretKey;
  bool? enable;
  String? name;
  String? callbackURL;
  String? publicKey;
  bool? isSandbox;
  String? webhookURL;

  PayStack({this.secretKey, this.enable, this.name, this.callbackURL, this.publicKey, this.isSandbox, this.webhookURL});

  PayStack.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    callbackURL = json['callbackURL'];
    publicKey = json['publicKey'];
    isSandbox = json['isSandbox'];
    webhookURL = json['webhookURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['callbackURL'] = callbackURL;
    data['publicKey'] = publicKey;
    data['isSandbox'] = isSandbox;
    data['webhookURL'] = webhookURL;
    return data;
  }
}

class Strip {
  String? clientpublishableKey;
  String? stripeSecret;
  bool? enable;
  String? name;
  bool? isSandbox;

  Strip({this.clientpublishableKey, this.stripeSecret, this.enable, this.name, this.isSandbox});

  Strip.fromJson(Map<String, dynamic> json) {
    clientpublishableKey = json['clientpublishableKey'];
    stripeSecret = json['stripeSecret'];
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientpublishableKey'] = clientpublishableKey;
    data['stripeSecret'] = stripeSecret;
    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    return data;
  }
}

class Wallet {
  bool? enable;
  String? name;

  Wallet({this.enable, this.name});

  Wallet.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    return data;
  }
}

class MercadoPago {
  bool? enable;
  String? name;
  String? publicKey;
  String? accessToken;
  bool? isSandbox;

  MercadoPago({this.enable, this.name, this.publicKey, this.accessToken, this.isSandbox});

  MercadoPago.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    accessToken = json['accessToken'];
    isSandbox = json['isSandbox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['accessToken'] = accessToken;
    data['isSandbox'] = isSandbox;
    return data;
  }
}

class RazorpayModel {
  bool? enable;
  String? razorpayKey;
  bool? isSandbox;
  String? razorpaySecret;
  String? name;

  RazorpayModel({this.name, this.enable, this.razorpayKey, this.isSandbox, this.razorpaySecret});

  RazorpayModel.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    razorpayKey = json['razorpayKey'];
    isSandbox = json['isSandbox'];
    razorpaySecret = json['razorpaySecret'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['razorpayKey'] = razorpayKey;
    data['isSandbox'] = isSandbox;
    data['razorpaySecret'] = razorpaySecret;
    data['name'] = name;
    return data;
  }
}

class Paytm {
  bool? enable;
  String? paytmMID;
  bool? isSandbox;
  String? merchantKey;
  String? name;

  Paytm({this.name, this.enable, this.paytmMID, this.isSandbox, this.merchantKey});

  Paytm.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    paytmMID = json['paytmMID'];
    isSandbox = json['isSandbox'];
    merchantKey = json['merchantKey'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['paytmMID'] = paytmMID;
    data['isSandbox'] = isSandbox;
    data['merchantKey'] = merchantKey;
    data['name'] = name;
    return data;
  }
}

class Payfast {
  String? merchantId;
  bool? enable;
  String? name;
  String? returnUrl;
  String? notifyUrl;
  bool? isSandbox;
  String? cancelUrl;
  String? merchantKey;

  Payfast({this.merchantId, this.enable, this.name, this.returnUrl, this.notifyUrl, this.isSandbox, this.cancelUrl, this.merchantKey});

  Payfast.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    enable = json['enable'];
    name = json['name'];
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    isSandbox = json['isSandbox'];
    cancelUrl = json['cancel_url'];
    merchantKey = json['merchantKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['enable'] = enable;
    data['name'] = name;
    data['return_url'] = returnUrl;
    data['notify_url'] = notifyUrl;
    data['isSandbox'] = isSandbox;
    data['cancel_url'] = cancelUrl;
    data['merchantKey'] = merchantKey;
    return data;
  }
}

class Paypal {
  bool? enable;
  String? name;
  String? paypalSecret;
  String? paypalClient;
  String? image;
  bool? isSandbox;

  Paypal({this.name, this.enable, this.paypalSecret, this.isSandbox, this.paypalClient, this.image});

  Paypal.fromJson(Map<String, dynamic> json) {

    enable = json['enable'];
    name = json['name'];
    paypalSecret = json['paypalSecret'];
    paypalClient = json['paypalClient'];
    isSandbox = json['isSandbox'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['paypalSecret'] = paypalSecret;
    data['isSandbox'] = isSandbox;
    data['paypalClient'] = paypalClient;
    data['image'] = image;
    return data;
  }
}
