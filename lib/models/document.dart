import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Document {
  final String name;
  final String desc;
  List urls = [];
  List docpaths = [];
  int docState;

  Document(this.name, this.desc, this.docState);
}

List<String> dockeys = [
  "aadhar",
  "pan",
  "birth",
  "Passport",
  "photo",
  "license",
  "caste",
  "voter",
  "ssc",
  "10th",
  "12th",
  "bonafide",
  "reportcard",
  "prescription",
  "medical_report"
];

var doctypes = [
  Document(
      'Aadhar Card',
      'Kidly upload clear images or a document of your Aadhar card with both sides of the card',
      0),
  Document('PAN Card', '', 0),
  Document(
      'Birth Certificate',
      'Kindly upload a clear image/document of your Birth Certificate with your full name and date of birth clearly visible',
      0),
  Document('Passport', '', 0),
  Document('Passport Size photograph', '', 0),
  Document('Driving License', '', 0),
  Document('Caste Certificate', '', 0),
  Document('Voter ID card', '', 0),
  Document('Secondary School Certificate/10th', '', 0),
  Document('10th Class marksheet', '', 0),
  Document(
      '12th class marksheet',
      'Kindly upload a clear image/document of your 12th class marksheet with your full name and board certification stamp clearly visible',
      0),
  Document(
      'Bonafide',
      'Kindly upload a clear image/document of your Bonafide with the signature of your institution\'s head clearly visible',
      0),
  Document('School progress report', '', 0),
  Document(
      'Medical Certificate',
      'Kindly upload a clear image/document of your Medical Certificate(s) containing your hospital details along with your patient ID',
      0),
  Document('Diagnosis Reports', '', 0)
];
