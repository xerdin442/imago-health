import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/services/user_auth_services/register_services.dart';
import 'package:test/core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggleObscureText2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Future<void> _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, String> formData = {
        'fullname': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text
      };

      await RegisterServices().registerUser(formData);

      _nameController.clear;
      _emailController.clear;
      _passwordController.clear;
      _confirmPasswordController.clear;

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: appColorWhite,
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 1.sh,
                child: Stack(children: [
                  Container(
                    height: 0.7.sh,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: const Color(0xff9169C1).withOpacity(0.8),
                      image: DecorationImage(
                        image: const AssetImage("assets/images/female-doc.png"),
                        colorFilter: ColorFilter.mode(
                          const Color(0xff9169C1).withOpacity(0.4),
                          BlendMode.dstATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.45.sh,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 0.55.sh,
                      transform: Matrix4.translationValues(0, 0.01.sw, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                        child: Form(
                          key: _formKey,
                          child: SizedBox(
                            width: 1.sw,
                            height: 0.46.sh,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Text(
                                      localizations!.register,
                                      style: TextStyle(
                                          fontSize: 35.sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Kanit'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  _buildFullNameField(localizations),
                                  SizedBox(height: 0.02.sh),
                                  _buildEmailField(localizations),
                                  SizedBox(height: 0.02.sh),
                                  _buildPasswordField(localizations),
                                  SizedBox(height: 0.02.sh),
                                  _buildConfirmPasswordField(localizations),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  _buildRegisterButton(localizations),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(AppLocalizations localization) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.email,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 0.85.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: appColorLightPurple,
                  width: 3.w,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.enterYourEmail;
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return localization.enterValidEmail;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullNameField(AppLocalizations localization) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.fullName,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 0.85.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: appColorLightPurple,
                  width: 3.w,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.enterYourFullName;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(AppLocalizations localization) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.password,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 0.85.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: appColorLightPurple,
                  width: 3.w,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.enterYourPassword;
                  }
                  if (value.length < 8) {
                    return localization.passwordMinLength;
                  }
                  return null;
                },
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText1 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _toggleObscureText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmPasswordField(AppLocalizations localization) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.confirmPassword,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 0.82.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: appColorLightPurple,
                  width: 3,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                obscureText: _obscureText2,
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText2 ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _toggleObscureText2,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localization.confirmPasswordRequired;
                  }
                  if (value != _passwordController.text) {
                    return localization.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(AppLocalizations localization) {
    return SizedBox(
      width: double.infinity,
      height: 50.0.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColorLightPurple,
          textStyle: TextStyle(fontSize: 20.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        onPressed: _onRegisterPressed,
        child: _isLoading
            ? const CupertinoActivityIndicator()
            : Text(
                localization.register,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
