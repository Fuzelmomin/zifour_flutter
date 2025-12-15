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
  /// **'Upload your last year marksheet or 10th Exam Receipt (It is Optional)'**
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

  /// No description provided for @trendingCourse.
  ///
  /// In en, this message translates to:
  /// **'Trending Courses'**
  String get trendingCourse;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @studentInfo.
  ///
  /// In en, this message translates to:
  /// **'Student Information'**
  String get studentInfo;

  /// No description provided for @mentors.
  ///
  /// In en, this message translates to:
  /// **'Mentors'**
  String get mentors;

  /// No description provided for @myCourse.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourse;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentActivities;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @studentName.
  ///
  /// In en, this message translates to:
  /// **'Student Name'**
  String get studentName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @zMentors.
  ///
  /// In en, this message translates to:
  /// **'Z Mentors'**
  String get zMentors;

  /// No description provided for @enterOldPass.
  ///
  /// In en, this message translates to:
  /// **'Enter Old Password'**
  String get enterOldPass;

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get giveFeedback;

  /// No description provided for @howDidWe.
  ///
  /// In en, this message translates to:
  /// **'How did we do?'**
  String get howDidWe;

  /// No description provided for @careToShare.
  ///
  /// In en, this message translates to:
  /// **'Care To Share More Ab Out it?'**
  String get careToShare;

  /// No description provided for @publishFeedback.
  ///
  /// In en, this message translates to:
  /// **'Publish Feedback'**
  String get publishFeedback;

  /// No description provided for @changeCourse.
  ///
  /// In en, this message translates to:
  /// **'Change Course'**
  String get changeCourse;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @areYouWantLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to logout?'**
  String get areYouWantLogout;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help Support'**
  String get helpSupport;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'CONTACT US'**
  String get contactUs;

  /// No description provided for @zifour_calender.
  ///
  /// In en, this message translates to:
  /// **'Zifour Calender'**
  String get zifour_calender;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get bookmarked;

  /// No description provided for @myNotes.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get myNotes;

  /// No description provided for @multimediaLibrary.
  ///
  /// In en, this message translates to:
  /// **'Multimedia Library'**
  String get multimediaLibrary;

  /// No description provided for @myPerformance.
  ///
  /// In en, this message translates to:
  /// **'My Performance'**
  String get myPerformance;

  /// No description provided for @askYourDoubts.
  ///
  /// In en, this message translates to:
  /// **'Ask Your Doubts'**
  String get askYourDoubts;

  /// No description provided for @pastDoubts.
  ///
  /// In en, this message translates to:
  /// **'Past Doubts'**
  String get pastDoubts;

  /// No description provided for @getExpertAnswer.
  ///
  /// In en, this message translates to:
  /// **'Get expert answers from mentors and toppers'**
  String get getExpertAnswer;

  /// No description provided for @typeYourDoubt.
  ///
  /// In en, this message translates to:
  /// **'Type your doubt clearly'**
  String get typeYourDoubt;

  /// No description provided for @uploadYourImage.
  ///
  /// In en, this message translates to:
  /// **'Upload your image'**
  String get uploadYourImage;

  /// No description provided for @submitDoubt.
  ///
  /// In en, this message translates to:
  /// **'Submit Doubt'**
  String get submitDoubt;

  /// No description provided for @myDoubts.
  ///
  /// In en, this message translates to:
  /// **'My Doubts'**
  String get myDoubts;

  /// No description provided for @challengerZone.
  ///
  /// In en, this message translates to:
  /// **'Challenger Zone'**
  String get challengerZone;

  /// No description provided for @chooseChallenge.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to challenge yourself today.'**
  String get chooseChallenge;

  /// No description provided for @createOwnChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create Own Challenge'**
  String get createOwnChallenge;

  /// No description provided for @expertsChallenge.
  ///
  /// In en, this message translates to:
  /// **'Expert’s Challenge'**
  String get expertsChallenge;

  /// No description provided for @expertChallenge.
  ///
  /// In en, this message translates to:
  /// **'Expert Challenge'**
  String get expertChallenge;

  /// No description provided for @selectYourSubject.
  ///
  /// In en, this message translates to:
  /// **'Select your subjects, Chapters, Topics and take control of your practice.'**
  String get selectYourSubject;

  /// No description provided for @completeInFaculty.
  ///
  /// In en, this message translates to:
  /// **'Complete in faculty-designed challenges held twice a month with fixed syllabus.'**
  String get completeInFaculty;

  /// No description provided for @selectAnySubject.
  ///
  /// In en, this message translates to:
  /// **'Select any subjects, Chapters, and Topics to build your custom test.'**
  String get selectAnySubject;

  /// No description provided for @selectSubject.
  ///
  /// In en, this message translates to:
  /// **'Select Subject'**
  String get selectSubject;

  /// No description provided for @selectChapter.
  ///
  /// In en, this message translates to:
  /// **'Select Chapters'**
  String get selectChapter;

  /// No description provided for @selectTopic.
  ///
  /// In en, this message translates to:
  /// **'Select Topics'**
  String get selectTopic;

  /// No description provided for @generateMyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Generate My Challenge'**
  String get generateMyChallenge;

  /// No description provided for @youCanSaveChallenge.
  ///
  /// In en, this message translates to:
  /// **'You can save this challenge for later practice'**
  String get youCanSaveChallenge;

  /// No description provided for @chooseOneMoreTopics.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more topics to include in your challenge.'**
  String get chooseOneMoreTopics;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @challengeReady.
  ///
  /// In en, this message translates to:
  /// **'Challenge is Ready!'**
  String get challengeReady;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @reviewYourSelections.
  ///
  /// In en, this message translates to:
  /// **'Review your selections and start when you’re ready.'**
  String get reviewYourSelections;

  /// No description provided for @subjectsSelected.
  ///
  /// In en, this message translates to:
  /// **'Subjects Selected'**
  String get subjectsSelected;

  /// No description provided for @chapterSelected.
  ///
  /// In en, this message translates to:
  /// **'Chapter Selected'**
  String get chapterSelected;

  /// No description provided for @topicsIncluded.
  ///
  /// In en, this message translates to:
  /// **'Topics Included'**
  String get topicsIncluded;

  /// No description provided for @totalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get totalQuestions;

  /// No description provided for @startChallenge.
  ///
  /// In en, this message translates to:
  /// **'Start Challenge'**
  String get startChallenge;

  /// No description provided for @challengesList.
  ///
  /// In en, this message translates to:
  /// **'Challenges List'**
  String get challengesList;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topic;

  /// No description provided for @selectCourse.
  ///
  /// In en, this message translates to:
  /// **'Select Course'**
  String get selectCourse;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter confirm password'**
  String get pleaseEnterConfirmPassword;

  /// No description provided for @passwordMustBe6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordMustBe6Characters;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordNotMatch;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE PREFERENCE'**
  String get languagePreference;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @pleaseSelectSubject.
  ///
  /// In en, this message translates to:
  /// **'Please select a subject'**
  String get pleaseSelectSubject;

  /// No description provided for @pleaseSelectChapter.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one chapter'**
  String get pleaseSelectChapter;

  /// No description provided for @pleaseSelectTopic.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one topic'**
  String get pleaseSelectTopic;

  /// No description provided for @askDoubts.
  ///
  /// In en, this message translates to:
  /// **'Ask Doubts'**
  String get askDoubts;
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
