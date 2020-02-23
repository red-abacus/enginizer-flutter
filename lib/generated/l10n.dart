// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String get general_back {
    return Intl.message(
      'Back',
      name: 'general_back',
      desc: '',
      args: [],
    );
  }

  String get general_continue {
    return Intl.message(
      'Continue',
      name: 'general_continue',
      desc: '',
      args: [],
    );
  }

  String get general_add {
    return Intl.message(
      'Add',
      name: 'general_add',
      desc: '',
      args: [],
    );
  }

  String get general_details {
    return Intl.message(
      'Details',
      name: 'general_details',
      desc: '',
      args: [],
    );
  }

  String get general_auction {
    return Intl.message(
      'Auction',
      name: 'general_auction',
      desc: '',
      args: [],
    );
  }

  String get auth_name {
    return Intl.message(
      'Name',
      name: 'auth_name',
      desc: '',
      args: [],
    );
  }

  String get auth_email {
    return Intl.message(
      'E-mail',
      name: 'auth_email',
      desc: '',
      args: [],
    );
  }

  String get auth_password {
    return Intl.message(
      'Password',
      name: 'auth_password',
      desc: '',
      args: [],
    );
  }

  String get auth_passwordConfirmation {
    return Intl.message(
      'Confirm password',
      name: 'auth_passwordConfirmation',
      desc: '',
      args: [],
    );
  }

  String get auth_login {
    return Intl.message(
      'Login',
      name: 'auth_login',
      desc: '',
      args: [],
    );
  }

  String get auth_register {
    return Intl.message(
      'Register',
      name: 'auth_register',
      desc: '',
      args: [],
    );
  }

  String get auth_register_client {
    return Intl.message(
      'Car holder',
      name: 'auth_register_client',
      desc: '',
      args: [],
    );
  }

  String get auth_register_provider {
    return Intl.message(
      'Service provider',
      name: 'auth_register_provider',
      desc: '',
      args: [],
    );
  }

  String get auth_error_nameRequired {
    return Intl.message(
      'Name is required!',
      name: 'auth_error_nameRequired',
      desc: '',
      args: [],
    );
  }

  String get auth_error_passwordMismatch {
    return Intl.message(
      'Passwords are not the same!',
      name: 'auth_error_passwordMismatch',
      desc: '',
      args: [],
    );
  }

  String get auth_error_passwordTooShort {
    return Intl.message(
      'Password is too short!',
      name: 'auth_error_passwordTooShort',
      desc: '',
      args: [],
    );
  }

  String get auth_error_invalidEmail {
    return Intl.message(
      'Email is not valid',
      name: 'auth_error_invalidEmail',
      desc: '',
      args: [],
    );
  }

  String get auctions_search_hint {
    return Intl.message(
      'Registration no. or car model',
      name: 'auctions_search_hint',
      desc: '',
      args: [],
    );
  }

  String get auctions_finished {
    return Intl.message(
      'Finished',
      name: 'auctions_finished',
      desc: '',
      args: [],
    );
  }

  String get auctions_details_appointment_details {
    return Intl.message(
      'Appointment Details',
      name: 'auctions_details_appointment_details',
      desc: '',
      args: [],
    );
  }

  String get auctions_details_appointment_auctions {
    return Intl.message(
      'Auctions',
      name: 'auctions_details_appointment_auctions',
      desc: '',
      args: [],
    );
  }

  String get cars_create_step1 {
    return Intl.message(
      'Identification',
      name: 'cars_create_step1',
      desc: '',
      args: [],
    );
  }

  String get cars_create_step2 {
    return Intl.message(
      'Technical',
      name: 'cars_create_step2',
      desc: '',
      args: [],
    );
  }

  String get cars_create_step3 {
    return Intl.message(
      'Extra',
      name: 'cars_create_step3',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectBrand {
    return Intl.message(
      'Select brand',
      name: 'cars_create_selectBrand',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectModel {
    return Intl.message(
      'Select model',
      name: 'cars_create_selectModel',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectYear {
    return Intl.message(
      'Select year',
      name: 'cars_create_selectYear',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectFuelType {
    return Intl.message(
      'Select fuel type',
      name: 'cars_create_selectFuelType',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectTransmission {
    return Intl.message(
      'Select transmission',
      name: 'cars_create_selectTransmission',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectMotorCapacity {
    return Intl.message(
      'Select motor capacity',
      name: 'cars_create_selectMotorCapacity',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectPower {
    return Intl.message(
      'Select power',
      name: 'cars_create_selectPower',
      desc: '',
      args: [],
    );
  }

  String get cars_create_selectColor {
    return Intl.message(
      'Select color',
      name: 'cars_create_selectColor',
      desc: '',
      args: [],
    );
  }

  String get cars_create_insertVIN {
    return Intl.message(
      'Insert VIN',
      name: 'cars_create_insertVIN',
      desc: '',
      args: [],
    );
  }

  String get cars_create_registrationNumber {
    return Intl.message(
      'Registration number',
      name: 'cars_create_registrationNumber',
      desc: '',
      args: [],
    );
  }

  String get cars_create_mileage {
    return Intl.message(
      'Mileage (KM)',
      name: 'cars_create_mileage',
      desc: '',
      args: [],
    );
  }

  String get cars_create_rcaExpiryDate {
    return Intl.message(
      'Insert RCA Expiry date',
      name: 'cars_create_rcaExpiryDate',
      desc: '',
      args: [],
    );
  }

  String get cars_create_itpExpiryDate {
    return Intl.message(
      'Insert ITP Expiry date',
      name: 'cars_create_itpExpiryDate',
      desc: '',
      args: [],
    );
  }

  String get cars_create_vin {
    return Intl.message(
      'Insert VIN',
      name: 'cars_create_vin',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_brandNotSelected {
    return Intl.message(
      'Brand not selected!',
      name: 'cars_create_error_brandNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_modelNotSelected {
    return Intl.message(
      'Model not selected!',
      name: 'cars_create_error_modelNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_yearNotSelected {
    return Intl.message(
      'Year not selected!',
      name: 'cars_create_error_yearNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_fuelTypeNotSelected {
    return Intl.message(
      'Fuel type not selected!',
      name: 'cars_create_error_fuelTypeNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_CCNotSelected {
    return Intl.message(
      'Capacity not selected!',
      name: 'cars_create_error_CCNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_PowerNotSelected {
    return Intl.message(
      'Power not selected!',
      name: 'cars_create_error_PowerNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_transmissionNotSelected {
    return Intl.message(
      'Transmission not selected!',
      name: 'cars_create_error_transmissionNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_ColorNotSelected {
    return Intl.message(
      'Color not selected!',
      name: 'cars_create_error_ColorNotSelected',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_RegistrationNumberEmpty {
    return Intl.message(
      'Registration Number empty!',
      name: 'cars_create_error_RegistrationNumberEmpty',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_MileageEmpty {
    return Intl.message(
      'Mileage empty!',
      name: 'cars_create_error_MileageEmpty',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_RCAExpiryEmpty {
    return Intl.message(
      'RCA empty!',
      name: 'cars_create_error_RCAExpiryEmpty',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_ITPExpiryEmpty {
    return Intl.message(
      'ITP empty!',
      name: 'cars_create_error_ITPExpiryEmpty',
      desc: '',
      args: [],
    );
  }

  String get cars_create_error_vinEmpty {
    return Intl.message(
      'VIN empty!',
      name: 'cars_create_error_vinEmpty',
      desc: '',
      args: [],
    );
  }

  String get cars_list_search_hint {
    return Intl.message(
      'Registration no. or car model',
      name: 'cars_list_search_hint',
      desc: '',
      args: [],
    );
  }

  String get COLOR_RED {
    return Intl.message(
      'Red',
      name: 'COLOR_RED',
      desc: '',
      args: [],
    );
  }

  String get COLOR_BLACK {
    return Intl.message(
      'Black',
      name: 'COLOR_BLACK',
      desc: '',
      args: [],
    );
  }

  String get COLOR_GREEN {
    return Intl.message(
      'Green',
      name: 'COLOR_GREEN',
      desc: '',
      args: [],
    );
  }

  String get COLOR_SILVER {
    return Intl.message(
      'Silver',
      name: 'COLOR_SILVER',
      desc: '',
      args: [],
    );
  }

  String get COLOR_WHITE {
    return Intl.message(
      'White',
      name: 'COLOR_WHITE',
      desc: '',
      args: [],
    );
  }

  String get COLOR_GRAY {
    return Intl.message(
      'Gray',
      name: 'COLOR_GRAY',
      desc: '',
      args: [],
    );
  }

  String get COLOR_DARK_BLUE {
    return Intl.message(
      'Dark blue',
      name: 'COLOR_DARK_BLUE',
      desc: '',
      args: [],
    );
  }

  String get COLOR_DARK_GRAY {
    return Intl.message(
      'Dark gray',
      name: 'COLOR_DARK_GRAY',
      desc: '',
      args: [],
    );
  }

  String get COLOR_GOLD {
    return Intl.message(
      'Gold',
      name: 'COLOR_GOLD',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step1 {
    return Intl.message(
      'Choose services',
      name: 'appointment_create_step1',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step2 {
    return Intl.message(
      'Describe issues',
      name: 'appointment_create_step2',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step2_alert {
    return Intl.message(
      'Add the problems encountered with your car, one on the line',
      name: 'appointment_create_step2_alert',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step3 {
    return Intl.message(
      'Select providers',
      name: 'appointment_create_step3',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step3_specific {
    return Intl.message(
      'Specific',
      name: 'appointment_create_step3_specific',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step3_bid {
    return Intl.message(
      'Auction',
      name: 'appointment_create_step3_bid',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step3_alert {
    return Intl.message(
      'In Auction mode, the services will bid to carry out your repairs',
      name: 'appointment_create_step3_alert',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step4 {
    return Intl.message(
      'Schedule appointment',
      name: 'appointment_create_step4',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_issues {
    return Intl.message(
      'Add issue',
      name: 'appointment_create_issues',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_add_pickup_address {
    return Intl.message(
      'Add Pick-Up Address',
      name: 'appointment_create_add_pickup_address',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_error_issueCannotBeEmpty {
    return Intl.message(
      'Issue cannot be empty',
      name: 'appointment_create_error_issueCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_error_pickupAddressCannotBeEmpty {
    return Intl.message(
      'Address cannot be empty',
      name: 'appointment_create_error_pickupAddressCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_request {
    return Intl.message(
      'Request',
      name: 'appointment_details_request',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_car {
    return Intl.message(
      'Car',
      name: 'appointment_details_car',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_services_title {
    return Intl.message(
      'Requested services',
      name: 'appointment_details_services_title',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_services_issues {
    return Intl.message(
      'Reported issues',
      name: 'appointment_details_services_issues',
      desc: '',
      args: [],
    );
  }

  String get appointments_list_search_hint {
    return Intl.message(
      'Registration no. or car model',
      name: 'appointments_list_search_hint',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_services_appointment_cancel {
    return Intl.message(
      'Cancel',
      name: 'appointment_details_services_appointment_cancel',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_services_appointment_date {
    return Intl.message(
      'Appointment date',
      name: 'appointment_details_services_appointment_date',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_estimator {
    return Intl.message(
      'See estimate',
      name: 'appointment_details_estimator',
      desc: '',
      args: [],
    );
  }

  String get appointment_status_waiting {
    return Intl.message(
      'Waiting',
      name: 'appointment_status_waiting',
      desc: '',
      args: [],
    );
  }

  String get appointment_status_in_progress {
    return Intl.message(
      'In Progress',
      name: 'appointment_status_in_progress',
      desc: '',
      args: [],
    );
  }

  String get appointment_status_finished {
    return Intl.message(
      'Finished',
      name: 'appointment_status_finished',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_applicant {
    return Intl.message(
      'Applicant',
      name: 'appointment_details_applicant',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_request_reprogramming {
    return Intl.message(
      'Request reprogramming',
      name: 'appointment_details_request_reprogramming',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_assiged_mechanic {
    return Intl.message(
      'Assigned Mechanics',
      name: 'appointment_details_assiged_mechanic',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_no_mechanic_alert {
    return Intl.message(
      'No mechanic is assigned!',
      name: 'appointment_details_no_mechanic_alert',
      desc: '',
      args: [],
    );
  }

  String get appointment_details_service_occupancy {
    return Intl.message(
      'Service Occupancy',
      name: 'appointment_details_service_occupancy',
      desc: '',
      args: [],
    );
  }

  String get auction_details_title {
    return Intl.message(
      'Auction Details',
      name: 'auction_details_title',
      desc: '',
      args: [],
    );
  }

  String get auction_bids_title {
    return Intl.message(
      'Bids',
      name: 'auction_bids_title',
      desc: '',
      args: [],
    );
  }

  String get auction_bids_provider {
    return Intl.message(
      'Service Provider',
      name: 'auction_bids_provider',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_services_provided {
    return Intl.message(
      'Services Provided',
      name: 'auction_bid_services_provided',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_see_provider_profile {
    return Intl.message(
      'See Profile',
      name: 'auction_bid_see_provider_profile',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_estimate {
    return Intl.message(
      'See Estimate',
      name: 'auction_bid_estimate',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_estimate_price {
    return Intl.message(
      'Estimated Price',
      name: 'auction_bid_estimate_price',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_cancel_description {
    return Intl.message(
      'Are you sure you want to cancel this bid?',
      name: 'auction_bid_cancel_description',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_accept_description {
    return Intl.message(
      'Are you sure you want to accept this bid?',
      name: 'auction_bid_accept_description',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_all_services {
    return Intl.message(
      'All requested.',
      name: 'auction_bid_all_services',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_no_services {
    return Intl.message(
      'No service.',
      name: 'auction_bid_no_services',
      desc: '',
      args: [],
    );
  }

  String get auction_bid_date_schedule {
    return Intl.message(
      'Scheduled date',
      name: 'auction_bid_date_schedule',
      desc: '',
      args: [],
    );
  }

  String get estimator_type {
    return Intl.message(
      'Type',
      name: 'estimator_type',
      desc: '',
      args: [],
    );
  }

  String get estimator_typePlaceholder {
    return Intl.message(
      'Entry type',
      name: 'estimator_typePlaceholder',
      desc: '',
      args: [],
    );
  }

  String get estimator_code {
    return Intl.message(
      'Code',
      name: 'estimator_code',
      desc: '',
      args: [],
    );
  }

  String get estimator_name {
    return Intl.message(
      'Name',
      name: 'estimator_name',
      desc: '',
      args: [],
    );
  }

  String get estimator_quantity {
    return Intl.message(
      'Quantity /\nTime unit',
      name: 'estimator_quantity',
      desc: '',
      args: [],
    );
  }

  String get estimator_quantityPlaceholder {
    return Intl.message(
      'Quantity / Time unit',
      name: 'estimator_quantityPlaceholder',
      desc: '',
      args: [],
    );
  }

  String get estimator_price {
    return Intl.message(
      'Price',
      name: 'estimator_price',
      desc: '',
      args: [],
    );
  }

  String get estimator_priceNoVAT {
    return Intl.message(
      'Price\n(w/o VAT)',
      name: 'estimator_priceNoVAT',
      desc: '',
      args: [],
    );
  }

  String get estimator_priceVAT {
    return Intl.message(
      'Price\n(w/ VAT)',
      name: 'estimator_priceVAT',
      desc: '',
      args: [],
    );
  }

  String get estimator_service {
    return Intl.message(
      'Service',
      name: 'estimator_service',
      desc: '',
      args: [],
    );
  }

  String get estimator_product {
    return Intl.message(
      'Product',
      name: 'estimator_product',
      desc: '',
      args: [],
    );
  }

  String get estimator_dismiss {
    return Intl.message(
      'Dismiss',
      name: 'estimator_dismiss',
      desc: '',
      args: [],
    );
  }

  String get estimator_totalProducts {
    return Intl.message(
      'Total Products',
      name: 'estimator_totalProducts',
      desc: '',
      args: [],
    );
  }

  String get estimator_totalServices {
    return Intl.message(
      'Total Services',
      name: 'estimator_totalServices',
      desc: '',
      args: [],
    );
  }

  String get estimator_total {
    return Intl.message(
      'Total',
      name: 'estimator_total',
      desc: '',
      args: [],
    );
  }

  String get user_profile_current_password {
    return Intl.message(
      'Current Password',
      name: 'user_profile_current_password',
      desc: '',
      args: [],
    );
  }

  String get user_profile_new_password {
    return Intl.message(
      'New Password',
      name: 'user_profile_new_password',
      desc: '',
      args: [],
    );
  }

  String get user_profile_confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'user_profile_confirm_password',
      desc: '',
      args: [],
    );
  }

  String get user_profile_save_password {
    return Intl.message(
      'Save Password',
      name: 'user_profile_save_password',
      desc: '',
      args: [],
    );
  }

  String get user_profile_fiscal_name {
    return Intl.message(
      'Fiscal Name',
      name: 'user_profile_fiscal_name',
      desc: '',
      args: [],
    );
  }

  String get user_profile_fiscal_name_error {
    return Intl.message(
      'Fiscal name is required!',
      name: 'user_profile_fiscal_name_error',
      desc: '',
      args: [],
    );
  }

  String get user_profile_registration_number {
    return Intl.message(
      'Registration Number',
      name: 'user_profile_registration_number',
      desc: '',
      args: [],
    );
  }

  String get user_profile_registration_number_error {
    return Intl.message(
      'Registration number is required!',
      name: 'user_profile_registration_number_error',
      desc: '',
      args: [],
    );
  }

  String get user_profile_vta_payer {
    return Intl.message(
      'VTA Payer',
      name: 'user_profile_vta_payer',
      desc: '',
      args: [],
    );
  }

  String get user_profile_cui {
    return Intl.message(
      'CUI',
      name: 'user_profile_cui',
      desc: '',
      args: [],
    );
  }

  String get user_profile_cui_error {
    return Intl.message(
      'CUI is required!',
      name: 'user_profile_cui_error',
      desc: '',
      args: [],
    );
  }

  String get SERVICE {
    return Intl.message(
      'Service',
      name: 'SERVICE',
      desc: '',
      args: [],
    );
  }

  String get CAR_WASHING {
    return Intl.message(
      'Car washing',
      name: 'CAR_WASHING',
      desc: '',
      args: [],
    );
  }

  String get PAINT_SHOP {
    return Intl.message(
      'Paint shop',
      name: 'PAINT_SHOP',
      desc: '',
      args: [],
    );
  }

  String get TIRE_SHOP {
    return Intl.message(
      'Tire shop',
      name: 'TIRE_SHOP',
      desc: '',
      args: [],
    );
  }

  String get TOW_SERVICE {
    return Intl.message(
      'Tow Service',
      name: 'TOW_SERVICE',
      desc: '',
      args: [],
    );
  }

  String get PICKUP_RETURN {
    return Intl.message(
      'Pickup Return',
      name: 'PICKUP_RETURN',
      desc: '',
      args: [],
    );
  }

  String get service_services {
    return Intl.message(
      'Services',
      name: 'service_services',
      desc: '',
      args: [],
    );
  }

  String get service_reviews {
    return Intl.message(
      'Reviews',
      name: 'service_reviews',
      desc: '',
      args: [],
    );
  }

  String get service_fiscal {
    return Intl.message(
      'Fiscal info',
      name: 'service_fiscal',
      desc: '',
      args: [],
    );
  }

  String get service_promotions {
    return Intl.message(
      'Promotions',
      name: 'service_promotions',
      desc: '',
      args: [],
    );
  }

  String get general_at {
    return Intl.message(
      'at',
      name: 'general_at',
      desc: '',
      args: [],
    );
  }

  String get appointment_create_step0 {
    return Intl.message(
      'Select car',
      name: 'appointment_create_step0',
      desc: '',
      args: [],
    );
  }

  String get general_find {
    return Intl.message(
      'Find',
      name: 'general_find',
      desc: '',
      args: [],
    );
  }

  String get general_status {
    return Intl.message(
      'Status',
      name: 'general_status',
      desc: '',
      args: [],
    );
  }

  String get general_car {
    return Intl.message(
      'Car',
      name: 'general_car',
      desc: '',
      args: [],
    );
  }

  String get general_all {
    return Intl.message(
      'All',
      name: 'general_all',
      desc: '',
      args: [],
    );
  }

  String get general_decline {
    return Intl.message(
      'Decline',
      name: 'general_decline',
      desc: '',
      args: [],
    );
  }

  String get general_accept {
    return Intl.message(
      'Accept',
      name: 'general_accept',
      desc: '',
      args: [],
    );
  }

  String get general_warning {
    return Intl.message(
      'Warning',
      name: 'general_warning',
      desc: '',
      args: [],
    );
  }

  String get general_yes {
    return Intl.message(
      'Yes',
      name: 'general_yes',
      desc: '',
      args: [],
    );
  }

  String get general_no {
    return Intl.message(
      'No',
      name: 'general_no',
      desc: '',
      args: [],
    );
  }

  String get general_date {
    return Intl.message(
      'Date',
      name: 'general_date',
      desc: '',
      args: [],
    );
  }

  String get general_services {
    return Intl.message(
      'Services',
      name: 'general_services',
      desc: '',
      args: [],
    );
  }

  String get general_service {
    return Intl.message(
      'Service',
      name: 'general_service',
      desc: '',
      args: [],
    );
  }

  String get general_only {
    return Intl.message(
      'Only',
      name: 'general_only',
      desc: '',
      args: [],
    );
  }

  String get general_price {
    return Intl.message(
      'Price',
      name: 'general_price',
      desc: '',
      args: [],
    );
  }

  String get general_currency {
    return Intl.message(
      'Ron',
      name: 'general_currency',
      desc: '',
      args: [],
    );
  }

  String get general_no_entries {
    return Intl.message(
      'No entries available',
      name: 'general_no_entries',
      desc: '',
      args: [],
    );
  }

  String get general_new {
    return Intl.message(
      'New',
      name: 'general_new',
      desc: '',
      args: [],
    );
  }

  String get general_scheduled {
    return Intl.message(
      'Scheduled',
      name: 'general_scheduled',
      desc: '',
      args: [],
    );
  }

  String get general_finished {
    return Intl.message(
      'Finished',
      name: 'general_finished',
      desc: '',
      args: [],
    );
  }

  String get general_estimator {
    return Intl.message(
      'Estimator',
      name: 'general_estimator',
      desc: '',
      args: [],
    );
  }

  String get general_assign {
    return Intl.message(
      'Assign',
      name: 'general_assign',
      desc: '',
      args: [],
    );
  }

  String get general_save_changes {
    return Intl.message(
      'Save Changes',
      name: 'general_save_changes',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('ro', ''), Locale('en', ''),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}