import 'package:flash_chat/screens/application_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'screens/registration_screen_two.dart';
import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/campaign_screen.dart';
import 'screens/campaignDetailsScreen.dart';
import 'screens/navigationBarScreen.dart';
import 'screens/enrolledCampaigns.dart';
import 'screens/enrolled_details_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'welcomeScreen',
      routes: {
        'welcomeScreen': (context) => WelcomeScreen(),
        'chatScreen': (context) => ChatScreen(),
        'registrationScreen': (context) => RegistrationScreen(),
        'loginScreen': (context) => LoginScreen(),
        'registrationScreenTwo': (context) => RegistrationScreenTwo(),
        'CampaignScreen': (context) => CampaignScreen(),
        'campaignDetailsScreen': (context) => campaignDetailsScreen(),
        'applicationScreen': (context) => applicationScreen(),
        'bottomBar': (context) => MyBottomNavigationBar(),
        'enrolledScreen': (context) => EnrolledScreen(),
        'enrolledDetailsScreen': (context) => enrolledCampaignDetailsScreen(),
      },
      home: WelcomeScreen(),
    );
  }
}
