import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Model/personal_info_options.dart';

import '../Controller/firebase_controller.dart';
import 'contact.dart';

class ResourceListBuilder {
  List<Contact> _resourceList;

  String _email;

  ResourceListBuilder() {
    _resourceList = new List<Contact>();
  }

  Future<List<Contact>> createResourceList(String email) async {
    _email = email;
    PersonalInfo info = await FirebaseController.getPersonalInfo(_email);
    _buildDefaultResources();

    SexualPreference preference = PersonalInfoOptions.sexualPreferenceMap.keys
        .firstWhere((k) =>
            PersonalInfoOptions.sexualPreferenceMap[k] ==
            info.sexualOrientation);
    _buildSexualOrientationResources(preference);

    Gender gender = PersonalInfoOptions.genderMap.keys
        .firstWhere((k) => PersonalInfoOptions.genderMap[k] == info.gender);
    _buildGenderResources(gender);

    ReligiousAffiliation religion =
        PersonalInfoOptions.religiousAffiliationMap.keys.firstWhere((k) =>
            PersonalInfoOptions.religiousAffiliationMap[k] ==
            info.religiousAffiliation);
    _buildReligiousResources(religion);
    return _saveResourceList();
  }

  void _buildDefaultResources() {
    _resourceList.add(Contact(
        email: _email,
        name: "National Suicide Prevention Lifeline",
        address: "Los Angeles, CA",
        phoneNumber: "800-273-8255",
        type: ContactType.Personal));
    _resourceList.add(Contact(
        email: _email,
        name: "Veteran Crisis Line",
        address: "N/A",
        phoneNumber: "1-800-273-8255",
        type: ContactType.Personal,
        notes: "Press 1 or text 838255"));
    _resourceList.add(Contact(
        email: _email,
        name: "Substance Abuse and Mental Health Services Administration",
        address: "N/A",
        phoneNumber: "1-800-622-4357",
        type: ContactType.Personal,
        notes: "Visit samhsa.gov for more information"));
  }

  void _buildSexualOrientationResources(SexualPreference preference) {
    switch (preference) {
      case SexualPreference.Gay_Lesbian:
      case SexualPreference.Bisexual:
      case SexualPreference.Pansexual:
      case SexualPreference.Asexual:
        _resourceList.add(Contact(
            email: _email,
            name: "LGBTQ Crisis Intervention List",
            address: "N/A",
            phoneNumber: "1-866-488-7386",
            type: ContactType.Personal,
            notes: "Visit thetrevorproject.org for more information"));
        break;
      default:
        return;
    }
  }

  void _buildGenderResources(Gender gender) {
    switch (gender) {
      case Gender.Transgender:
        _resourceList.add(Contact(
            email: _email,
            name: "Trans Lifeline",
            address: "N/A",
            phoneNumber: "1-877-565-8860",
            type: ContactType.Personal,
            notes: "Visit translifeline.org for more information"));
        break;
      default:
        return;
    }
  }

  void _buildReligiousResources(ReligiousAffiliation religiousAffiliation) {
    switch (religiousAffiliation) {
      case ReligiousAffiliation.Islam:
        _resourceList.add(Contact(
            email: _email,
            name: "Naseeha Mental Health",
            address: "N/A",
            phoneNumber: "1-866-627-3342",
            type: ContactType.Personal,
            notes: "Visit naseeha.org for more information"));
        break;
      case ReligiousAffiliation.Christianity:
        _resourceList.add(Contact(
            email: _email,
            name: "Samaritans Christian Helpline",
            address: "N/A",
            phoneNumber: "1-877-870-4673",
            type: ContactType.Personal,
            notes: "Visit samaritanshope.org for more information"));
        break;
      default:
        return;
    }
  }

  List<Contact> _saveResourceList() {
    _resourceList.forEach((c) async {
      c.docID = await FirebaseController.addContact(c);
    });
    return _resourceList;
  }
}
