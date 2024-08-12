import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/models/chat%20model/chat_model.dart';
import 'package:test/view%20model/drug%20vetting%20view%20model/drug_vetting_chat_provider.dart';
import 'package:test/core/utility/constants.dart';

class DrugVettingChatbot extends StatefulWidget {
  const DrugVettingChatbot({super.key});

  @override
  State<DrugVettingChatbot> createState() => _ChatBotState();
}

class _ChatBotState extends State<DrugVettingChatbot> {
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  bool _messageHasData = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messageFocusNode.addListener(_onFocusChange);
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _messageController.dispose();
    Provider.of<DrugVettingChatProvider>(context, listen: false)
        .clearDrugVettingChatHistory();

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Update focus state
    });
  }

  void _onTextChanged() {
    setState(() {
      _messageHasData = _messageController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatHistoryProvider = Provider.of<DrugVettingChatProvider>(context);
    List<ChatMessage> chatHistory = chatHistoryProvider.drugVettingChatHistory;

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
                child: Image.asset('assets/images/mdi_drugs.png'),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: false,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
              ? appColorDarkPurple
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
        child: Text(
          message.content,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
        ));
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
