import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/core/services/emergency%20chat%20service/chat_services.dart';
import 'package:test/models/chat%20model/chat_model.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_history_provider.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_id_provider.dart';

class EmergencyChatbot extends StatefulWidget {
  const EmergencyChatbot({super.key});

  @override
  State<EmergencyChatbot> createState() => _ChatBotState();
}

class _ChatBotState extends State<EmergencyChatbot> {
  final TextEditingController _messageController = TextEditingController();
  bool _messageHasData = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _messageHasData = _messageController.text.isNotEmpty;
    });
  }

  Future<void> _sendMessage(BuildContext context) async {
    if (_messageHasData && !_isLoading) {
      final chatMessage = ChatMessage(
        content: _messageController.text,
        sender: Sender.user,
      );

      final chatIdProvider =
          Provider.of<EmergencyChatIdProvider>(context, listen: false);
      final chatHistoryProvider =
          Provider.of<EmergencyChatHistoryProvider>(context, listen: false);

      // Add the user's message to the provider and display it
      chatHistoryProvider.addEmergencyMessage(chatMessage);

      // Clear the input field
      _messageController.clear();
      _messageHasData = false;

      // Show loading indicator
      setState(() {
        _isLoading = true;
      });

      // Send the user's message to the server and fetch AI's response
      final emergencyChatService =
          EmergencyChatService(chatIdProvider, chatHistoryProvider);
      await emergencyChatService.askAssitant(
        {
          "emergency": chatMessage.content,
        },
        context,
      );

      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatHistoryProvider =
        Provider.of<EmergencyChatHistoryProvider>(context);
    List<ChatMessage> chatHistory = chatHistoryProvider.emergencyChatHistory;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: appColorWhite,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.all(20.dm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30.h,
                child: Image.asset('assets/images/mdi.png'),
              ),
              SizedBox(
                height: 30.h,
                child: Image.asset('assets/images/medical-icon.png'),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset:
          true, // This ensures the layout resizes when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: false,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                    .onDrag, // To ensure that the ListView scrolls to the bottom when new messages are added
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(20.dm),
                        itemCount: chatHistory.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < chatHistory.length) {
                            final message = chatHistory[index];
                            return Align(
                              alignment: message.sender == Sender.user
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: _buildTextMessage(message),
                            );
                          } else {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: _buildLoadingIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: Container(
                height: 55.0.h,
                decoration: BoxDecoration(
                  color: const Color(0xff9169C1).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  children: [
                    const Icon(
                      Icons.photo,
                      color: appColorDarkPurple,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Enter your message here",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 15.0.h),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    if (_messageHasData)
                      InkWell(
                        onTap: () => _sendMessage(context),
                        child:
                            const Icon(Icons.send, color: appColorDarkPurple),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextMessage(ChatMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.all(10.dm),
      decoration: BoxDecoration(
        color: message.sender == Sender.user
            ? appColorLightPurple
            : appColorDarkPurple,
        borderRadius: message.sender == Sender.user
            ? BorderRadius.only(
                topRight: Radius.circular(15.r),
                topLeft: Radius.circular(15.r),
                bottomLeft: Radius.circular(15.r),
              )
            : BorderRadius.only(
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
      ),
      child: message.sender == Sender.user
          ? Text(
              message.content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : Center(
              child: Text(
                message.content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.all(10.dm),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CupertinoActivityIndicator(),
        ],
      ),
    );
  }
}
