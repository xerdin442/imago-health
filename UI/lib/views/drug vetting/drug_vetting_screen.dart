import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/core/services/drug%20vetting%20service/upload_image_service.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/widgets/build_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrugVettingScreen extends StatefulWidget {
  const DrugVettingScreen({super.key});

  @override
  State<DrugVettingScreen> createState() => _DrugVettingScreenState();
}

class _DrugVettingScreenState extends State<DrugVettingScreen> {
  File? selectedImage;
  late XFile _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(
        () {
          selectedImage = File(pickedFile.path);
          _image = pickedFile;
        },
      );
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.photoLibrary),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(AppLocalizations.of(context)!.camera),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColorWhite,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTitle(
                    context: context,
                    text: AppLocalizations.of(context)!.drugVettingTitle,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.chooseMethod,
                    style: fontStyle.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                _buildImageCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context) {
    return Container(
      height: 280.h,
      width: 360.w,
      decoration: BoxDecoration(
        color: appColorDarkPurple,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200.w,
            height: 200.h,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    image: selectedImage != null
                        ? DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: selectedImage == null
                      ? Center(
                          child: IconButton(
                            onPressed: () {
                              _showPicker(context);
                            },
                            icon: const Icon(Icons.photo_camera),
                            iconSize: 80.r,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                if (selectedImage != null)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Material(
                      elevation: 3,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            _showPicker(context);
                          },
                          icon: const Icon(Icons.photo_camera_outlined),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          selectedImage == null
              ? Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.imageInstruction,
                  style: TextStyle(
                      color: appColorWhite,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                )
              : SizedBox(
                  height: 18.h,
                ),
          if (selectedImage != null)
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await UploadImageService().uploadImage(context, _image);
                  Navigator.pushNamed(context, 'vetchat');
                  setState(() {
                    _isLoading = false;
                  });
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: _isLoading
                  ? const CupertinoActivityIndicator() 
                  : Text(
                      AppLocalizations.of(context)!.uploadImage,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
