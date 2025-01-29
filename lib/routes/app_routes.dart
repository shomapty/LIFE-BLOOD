import '../core/app_export.dart';
import '../presentation/Add_Staff/Add_Staff.dart';
import '../presentation/Add_User/Add_User_Screen.dart';
import '../presentation/All_Donation_History/all_donation_history.dart';
import '../presentation/All_Donation_History/edit_all_donation_history.dart';
import '../presentation/Blood_Storage/EditBloodStorage.dart';
import '../presentation/Blood_Storage/add_Storage.dart';
import '../presentation/Blood_Storage/blood_storage_page.dart';
import '../presentation/Campaign_Information_screen/campaign_information_Screen.dart';
import '../presentation/Campaign_Screen/Campaign_Screen.dart';
import '../presentation/ForgetPassword_screen/ForgetPassword_screen.dart';
import '../presentation/Google_Map/google_map.dart';
import '../presentation/Splash_Screen/Splash_screen.dart';
import '../presentation/User_Donation_History/user_donation_history.dart';
import '../presentation/User_Management/user_management.dart';
import '../presentation/donation_form_screen/donation_form_screen.dart';
import '../presentation/donation_record_screen/donation_record_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/readyToDonate/readyToDonate.dart';
import '../presentation/signup_screen/signup_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String signupScreen = '/signup_screen';

  static const String loginScreen = '/login_screen';

  static const String donationRecordScreen = '/donation_record_screen';

  static const String bloodCampaignScreen = '/blood_campaign_screen';
  static const String campaign_information_Screen = '/campaign_information_screen';

  static const String donationHistoryScreen = '/donation_history_screen';

  static const String donationFormScreen = '/donation_form_screen';

  static const String addStaff = '/addStaff';
  static const String campaignPostSceen = '/campaignPost';
  static const String googleMap = '/googleMap';
  static const String resetPassword = '/resetPassword';
  static const String userDonationHistory = '/userDonationHistory';
  static const String addUserScreen = '/addUserScreen';
  static const String userManagement = '/userManagement';
  static const String allDonationHistory = '/allDonationHistory';
  static const String bloodStoragePage = '/bloodStoragePage';
  static const String editBloodStorage = '/editBloodStorage';
  static const String addBloodStorage = '/addBloodStorage';
  static const String editAllDonationHistory = '/editAllDonationHistory';
  static const String readyToDonate = '/readyToDonate';

  static const String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: signupScreen,
      page: () => SignupScreen(),
    ),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: donationRecordScreen,
      page: () => DonationRecordScreen(),
    ),
    GetPage(
      name: campaign_information_Screen,
      page: () => CampaignInformationScreen(),
    ),
    GetPage(
      name: donationFormScreen,
      page: () => DonationFormScreen(),
    ),
    GetPage(
      name: addStaff,
      page: () => AddStaff(),
    ),
    GetPage(
      name: campaignPostSceen,
      page: () => Campaign_Screen(),
    ),
    GetPage(
      name: googleMap,
      page: () => GoogleMap(),
    ),
    GetPage(
      name: resetPassword,
      page: () => ForgetPasswordScreen(),
    ),
    GetPage(
      name: userDonationHistory,
      page: () => UserDonationHistory(),
    ),
    GetPage(
      name: addUserScreen,
      page: () => AddUserScreen(),
    ),
    GetPage(
      name: userManagement,
      page: () => UserManagement(),
    ),
    GetPage(
      name: allDonationHistory,
      page: () => AllDonationHistory(),
    ),
    GetPage(
      name: bloodStoragePage,
      page: () => BloodStoragePage(),
    ),
    GetPage(
      name: editBloodStorage,
      page: () => EditBloodStorage(),
    ),
    GetPage(
      name: editAllDonationHistory,
      page: () => EditAllDonationHistory(),
    ),
    GetPage(
      name: readyToDonate,
      page: () => ReadyToDonate(),
    ),
    GetPage(
      name: addBloodStorage,
      page: () => AddBloodStorage(),
    ),
    GetPage(
      name: initialRoute,
      page: () => SplashScreen(),
    )
  ];
}
