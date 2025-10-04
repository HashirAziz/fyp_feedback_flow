import 'package:fyp_feedback_flow/screens/bus_routes/bus_routes_screen.dart';
import 'package:fyp_feedback_flow/screens/get_started/get_started_screen.dart';
import 'package:fyp_feedback_flow/screens/select_role_screen.dart';
import 'package:fyp_feedback_flow/screens/signup/create_new_account.dart';
import 'package:fyp_feedback_flow/screens/feedback_students_staff_faculty.dart';
import 'package:fyp_feedback_flow/screens/home/home_screen.dart';
import 'package:fyp_feedback_flow/screens/splash_screen.dart';
import 'package:fyp_feedback_flow/screens/login/login_screen.dart';
import 'package:get/get.dart';

import '../screens/chatbot_screen.dart';
import '../screens/feedback_submitted_successfully.dart';
import '../screens/forgot_password_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String getStartedScreen = '/get-started-screen';
  static const String loginScreen = '/login-screen';
  static const String signUpScreen = '/sign-up-screen';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String homeScreen = '/home-screen';
  static const String chatbotScreen = '/chatbot-screen';
  static const String feedbackScreen = '/feedback-screen';
  static const String feedbackSubmittedSuccessfullyScreen =
      '/feedback-submitted-successfully-screen';
  static const String selectRoleScreen = '/select-role-screen';
  static const String routesMapScreen = '/routes-map-screen';

  static List<GetPage<dynamic>>? pages = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => CreateNewAccountScreen()),
    GetPage(
      name: forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: chatbotScreen, page: () => const ChatbotScreen()),
    GetPage(
      name: feedbackSubmittedSuccessfullyScreen,
      page: () => const FeedbackSubmittedSuccessfully(),
    ),
    GetPage(name: feedbackScreen, page: () => FeedbackStudentsStaffFaculty()),
    GetPage(name: selectRoleScreen, page: () => SelectRoleScreen()),
    GetPage(name: getStartedScreen, page: () => GetStartedScreen()),
    GetPage(name: routesMapScreen, page: () => const RoutesMapScreen()),
  ];
}
