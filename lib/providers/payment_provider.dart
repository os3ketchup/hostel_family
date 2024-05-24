import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/network/http_result.dart';
import 'package:hostels/variables/links.dart';
import 'package:url_launcher/url_launcher.dart';

final paymentProvider = ChangeNotifierProvider<PaymentCounter>((ref) {
  return paymentCounter;
});

PaymentCounter? _paymentCounter;

PaymentCounter get paymentCounter {
  _paymentCounter ??= PaymentCounter();
  return _paymentCounter!;
}

class PaymentCounter with ChangeNotifier {
  Order? order;
  Repayment? repayment;
  List<Status>? statusList;
  String? barcode;

  PaymentCounter() {
    getAllOrder();
  }

  Future<dynamic> getBarcode(String orderId) async {
    MainModel result = await client.post(Links.getBarCode + orderId);
    if (result.status == 200) {
      if (result.data is String) {
        barcode = result.data;
        try {} catch (error) {
          print('this is error status: $error');
        }
      }
      if (result.data.toString().isEmpty) {
        barcode = '';
        print('data pustoy');
      }
    } else {
      print('else ${result.error}');
    }

    update();
  }

  Future<dynamic> getAllOrder() async {
    MainModel result = await client.get(Links.getAllOrder);
    if (result.status == 200) {
      if (result.data is List) {
        try {
          statusList =
              List<Status>.from(result.data.map((s) => Status.fromJSON(s)));
        } catch (error) {
          print('this is error status: $error');
          statusList = [];
        }
      }
      if (result.data.toString().isEmpty) {
        statusList = [];
        print('data pustoy');
      }
    } else {
      print('else');
      statusList = [];
    }

    update();
  }

  Future<dynamic> rePayment(String orderId) async {
    await client.post(Links.repayment + orderId).then(
      (value) {
        if (value.status == 200) {
          repayment = Repayment.fromJSON(value.data);
          launchUrl(
            Uri.parse(repayment!.paymentUrl),
            mode: LaunchMode.externalApplication,
          );
          update();
        }
      },
    );
  }

  Future<dynamic> payToRoom(
      {required String startDate,
      required String finishDate,
      required int selectedIndex,
      required String price,
      required String roomId}) async {
    await client.post(Links.order, data: {
      'room_id': roomId,
      'price': price,
      'payment_type': selectedIndex,
      'started_date': startDate,
      'finished_date': finishDate
    }).then(
      (value) {
        if (value.status == 200) {
          order = Order.fromJSON(value.data);
          launchUrl(
            Uri.parse(order!.paymentUrl),
            mode: LaunchMode.externalApplication,
          );
            paymentCounter.getAllOrder();
        }
      },
    );
    update();
  }

  void update() {
    notifyListeners();
  }
}

class Status {
  String id;
  String hotelName;
  String roomId;
  String price;
  String totalPrice;
  String orderStatusString;
  String orderStatusCode;
  String paymentStatusString;
  String paymentStatusCode;
  String paymentTypeString;
  String paymentTypeCode;
  String startedDate;
  String finishedDate;
  String day;
  String createdAt;

  Status(
      {required this.id,
      required this.hotelName,
      required this.finishedDate,
      required this.startedDate,
      required this.paymentStatusString,
      required this.paymentStatusCode,
      required this.price,
      required this.createdAt,
      required this.day,
      required this.orderStatusCode,
      required this.orderStatusString,
      required this.paymentTypeCode,
      required this.paymentTypeString,
      required this.roomId,
      required this.totalPrice});

  factory Status.fromJSON(Map<String, dynamic> json) {
    return Status(
        id: json['id'].toString(),
        finishedDate: json['finished_date'].toString(),
        startedDate: json['started_date'].toString(),
        price: json['price'].toString(),
        createdAt: json['created_at'].toString(),
        day: json['day'].toString(),
        roomId: json['room_id'].toString(),
        totalPrice: json['total_price'].toString(),
        paymentStatusString: json['payment_status_string'].toString(),
        paymentStatusCode: json['payment_status_code'].toString(),
        orderStatusCode: json['order_status_code'].toString(),
        orderStatusString: json['order_status_string'].toString(),
        paymentTypeCode: json['payment_type_code'].toString(),
        paymentTypeString: json['payment_type_string'].toString(),
        hotelName: json['hotel_name']);
  }
}

class Repayment {
  String paymentTypeName;
  int paymentType;
  String paymentUrl;

  Repayment(
      {required this.paymentType,
      required this.paymentUrl,
      required this.paymentTypeName});

  factory Repayment.fromJSON(Map<String, dynamic> json) {
    return Repayment(
        paymentType: json['paymentType'],
        paymentUrl: json['paymentUrl'],
        paymentTypeName: json['paymentTypeName']);
  }
}

class Order {
  String paymentName;
  int paymentType;
  String paymentUrl;
  String barcode;

  Order(
      {required this.paymentName,
      required this.paymentType,
      required this.paymentUrl,
      required this.barcode});

  factory Order.fromJSON(Map<String, dynamic> json) {
    return Order(
        paymentName: json['paymentTypeName'],
        paymentType: json['paymentType'],
        paymentUrl: json['paymentUrl']??'',
        barcode: json['barcode']??'');
  }
}
