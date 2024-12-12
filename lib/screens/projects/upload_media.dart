import 'dart:developer';
import 'dart:io';
import 'dart:js_interop';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_bloc.dart';
import 'package:admin_smartfunding/screens/projects/create_project.dart';
import 'package:admin_smartfunding/screens/projects/project_home.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/ProjectBloc/upload_media/upload_media_bloc.dart';
import '../../bloc/ProjectBloc/upload_media/upload_media_event.dart';
import '../../bloc/ProjectBloc/upload_media/upload_media_state.dart';
import '../../responsive/responsive.dart';

class UploadMediaScreen extends StatefulWidget {
  String uuid;
  UploadMediaScreen(this.uuid, {super.key});

  @override
  State<UploadMediaScreen> createState() => _UploadMediaScreenState();
}

class _UploadMediaScreenState extends State<UploadMediaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _collectionController = TextEditingController(text: "images");

  String? pickedImagePath;
  XFile? pickedImage;
  PlatformFile? file;
  PlatformFile? pdfFile;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("عکس"), value: "images"),
      const DropdownMenuItem(child: Text("فایل"), value: "attachments"),
      const DropdownMenuItem(child: Text("قرارداد"), value: "contract")
    ];
    return menuItems;
  }

  String selectedValue = "images";
  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _pickImage = ImagePicker();
      XFile? image = await _pickImage.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          pickedImage = image;
          pickedImagePath = image.path;
          // print(pickedImagePath);
        });
      } else {
        // print('no image has been picked');
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

  Future<void> pickAndPlayVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: true,
    );

    if (result != null) {
      file = result.files.first;
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
      allowCompression: true,
    );

    if (result != null) {
      pdfFile = result.files.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => BlocProvider(
                      create: (context) => ProjectBloc(),
                      child: ProjectHome(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: BlocListener<UploadMediaBloc, UploadMediaState>(
            listener: (context, state) {
              if (state is UploadMediaResponseState) {
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => ProjectBloc(),
                          child: ProjectHome(),
                        ),
                      ),
                    );
                    // Navigator.pop(context);
                  },
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.all(Responsive.isDesktop(context) ? 70 : 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'عنوان',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'لطفا عنوان را وراد کنید';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
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
                          items: dropdownItems,
                          elevation: 4,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                          value: selectedValue,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (selectedValue == 'images')
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            dashPattern: const [10, 10],
                            color: Colors.grey,
                            strokeWidth: 2,
                            child:
                                pickedImagePath != null && pickedImagePath != ''
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
                        if (selectedValue == 'video')
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            dashPattern: const [10, 10],
                            color: Colors.grey,
                            strokeWidth: 2,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: BlocBuilder<UploadMediaBloc,
                                    UploadMediaState>(
                                  builder: (context, state) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (state
                                            is UploadMediaLoadingState) ...{
                                          CircularProgressIndicator()
                                        } else ...{
                                          IconButton(
                                            onPressed: () {
                                              pickAndPlayVideo();
                                            },
                                            icon: const Icon(
                                                Icons.video_chat_outlined),
                                          )
                                        }
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        if (selectedValue == 'attachments' ||
                            selectedValue == 'contract')
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            dashPattern: const [10, 10],
                            color: Colors.grey,
                            strokeWidth: 2,
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: BlocBuilder<UploadMediaBloc,
                                    UploadMediaState>(
                                  builder: (context, state) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (state
                                            is UploadMediaLoadingState) ...{
                                          CircularProgressIndicator()
                                        } else ...{
                                          IconButton(
                                            onPressed: () {
                                              pickFile();
                                            },
                                            icon: const Icon(
                                                Icons.picture_as_pdf_rounded),
                                          )
                                        }
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                minimumSize: const Size(150, 50)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // print(webImage);
                                // print(pickedImage!.path);
                                //print(_paths!.first.bytes!);
                                final name = _nameController.text;

                                if (selectedValue == 'images') {
                                  if (pickedImage == 'null') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('لطفا عکس را آپلود کنید'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    BlocProvider.of<UploadMediaBloc>(context)
                                        .add(
                                      UploadMediaRequestEvent(
                                        widget.uuid,
                                        name,
                                        selectedValue,
                                        pickedImage!,
                                      ),
                                    );
                                  }
                                }

                                if (selectedValue == 'attachments') {
                                  if (pdfFile == 'null') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('لطفا فایل را آپلود کنید'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    BlocProvider.of<UploadMediaBloc>(context)
                                        .add(
                                      UploadFileRequestEvent(widget.uuid, name,
                                          pdfFile!, 'attachments'),
                                    );
                                  }
                                }
                                if (selectedValue == 'contract') {
                                  if (pdfFile == 'null') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('لطفا فایل را آپلود کنید'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    BlocProvider.of<UploadMediaBloc>(context)
                                        .add(
                                      UploadFileRequestEvent(widget.uuid, name,
                                          pdfFile!, 'contract'),
                                    );
                                  }
                                }
                              }
                            },
                            child:
                                BlocBuilder<UploadMediaBloc, UploadMediaState>(
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (state is UploadMediaLoadingState) ...{
                                      const Text('در حال آپلود'),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    } else ...{
                                      const Text('اضافه کردن'),
                                    }
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
