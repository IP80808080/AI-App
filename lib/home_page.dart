import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpt_dall/provider/chat_provider.dart';
import 'package:gpt_dall/models/chat_model.dart';
import 'package:gpt_dall/provider/model_provider.dart';
import 'package:gpt_dall/services/api_services.dart';
import 'package:gpt_dall/services/services.dart';
import 'package:gpt_dall/widgets/chat_widget.dart';
import 'package:gpt_dall/widgets/text_widget.dart';
import 'package:provider/provider.dart';

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
  late ScrollController _listScrollController;
  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  //List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

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
                    controller: _listScrollController,
                    itemCount:
                        chatProvider.getChatList.length, //chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatProvider
                            .getChatList[index].msg, // chatList[index].msg,
                        chatIndex: chatProvider.getChatList[index]
                            .chatIndex, //chatList[index].chatIndex,
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
                child: Material(
                  color: const Color(0xff181818),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
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
                                  chatProvider: chatProvider);
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
                                chatProvider: chatProvider);
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

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type Something.",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
