import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/providers/hotels_provider.dart';
import 'package:hostels/providers/room_provider.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/ui/home/detail_room/order/order_appbar.dart';
import 'package:hostels/variables/fonts.dart';
import 'package:hostels/variables/icons.dart';
import 'package:hostels/variables/images.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../../../../providers/payment_provider.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen(
      {super.key, required this.status, required this.barcode});

  final Status status;
  final String barcode;

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    hostelsCounter.getHostelsList();
    super.initState();
  }

  Hostels getRoomById(Status status) {
    var hostel = hostelsCounter.hostelsList!
        .where((hostel) => hostel.name == status.hotelName)
        .toList()
        .first;
    return hostel;
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
        if (!await directory!.exists()) {
          directory = await getDownloadsDirectory();
        }
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<void> savePdf() async {
    final fontData = await rootBundle.load(FontAssets.comforta);
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final fontDataRegular = await rootBundle.load(FontAssets.light);
    final regularTtf = pw.Font.ttf(fontDataRegular.buffer.asByteData());
    // Create a PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            margin: pw.EdgeInsets.symmetric(horizontal: 12.o),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(geust.tr, style: pw.TextStyle(font: regularTtf)),
                    pw.Text(
                      '${userCounter.appUser!.firstName} ${userCounter.appUser!.lastName} (id: ${userCounter.appUser!.id})',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(startDate.tr,
                        style: pw.TextStyle(font: regularTtf)),
                    pw.Text(widget.status.startedDate,
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(finishDate.tr,
                        style: pw.TextStyle(font: regularTtf)),
                    pw.Text(widget.status.finishedDate,
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(typePayment.tr,
                        style: pw.TextStyle(font: regularTtf)),
                    pw.Text(widget.status.paymentTypeString,
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(orderId.tr,
                        style: pw.TextStyle(font: regularTtf)),
                    pw.Text(widget.status.id, style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(total.tr,
                        style: pw.TextStyle(font: regularTtf)),
                    pw.Text(widget.status.price,
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(hotel.tr,
                        style: pw.TextStyle(font: regularTtf)),
                    pw.Text(widget.status.roomId,
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.BarcodeWidget(
                  textStyle: pw.TextStyle(font: regularTtf),
                  barcode: pw.Barcode.code128(),
                  data: widget.barcode,
                  color: PdfColors.black,
                  height: 100,
                  width: 300,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Get the directory for saving the file
    getDownloadPath().then((value) async {
    final filePath = '$value/hostel-check.pdf';

    // Save the PDF file

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print(filePath);

      // Open the saved PDF file
      OpenFile.open(filePath);
    });
  }

  Future<void> checkPermissionAndSavePdf(BuildContext context) async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    int androidVersion = 0;

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      androidVersion = androidInfo.version.sdkInt;
    }

    if (androidVersion >= 30) {
      // If the device is running Android 13 (API level 30) or higher,
      // the permission is not needed as per scoped storage.
      await savePdf();
      return;
    }

    // Check if permission is granted
    if (await Permission.storage.request().isGranted) {
      // If permission is granted, save the PDF
      await savePdf();
    } else {
      // If permission is not granted, request it again
      PermissionStatus status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        // If the user permanently denied the permission, display a message
        // or navigate to the app settings to enable the permission manually.
        openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    ThemeData mTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: mTheme.colorScheme.background,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.o),
          child: OrderAppBar(
            titleAppbar: permission.tr,
            onBackPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Stack(
        children: [
          Container(
            height: height * 0.75,
            // padding: EdgeInsets.symmetric(horizontal: 28.o,vertical: 12.o),
            decoration: BoxDecoration(
                color: mTheme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.o)),
            margin: EdgeInsets.symmetric(horizontal: 12.o, vertical: 12.o),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 120.o),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(10.o),
                  Row(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.o, vertical: 12.o),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.o)),
                        width: 40,
                        height: 40,
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(getRoomById(widget.status).image),
                          height: 40.o,
                          width: 40.o,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(20.o),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.status.hotelName,
                            style: theme.primaryTextStyle.copyWith(
                                color: mTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.status.roomId,
                            style: theme.hintTextFieldStyle
                                .copyWith(color: mTheme.colorScheme.secondary),
                          ),
                        ],
                      )
                    ],
                  ),
                  Gap(10.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    width: double.infinity,
                    color: theme.primaryColor.withOpacity(0.1),
                    height: 1,
                  ),
                  Gap(20.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enter.tr,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color),
                            ),
                            Text(
                              widget.status.startedDate,
                              style: theme.primaryTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: mTheme.textTheme.bodyMedium!.color),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.o, vertical: 6.o),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.o,
                                  color: theme.primaryColor.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(18.o)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                SVGIcons.moon,
                                color: mTheme.colorScheme.primary,
                              ),
                              Gap(10.o),
                              Text(
                                widget.status.day,
                                style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.textTheme.bodyMedium!.color),
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exit.tr,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color),
                            ),
                            Text(
                              widget.status.finishedDate,
                              style: theme.primaryTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: mTheme.textTheme.bodyMedium!.color),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(20.o),
                  // Container(
                  //   width: double.infinity,
                  //   color: theme.primaryColor.withOpacity(0.1),
                  //   height: 1,
                  // ),
                  // Gap(10.o),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               SvgPicture.asset(SVGIcons.restaurant),
                  //               Gap(10.o),
                  //               Text(
                  //                 'ds',
                  //                 style: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.secondary),
                  //               )
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               SvgPicture.asset(
                  //                 SVGIcons.person,
                  //                 color: Colors.amber,
                  //               ),
                  //               Gap(10.o),
                  //               Text(
                  //                 'ds',
                  //                 style: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.secondary),
                  //               )
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               SvgPicture.asset(SVGIcons.bed),
                  //               Gap(10.o),
                  //               Text('ds', style: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.secondary))
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               SvgPicture.asset(SVGIcons.bed),
                  //               Gap(10.o),
                  //               Text('ds', style: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.secondary))
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Gap(10.o),
                  // Container(
                  //   width: double.infinity,
                  //   color: theme.primaryColor.withOpacity(0.1),
                  //   height: 1,
                  // ),
                  // Gap(20.o),
                  // Container(
                  //     width: double.infinity,
                  //     child: Text(
                  //       'MAXSUS TALAB',
                  //       style: theme.hintTextFieldStyle.copyWith(color: mTheme.colorScheme.secondary),
                  //       textAlign: TextAlign.start,
                  //     )),
                  // Gap(5.o),
                  // Container(
                  //       decoration: BoxDecoration(),
                  //     width: double.infinity,
                  //     child: Text(
                  //         maxLines: 5,
                  //         style: theme.primaryTextStyle.copyWith(
                  //             color: mTheme.colorScheme.primary,
                  //             fontWeight: FontWeight.w700),
                  //         'Yuqori qavat, chekilmaydigan xona, qo\'shimcha  dasdasdass sdadasda yotoq')),
                  // Gap(26.o),

                  Gap(26.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.o))),
                          width: 40.o,
                          height: 40.o,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.o)),
                            child: Image.asset(
                              IMAGES.person,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Gap(20.o),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userCounter.appUser!.firstName,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color),
                            ),
                            Text(
                              'ID: ${userCounter.appUser!.id}',
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Gap(10.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    width: double.infinity,
                    color: theme.primaryColor.withOpacity(0.1),
                    height: 1,
                  ),
                  Gap(10.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.tr,
                          style: theme.hintTextFieldStyle
                              .copyWith(color: mTheme.colorScheme.secondary),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.status.id,
                              style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color),
                            ),
                            Gap(10.o),
                            GestureDetector(
                              onTap: () {
                                _copyToClipboard(context, '${widget.status}');
                              },
                              child: SvgPicture.asset(
                                SVGIcons.copy,
                                color: mTheme.colorScheme.primary,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Gap(30.o),
                  Row(
                    children: [
                      Container(
                        width: 24.o,
                        height: 35.o,
                        decoration: BoxDecoration(
                          color: mTheme.colorScheme.background,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18.o),
                            bottomRight: Radius.circular(18.o),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.o),
                          decoration: BoxDecoration(
                            border: DashedBorder.fromBorderSide(
                              side: BorderSide(
                                  width: 1.o,
                                  color: mTheme.colorScheme.primary
                                      .withOpacity(0.1)),
                              dashLength: 8,
                            ),
                          ),
                          width: 100.o,
                          height: 1,
                        ),
                      ),
                      Container(
                        width: 24.o,
                        height: 35.o,
                        decoration: BoxDecoration(
                            color: mTheme.colorScheme.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18.o),
                              bottomLeft: Radius.circular(18.o),
                            )),
                      ),
                    ],
                  ),

                  Gap(10.o),
                  widget.barcode.isEmpty
                      ? Text(
                          barCodeNotFound.tr,
                          style: theme.primaryTextStyle.copyWith(
                              color: mTheme.textTheme.bodyMedium!.color),
                        )
                      : SizedBox(
                          width: 250.w,
                          height: 50.h,
                          child: SfBarcodeGenerator(value: widget.barcode),
                        ),
                  Gap(20.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    width: double.infinity,
                    color: theme.primaryColor.withOpacity(0.1),
                    height: 1,
                  ),
                  Gap(20.o),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.o),
                    child: Text(
                      maxLines: 5,
                      bringYourPrivacyId.tr,
                      style: theme.hintTextFieldStyle
                          .copyWith(color: mTheme.colorScheme.secondary),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: Platform.isIOS
                  ? EdgeInsets.only(bottom: 30.o)
                  : const EdgeInsets.only(bottom: 0),
              padding: EdgeInsets.symmetric(vertical: 10.o, horizontal: 12.o),
              height: 70.o,
              color: mTheme.colorScheme.background,
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: mTheme.colorScheme.primary),
                  onPressed: () async {
                    checkPermissionAndSavePdf(context);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                          color: theme.white,
                        ),
                        Gap(10.o),
                        Text(
                          textAlign: TextAlign.center,
                          downloadPermission.tr,
                          style: theme.primaryTextStyle
                              .copyWith(color: theme.white),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
