import 'dart:convert';

import 'package:admin_smartfunding/responsive/responsive.dart';
import 'package:admin_smartfunding/screens/projects/upload_media.dart';
import 'package:admin_smartfunding/utils/phosphor_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/ProjectBloc/create_project/create_project_bloc.dart';
import '../../bloc/ProjectBloc/create_project/create_project_event.dart';
import '../../bloc/ProjectBloc/create_project/create_project_state.dart';
import '../../bloc/ProjectBloc/upload_media/upload_media_bloc.dart';
import '../../bloc/ProjectBloc/upload_media/upload_media_event.dart';
import '../../constant/scheme.dart';
import '../../utils/money_seprator_ir.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({super.key});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  QuillController _controller = QuillController.basic();
  int selectedValue = 1;
  int? selectedPriorityValue;
  ScrollController _screenController = ScrollController();
  List<Map<String, String>> keyValues = [];
  List<Map<String, String>> timeTable = [];
  void addKeyValuePair(String key, String value) {
    setState(() {
      keyValues.add({'key': key, 'value': value});
    });
  }

  void addTimeValuePair(String key, String value) {
    setState(() {
      timeTable.add({'title': key, 'date': value});
    });
  }

  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  final TextEditingController _titleKeyController = TextEditingController();
  final TextEditingController _dateValueController = TextEditingController();

  bool selectedPriority = false;
  List<DropdownMenuItem<int>> get dropdownPriorityItems {
    List<DropdownMenuItem<int>> menuItems = [
      const DropdownMenuItem(
          value: 1,
          child: Text(
            "اولویت بالا",
            style: TextStyle(fontFamily: 'IR'),
          )),
      const DropdownMenuItem(
        value: 2,
        child: Text(
          "اولویت متوسط",
          style: TextStyle(fontFamily: 'IR'),
        ),
      ),
      const DropdownMenuItem(
        value: 3,
        child: Text(
          "اولویت پایین",
          style: TextStyle(fontFamily: 'IR'),
        ),
      )
    ];
    return menuItems;
  }

  Jalali? start;
  Jalali? picked;

  Jalali? keyDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fundNeededController = TextEditingController();
  final TextEditingController _minInvestController = TextEditingController();
  final TextEditingController _expectedController = TextEditingController();
  final TextEditingController _finishedController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _ifbUuidController = TextEditingController();
  final TextEditingController _profitController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'اضافه کردن طرح',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context) ? 200 : 0),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[50]),
              child: ListView(
                controller: _screenController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _titleController,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'نام طرح',
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا نام طرح خود را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _shortDescriptionController,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'نماد طرح',
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا نماد طرح خود را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          QuillToolbar.simple(
                            configurations: QuillSimpleToolbarConfigurations(
                              fontFamilyValues: const {
                                'Iran sans': 'IR',
                                'Sans Serif': 'Sans Serif',
                                'Courier New': 'Courier New',
                                'Times New Roman': 'Times New Roman',
                                'Clear': 'Clear'
                              },
                              showDirection: true,
                              controller: _controller,
                              sharedConfigurations:
                                  const QuillSharedConfigurations(
                                locale: Locale('fa'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 300,
                            child: QuillEditor.basic(
                              configurations: QuillEditorConfigurations(
                                controller: _controller,
                                padding: const EdgeInsets.all(4),
                                sharedConfigurations:
                                    const QuillSharedConfigurations(
                                  locale: Locale('fa'),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      inputFormatters: [
                        PersianNumberFormatter(),
                      ],
                      controller: _fundNeededController,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'کل مبلغ مورد نیاز(تومان)',
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا مبلغ خود را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      inputFormatters: [PersianNumberFormatter()],
                      controller: _minInvestController,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'کم ترین مقدار سرمایه (تومان)',
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا مبلغ خود را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _expectedController,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'سود مورد انتظار(درصد)',
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا سود خود را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _profitController,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'میزان سود در ماه (درصد)',
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا میزان سود در ماه را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      readOnly: true,
                      controller: _startController,
                      onTap: () async {
                        start = await showPersianDatePicker(
                            confirmText: 'انتخاب',
                            initialEntryMode: PDatePickerEntryMode.input,
                            initialDatePickerMode: PDatePickerMode.year,
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1300, 4),
                            lastDate: Jalali(1450, 4));

                        setState(() {
                          _startController.text =
                              "${start!.year.toString()}/${start!.month.toString()}/${start!.day.toString()}"
                                  .toPersianDigit();
                        });
                        setState(
                          () {
                            _startController.text =
                                start!.formatFullDate().toPersianDigit();
                          },
                        );
                      },
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        labelText: 'تاریخ شروع پروژه',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا تاریخ شروع پروژه را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      readOnly: true,
                      controller: _finishedController,
                      onTap: () async {
                        picked = await showPersianDatePicker(
                            initialEntryMode: PDatePickerEntryMode.input,
                            initialDatePickerMode: PDatePickerMode.year,
                            confirmText: 'انتخاب',
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1300, 4),
                            lastDate: Jalali(1450, 4));

                        setState(() {
                          _finishedController.text =
                              "${picked!.year.toString()}/${picked!.month.toString()}/${picked!.day.toString()}"
                                  .toPersianDigit();
                        });
                        setState(() {
                          _finishedController.text =
                              picked!.formatFullDate().toPersianDigit();
                        });
                      },
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        labelText: 'تاریخ پایان پروژه',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا تاریخ پایان پروژه را وارد کنید';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: DropdownButtonFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      onTap: () {
                        selectedPriority = true;
                      },
                      decoration: InputDecoration(
                        hintText: 'لطفا اولویت پروژه را مشخص کنید',
                        labelStyle: Theme.of(context).textTheme.titleMedium,
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        helperStyle: Theme.of(context).textTheme.titleMedium,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        //fillColor: Colors.blueAccent,
                      ),
                      items: dropdownPriorityItems,
                      elevation: 4,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedPriorityValue = newValue!;
                        });
                      },
                      value: selectedPriorityValue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _keyController,
                            decoration: InputDecoration(
                              labelText: 'لیبل',
                              labelStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // Other styling properties...
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _valueController,
                            decoration: InputDecoration(
                              labelText: 'توضیح',
                              labelStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // Other styling properties...
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(shape: CircleBorder()),
                          onPressed: () {
                            addKeyValuePair(
                                _keyController.text, _valueController.text);
                            _keyController.clear();
                            _valueController.clear();
                          },
                          child:
                              buildPhosphorIcon(PhosphorIconsBold.plusCircle),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: keyValues.length * 80,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _screenController,
                      itemCount: keyValues.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              isThreeLine: true,
                              title: Text(
                                'لیبل: ${keyValues[index]['key'] ?? ''}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                'توضیح:${keyValues[index]['value'] ?? ''}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              trailing: IconButton(
                                color: AppColorScheme.primaryColor,
                                icon: buildPhosphorIcon(
                                  PhosphorIconsBold.trash,
                                ),
                                onPressed: () {
                                  // Add logic to remove the key-value pair at the given index
                                  setState(() {
                                    keyValues.removeAt(index);
                                  });
                                },
                              ),
                            ),
                            const Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocListener<CreateProjectBloc, CreateProjectState>(
                    listener: (context, state) {
                      if (state is CreateProjectResponseState) {
                        state.response.fold(
                          (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          (project) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text(project.uuid!),
                            //     backgroundColor: Colors.red,
                            //   ),
                            // );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return BlocProvider(
                                    create: (context) {
                                      final UploadMediaBloc bloc =
                                          UploadMediaBloc();
                                      bloc.add(UploadMediaStartEvent());
                                      return bloc;
                                    },
                                    child: UploadMediaScreen(project.uuid!),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorScheme.primaryColor,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final type = selectedPriorityValue;
                            final String title = _titleController.text;
                            final String shortDescription =
                                _shortDescriptionController.text;
                            final String description = jsonEncode(
                                _controller.document.toDelta().toJson());
                            final priority = selectedPriorityValue!;
                            final minInvest = _minInvestController.text
                                .replaceAll(',', '')
                                .toEnglishDigit();
                            final fundNeeded = _fundNeededController.text
                                .replaceAll(',', '')
                                .toEnglishDigit();
                            final String ifbUuid = _ifbUuidController.text;
                            final expectedProfit =
                                _expectedController.text.toEnglishDigit();
                            final finishAt =
                                '${picked!.toGregorian().year}-${picked!.toGregorian().month}-${picked!.toGregorian().day}';
                            final startAt =
                                '${start!.toGregorian().year}-${start!.toGregorian().month}-${start!.toGregorian().day}';

                            final profit =
                                _profitController.text.toEnglishDigit();
                            BlocProvider.of<CreateProjectBloc>(context).add(
                              CreateProjectRequestEvent(
                                title,
                                description,
                                type ?? 1,
                                priority,
                                minInvest,
                                fundNeeded,
                                expectedProfit,
                                finishAt,
                                startAt,
                                keyValues,
                                shortDescription,
                                profit,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('لطفا تمامی فیلد ها را پر کنید'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child:
                            BlocBuilder<CreateProjectBloc, CreateProjectState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (state is CreateProjectLoadingState) ...{
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'ذخیره',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                } else ...{
                                  Text(
                                    'ذخیره',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                }
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    TextEditingController titleController =
        TextEditingController(text: timeTable[index]['title']);
    TextEditingController dateController = TextEditingController(
        text: timeTable[index]['date'].toString().toPersianDate());
    var time;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ویرایش'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'عنوان'),
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  Jalali? pickedDate = await showPersianDatePicker(
                    context: context,
                    initialDate: Jalali.now(),
                    firstDate: Jalali(1300, 1),
                    lastDate: Jalali(1450, 1),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateController.text = pickedDate.formatFullDate();
                      time = pickedDate.toGregorian().toDateTime().toString();
                    });
                  }
                },
                decoration: InputDecoration(labelText: 'تاریخ'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('لغو'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // print(dateController.text);
                  timeTable[index]['title'] = titleController.text;

                  timeTable[index]['date'] = time;
                });
                Navigator.of(context).pop();
              },
              child: Text('ذخیره'),
            ),
          ],
        );
      },
    );
  }
}
