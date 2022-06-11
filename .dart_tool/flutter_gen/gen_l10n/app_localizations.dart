
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('ml'),
    Locale('ta'),
    Locale('te')
  ];

  /// The current language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// Selecting the app language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get cont;

  /// Enter UID
  ///
  /// In en, this message translates to:
  /// **'Enter UID'**
  String get uid;

  /// Submit
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// uid doesnt exist. Please try again
  ///
  /// In en, this message translates to:
  /// **'UID Does not exist. Please try again!'**
  String get invaliduid;

  /// Invalid OTP. Please try again
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again!'**
  String get invalidotp;

  /// Verify
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Raise Request
  ///
  /// In en, this message translates to:
  /// **'Raise Request'**
  String get raisereq;

  /// Counselling
  ///
  /// In en, this message translates to:
  /// **'Counselling'**
  String get counselling;

  /// Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Requests
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// Need some guidance
  ///
  /// In en, this message translates to:
  /// **'Need some guidance?'**
  String get need;

  /// Apply for
  ///
  /// In en, this message translates to:
  /// **'Apply for'**
  String get applyfor;

  /// Incoun
  ///
  /// In en, this message translates to:
  /// **'Counselling'**
  String get incoun;

  /// countext
  ///
  /// In en, this message translates to:
  /// **'We’re there for you! On applying for counselling our officials will help you out with your much required career and life counselling.'**
  String get countext;

  /// Get Enrolled
  ///
  /// In en, this message translates to:
  /// **'Get Enrolled'**
  String get enrol;

  /// Request Raised. Waiting for approval
  ///
  /// In en, this message translates to:
  /// **'Request Raised. Waiting for approval.'**
  String get reqapr;

  /// Short
  ///
  /// In en, this message translates to:
  /// **'Request shortlisted. You can proceed to upload documents.'**
  String get shortlisted;

  /// Documents to be verified
  ///
  /// In en, this message translates to:
  /// **'Documents have been uploaded. Please wait till we verify them.'**
  String get waitverify;

  /// Request Accepted
  ///
  /// In en, this message translates to:
  /// **'Request Approved. We ll contact you shortly'**
  String get accepted;

  /// Request not approved
  ///
  /// In en, this message translates to:
  /// **'Request not approved.'**
  String get rejected;

  /// Active
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// OLD
  ///
  /// In en, this message translates to:
  /// **'OLD'**
  String get old;

  /// Something went wrong
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get err;

  /// Please upload your
  ///
  /// In en, this message translates to:
  /// **'Please upload your'**
  String get upload;

  /// approved
  ///
  /// In en, this message translates to:
  /// **'has been approved'**
  String get hasbeenapproved;

  /// uploaded
  ///
  /// In en, this message translates to:
  /// **'has been uploaded'**
  String get hasbeenuploaded;

  /// No file Selected. Click + to add documents
  ///
  /// In en, this message translates to:
  /// **'No file Selected. Click + to add documents'**
  String get noselect;

  /// Contact Us
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact;

  /// Write us your query and we ll get back to you soon
  ///
  /// In en, this message translates to:
  /// **'Write us your query and we ll get back to you soon'**
  String get query;

  /// Or call us on our numbers at
  ///
  /// In en, this message translates to:
  /// **'Or call us on our numbers at'**
  String get call;

  /// Raise
  ///
  /// In en, this message translates to:
  /// **'Raise a'**
  String get raise;

  /// Request
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// Need financial help
  ///
  /// In en, this message translates to:
  /// **'Need financial help?'**
  String get finhelp;

  /// Dont worry! Once you raise
  ///
  /// In en, this message translates to:
  /// **'Dont worry! Once you raise a request, our officials shall contact you to furthur understand your problem and requirement.'**
  String get fintext;

  /// Request has been made. Please
  ///
  /// In en, this message translates to:
  /// **'Request has been made. Please wait until it is approved.'**
  String get requestraised;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en', 'hi', 'ml', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'ml': return AppLocalizationsMl();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
