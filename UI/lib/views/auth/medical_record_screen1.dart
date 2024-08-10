import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test/models/user%20record%20model/bloodgroup_model.dart';
import 'package:test/models/user%20record%20model/country_model.dart';
import 'package:test/view%20model/medical%20record%20view%20model/medical_record_provider.dart';
import 'package:test/core/utility/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MedicalRecordScreen1 extends StatefulWidget {
  const MedicalRecordScreen1({super.key});

  @override
  _MedicalRecordScreen1State createState() => _MedicalRecordScreen1State();
}

class _MedicalRecordScreen1State extends State<MedicalRecordScreen1> {
  String? _selectedGender;
  String? _selectedCountry;
  String? _selectedBloodgroup;
  final List<String> _regionItems = CountryModel().countryList;
  final List<String> _bloodGroupItems = BloodGroupModel().bloodGroupList;
  final List<String> _genderOptions = ['Male', 'Female', 'Non-binary'];

  // State variables for field completion
  bool _isDOBComplete = false;
  bool _isGenderSelected = false;
  bool _isCountrySelected = false;
  bool _isBloodGroupSelected = false;

  // Controllers and Focus Nodes for DOB fields
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final FocusNode _dayFocus = FocusNode();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();
  final FocusNode _allergiesFocus = FocusNode();

  bool _allergiesHasData = false;

  void _onFocusChange() {
    setState(() {});
  }

  void _onTextChanged() {
    setState(() {
      _allergiesHasData = _allergiesController.text.isNotEmpty;
    });
  }

  int? _age;

  void _calculateAge() {
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day != null && month != null && year != null) {
      final dob = DateTime(year, month, day);
      final currentDate = DateTime.now();

      int age = currentDate.year - dob.year;

      if (currentDate.month < dob.month ||
          (currentDate.month == dob.month && currentDate.day < dob.day)) {
        age--;
      }

      setState(() {
        _age = age;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dayController.addListener(_checkDOBCompletion);
    _monthController.addListener(_checkDOBCompletion);
    _yearController.addListener(_checkDOBCompletion);
    _allergiesFocus.addListener(_onFocusChange);
    _allergiesController.addListener(_onTextChanged);

    _dayController.addListener(() {
      if (_dayController.text.length == 2) {
        int day = int.tryParse(_dayController.text) ?? 0;
        if (day < 1 || day > 31) {
          _showInvalidDateDialog(
              AppLocalizations.of(context)!.invalidDayTitle,
              AppLocalizations.of(context)!.invalidDayContent);
          _dayController.clear();
        } else {
          _monthFocus.requestFocus();
        }
      }
    });

    _monthController.addListener(() {
      if (_monthController.text.length == 2) {
        int month = int.tryParse(_monthController.text) ?? 0;
        if (month < 1 || month > 12) {
          _showInvalidDateDialog(
              AppLocalizations.of(context)!.invalidMonthTitle,
              AppLocalizations.of(context)!.invalidMonthContent);
          _monthController.clear();
        } else {
          _yearFocus.requestFocus();
        }
      }
    });
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _allergiesController.dispose();

    _dayFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
    _allergiesFocus.dispose();

    super.dispose();
  }

  void _showInvalidDateDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _checkDOBCompletion() {
    setState(() {
      _isDOBComplete = _dayController.text.isNotEmpty &&
          _monthController.text.isNotEmpty &&
          _yearController.text.isNotEmpty;
    });
  }

  double _calculateProgress() {
    double progress = 0;
    if (_isDOBComplete) progress += 0.1;
    if (_isGenderSelected) progress += 0.1;
    if (_isCountrySelected) progress += 0.11;
    if (_isBloodGroupSelected) progress += 0.1;
    if (_allergiesHasData) progress += 0.1;

    return progress;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final medicalProvider = Provider.of<MedicalRecordProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.dm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.medicalRecords,
                  style: fontStyle.copyWith(
                      fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  minHeight: 15.h,
                  value: _calculateProgress(),
                  backgroundColor: appColorLightPurple.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(appColorDarkPurple),
                ),
                SizedBox(height: 15.h),
                Text(
                  localizations.age,
                  style: fontStyle.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 10.h),
                _buildDOBTextField(),
                SizedBox(height: 30.h),
                _buildGenderDropdown(localizations),
                SizedBox(height: 30.h),
                _buildCountryDropdown(localizations),
                SizedBox(height: 30.h),
                _buildBloodGroupDropdown(localizations),
                SizedBox(height: 30.h),
                _buildMultilineText(localizations),
                SizedBox(height: 80.h),
                _buildNextButton(() {
                  _calculateAge();
                  medicalProvider.setAge(_age!);
                  medicalProvider.setGender(_selectedGender!);
                  medicalProvider.setCountry(_selectedCountry!);
                  medicalProvider.setBloodGroup(_selectedBloodgroup!);
                  medicalProvider.setAllergies(_allergiesController.text);
                  Navigator.pushNamed(context, 'record2');
                }, localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDOBTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDOBInputField(_dayController, _dayFocus, 'DD', 75),
            _buildDOBInputField(_monthController, _monthFocus, 'MM', 75),
            _buildDOBInputField(_yearController, _yearFocus, 'YYYY', 100),
          ],
        ),
        if (_age != null) Text('Age: $_age'),
      ],
    );
  }

  Widget _buildDOBInputField(TextEditingController controller,
      FocusNode focusNode, String hintText, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: appColorLightPurple,
            width: 3,
          ),
        ),
        borderRadius: BorderRadius.circular(5.0.r),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        onChanged: (value) {},
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGenderDropdown(AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        hint: Text(localizations.selectGender),
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue;
            _isGenderSelected = true;
          });
        },
        items: _genderOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        isExpanded: true,
      ),
    );
  }

  Widget _buildCountryDropdown(AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedCountry,
        hint: Text(localizations.selectCountry),
        onChanged: (newValue) {
          setState(() {
            _selectedCountry = newValue;
            _isCountrySelected = true;
          });
        },
        items: _regionItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        isExpanded: true,
      ),
    );
  }

  Widget _buildBloodGroupDropdown(AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedBloodgroup,
        hint: Text(localizations.selectBloodGroup),
        onChanged: (newValue) {
          setState(() {
            _selectedBloodgroup = newValue;
            _isBloodGroupSelected = true;
          });
        },
        items: _bloodGroupItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        icon: Icon(Icons.arrow_drop_down_outlined),
        isExpanded: true,
        dropdownColor: Colors.white,
        menuMaxHeight: 500,
      ),
    );
  }

  Widget _buildMultilineText(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.doYouHaveAnyAllergies,
          style: fontStyle.copyWith(
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _allergiesHasData = value.isNotEmpty;
              });
            },
            controller: _allergiesController,
            focusNode: _allergiesFocus,
            maxLines: null,
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
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(VoidCallback onPressed, AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 65),
      child: SizedBox(
        height: 50.h,
        width: 300.h,
        child: ElevatedButton(
          onPressed: _isDOBComplete &&
                  _isGenderSelected &&
                  _isCountrySelected &&
                  _isBloodGroupSelected &&
                  _allergiesHasData
              ? onPressed
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isDOBComplete &&
                    _isGenderSelected &&
                    _isCountrySelected &&
                    _isBloodGroupSelected &&
                    _allergiesHasData
                ? appColorLightPurple
                : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Text(
            localizations.nextButton,
            style: TextStyle(color: appColorWhite, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
