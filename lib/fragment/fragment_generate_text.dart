import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/global_variable.dart';

class FragmentGenerateText extends StatefulWidget {
  const FragmentGenerateText({super.key});

  @override
  State<FragmentGenerateText> createState() => _FragmentGenerateTextState();
}

class _FragmentGenerateTextState extends State<FragmentGenerateText> {
  TextEditingController textEditingController = TextEditingController();
  String strAnswer = '';
  bool visibleSP = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: textEditingController,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.red,
                          icon: Icon(textEditingController.text.isNotEmpty
                              ? Icons.cancel
                              : null),
                          onPressed: () {
                            textEditingController.clear();
                            visibleSP = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.amber,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(
                          color: Color(0xFF5A5A5A),
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Enter your request here',
                    labelStyle: const TextStyle(
                        color: Colors.black)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A5A5A),
                    shape: const StadiumBorder()),
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text('Ups, keyword tidak boleh kosong!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Chirp')
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      shape: StadiumBorder(),
                      behavior: SnackBarBehavior.floating,
                    ));
                  } else {
                    visibleSP = true;
                    GenerativeModel model = GenerativeModel(
                        model: 'gemini-1.5-flash-latest',
                        apiKey: API_KEY);
                    model.generateContent([
                      Content.text(textEditingController.text),
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF5A5A5A)),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: MarkdownBody(
                        data: strAnswer
                    ),
                  ),
                )
            )
          ],
        )
    );
  }
}
