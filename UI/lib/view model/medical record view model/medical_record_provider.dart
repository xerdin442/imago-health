import 'package:flutter/material.dart';

class MedicalRecordProvider extends ChangeNotifier {
  int? _age;
  String? _gender;
  String? _country;
  String? _allergies;
  String? _bloodGroup;
  String? _terminalIllness;
  String? _acuteIllness;
  String? _currentMedications;
  String? _previousSurgery;

  int? get age => _age;
  String? get gender => _gender;
  String? get country => _country;
  String? get allergies => _allergies;
  String? get bloodGroup => _bloodGroup;
  String? get terminalIllness => _terminalIllness;
  String? get acuteIllness => _acuteIllness;
  String? get currentMedications => _currentMedications;
  String? get previousSurgery => _previousSurgery;

  void setAge(int age) {
    _age = age;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setCountry(String country) {
    _country = country;
    notifyListeners();
  }

  void setAllergies(String allergies) {
    _allergies = allergies;
    notifyListeners();
  }

  void setBloodGroup(String bloodGroup) {
    _bloodGroup = bloodGroup;
    notifyListeners();
  }

  void setTerminalIllness(String terminalIllness) {
    _terminalIllness = terminalIllness;
    notifyListeners();
  }

  void setAcuteIllness(String acuteIllness) {
    _acuteIllness = acuteIllness;
    notifyListeners();
  }

  void setCurrentMedications(String currentMedications) {
    _currentMedications = currentMedications;
    notifyListeners();
  }

  void setPreviousSurgery(String previousSurgery) {
    _previousSurgery = previousSurgery;
    notifyListeners();
  }

}
