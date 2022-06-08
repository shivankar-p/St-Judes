import 'dart:collection';
import 'package:flutter/material.dart';

class Document {
  final String name;
  final String desc;
  List urls = [];
  List docpaths = [];
  int docState;

  Document(this.name, this.desc, this.docState);
}

var doctypes = [
  Document(
      'Aadhar Card',
      'jdbfsbsbfhbfkdfbbfkbfkdbfjkdbfjdfbjdfbdkbfdksfbdkfbdskbfjkdbfdjksfbdsjkfbdsjfbdjksbfjkdsfbdjkfbdskjfbdsjkfbdsjkfbdskjfbdsjkb',
      0),
  Document('PAN Card', '', 0),
  Document('Birth Certificate', '', 0),
  Document('Passport', '', 0),
  Document('Passport Size photograph', '', 0),
  Document('Driving License', '', 0),
  Document('Attendence Certificate', '', 0),
  Document('Caste Certificate', '', 0),
  Document('Voter ID card', '', 0),
  Document('Secondary School Certificate/10th', '', 0),
  Document('10th Class marksheet', '', 0),
  Document('12th class marksheet', '', 0),
  Document('Bonafide', '', 0),
  Document('School progress/grade report', '', 0),
  Document('Medical Certificate', '', 0),
  Document('Diagnosis Reports', '', 0)
];
