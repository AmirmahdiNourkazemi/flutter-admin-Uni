import 'dart:js_interop';

import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/screens/home/home_screen.dart';
import 'package:admin_smartfunding/screens/withdraw/withdraw_datalist.dart';
import 'package:admin_smartfunding/utils/phosphor_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/withdraw/answer_withdraw/answer_withdraw_bloc.dart';
import '../../bloc/withdraw/answer_withdraw/answer_withdraw_event.dart';
import '../../bloc/withdraw/answer_withdraw/answer_withdraw_state.dart';
import '../../bloc/withdraw/get_withdraw/withdraw_bloc.dart';
import '../../data/model/withdraw/withdraw_item.dart';

class AnswerWithdraw extends StatefulWidget {
  final WithdrawItem withdrawItem;
  const AnswerWithdraw(this.withdrawItem, {super.key});

  @override
  State<AnswerWithdraw> createState() => _AnswerWithdrawState();
}

class _AnswerWithdrawState extends State<AnswerWithdraw> {
  final _formKey = GlobalKey<FormState>();
  final _imageName = TextEditingController();
  final _refID = TextEditingController();
  final _datePicker = TextEditingController();
  Jalali? picked;
  int selectedChangeStatusValue = 1;
  bool isDroppDownPress = false;
  String? pickedImagePath;
  XFile? pickedImage;
  List<DropdownMenuItem<int>> get dropdownChangeStatusItems {
    List<DropdownMenuItem<int>> stausItems = [
      DropdownMenuItem(
        value: 1,
        child: Text("در حال بررسی",
            style: Theme.of(context).textTheme.titleMedium),
      ),
      DropdownMenuItem(
        value: 2,
        child: Text("پرداخت", style: Theme.of(context).textTheme.titleMedium),
      ),
      DropdownMenuItem(
        value: 3,
        child: Text("لغو", style: Theme.of(context).textTheme.titleMedium),
      ),
    ];
    return stausItems;
  }

  String selectedValue = "images";

  @override
  void initState() {
    BlocProvider.of<AnswerWithdrawBloc>(context)
        .add(AnswerWithdrawStartEvent());
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _pickImage = ImagePicker();
      XFile? image = await _pickImage.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          pickedImage = image;
          pickedImagePath = image.path;
          print(pickedImagePath);
        });
      } else {
        print('no image has been picked');
      }
      if (image != null) {
        pickedImage = image;
      } else {
        print('no image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _pickImage = ImagePicker();
      XFile? image = await _pickImage.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          pickedImage = image;
          pickedImagePath = image.path;
          print(pickedImagePath);
        });
      }
      if (image != null) {
        pickedImage = image;

        setState(() {});
      } else {
        print('no image has been picked');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //backgroundColor: scafoldCollor,
        appBar: AppBar(
          //backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) {
                              final WithdrawBloc bloc = WithdrawBloc();
                              bloc.add(WithdrawStartEvent());
                              return bloc;
                            },
                          ),
                        ],
                        child: const WithdrawScreen(),
                      );
                    },
                  ),
                );
              },
              icon: buildPhosphorIcon(PhosphorIconsBold.arrowLeft)),
        ),
        body: SingleChildScrollView(
          child: BlocListener<AnswerWithdrawBloc, AnswerWithdrawState>(
            listener: (context, state) {
              if (state is AnswerWithdrawResponseState) {
                state.answerWithdraw.fold(
                  (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => MetabaseBloc(),
                          child: const HomeScreen(),
                        ),
                      ),
                    );
                    // Navigator.pop(context);
                  },
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5), // Shadow color
                //     spreadRadius: 2, // Spread radius of the shadow
                //     blurRadius: 5, // Blur radius of the shadow
                //     offset: const Offset(0, 3), // Offset of the shadow
                //   ),
                // ],
                //  color: containerColor,
                border: Border.all(
                  width: 1,
                  color: Colors.white24,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _refID,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'کد پیگیری',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'لطفا نام خانوادگی خود را وارد کنید';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _datePicker,
                      onTap: () async {
                        picked = await showPersianDatePicker(
                            initialEntryMode: PDatePickerEntryMode.input,
                            initialDatePickerMode: PDatePickerMode.year,
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1390, 2),
                            lastDate: Jalali(1450, 4));

                        setState(() {
                          _datePicker.text =
                              "${picked!.year.toString()}/${picked!.month.toString()}/${picked!.day.toString()}"
                                  .toPersianDigit();
                        });
                        setState(() {
                          _datePicker.text =
                              picked!.formatFullDate().toPersianDigit();
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'تاریخ',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'لطفا نام خانوادگی خود را وارد کنید';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(20),
                      dashPattern: [10, 10],
                      color: Colors.grey,
                      strokeWidth: 2,
                      child: pickedImagePath != null && pickedImagePath != ''
                          ? Stack(
                              children: [
                                Container(
                                  width: 250,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Image.network(
                                    pickedImagePath!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        pickedImagePath = '';
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container(
                              width: 200,
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    _pickImage();
                                  },
                                  icon: const Icon(Icons.add_a_photo),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: pickedImagePath != null && pickedImagePath != '',
                      child: TextFormField(
                        controller: _imageName,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          labelText: 'نام عکس',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'لطفا نام خانوادگی خود را وارد کنید';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isDroppDownPress = true;
                            setState(() {
                              isDroppDownPress = true;
                            });
                          },
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              //color: scafoldCollor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              iconEnabledColor: Colors.black,
                              items: dropdownChangeStatusItems,

                              // dropdownColor: Colors.grey,
                              hint: widget.withdrawItem.status == 1
                                  ? Text('جدید')
                                  : widget.withdrawItem.status == 2
                                      ? Text('پاسخ داده شده')
                                      : Text('بسته شده'),
                              focusColor: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(10),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              onChanged: (int? newValue) {
                                //  selectedValue = newValue!;
                                selectedChangeStatusValue = newValue!;
                                setState(() {
                                  isDroppDownPress = true;
                                  selectedChangeStatusValue = newValue;
                                });
                              },
                              value: isDroppDownPress
                                  ? selectedChangeStatusValue
                                  : widget.withdrawItem.status,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(200, 50)),
                      onPressed: () async {
                        final datePicker = picked != 'null'
                            ? '${picked!.toGregorian().year}-${picked!.toGregorian().month}-${picked!.toGregorian().day}'
                            : DateTime.now().toString();
                        final status =
                            isDroppDownPress ? selectedChangeStatusValue : 2;

                        BlocProvider.of<AnswerWithdrawBloc>(context).add(
                            AnswerWithdrawClickEvent(
                                status,
                                _refID.text,
                                datePicker,
                                _imageName.text,
                                pickedImage,
                                widget.withdrawItem.uuid));
                      },
                      child: const Text('ذخیره'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
