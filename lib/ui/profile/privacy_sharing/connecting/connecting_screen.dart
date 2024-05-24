import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hostels/network/client.dart';
import 'package:hostels/ui/custom/profile_appbar.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostels/widgets/Toast.dart';

import '../../../../apptheme.dart';
import '../../../../variables/icons.dart';
import '../../../../variables/links.dart';

class ConnectingScreen extends StatefulWidget {
  const ConnectingScreen({super.key});

  @override
  State<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> {
  String _selectedRegion = regions().first;
  List<String> regionList = regions();
  final _regionController = TextEditingController();
  final _messageController = TextEditingController();
  bool isRegionEmpty = true;
  bool isContentEmpty = true;

  @override
  void initState() {
    _regionController.text = _selectedRegion;
    super.initState();
  }
  @override
  void dispose() {
    _regionController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: mTheme.cardColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.o),
        child: ProfileAppbar(
          titleAppbar: connectWithUs.tr,
          color: mTheme.colorScheme.background,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.o),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.o),
              child: Text(
                maxLines: 3,
                requestToLoad.tr,
                style: theme.hintTextFieldStyle
                    .copyWith(color: mTheme.colorScheme.secondary),
              ),
            ),
            Gap(10.o),
            Stack(
              children: [
                Container(
                  height: 65.o,
                  margin: EdgeInsets.symmetric(vertical: 8.o, horizontal: 12.o),
                  padding: EdgeInsets.symmetric(horizontal: 16.o),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: mTheme.colorScheme.primary.withOpacity(0.5)),
                      borderRadius: BorderRadius.all(Radius.circular(16.o)),
                      color: mTheme.colorScheme.onSecondary),
                  child: TextField(
                      controller: _regionController,
                      readOnly: true,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            isRegionEmpty = true;
                          } else {
                            isRegionEmpty = false;
                          }
                        });
                      },
                      keyboardType: TextInputType.phone,
                      style: theme.primaryTextStyle
                          .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                      cursorColor: theme.primaryColor,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle: theme.hintTextFieldStyle
                              .copyWith(color: mTheme.colorScheme.secondary),
                          labelText: livingPlace.tr)),
                ),
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(24.o),
                    child: DropdownButton(
                      style: theme.primaryTextStyle.copyWith(
                          color: mTheme.colorScheme.primary),
                      dropdownColor: mTheme.colorScheme.onSecondary,
                      // focusColor: mTheme.colorScheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.all(Radius.circular(16.o)),
                      // alignment: Alignment.centerRight,
                      icon: SvgPicture.asset(
                        SVGIcons.downCaret,
                        color: mTheme.colorScheme.primary,
                        width: 8.o,
                        height: 8.o,
                      ),
                      // ,
                      isExpanded: true,
                      underline: Container(),
                      menuMaxHeight: 200.h,
                      items: regionList
                          .map((region) => DropdownMenuItem(
                          value: region,
                          child: Text(
                            region,
                            style: theme.primaryTextStyle.copyWith(
                                color: mTheme.colorScheme.primary),
                          )))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value == null) {
                            return;
                          }
                          _selectedRegion = value;
                          _regionController.text = _selectedRegion;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            Gap(20.o),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 14.o),
                child: Text(
                  contentInfo.tr,
                  style: theme.primaryTextStyle.copyWith(
                      fontSize: 16.o,
                      fontWeight: FontWeight.w700,
                      color: mTheme.colorScheme.primary),
                )),
            Gap(10.o),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.o, horizontal: 12.o),
              padding: EdgeInsets.symmetric(horizontal: 16.o, vertical: 8.o),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: mTheme.colorScheme.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.all(Radius.circular(16.o)),
                  color: mTheme.colorScheme.onSecondary),
              child: TextField(
                  controller: _messageController,
                  minLines: 5,
                  maxLines: 5,
                  maxLength: 150,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        isContentEmpty = true;
                      } else {
                        isContentEmpty = false;
                      }
                    });
                  },
                  keyboardType: TextInputType.text,
                  style: theme.primaryTextStyle
                      .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                  cursorColor: mTheme.colorScheme.primary,
                  decoration: InputDecoration(
                    counterStyle: theme.primaryTextStyle
                        .copyWith(color: mTheme.textTheme.bodyMedium!.color),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  )),
            ),
            Gap(10.o),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12.o),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:!isContentEmpty? mTheme.colorScheme.primary:Colors.grey,
                      side: BorderSide(
                          width: 1.o,
                          color: theme.primaryColor.withOpacity(0.2))),
                  onPressed: !isContentEmpty
                      ? () {
                    contactAdmin();
                    setState(() {
                      _messageController.clear();
                      isContentEmpty = true;
                    });
                    awesomeToast(context: context, txt: messageSuccess.tr, title: message.tr, contentType: ContentType.success);
                    Navigator.pop(context);
                  }
                      : null,
                  child: Text(
                    send.tr,
                    style: theme.primaryTextStyle.copyWith(color: theme.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void contactAdmin() {
    client.post('${Links.contactAdmin}1', data: {
      'message': '${_regionController.text}\n ${_messageController.text}'
    }).then((value) {});
  }
}
