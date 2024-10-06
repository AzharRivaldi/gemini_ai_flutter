import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/global_variable.dart';

class FragmentGenerateImage extends StatefulWidget {
  const FragmentGenerateImage({super.key});

  @override
  State<FragmentGenerateImage> createState() => _FragmentGenerateImageState();
}

class _FragmentGenerateImageState extends State<FragmentGenerateImage> {
  TextEditingController textEditingController = TextEditingController();
  String strAnswer = '';
  bool visibleSP = false;
  File? imageFile;
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              height: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              getFromGallery();
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(200)
                                                      ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.center,
                                                    colors: [
                                                      Colors.red,
                                                      Colors.redAccent
                                                    ],
                                                  )
                                              ),
                                              child: const Icon(
                                                Icons.image_search_outlined,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Galeri',
                                        ),
                                      ]
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            getFromCamera();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(200)
                                                    ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.center,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.blueAccent
                                                  ],
                                                )
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Kamera',
                                      ),
                                    ],
                                  )
                                ],
                              )
                          )
                      );
                    });
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                width: size.width,
                height: 250,
                child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    color: const Color(0xFF5A5A5A),
                    strokeWidth: 1,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                      child: FittedBox(
                        child: imageFile != null
                            ? Image.file(File(imageFile!.path),
                                fit: BoxFit.cover)
                            : const Icon(
                                Icons.image_outlined,
                                color: Color(0xFF5A5A5A),
                              ),
                      ),
                    )
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: textEditingController,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: textEditingController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              textEditingController.clear();
                              visibleSP = false;
                              imageFile = null;
                              setState(() {});
                            },
                            icon: const Icon(Icons.cancel, color: Colors.red))
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(
                              color: Colors.amber,
                              width: 1
                          ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xFF5A5A5A), width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Enter your request here',
                    labelStyle: const TextStyle(color: Colors.black)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A5A5A),
                    shape: const StadiumBorder()
                ),
                onPressed: () {
                  if (textEditingController.text.isEmpty || imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(
                                  'Ups, keyword dan gambar tidak boleh kosong!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Chirp')
                              )
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      shape: StadiumBorder(),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                  else {
                    visibleSP = true;
                    GenerativeModel model = GenerativeModel(
                        model: 'gemini-1.5-flash-latest', apiKey: API_KEY);
                    model.generateContent([
                      Content.multi([
                        TextPart(textEditingController.text),
                        if (imageFile != null)
                          DataPart('image/jpeg',
                              File(imageFile!.path).readAsBytesSync()
                          )
                      ]),
                    ]).then((value) => setState(() {
                          strAnswer = value.text.toString();
                    }));
                  }
                },
                child: const Text('Send'),
              ),
            ),
            Visibility(
                visible: visibleSP,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF5A5A5A)),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: MarkdownBody(data: strAnswer),
                  ),
                )
            )
          ],
        )
    );
  }

  // get from gallery
  getFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // get from camera
  getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
