import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostels/network/http_result.dart';
import 'package:hostels/ui/custom/custom_button.dart';
import 'package:hostels/ui/custom/profile_appbar.dart';
import 'package:hostels/ui/profile/private_data/data_textfield.dart';
import 'package:hostels/providers/user_provider.dart';
import 'package:hostels/ui/register/dialog/picker_dialog_profile.dart';
import 'package:hostels/variables/images.dart';
import 'package:hostels/variables/language.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';
import 'package:hostels/widgets/Toast.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:image_picker/image_picker.dart';

import '../../../apptheme.dart';
import '../../../network/client.dart';
import '../../../variables/links.dart';
import '../../login/login.dart';
import '../../register/date_textfield.dart';

class PrivateDataScreen extends StatefulWidget {
  const PrivateDataScreen({super.key});

  @override
  State<PrivateDataScreen> createState() => _PrivateDataScreenState();
}

class _PrivateDataScreenState extends State<PrivateDataScreen> {
  bool isNameEmpty = false;
  bool isSecondNameEmpty = false;
  bool isBirthDayEmpty = true;
  bool emptiness = false;
  String selectedOption = '20';
  String birthDay = '';
  String imgUrl = '';
  String path = '';
  bool imageloading = false,
      nameError = false,
      surnameError = false,
      isMan = true,
      dateError = false,
      isNext = false;
  String bornDay = '';
  TextEditingController nameTextField = TextEditingController(),
      lastNameTextField = TextEditingController();
  File? selectedImage;
  XFile? returnImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    if (userCounter.appUser != null) {
      nameTextField.text = userCounter.appUser!.firstName;
      lastNameTextField.text = userCounter.appUser!.lastName;
      birthDay = userCounter.appUser!.bornDate;
      selectedOption = userCounter.appUser!.gender;
      path = userCounter.appUser!.img;
      print(birthDay);
      print(imgUrl);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          100.o,
        ),
        child: ProfileAppbar(
          titleAppbar: privateInfo.tr,
          color: mTheme.colorScheme.background,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final notifier = ref.watch(userProvider);
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Gap(40.o),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.o),
                          width: 85.o,
                          height: 85.o,
                          decoration: BoxDecoration(
                              border: DashedBorder.fromBorderSide(
                                side: BorderSide(
                                    width: 2.o,
                                    color: mTheme.colorScheme.primary
                                        .withOpacity(0.2)),
                                dashLength: 4,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(50.o)),
                              color: mTheme.colorScheme.background),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50.o)),
                            child:notifier.appUser!.img.isNotEmpty
                                ? Image.network(
                              notifier.appUser!.img,
                              fit: BoxFit.cover,
                            )
                                : Image.asset(
                              IMAGES.person,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {
                                // pickImageFromGallery();
                                pickImage(ImageSource.gallery);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      width: 4.o,
                                      color: mTheme.colorScheme.background),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50.o)),
                                  color: mTheme.colorScheme.primary,
                                ),
                                width: 24.o,
                                height: 24.o,
                                child: Icon(
                                  Icons.edit,
                                  color: theme.white,
                                  size: 16.o,
                                ),
                              ),
                            ))
                      ],
                    ),
                    Gap(40.o),
                    DataTextFieldWidget(
                      onChanged: (value) {
                        setState(() {
                          if (value.length < 2) {
                            isNameEmpty = true;
                          } else {
                            isNameEmpty = false;
                          }
                        });
                      },
                      labelText: yourName.tr,
                      textEditingController: nameTextField,
                    ),
                    DataTextFieldWidget(
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            isSecondNameEmpty = true;
                          } else {
                            isSecondNameEmpty = false;
                          }
                        });
                      },
                      labelText: yourSurname.tr,
                      textEditingController: lastNameTextField,
                    ),
                    Gap(5.o),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12.o),
                      child: DateTextField(
                        date: myBirthDay.tr,
                        onIconTapped: () {
                          {
                            showModalBottomSheet<void>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.h),
                              ),
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (BuildContext context) {
                                return PickerDialogProfile(
                                  title: 'Tu\'gilgan sana',
                                  selected: (year, month, day) {
                                    setState(() {
                                      birthDay = [
                                        day.toString().padLeft(2, '0'),
                                        month.toString().padLeft(2, '0'),
                                        year,
                                      ].join('.');
                                      checkIs(false);
                                      setState(() {
                                        if (birthDay.isNotEmpty) {
                                          print(birthDay.isNotEmpty);
                                        } else {}
                                      });
                                    });
                                  },
                                  initialDate: birthDay,
                                );
                              },
                            );
                          }
                        },
                        birthDay: birthDay,
                        onTextFieldTapped: () {
                          showModalBottomSheet<void>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.h),
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) {
                              return PickerDialogProfile(
                                title: dateBirth.tr,
                                selected: (year, month, day) {
                                  setState(() {
                                    birthDay = [
                                      day.toString().padLeft(2, '0'),
                                      month.toString().padLeft(2, '0'),
                                      year,
                                    ].join('.');
                                    checkIs(false);
                                    setState(() {
                                      if (birthDay.isNotEmpty) {
                                        print(birthDay.isNotEmpty);
                                      } else {}
                                    });
                                  });
                                },
                                initialDate: birthDay,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Gap(15.o),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption =
                                '20'; // Set the selected option value
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12.o, left: 12.o),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12.o)),
                                color:
                                mTheme.colorScheme.primary.withOpacity(0.05),
                              ),
                              child: ListTile(
                                title: Text(
                                  male.tr,
                                  style: theme.primaryTextStyle.copyWith(
                                    color: mTheme.textTheme.bodyMedium!.color,fontSize: 12.o
                                  ),
                                ),
                                leading: Radio<String>(
                                  activeColor: mTheme.colorScheme.primary,
                                  value: '20',
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption =
                                '30'; // Set the selected option value
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8.o, left: 12.o),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.o),
                                color:
                                mTheme.colorScheme.primary.withOpacity(0.05),
                              ),
                              child: ListTile(
                                title:  Text(female.tr,style: theme.primaryTextStyle.copyWith(
                                  color: mTheme.textTheme.bodyMedium!.color,fontSize: 12.o
                                ),),
                                leading: Radio<String>(
                                  activeColor: mTheme.colorScheme.primary,
                                  value: '30',
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.only(right: 12.o, left: 12.o),
                    //         decoration: BoxDecoration(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(12.o)),
                    //             color:
                    //                 mTheme.colorScheme.primary.withOpacity(0.05)),
                    //         child: ListTile(
                    //           title: Text(
                    //             'Erkak',
                    //             style: theme.primaryTextStyle.copyWith(
                    //                 color: mTheme.textTheme.bodyMedium!.color),
                    //           ),
                    //           leading: Radio<String>(
                    //             activeColor: mTheme.colorScheme.primary,
                    //             value: '20',
                    //             groupValue: selectedOption,
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 selectedOption = value!;
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Container(
                    //         margin: EdgeInsets.only(right: 8.o, left: 12.o),
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12.o),
                    //             color:
                    //                 mTheme.colorScheme.primary.withOpacity(0.05)),
                    //         child: ListTile(
                    //           title: const Text('Ayol'),
                    //           leading: Radio<String>(
                    //             activeColor: mTheme.colorScheme.primary,
                    //             value: '30',
                    //             groupValue: selectedOption,
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 selectedOption = value!;
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            },),
          ),
          Container(
            margin: Platform.isIOS
                ? EdgeInsets.only(bottom: 30.o, left: 12.o, right: 12.o)
                : EdgeInsets.all(12.o),
            child: CustomButton(
              title: Text(
                textAlign: TextAlign.center,
                save.tr,
                style: theme.primaryTextStyle
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onPressed: isNameEmpty || isSecondNameEmpty
                  ? null
                  : () {
                      sendData();
                      userCounter.appUser;
                      Navigator.pop(context);
                      awesomeToast(
                          context: context,
                          txt: successData.tr,
                          title: data.tr,
                          contentType: ContentType.success);
                    },
            ),
          )
        ],
      ),
    );
  }

  bool defineTextFieldEmptiness(String value) {
    setState(() {
      if (value.isEmpty) {
        isNameEmpty = true;
      } else {
        isNameEmpty = false;
      }
    });
    return isNameEmpty;
  }

  bool defineSecondNameEmptiness(String value) {
    setState(() {
      if (value.isEmpty) {
        isSecondNameEmpty = true;
      } else {
        isSecondNameEmpty = false;
      }
    });
    return isSecondNameEmpty;
  }

  bool defineBirthDayEmptiness(String value) {
    setState(() {
      if (value.isEmpty) {
        isBirthDayEmpty = true;
      } else {
        isBirthDayEmpty = false;
      }
    });
    return isBirthDayEmpty;
  }

  bool checkIsEmpty() {
    return isNameEmpty || isSecondNameEmpty || isBirthDayEmpty;
  }

  bool checkIs(bool isToast) {
    dateError = bornDay.isEmpty;
    isNext = true;
    if (isToast) {
      if (nameError) {
        isNext = false;
        // toast(context: context, txt: "enter name");
        return false;
      } else if (surnameError) {
        isNext = false;
        // toast(context: context, txt: 'enterSurname'.tr);
        return false;
      } else if (dateError) {
        isNext = false;
        // toast(context: context, txt: bornDate.tr);
        return false;
      }
    }
    setState(() {});
    return true;
  }

  void sendData() async {
    await client.post(Links.update, data: {
      'first_name': nameTextField.text.trim(),
      'last_name': lastNameTextField.text.trim(),
      'born_date': birthDay,
      'img':selectedImage,
    }).then((result) {
      print('then out');
      if (result.status == 200) {
        print('then 200');
        pref.setString(PrefKeys.name, nameTextField.text.trim());
        pref.setString(PrefKeys.surname, lastNameTextField.text.trim());
        pref.setString(PrefKeys.born, birthDay);
        pref.setString(PrefKeys.gender, selectedOption == '20' ? '20' : '30');
        pref.setString(
            PrefKeys.genderName, result.data['gender_name'].toString());
        pref.setString(PrefKeys.status, result.data['status'].toString());
        pref.setString(PrefKeys.userId, result.data['id'].toString());
        pref.setString(PrefKeys.authKey, result.data['auth_key'].toString());
        pref.setString(PrefKeys.authKey, result.data['phone'].toString());

        userCounter.appUser = AppUser(
          firstName: nameTextField.text.trim(),
          lastName: lastNameTextField.text.trim(),
          gender: selectedOption == '20' ? '20' : '30',
          bornDate: birthDay,
          authKey: result.data['auth_key'].toString(),
          phone: result.data['phone'].toString(),
          status: result.data['status'].toString(),
          id: result.data['id'].toString(),
          genderName: result.data['gender_name'].toString(),
          img: result.data['img'].toString(),
        );
        userCounter.update();
      } else if (result.status == 401) {
        navigate();
      }
    });
  }
  // Future<void> postImage(String selectedImage) async {
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(Links.upLoadImage));
  //     request.files.add(await http.MultipartFile.fromPath('img', selectedImage));
  //
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       print('Image uploaded successfully');
  //     } else {
  //       print('Failed to upload image. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }


  // Future pickImageFromGallery() async {
  //   returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (returnImage == null) {
  //     return;
  //   }
  //   setState(() {
  //     selectedImage = File(returnImage!.path);
  //     postImage(selectedImage!.path);
  //     pref.setString(PrefKeys.photo, returnImage?.path ?? '');
  //   });
  // }

  void navigate() {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  // Future<void> postImage(String? selectedImage) async {
  //   client.post(Links.upLoadImage, data: {
  //     'img': selectedImage,
  //   });
  // }

  Future pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
      );
      setState(() {
        imageloading = true;
      });
      if (file == null) {
        setState(() {
          imageloading = false;
        });
        return;
      }
      print('path: ${file.path}');
       path = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(file.path, filename: path),
      });
      MainModel result = await client.post(Links.upLoadImage, data: formData);
      if (result.status == 200) {
        // 2
        userCounter.appUser = AppUser(
          firstName: nameTextField.text.trim(),
          lastName: lastNameTextField.text.trim() ?? '',
          gender: selectedOption == '20' ? '20' : '30' ?? '',
          bornDate: birthDay ?? '',
          authKey: result.data['auth_key'].toString(),
          phone: result.data['phone'].toString(),
          status: result.data['status'].toString(),
          id: result.data['id'].toString(),
          genderName: result.data['gender_name'].toString(),
          img: result.data['img'].toString(),
        );
        userCounter.update();
        // userNotifier.setUser(User.fromJson(result.data));
        print('success');
      }
      setState(() {
        imageloading = false;
      });
    } on PlatformException catch (_) {
      print('error pick image : $_');
    }
  }

}
