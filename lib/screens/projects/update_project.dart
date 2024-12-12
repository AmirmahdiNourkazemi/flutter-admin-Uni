import 'dart:convert';

import 'package:admin_smartfunding/data/model/projects/projects.dart';
import 'package:admin_smartfunding/screens/projects/project_home.dart';
import 'package:admin_smartfunding/utils/phosphor_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/ProjectBloc/edit_project/edit_project_bloc.dart';
import '../../bloc/ProjectBloc/edit_project/edit_project_event.dart';
import '../../bloc/ProjectBloc/edit_project/edit_project_state.dart';
import '../../bloc/ProjectBloc/projects/project_bloc.dart';
import '../../constant/scheme.dart';
import '../../data/model/projects/properties.dart';
import '../../responsive/responsive.dart';
import '../../utils/jaliliToGorgian.dart';
import '../../utils/money_seprator_ir.dart';

class UpdateProject extends StatefulWidget {
  final Project _project;
  const UpdateProject(this._project, {super.key});

  @override
  State<UpdateProject> createState() => _UpdateProjectState();
}

class _UpdateProjectState extends State<UpdateProject> {
  @override
  int selectedValue = 1;
  bool isDatePressed = false;
  bool isStartDatePressed = false;
  bool isTypePressed = false;
  bool isStatusPressed = false;
  bool isPriorityPressed = false;
  int? selectedPriorityValue;
  //int? selectPriorityValue;
  int? selectStatusValue;
  bool selectedPriority = false;
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

  List<DropdownMenuItem<int>> get dropdownStatusItems {
    List<DropdownMenuItem<int>> menuItems = [
      const DropdownMenuItem(value: 1, child: Text("باز")),
      const DropdownMenuItem(value: 2, child: Text("بسته")),
    ];
    return menuItems;
  }

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
  final _titleController = TextEditingController();
  final _controller = QuillController.basic();
  final _fundNeededController = TextEditingController();
  final _minInvestController = TextEditingController();
  final _expectedController = TextEditingController();
  final _finishedController = TextEditingController();
  final _startController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _ifbUuidController = TextEditingController();
   final _commisionController = TextEditingController();
   final _profitController = TextEditingController();
  void initState() {
    _titleController.text = widget._project.title;
    // final delta = Delta.fromJson(jsonDecode(widget._project.description));
    _controller.document =
        Document.fromJson(jsonDecode(widget._project.description));
    // selection:
    // const TextSelection.collapsed(offset: 0);
    widget._project.properties?.forEach((property) {
      addKeyValuePair(property.key!, property.value!);
    });
     widget._project.timeTables?.forEach((timeTable) {
      addTimeValuePair(timeTable.title!, timeTable.date!);
    });
    _fundNeededController.text =
        widget._project.fundNeeded.toString().toPersianDigit().seRagham();
    _minInvestController.text =
        widget._project.minInvest.toString().toPersianDigit().seRagham();
    _expectedController.text = widget._project.expectedProfit;
    _finishedController.text = widget._project.finishAt.toPersianDate();
    _startController.text = widget._project.startAt.toPersianDate();
    _shortDescriptionController.text = widget._project.shortDescription ?? '';
    _ifbUuidController.text = widget._project.ifbUuid.toEnglishDigit();
    _commisionController.text = widget._project.commission.toString().toPersianDigit();
    _profitController.text = widget._project.profit.toPersianDigit();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ویرایش کردن طرح',
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
                      inputFormatters: [PersianNumberFormatter()],
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
                        labelText: 'کم ترین مقدار سرمایه(تومان)',
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
                        labelText: 'سود مورد انتظار (درصد)',
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
                      controller: _ifbUuidController,
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
                        labelText: 'کد فرابورسی',
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
                          return 'لطفا کد فرابورسی را وارد کنید';
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
                        isStartDatePressed = true;
                        start = await showPersianDatePicker(
                            confirmText: 'انتخاب',
                            initialEntryMode: PDatePickerEntryMode.input,
                            initialDatePickerMode: PDatePickerMode.year,
                            context: context,
                            initialDate: Jalali(1300, 4),
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
                        isDatePressed = true;
                        picked = await showPersianDatePicker(
                            initialEntryMode: PDatePickerEntryMode.input,
                            initialDatePickerMode: PDatePickerMode.year,
                            confirmText: 'انتخاب',
                            context: context,
                            initialDate: Jalali(1300, 4),
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
                          selectedPriority = true;
                          selectedPriorityValue = newValue!;
                        });
                      },
                      value: selectedPriorityValue,
                    ),
                  ),
                  DropdownButtonFormField(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: InputDecoration(
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
                      items: dropdownStatusItems,
                      elevation: 4,
                      hint: widget._project.status == 1
                          ? const Text('باز')
                          : const Text('بسته'),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectStatusValue = newValue!;
                        });
                      },
                      value: selectStatusValue),
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
                            // Update the ListView by calling setState
                            setState(() {});
                            // addKeyValuePair(
                            //     _keyController.text, _valueController.text);
                            // _keyController.clear();
                            // _valueController.clear();
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
Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _titleKeyController,
                            decoration: InputDecoration(
                              labelText: 'عنوان تاریخ',
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
                            controller: _dateValueController,
                            readOnly: true,
                            onTap: () async{
                                 keyDate = await showPersianDatePicker(
                            confirmText: 'انتخاب',
                            initialEntryMode: PDatePickerEntryMode.input,
                            initialDatePickerMode: PDatePickerMode.year,
                            context: context,
                            initialDate: Jalali.now(),
                            firstDate: Jalali(1300, 4),
                            lastDate: Jalali(1450, 4));

                        setState(() {
                          _dateValueController.text =
                              "${keyDate!.toGregorian().year}/${keyDate!.toGregorian().month}/${keyDate!.toGregorian().day}";
                                
                        });
                        setState(
                          () {
                           _dateValueController.text =
                              keyDate!.formatFullDate().toPersianDigit();
                          },
                        );
                            },
                            decoration: InputDecoration(
                              labelText: 'تاریخ',
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
                            addTimeValuePair(
                                _titleKeyController.text, '${keyDate!.toGregorian().toDateTime()}');
                            _titleKeyController.clear();
                            _dateValueController.clear();
                          },
                          child:
                              buildPhosphorIcon(PhosphorIconsBold.plusCircle),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: timeTable.length * 80,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _screenController,
                      itemCount: timeTable.length,
                      itemBuilder: (context, index) {
                      
                        return Column(
                          children: [
                            ListTile(
                              isThreeLine: true,
                              title: Text(
                                'لیبل: ${timeTable[index]['title'] ?? ''}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                'تاریخ:${timeTable[index]['date']!=null?
                                timeTable[index]['date']!.toString().toPersianDate():""
                                 }',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                  color: AppColorScheme.primaryColor,
                                  icon: buildPhosphorIcon(PhosphorIconsBold.pencilSimple),
                                  onPressed: () {
                                    _showEditDialog(context, index);
                                  },
                                ),
                                  IconButton(
                                    color: AppColorScheme.primaryColor,
                                    icon: buildPhosphorIcon(
                                      PhosphorIconsBold.trash,
                                    ),
                                    onPressed: () {
                                      // Add logic to remove the key-value pair at the given index
                                      setState(() {
                                        timeTable.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
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
                  BlocListener<EditProjectBloc, EditProjectState>(
                    listener: (context, state) {
                      if (state is EditProjectResponseState) {
                        state.response.fold(
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return BlocProvider(
                                    create: (context) => ProjectBloc(),
                                    child: const ProjectHome(),
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
                          
                            final title = _titleController.text;
                            final shortDescription =
                                _shortDescriptionController.text;
                            final description = jsonEncode(
                                _controller.document.toDelta().toJson());

                            final type = 1;
                            var status = selectStatusValue != null
                                ? selectStatusValue!
                                : widget._project.status;
                            var priority = selectedPriorityValue != null
                                ? selectedPriorityValue!
                                : widget._project.priority;
                            // print(priority);
                            final minInvest = _minInvestController.text
                                .replaceAll(',', '')
                                .toEnglishDigit();
                            final fundNeeded = _fundNeededController.text
                                .replaceAll(',', '')
                                .toEnglishDigit();
                            final ifbUuid =
                                _ifbUuidController.text.toEnglishDigit();
                            final expectedProfit =
                                _expectedController.text.toEnglishDigit();
                            final finishAt = isDatePressed
                                ? '${picked!.toGregorian().year}-${picked!.toGregorian().month}-${picked!.toGregorian().day}'
                                : jalili2Gorgian(_finishedController.text);

                            final startAt = isStartDatePressed
                                ? '${start!.toGregorian().year}-${start!.toGregorian().month}-${start!.toGregorian().day}'
                                : jalili2Gorgian(_startController.text);

                            final commison = int.parse(_commisionController.text.toEnglishDigit()); 

                            final profit = _profitController.text.toEnglishDigit();   
                            BlocProvider.of<EditProjectBloc>(context).add(
                              EditProjectRequestEvent(
                                  widget._project.uuid,
                                  title,
                                  description,
                                  type,
                                  status,
                                  priority,
                                  minInvest,
                                  fundNeeded,
                                  expectedProfit,
                                  finishAt,
                                  startAt,
                                  keyValues,
                                  timeTable,
                                  shortDescription,
                                  ifbUuid,profit),
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
                        child: BlocBuilder<EditProjectBloc, EditProjectState>(
                          builder: (context, state) {
                            if (state is EditProjectLoadingState) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'در حال دخیره',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  CircularProgressIndicator()
                                ],
                              );
                            } else {
                              return Text(
                                'ویرایش',
                                style: Theme.of(context).textTheme.bodySmall,
                              );
                            }
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
  TextEditingController titleController = TextEditingController(text: timeTable[index]['title']);
  TextEditingController dateController = TextEditingController(text: timeTable[index]['date'].toString().toPersianDate());
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
                    time =  pickedDate.toGregorian().toDateTime().toString();
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
