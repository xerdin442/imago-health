import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/services/user_auth_services/login_services.dart';
import 'package:test/core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoading = false;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _onLoginPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, String> formData = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      try {
        await LoginServices().loginUser(formData);
        _emailController.clear;
        _passwordController.clear;
        setState(() {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'home',
            (Route<dynamic> route) => false,
          );
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text("An error occurred")),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                        image: const AssetImage("assets/images/male-doc.png"),
                        colorFilter: ColorFilter.mode(
                          const Color(0xff9169C1).withOpacity(0.4),
                          BlendMode.dstATop,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.5.sh,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 0.65.sh,
                      transform: Matrix4.translationValues(0, 0.01.sw, 0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 5.w),
                                child: Text(
                                  localizations.login,
                                  style: TextStyle(
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.h),
                              _buildEmailField(localizations),
                              SizedBox(height: 0.02.sh),
                              _buildPasswordField(localizations),
                              SizedBox(height: 30.h),
                              _buildLoginButton(localizations),
                              SizedBox(height: 10.h),
                            ],
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
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
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

  Widget _buildLoginButton(AppLocalizations localization) {
    return Center(
      child: SizedBox(
        height: 0.065.sh,
        width: 0.5.sw,
        child: ElevatedButton(
          onPressed: _onLoginPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: appColorLightPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.r)),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isLoading)
                CupertinoActivityIndicator(
                  radius: 10.r,
                ),
              if (!_isLoading)
                Text(
                  localization.login,
                  style: TextStyle(color: appColorWhite, fontSize: 18.sp),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
