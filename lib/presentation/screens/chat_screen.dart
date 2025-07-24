import 'dart:developer';

import 'package:demo/widgets/custom_ui.dart';
import 'package:demo/widgets/text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:svg_flutter/svg.dart';

import '../../constants/utilities.dart';
import '../../data/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.id});
  final int id;
  static String route = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late io.Socket socket;

  List<MessageModel> messages = <MessageModel>[];
  void connect() {
    try {
      socket = io.io('http://10.0.2.2:3050', <String, Object>{
        'transports': <String>['websocket'],
        'autoConnect': false,
      });
      socket.connect();

      socket.on('connect', (dynamic msg) {
        // Emit a "user-joined" event with the user ID when the socket connects
        socket.emit('user-joined', <String, Object?>{
          'userId': widget.id,
          'socket': socket.id,
        });
      });

      socket.emit('user-joined', widget.id);
      log('id ${widget.id}');
      socket.onDisconnect((_) {});

      socket.onConnect((_) {});
      // socket.onAny((String event, dynamic data) => print(event));
      socket.on('boardcontent', (dynamic msg) {
        setState(() {
          final MessageModel messageModel =
              MessageModel()
                ..sendBy = msg['send_by']
                ..sendTo = msg['send_to']
                ..text = msg['text'];
          messages.add(messageModel);
        });
      });
      socket.hasListeners('boardcontent');
      socket.onError((dynamic data) => log(data));
    } catch (e) {
      log(e.toString());
    }
  }

  void sendMessage({
    required String message,
    required int sourceId,
    required int targetId,
  }) {
    setState(() {
      final MessageModel messageModel =
          MessageModel()
            ..sendBy = sourceId
            ..sendTo = targetId
            ..text = message;
      messages.add(messageModel);
    });
    socket.emit('message', <String, Object>{
      'text': message,
      'send_by': sourceId,
      'send_to': targetId,
    });
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController chatController = TextEditingController();
    return CustomUi(
      title: 'Orado',
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BuildTextFormField(
        // padding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.grey.shade200,
        controller: chatController,
        hint: 'Message',
        suffix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: CircleAvatar(
            backgroundColor: AppColors.baseColor,
            child: IconButton(
              onPressed: () {
                sendMessage(
                  message: chatController.text,
                  sourceId: widget.id,
                  targetId: widget.id == 1 ? 2 : 1,
                );
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ),
      ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
          // reverse: true,
          itemCount: messages.length,
          itemBuilder: (BuildContext c, int i) {
            return ChatBox(
              isUserMessage: messages[i].sendBy == widget.id,
              message: messages[i].text.toString(),
            );
          },
        ),
      ],
    );

    Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppColors.baseColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
        ),
        title: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: SvgPicture.asset('assets/images/logo.svg', height: 33),
            ),
            const SizedBox(width: 20),
            Text(
              'Orado',
              style: AppStyles.getSemiBoldTextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
            // reverse: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext c, int i) {
              return ChatBox(
                isUserMessage: messages[i].sendBy == widget.id,
                message: messages[i].text.toString(),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BuildTextFormField(
        // padding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.grey.shade200,
        controller: chatController,
        hint: 'Message',
        suffix: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: CircleAvatar(
            backgroundColor: AppColors.baseColor,
            child: IconButton(
              onPressed: () {
                sendMessage(
                  message: chatController.text,
                  sourceId: widget.id,
                  targetId: widget.id == 1 ? 2 : 1,
                );
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBox extends StatelessWidget {
  const ChatBox({super.key, this.isUserMessage = false, required this.message});
  final bool isUserMessage;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          if (isUserMessage) Expanded(flex: 2, child: Container()),
          Flexible(
            flex: 4,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: !isUserMessage ? Colors.grey.shade300 : AppColors.yellow,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(message),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '11:31 AM',
                      style: AppStyles.getMediumTextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isUserMessage) Expanded(flex: 2, child: Container()),
        ],
      ),
    );
  }
}
