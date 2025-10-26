import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu')
  ];

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your Language'**
  String get chooseLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select the language you\'re most comfortable with to continue using the platform smoothly.'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get language;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue With'**
  String get continueWith;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get gujarati;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get your started!'**
  String get letsGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @selectStandard.
  ///
  /// In en, this message translates to:
  /// **'Select Standard'**
  String get selectStandard;

  /// No description provided for @class11.
  ///
  /// In en, this message translates to:
  /// **'Class 11'**
  String get class11;

  /// No description provided for @class12.
  ///
  /// In en, this message translates to:
  /// **'Class 12'**
  String get class12;

  /// No description provided for @dropper.
  ///
  /// In en, this message translates to:
  /// **'Dropper'**
  String get dropper;

  /// No description provided for @neet.
  ///
  /// In en, this message translates to:
  /// **'NEET'**
  String get neet;

  /// No description provided for @jee.
  ///
  /// In en, this message translates to:
  /// **'JEE'**
  String get jee;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @reSendCode.
  ///
  /// In en, this message translates to:
  /// **'Re-send Code'**
  String get reSendCode;

  /// No description provided for @reSendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Re-send Code in '**
  String get reSendCodeIn;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @mobileVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Mobile Verification Failed'**
  String get mobileVerificationFailed;

  /// No description provided for @mobileVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Mobile Verified Successfully'**
  String get mobileVerifiedSuccessfully;

  /// No description provided for @yourDetailsAreSafe.
  ///
  /// In en, this message translates to:
  /// **'Your Details are safe with us'**
  String get yourDetailsAreSafe;

  /// No description provided for @signUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpNow;

  /// No description provided for @signupNow.
  ///
  /// In en, this message translates to:
  /// **'Signup Now!'**
  String get signupNow;

  /// No description provided for @beZiddi.
  ///
  /// In en, this message translates to:
  /// **'Be Ziddi. Be a Topper.'**
  String get beZiddi;

  /// No description provided for @alreadyAMember.
  ///
  /// In en, this message translates to:
  /// **'Already a Member? '**
  String get alreadyAMember;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @signupSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Signup successful!'**
  String get signupSuccessful;

  /// No description provided for @uploadMarksheet.
  ///
  /// In en, this message translates to:
  /// **'Upload your last year marksheet or 10th Exam Receipt'**
  String get uploadMarksheet;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @sendOtpOnNumber.
  ///
  /// In en, this message translates to:
  /// **'Send OTP on your this number!'**
  String get sendOtpOnNumber;

  /// No description provided for @otpVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification Code'**
  String get otpVerificationCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verificationSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Verification Successfully!'**
  String get verificationSuccessfully;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @passwordDoesNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password does not match'**
  String get passwordDoesNotMatch;

  /// No description provided for @changePasswordSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Change Password successful!'**
  String get changePasswordSuccessful;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
