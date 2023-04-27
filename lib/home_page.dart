import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:gpt_dall/provider/model_provider.dart';
import 'package:gpt_dall/services/api_services.dart';
import 'package:gpt_dall/services/services.dart';
import 'package:gpt_dall/widgets/chat_widget.dart';

import 'package:provider/provider.dart';

import 'models/chat_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int start = 200;
  final int delay = 200;
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late FocusNode focusNode;
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff343541),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(left: 11),
            child: ElasticIn(
              delay: Duration(milliseconds: delay),
              child: const Image(
                image: AssetImage("assets/images/mistletoe.png"),
              ),
            ),
          ),
          centerTitle: true,
          title: FadeInRight(
            delay: Duration(milliseconds: 300 + delay),
            child: const Text(
              "Kepton",
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Color(0xffFFFFFF),
              ),
            ),
          ),
          backgroundColor: const Color(0xff1E1E1E),
          actions: [
            IconButton(
              onPressed: () async {
                await Services.showModelSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatList[index].msg,
                        chatIndex: chatList[index].chatIndex,
                      );
                    }),
              ),
              if (_isTyping) ...[
                const SpinKitSpinningLines(
                  color: Color(0xff7DF9FF),
                  size: 25,
                ),
              ],
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: const EdgeInsets.only(left: 1, right: 1, bottom: 3),
                child: Material(
                  color: const Color(0xff181818),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(1).copyWith(left: 10, right: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: focusNode,
                            cursorColor: Colors.cyan,
                            style: const TextStyle(color: Colors.white),
                            controller: textEditingController,
                            onSubmitted: (value) async {
                              await sendMessageFCT(
                                modelsProvider: modelsProvider,
                              );
                            },
                            decoration: const InputDecoration.collapsed(
                              hintText: "How can I help you?",
                              hintStyle: TextStyle(
                                color: Color(0xff787276),
                                fontFamily: 'PoltawskiNowy',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await sendMessageFCT(
                              modelsProvider: modelsProvider,
                            );
                          },
                          icon: const Icon(
                            Icons.send_outlined,
                            color: Color(0xff607D8B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    try {
      setState(() {
        _isTyping = true;
        chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatList.addAll(await ApiServices.sendMessage(
        message: textEditingController.text,
        modelId: modelsProvider.getCurrentModel,
      ));
      setState(() {});
    } catch (error) {
      log("error $error");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }
}
