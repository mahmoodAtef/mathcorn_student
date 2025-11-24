// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue your learning journey`
  String get signInToContinue {
    return Intl.message(
      'Sign in to continue your learning journey',
      name: 'signInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter your email address`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email address',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Don't have an account? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Account`
  String get createYourAccount {
    return Intl.message(
      'Create Your Account',
      name: 'createYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Enter your first name`
  String get enterFirstName {
    return Intl.message(
      'Enter your first name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Enter your last name`
  String get enterLastName {
    return Intl.message(
      'Enter your last name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get grade {
    return Intl.message('Grade', name: 'grade', desc: '', args: []);
  }

  /// `Select your grade`
  String get selectYourGrade {
    return Intl.message(
      'Select your grade',
      name: 'selectYourGrade',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmYourPassword {
    return Intl.message(
      'Confirm your password',
      name: 'confirmYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you a link to reset your password`
  String get forgotPasswordDescription {
    return Intl.message(
      'Enter your email address and we\'ll send you a link to reset your password',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetEmail {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Back to Sign In`
  String get backToSignIn {
    return Intl.message(
      'Back to Sign In',
      name: 'backToSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Email Sent!`
  String get emailSent {
    return Intl.message('Email Sent!', name: 'emailSent', desc: '', args: []);
  }

  /// `We've sent a password reset link to your email address. Please check your inbox and follow the instructions to reset your password.`
  String get resetEmailSentDescription {
    return Intl.message(
      'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions to reset your password.',
      name: 'resetEmailSentDescription',
      desc: '',
      args: [],
    );
  }

  /// `Check Your Email`
  String get checkYourEmail {
    return Intl.message(
      'Check Your Email',
      name: 'checkYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive email? `
  String get didntReceiveEmail {
    return Intl.message(
      'Didn\'t receive email? ',
      name: 'didntReceiveEmail',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resendEmail {
    return Intl.message('Resend', name: 'resendEmail', desc: '', args: []);
  }

  /// `Grade 1`
  String get grade1 {
    return Intl.message('Grade 1', name: 'grade1', desc: '', args: []);
  }

  /// `Grade 2`
  String get grade2 {
    return Intl.message('Grade 2', name: 'grade2', desc: '', args: []);
  }

  /// `Grade 3`
  String get grade3 {
    return Intl.message('Grade 3', name: 'grade3', desc: '', args: []);
  }

  /// `Grade 4`
  String get grade4 {
    return Intl.message('Grade 4', name: 'grade4', desc: '', args: []);
  }

  /// `Grade 5`
  String get grade5 {
    return Intl.message('Grade 5', name: 'grade5', desc: '', args: []);
  }

  /// `Grade 6`
  String get grade6 {
    return Intl.message('Grade 6', name: 'grade6', desc: '', args: []);
  }

  /// `Grade 7`
  String get grade7 {
    return Intl.message('Grade 7', name: 'grade7', desc: '', args: []);
  }

  /// `Grade 8`
  String get grade8 {
    return Intl.message('Grade 8', name: 'grade8', desc: '', args: []);
  }

  /// `Grade 9`
  String get grade9 {
    return Intl.message('Grade 9', name: 'grade9', desc: '', args: []);
  }

  /// `Grade 10`
  String get grade10 {
    return Intl.message('Grade 10', name: 'grade10', desc: '', args: []);
  }

  /// `Grade 11`
  String get grade11 {
    return Intl.message('Grade 11', name: 'grade11', desc: '', args: []);
  }

  /// `Grade 12`
  String get grade12 {
    return Intl.message('Grade 12', name: 'grade12', desc: '', args: []);
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `First name is required`
  String get firstNameRequired {
    return Intl.message(
      'First name is required',
      name: 'firstNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Last name is required`
  String get lastNameRequired {
    return Intl.message(
      'Last name is required',
      name: 'lastNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phoneRequired {
    return Intl.message(
      'Phone number is required',
      name: 'phoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please select your grade`
  String get gradeRequired {
    return Intl.message(
      'Please select your grade',
      name: 'gradeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmPasswordRequired {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Enter your full name`
  String get enterFullName {
    return Intl.message(
      'Enter your full name',
      name: 'enterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Full name is required`
  String get nameRequired {
    return Intl.message(
      'Full name is required',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Student Phone`
  String get studentPhone {
    return Intl.message(
      'Student Phone',
      name: 'studentPhone',
      desc: '',
      args: [],
    );
  }

  /// `Enter student phone number`
  String get enterStudentPhone {
    return Intl.message(
      'Enter student phone number',
      name: 'enterStudentPhone',
      desc: '',
      args: [],
    );
  }

  /// `Student phone number is required`
  String get studentPhoneRequired {
    return Intl.message(
      'Student phone number is required',
      name: 'studentPhoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Parent Phone`
  String get parentPhone {
    return Intl.message(
      'Parent Phone',
      name: 'parentPhone',
      desc: '',
      args: [],
    );
  }

  /// `Enter parent phone number`
  String get enterParentPhone {
    return Intl.message(
      'Enter parent phone number',
      name: 'enterParentPhone',
      desc: '',
      args: [],
    );
  }

  /// `Parent phone number is required`
  String get parentPhoneRequired {
    return Intl.message(
      'Parent phone number is required',
      name: 'parentPhoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `No data found`
  String get noDataFound {
    return Intl.message(
      'No data found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInfo {
    return Intl.message(
      'Personal Information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get stats {
    return Intl.message('Statistics', name: 'stats', desc: '', args: []);
  }

  /// `Saved Videos`
  String get savedVideos {
    return Intl.message(
      'Saved Videos',
      name: 'savedVideos',
      desc: '',
      args: [],
    );
  }

  /// `Saved Files`
  String get savedFiles {
    return Intl.message('Saved Files', name: 'savedFiles', desc: '', args: []);
  }

  /// `Cart`
  String get inCart {
    return Intl.message('Cart', name: 'inCart', desc: '', args: []);
  }

  /// `On Going`
  String get onGoing {
    return Intl.message('On Going', name: 'onGoing', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Enter your full name`
  String get enterYourFullName {
    return Intl.message(
      'Enter your full name',
      name: 'enterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourPhone {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhone',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profileUpdatedSuccessfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Change Profile Picture`
  String get changeProfilePicture {
    return Intl.message(
      'Change Profile Picture',
      name: 'changeProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Select Image`
  String get selectImage {
    return Intl.message(
      'Select Image',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Confirm Cancel`
  String get confirmCancel {
    return Intl.message(
      'Confirm Cancel',
      name: 'confirmCancel',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel editing? All unsaved changes will be lost.`
  String get cancelEditConfirmation {
    return Intl.message(
      'Are you sure you want to cancel editing? All unsaved changes will be lost.',
      name: 'cancelEditConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Continue Editing`
  String get continueEditing {
    return Intl.message(
      'Continue Editing',
      name: 'continueEditing',
      desc: '',
      args: [],
    );
  }

  /// `Discard Changes`
  String get discardChanges {
    return Intl.message(
      'Discard Changes',
      name: 'discardChanges',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contactInformation {
    return Intl.message(
      'Contact Information',
      name: 'contactInformation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email and password to delete your account`
  String get enterCredentialsToDelete {
    return Intl.message(
      'Please enter your email and password to delete your account',
      name: 'enterCredentialsToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Please select your grade`
  String get pleaseSelectYourGrade {
    return Intl.message(
      'Please select your grade',
      name: 'pleaseSelectYourGrade',
      desc: '',
      args: [],
    );
  }

  /// `Invalid grade selected`
  String get invalidGradeSelected {
    return Intl.message(
      'Invalid grade selected',
      name: 'invalidGradeSelected',
      desc: '',
      args: [],
    );
  }

  /// `Grade should be between 1 and 12`
  String get invalidGradeRange {
    return Intl.message(
      'Grade should be between 1 and 12',
      name: 'invalidGradeRange',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message('Courses', name: 'courses', desc: '', args: []);
  }

  /// `Enrolled`
  String get enrolled {
    return Intl.message('Enrolled', name: 'enrolled', desc: '', args: []);
  }

  /// `Students`
  String get students {
    return Intl.message('Students', name: 'students', desc: '', args: []);
  }

  /// `Lectures`
  String get lectures {
    return Intl.message('Lectures', name: 'lectures', desc: '', args: []);
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `EGP`
  String get currency {
    return Intl.message('EGP', name: 'currency', desc: '', args: []);
  }

  /// `OFF`
  String get off {
    return Intl.message('OFF', name: 'off', desc: '', args: []);
  }

  /// `Continue Watching`
  String get continueWatching {
    return Intl.message(
      'Continue Watching',
      name: 'continueWatching',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Cart`
  String get removeFromCart {
    return Intl.message(
      'Remove from Cart',
      name: 'removeFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message('Add to Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Course Description`
  String get courseDescription {
    return Intl.message(
      'Course Description',
      name: 'courseDescription',
      desc: '',
      args: [],
    );
  }

  /// `Course Lectures`
  String get courseLectures {
    return Intl.message(
      'Course Lectures',
      name: 'courseLectures',
      desc: '',
      args: [],
    );
  }

  /// `Exam`
  String get exam {
    return Intl.message('Exam', name: 'exam', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Content`
  String get content {
    return Intl.message('Content', name: 'content', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Course added to cart.`
  String get courseAddedToCart {
    return Intl.message(
      'Course added to cart.',
      name: 'courseAddedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Course removed from cart`
  String get courseRemovedFromCart {
    return Intl.message(
      'Course removed from cart',
      name: 'courseRemovedFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// `All Courses`
  String get allCourses {
    return Intl.message('All Courses', name: 'allCourses', desc: '', args: []);
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Search courses...`
  String get searchCourses {
    return Intl.message(
      'Search courses...',
      name: 'searchCourses',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Sort`
  String get sort {
    return Intl.message('Sort', name: 'sort', desc: '', args: []);
  }

  /// `Clear Filters`
  String get clearFilters {
    return Intl.message(
      'Clear Filters',
      name: 'clearFilters',
      desc: '',
      args: [],
    );
  }

  /// `Scroll to Top`
  String get scrollToTop {
    return Intl.message(
      'Scroll to Top',
      name: 'scrollToTop',
      desc: '',
      args: [],
    );
  }

  /// `Sort By`
  String get sortBy {
    return Intl.message('Sort By', name: 'sortBy', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Popularity`
  String get popularity {
    return Intl.message('Popularity', name: 'popularity', desc: '', args: []);
  }

  /// `Showing {count} enrolled courses`
  String showingEnrolledCourses(Object count) {
    return Intl.message(
      'Showing $count enrolled courses',
      name: 'showingEnrolledCourses',
      desc: '',
      args: [count],
    );
  }

  /// `Showing {count} available courses`
  String showingAvailableCourses(Object count) {
    return Intl.message(
      'Showing $count available courses',
      name: 'showingAvailableCourses',
      desc: '',
      args: [count],
    );
  }

  /// `Showing {count} courses in cart`
  String showingCartCourses(Object count) {
    return Intl.message(
      'Showing $count courses in cart',
      name: 'showingCartCourses',
      desc: '',
      args: [count],
    );
  }

  /// `Showing {count} courses`
  String showingAllCourses(Object count) {
    return Intl.message(
      'Showing $count courses',
      name: 'showingAllCourses',
      desc: '',
      args: [count],
    );
  }

  /// `Found {count} results for '{query}'`
  String searchResults(Object count, Object query) {
    return Intl.message(
      'Found $count results for \'$query\'',
      name: 'searchResults',
      desc: '',
      args: [count, query],
    );
  }

  /// `Cart is Empty`
  String get emptyCart {
    return Intl.message('Cart is Empty', name: 'emptyCart', desc: '', args: []);
  }

  /// `You haven't enrolled in any courses yet. Explore our courses and start learning!`
  String get noEnrolledCoursesDescription {
    return Intl.message(
      'You haven\'t enrolled in any courses yet. Explore our courses and start learning!',
      name: 'noEnrolledCoursesDescription',
      desc: '',
      args: [],
    );
  }

  /// `All courses are enrolled! Check back later for new courses.`
  String get noAvailableCoursesDescription {
    return Intl.message(
      'All courses are enrolled! Check back later for new courses.',
      name: 'noAvailableCoursesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty. Add some courses to get started!`
  String get emptyCartDescription {
    return Intl.message(
      'Your cart is empty. Add some courses to get started!',
      name: 'emptyCartDescription',
      desc: '',
      args: [],
    );
  }

  /// `Try adjusting your search terms or browse all courses.`
  String get noSearchResultsDescription {
    return Intl.message(
      'Try adjusting your search terms or browse all courses.',
      name: 'noSearchResultsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enrolled Courses`
  String get enrolledCourses {
    return Intl.message(
      'Enrolled Courses',
      name: 'enrolledCourses',
      desc: '',
      args: [],
    );
  }

  /// `Cart Courses`
  String get cartCourses {
    return Intl.message(
      'Cart Courses',
      name: 'cartCourses',
      desc: '',
      args: [],
    );
  }

  /// `Available Courses`
  String get availableCourses {
    return Intl.message(
      'Available Courses',
      name: 'availableCourses',
      desc: '',
      args: [],
    );
  }

  /// `Explore Courses`
  String get exploreCourses {
    return Intl.message(
      'Explore Courses',
      name: 'exploreCourses',
      desc: '',
      args: [],
    );
  }

  /// `Discover New Knowledge`
  String get discoverNewKnowledge {
    return Intl.message(
      'Discover New Knowledge',
      name: 'discoverNewKnowledge',
      desc: '',
      args: [],
    );
  }

  /// `Try a different filter or search term`
  String get tryDifferentFilter {
    return Intl.message(
      'Try a different filter or search term',
      name: 'tryDifferentFilter',
      desc: '',
      args: [],
    );
  }

  /// `Browse the available courses and enroll in the course that suits you.`
  String get browseCourses {
    return Intl.message(
      'Browse the available courses and enroll in the course that suits you.',
      name: 'browseCourses',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No new notifications , enjoy your day`
  String get noNotifications {
    return Intl.message(
      'No new notifications , enjoy your day',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Library`
  String get library {
    return Intl.message('Library', name: 'library', desc: '', args: []);
  }

  /// `Legal`
  String get legal {
    return Intl.message('Legal', name: 'legal', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Logout from current account`
  String get logoutDescription {
    return Intl.message(
      'Logout from current account',
      name: 'logoutDescription',
      desc: '',
      args: [],
    );
  }

  /// `Manage your profile information`
  String get profileDescription {
    return Intl.message(
      'Manage your profile information',
      name: 'profileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Educational app specialized in teaching mathematics`
  String get aboutDescription {
    return Intl.message(
      'Educational app specialized in teaching mathematics',
      name: 'aboutDescription',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Read our privacy policy`
  String get privacyPolicyDescription {
    return Intl.message(
      'Read our privacy policy',
      name: 'privacyPolicyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Contact us through whatsapp`
  String get whatsappDescription {
    return Intl.message(
      'Contact us through whatsapp',
      name: 'whatsappDescription',
      desc: '',
      args: [],
    );
  }

  /// `Whatsapp`
  String get whatsapp {
    return Intl.message('Whatsapp', name: 'whatsapp', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Remove from library`
  String get removeFromLibrary {
    return Intl.message(
      'Remove from library',
      name: 'removeFromLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Add to library`
  String get addToLibrary {
    return Intl.message(
      'Add to library',
      name: 'addToLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Removed from library`
  String get removedFromLibrary {
    return Intl.message(
      'Removed from library',
      name: 'removedFromLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Added to library`
  String get addedToLibrary {
    return Intl.message(
      'Added to library',
      name: 'addedToLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Saved Lectures`
  String get savedLectures {
    return Intl.message(
      'Saved Lectures',
      name: 'savedLectures',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this lecture from library?`
  String get confirmRemoveFromLibrary {
    return Intl.message(
      'Are you sure you want to remove this lecture from library?',
      name: 'confirmRemoveFromLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `View Library`
  String get viewLibrary {
    return Intl.message(
      'View Library',
      name: 'viewLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Search lectures...`
  String get searchLectures {
    return Intl.message(
      'Search lectures...',
      name: 'searchLectures',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Library is empty`
  String get emptyLibrary {
    return Intl.message(
      'Library is empty',
      name: 'emptyLibrary',
      desc: '',
      args: [],
    );
  }

  /// `You haven't saved any lectures yet. Start by adding your favorite lectures to easily access them later.`
  String get emptyLibraryDescription {
    return Intl.message(
      'You haven\'t saved any lectures yet. Start by adding your favorite lectures to easily access them later.',
      name: 'emptyLibraryDescription',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try different search terms or another filter`
  String get tryDifferentSearch {
    return Intl.message(
      'Try different search terms or another filter',
      name: 'tryDifferentSearch',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Has Attachment`
  String get hasAttachment {
    return Intl.message(
      'Has Attachment',
      name: 'hasAttachment',
      desc: '',
      args: [],
    );
  }

  /// `Lecture Name`
  String get lectureName {
    return Intl.message(
      'Lecture Name',
      name: 'lectureName',
      desc: '',
      args: [],
    );
  }

  /// `Content Type`
  String get contentType {
    return Intl.message(
      'Content Type',
      name: 'contentType',
      desc: '',
      args: [],
    );
  }

  /// `Has Exam`
  String get hasExam {
    return Intl.message('Has Exam', name: 'hasExam', desc: '', args: []);
  }

  /// `Unsupported Content Type`
  String get unsupportedContentType {
    return Intl.message(
      'Unsupported Content Type',
      name: 'unsupportedContentType',
      desc: '',
      args: [],
    );
  }

  /// `File URL`
  String get fileUrl {
    return Intl.message('File URL', name: 'fileUrl', desc: '', args: []);
  }

  /// `Lecture Info`
  String get lectureInfo {
    return Intl.message(
      'Lecture Info',
      name: 'lectureInfo',
      desc: '',
      args: [],
    );
  }

  /// `Add Courses To Cart`
  String get addCoursesToCart {
    return Intl.message(
      'Add Courses To Cart',
      name: 'addCoursesToCart',
      desc: '',
      args: [],
    );
  }

  /// `Add courses to cart`
  String get addCoursesToCartDescription {
    return Intl.message(
      'Add courses to cart',
      name: 'addCoursesToCartDescription',
      desc: '',
      args: [],
    );
  }

  /// `Cart Items`
  String get cartItems {
    return Intl.message('Cart Items', name: 'cartItems', desc: '', args: []);
  }

  /// `Cart Items`
  String get cartItemsDescription {
    return Intl.message(
      'Cart Items',
      name: 'cartItemsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Unknown`
  String get unknownDescription {
    return Intl.message(
      'Unknown',
      name: 'unknownDescription',
      desc: '',
      args: [],
    );
  }

  /// `Total Courses`
  String get totalCourses {
    return Intl.message(
      'Total Courses',
      name: 'totalCourses',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message('Total Price', name: 'totalPrice', desc: '', args: []);
  }

  /// `Proceed To Checkout`
  String get proceedToCheckout {
    return Intl.message(
      'Proceed To Checkout',
      name: 'proceedToCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this course from cart?`
  String get confirmRemoveFromCart {
    return Intl.message(
      'Are you sure you want to remove this course from cart?',
      name: 'confirmRemoveFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Removed from cart`
  String get removedFromCart {
    return Intl.message(
      'Removed from cart',
      name: 'removedFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Cart Cleared`
  String get cartCleared {
    return Intl.message(
      'Cart Cleared',
      name: 'cartCleared',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear cart?`
  String get confirmClearCart {
    return Intl.message(
      'Are you sure you want to clear cart?',
      name: 'confirmClearCart',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cart`
  String get clearCart {
    return Intl.message('Clear Cart', name: 'clearCart', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Billing Information`
  String get billingInformation {
    return Intl.message(
      'Billing Information',
      name: 'billingInformation',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Credit Card`
  String get creditCard {
    return Intl.message('Credit Card', name: 'creditCard', desc: '', args: []);
  }

  /// `Mobile Wallet`
  String get mobileWallet {
    return Intl.message(
      'Mobile Wallet',
      name: 'mobileWallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Number`
  String get walletNumber {
    return Intl.message(
      'Wallet Number',
      name: 'walletNumber',
      desc: '',
      args: [],
    );
  }

  /// `Wallet number is required`
  String get walletNumberRequired {
    return Intl.message(
      'Wallet number is required',
      name: 'walletNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get payNow {
    return Intl.message('Pay Now', name: 'payNow', desc: '', args: []);
  }

  /// `Payment completed successfully!`
  String get paymentSuccessful {
    return Intl.message(
      'Payment completed successfully!',
      name: 'paymentSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Payment failed. Please try again.`
  String get paymentFailed {
    return Intl.message(
      'Payment failed. Please try again.',
      name: 'paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Cannot get message of today`
  String get cannotGetMessage {
    return Intl.message(
      'Cannot get message of today',
      name: 'cannotGetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Notification dismissed successfully`
  String get notificationDismissed {
    return Intl.message(
      'Notification dismissed successfully',
      name: 'notificationDismissed',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private {
    return Intl.message('Private', name: 'private', desc: '', args: []);
  }

  /// `Public`
  String get public {
    return Intl.message('Public', name: 'public', desc: '', args: []);
  }

  /// `File picker error`
  String get filePickerError {
    return Intl.message(
      'File picker error',
      name: 'filePickerError',
      desc: '',
      args: [],
    );
  }

  /// `Send Access Request`
  String get sendAccessRequest {
    return Intl.message(
      'Send Access Request',
      name: 'sendAccessRequest',
      desc: '',
      args: [],
    );
  }

  /// `Please select a file`
  String get pleaseSelectFile {
    return Intl.message(
      'Please select a file',
      name: 'pleaseSelectFile',
      desc: '',
      args: [],
    );
  }

  /// `Access request sent`
  String get accessRequestSent {
    return Intl.message(
      'Access request sent',
      name: 'accessRequestSent',
      desc: '',
      args: [],
    );
  }

  /// `Required Attachments`
  String get requiredAttachments {
    return Intl.message(
      'Required Attachments',
      name: 'requiredAttachments',
      desc: '',
      args: [],
    );
  }

  /// `Please attach a photo of the transfer receipt or any document that proves payment`
  String get requiredAttachmentsDescription {
    return Intl.message(
      'Please attach a photo of the transfer receipt or any document that proves payment',
      name: 'requiredAttachmentsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Remove File`
  String get removeFile {
    return Intl.message('Remove File', name: 'removeFile', desc: '', args: []);
  }

  /// `Lecture already in library`
  String get lectureAlreadyInLibrary {
    return Intl.message(
      'Lecture already in library',
      name: 'lectureAlreadyInLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Generic Error`
  String get genericError {
    return Intl.message(
      'Generic Error',
      name: 'genericError',
      desc: '',
      args: [],
    );
  }

  /// `Access Request`
  String get accessRequest {
    return Intl.message(
      'Access Request',
      name: 'accessRequest',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message('Points', name: 'points', desc: '', args: []);
  }

  /// `Exam Details`
  String get examDetails {
    return Intl.message(
      'Exam Details',
      name: 'examDetails',
      desc: '',
      args: [],
    );
  }

  /// `Number of Questions`
  String get questionsCount {
    return Intl.message(
      'Number of Questions',
      name: 'questionsCount',
      desc: '',
      args: [],
    );
  }

  /// `Total Points`
  String get totalPoints {
    return Intl.message(
      'Total Points',
      name: 'totalPoints',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `minutes`
  String get minutes {
    return Intl.message('minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Start Exam`
  String get startExam {
    return Intl.message('Start Exam', name: 'startExam', desc: '', args: []);
  }

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Submit Exam`
  String get submitExam {
    return Intl.message('Submit Exam', name: 'submitExam', desc: '', args: []);
  }

  /// `Confirm Submission`
  String get confirmSubmission {
    return Intl.message(
      'Confirm Submission',
      name: 'confirmSubmission',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to submit the exam now?`
  String get areYouSureSubmit {
    return Intl.message(
      'Are you sure you want to submit the exam now?',
      name: 'areYouSureSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Unanswered Questions`
  String get unansweredQuestions {
    return Intl.message(
      'Unanswered Questions',
      name: 'unansweredQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Passed!`
  String get passed {
    return Intl.message('Passed!', name: 'passed', desc: '', args: []);
  }

  /// `Failed!`
  String get failed {
    return Intl.message('Failed!', name: 'failed', desc: '', args: []);
  }

  /// `Your Score`
  String get yourScore {
    return Intl.message('Your Score', name: 'yourScore', desc: '', args: []);
  }

  /// `View Correct Answers`
  String get viewCorrectAnswers {
    return Intl.message(
      'View Correct Answers',
      name: 'viewCorrectAnswers',
      desc: '',
      args: [],
    );
  }

  /// `questions`
  String get questions {
    return Intl.message('questions', name: 'questions', desc: '', args: []);
  }

  /// `Passing Score`
  String get passingScore {
    return Intl.message(
      'Passing Score',
      name: 'passingScore',
      desc: '',
      args: [],
    );
  }

  /// `Instructions`
  String get instructions {
    return Intl.message(
      'Instructions',
      name: 'instructions',
      desc: '',
      args: [],
    );
  }

  /// `Read each question carefully before selecting your answer`
  String get instruction1 {
    return Intl.message(
      'Read each question carefully before selecting your answer',
      name: 'instruction1',
      desc: '',
      args: [],
    );
  }

  /// `You can go back to previous questions and change your answer`
  String get instruction2 {
    return Intl.message(
      'You can go back to previous questions and change your answer',
      name: 'instruction2',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to answer all questions before submitting the exam`
  String get instruction3 {
    return Intl.message(
      'Make sure to answer all questions before submitting the exam',
      name: 'instruction3',
      desc: '',
      args: [],
    );
  }

  /// `The exam will be automatically submitted when time runs out`
  String get instruction4 {
    return Intl.message(
      'The exam will be automatically submitted when time runs out',
      name: 'instruction4',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `of`
  String get ofText {
    return Intl.message('of', name: 'ofText', desc: '', args: []);
  }

  /// `Exit Exam`
  String get exitExam {
    return Intl.message('Exit Exam', name: 'exitExam', desc: '', args: []);
  }

  /// `Are you sure you want to exit the exam? All answers will be lost.`
  String get exitExamConfirmation {
    return Intl.message(
      'Are you sure you want to exit the exam? All answers will be lost.',
      name: 'exitExamConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `Are you sure you want to submit the exam?`
  String get submitExamConfirmation {
    return Intl.message(
      'Are you sure you want to submit the exam?',
      name: 'submitExamConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get congratulations {
    return Intl.message(
      'Congratulations!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Better luck next time`
  String get betterLuckNextTime {
    return Intl.message(
      'Better luck next time',
      name: 'betterLuckNextTime',
      desc: '',
      args: [],
    );
  }

  /// `Exam Info`
  String get examInfo {
    return Intl.message('Exam Info', name: 'examInfo', desc: '', args: []);
  }

  /// `Available Now`
  String get availableNow {
    return Intl.message(
      'Available Now',
      name: 'availableNow',
      desc: '',
      args: [],
    );
  }

  /// `Lecture Exam`
  String get lectureExam {
    return Intl.message(
      'Lecture Exam',
      name: 'lectureExam',
      desc: '',
      args: [],
    );
  }

  /// `An exam is available for this lecture to assess your understanding of the explained content. This exam will help you reinforce the information and measure your comprehension of the lesson.`
  String get examDescription {
    return Intl.message(
      'An exam is available for this lecture to assess your understanding of the explained content. This exam will help you reinforce the information and measure your comprehension of the lesson.',
      name: 'examDescription',
      desc: '',
      args: [],
    );
  }

  /// `Timed duration`
  String get examFeatures {
    return Intl.message(
      'Timed duration',
      name: 'examFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Varied questions`
  String get examFeatures2 {
    return Intl.message(
      'Varied questions',
      name: 'examFeatures2',
      desc: '',
      args: [],
    );
  }

  /// `Instant results`
  String get examFeatures3 {
    return Intl.message(
      'Instant results',
      name: 'examFeatures3',
      desc: '',
      args: [],
    );
  }

  /// `Additional exam information`
  String get examAdditionalInfo {
    return Intl.message(
      'Additional exam information',
      name: 'examAdditionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Exam Instructions`
  String get examInstructions {
    return Intl.message(
      'Exam Instructions',
      name: 'examInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Time Duration`
  String get examTimeDuration {
    return Intl.message(
      'Time Duration',
      name: 'examTimeDuration',
      desc: '',
      args: [],
    );
  }

  /// `You have a limited time to complete the exam`
  String get examTimeDescription {
    return Intl.message(
      'You have a limited time to complete the exam',
      name: 'examTimeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Rules`
  String get examRules {
    return Intl.message('Rules', name: 'examRules', desc: '', args: []);
  }

  /// `Read each question carefully before answering`
  String get examRulesDescription {
    return Intl.message(
      'Read each question carefully before answering',
      name: 'examRulesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation`
  String get examEvaluation {
    return Intl.message(
      'Evaluation',
      name: 'examEvaluation',
      desc: '',
      args: [],
    );
  }

  /// `You will get the result immediately upon completion`
  String get examEvaluationDescription {
    return Intl.message(
      'You will get the result immediately upon completion',
      name: 'examEvaluationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get examRetry {
    return Intl.message('Retry', name: 'examRetry', desc: '', args: []);
  }

  /// `You can retake the exam again`
  String get examRetryDescription {
    return Intl.message(
      'You can retake the exam again',
      name: 'examRetryDescription',
      desc: '',
      args: [],
    );
  }

  /// `Understood`
  String get understood {
    return Intl.message('Understood', name: 'understood', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
