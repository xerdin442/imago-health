import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/core/services/emergency%20chat%20service/chat_services.dart';
import 'package:test/models/chat%20model/chat_model.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_history_provider.dart';
import 'package:test/view%20model/emegency%20view%20model/emergency_chat_id_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final FocusNode _messageFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  bool _messageHasData = false;

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

  bool _isLoading = false;
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool _isLoading3 = false;
  bool _isLoading4 = false;
  bool _isLoading5 = false;
  bool _isLoading6 = false;

  Future<void> _sendTextMessage(BuildContext context,
      {required String message}) async {
    if (_messageHasData && !_isLoading) {
      final chatMessage = ChatMessage(
        content: message,
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

      print("Process begun");
      // Send the user's message to the server and fetch AI's response
      final emergencyChatServices =
          EmergencyChatService(chatIdProvider, chatHistoryProvider);
      await emergencyChatServices.askAssistant(
        {
          "userPrompt": chatMessage.content,
        },
        context,
      );

      Navigator.pushNamed(context, "emergencyChatBot");
    }
  }

  Future<void> _sendEmergencyMessage(BuildContext context,
      {required String message}) async {
    final chatMessage = ChatMessage(
      content: message,
      sender: Sender.user,
    );

    final chatIdProvider =
        Provider.of<EmergencyChatIdProvider>(context, listen: false);
    final chatHistoryProvider =
        Provider.of<EmergencyChatHistoryProvider>(context, listen: false);

    // Adds the user's message to the provider and display it
    chatHistoryProvider.addEmergencyMessage(chatMessage);

    setState(() {
      _isLoading = true;
    });

    print("Process begun");
    // Send the user's message to the server and fetch AI's response
    final emergencyChatServices =
        EmergencyChatService(chatIdProvider, chatHistoryProvider);
    await emergencyChatServices.askAssistant(
      {
        "userPrompt": chatMessage.content,
      },
      context,
    );

    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamed(context, "emergencyChatBot");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(AppLocalizations.of(context)!.emergencyTitle),
        backgroundColor: appColorWhite,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              _buildEmergencyItem(
                icon: Icons.favorite,
                text: AppLocalizations.of(context)!.heartAttack,
                ontap: () async {
                  setState(() {
                    _isLoading1 = true;
                  });
                  try {
                    await _sendEmergencyMessage(context,
                        message: 'Heart Attack');
                    setState(() {
                      _isLoading1 = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isLoading1 = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("An error occurred")),
                      ),
                    );
                  }
                },
                trailing: _isLoading1
                    ? CupertinoActivityIndicator(
                        color: appColorDarkPurple,
                      )
                    : Icon(Icons.arrow_forward),
              ),
              _buildEmergencyItem(
                icon: Icons.whatshot,
                text: AppLocalizations.of(context)!.severeBurnsOrInjuries,
                ontap: () async {
                  setState(() {
                    _isLoading2 = true;
                  });

                  try {
                    await _sendEmergencyMessage(context,
                        message: 'Severe Burns or injuries');
                    setState(() {
                      _isLoading2 = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isLoading2 = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("An error occurred")),
                      ),
                    );
                  }
                },
                trailing: _isLoading2
                    ? CupertinoActivityIndicator(
                        color: appColorDarkPurple,
                      )
                    : Icon(Icons.arrow_forward),
              ),
              _buildEmergencyItem(
                icon: Icons.air,
                text: AppLocalizations.of(context)!.asthmaAttacks,
                ontap: () async {
                  setState(() {
                    _isLoading3 = true;
                  });

                  try {
                    await _sendEmergencyMessage(context,
                        message: 'Asthma attacks');
                    setState(() {
                      _isLoading3 = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isLoading3 = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("An error occurred")),
                      ),
                    );
                  }
                },
                trailing: _isLoading3
                    ? CupertinoActivityIndicator(
                        color: appColorDarkPurple,
                      )
                    : Icon(Icons.arrow_forward),
              ),
              _buildEmergencyItem(
                icon: Icons.broken_image_sharp,
                text: AppLocalizations.of(context)!.fracturedBone,
                ontap: () async {
                  setState(() {
                    _isLoading4 = true;
                  });
                  try {
                    await _sendEmergencyMessage(context,
                        message: 'Fractured Bone');
                    setState(() {
                      _isLoading4 = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isLoading4 = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("An error occurred")),
                      ),
                    );
                  }
                },
                trailing: _isLoading4
                    ? CupertinoActivityIndicator(
                        color: appColorDarkPurple,
                      )
                    : Icon(Icons.arrow_forward),
              ),
              _buildEmergencyItem(
                icon: Icons.medical_services,
                text: AppLocalizations.of(context)!.poisoningOrOverdose,
                ontap: () async {
                  setState(() {
                    _isLoading5 = true;
                  });
                  try {
                    await _sendEmergencyMessage(context,
                        message: 'Poisoning or overdose');
                    setState(() {
                      _isLoading5 = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isLoading5 = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("An error occurred")),
                      ),
                    );
                  }
                },
                trailing: _isLoading5
                    ? CupertinoActivityIndicator(
                        color: appColorDarkPurple,
                      )
                    : Icon(Icons.arrow_forward),
              ),
              _buildEmergencyItem(
                icon: Icons.phone,
                text: AppLocalizations.of(context)!.accessToCare,
                ontap: () async {
                  setState(() {
                    _isLoading6 = true;
                  });
                  try {
                    await _sendEmergencyMessage(context,
                        message: 'Access to Care');
                    setState(() {
                      _isLoading6 = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isLoading6 = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: Text("An error occurred")),
                      ),
                    );
                  }
                },
                trailing: _isLoading6
                    ? CupertinoActivityIndicator(
                        color: appColorDarkPurple,
                      )
                    : Icon(Icons.arrow_forward),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                child: Text(
                  AppLocalizations.of(context)!.textPrompt,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.dm),
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
                          padding: EdgeInsets.only(left: 10.dm),
                          child: TextFormField(
                            onChanged: (value) {},
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.messageHint,
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0.h),
                            ),
                          ),
                        ),
                      ),
                      if (_messageHasData)
                        InkWell(
                          onTap: () {
                            _sendTextMessage(context,
                                message: _messageController.text);
                          },
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
      ),
    );
  }

  Widget _buildEmergencyItem({
    required IconData icon,
    required String text,
    required VoidCallback ontap,
    required Widget trailing,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          height: 55.h,
          child: GestureDetector(
              onTap: ontap,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(icon),
                title: Text(text),
                trailing: trailing,
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: const Divider(),
        ),
      ],
    );
  }
}
