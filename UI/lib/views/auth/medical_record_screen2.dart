import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/core/services/user_auth_services/medical_records.dart';
import 'package:test/models/user%20record%20model/bloodgroup_model.dart';
import 'package:test/view%20model/medical%20record%20view%20model/medical_record_provider.dart';
import 'package:test/core/utility/config.dart';
import 'package:test/core/utility/constants.dart';
import 'package:test/widgets/popup/request_popup3.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MedicalRecordScreen2 extends StatefulWidget {
  const MedicalRecordScreen2({super.key});

  @override
  _MedicalRecordScreen2State createState() => _MedicalRecordScreen2State();
}

class _MedicalRecordScreen2State extends State<MedicalRecordScreen2> {
  final TextEditingController _detail1Controller = TextEditingController();
  final TextEditingController _detail2Controller = TextEditingController();
  final TextEditingController _detail3Controller = TextEditingController();
  final TextEditingController _detail4Controller = TextEditingController();

  bool _detail1HasData = false;
  bool _detail2HasData = false;
  bool _detail3HasData = false;
  bool _detail4HasData = false;

  String? _selectedItem = " ";
  final List<String> _items = BloodGroupModel().bloodGroupList;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _detail1Controller.addListener(_onTextChanged);
    _detail2Controller.addListener(_onTextChanged);
    _detail3Controller.addListener(_onTextChanged);
    _detail4Controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _detail1Controller.dispose();
    _detail2Controller.dispose();
    _detail3Controller.dispose();
    _detail4Controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _detail1HasData = _detail1Controller.text.isNotEmpty;
      _detail2HasData = _detail2Controller.text.isNotEmpty;
      _detail3HasData = _detail3Controller.text.isNotEmpty;
      _detail4HasData = _detail4Controller.text.isNotEmpty;
    });
  }

  double _calculateProgress() {
    double progress = 0.5;
    if (_selectedItem != null && _selectedItem != " ") progress += 0.1;
    if (_detail1HasData) progress += 0.1;
    if (_detail2HasData) progress += 0.13;
    if (_detail3HasData) progress += 0.135;
    if (_detail4HasData) progress += 0.15;

    return progress;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final medicalProvider = Provider.of<MedicalRecordProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.dm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.medicalRecords,
                style: fontStyle.copyWith(
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 10.h),
              LinearProgressIndicator(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                minHeight: 15.h,
                value: _calculateProgress(),
                backgroundColor: appColorLightPurple.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(appColorDarkPurple),
              ),
              SizedBox(height: 34.h),
              _buildMultilineText(
                localizations.chronicHealthConditions,
                _detail1Controller,
                _detail1HasData,
              ),
              SizedBox(height: 25.h),
              _buildMultilineText(
                localizations.maintenanceMedication,
                _detail2Controller,
                _detail2HasData,
              ),
              SizedBox(height: 25.h),
              _buildMultilineText(
                localizations.ongoingAcuteCondition,
                _detail3Controller,
                _detail3HasData,
              ),
              SizedBox(height: 25.h),
              _buildMultilineText(
                localizations.majorSurgery,
                _detail4Controller,
                _detail4HasData,
              ),
              SizedBox(height: 35.h),
              _buildNextButton(
                () async {
                  medicalProvider.setAcuteIllness(_detail1Controller.text);
                  medicalProvider
                      .setCurrentMedications(_detail2Controller.text);
                  medicalProvider.setTerminalIllness(_detail3Controller.text);
                  medicalProvider.setPreviousSurgery(_detail4Controller.text);
                  setState(() {
                    isLoading = true;
                  });
                  await MedicalRecordService().updateRecord(
                    {
                      "age": medicalProvider.age,
                      "gender": medicalProvider.gender,
                      "country": medicalProvider.country,
                      "allergies": medicalProvider.allergies,
                      "bloodGroup": medicalProvider.bloodGroup,
                      "terminalIlless": medicalProvider.terminalIllness,
                      "acuteIllness": medicalProvider.acuteIllness,
                      "currentMedications": medicalProvider.currentMedications,
                      "previousSurgery": medicalProvider.previousSurgery,
                    },
                  );
                  _detail1Controller.clear;
                  _detail2Controller.clear;
                  _detail3Controller.clear;
                  _detail4Controller.clear;
                  setState(() {
                    isLoading = false;
                  });
                  ShowPopUp3().showPopUp(context);
                },
                localizations,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultilineText(
      String label, TextEditingController controller, bool hasData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: fontStyle.copyWith(
            fontSize: 18.sp,
          ),
        ),
        SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextField(
              onChanged: (value) {},
              controller: controller,
              maxLines: null, // Allow multiple lines of text
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: appColorLightPurple, width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appColorLightPurple, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: appColorDarkPurple, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(
      VoidCallback onPressed, AppLocalizations localization) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 65.w),
      child: SizedBox(
        height: deviceHeight(context) * 0.06,
        width: deviceWidth(context) * 0.7,
        child: ElevatedButton(
          onPressed: _detail1HasData &&
                  _detail2HasData &&
                  _detail3HasData &&
                  _detail4HasData
              ? onPressed
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _detail1HasData &&
                    _detail2HasData &&
                    _detail3HasData &&
                    _detail4HasData
                ? appColorLightPurple
                : Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: isLoading
              ? CupertinoActivityIndicator()
              : Text(
                  localization.nextButton,
                  style: TextStyle(color: appColorWhite, fontSize: 18.sp),
                ),
        ),
      ),
    );
  }
}
