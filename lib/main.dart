import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/chat_view.dart';
import 'views/profile_summary_view.dart';
import 'views/personality_test_view.dart';
import 'views/mood_journal_view.dart';
import 'views/cognitive_task_view.dart';
import 'views/processing_test_view.dart';
import 'widgets/dynamic_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "env");
  runApp(const PsyApp());
}

class PsyApp extends StatelessWidget {
  const PsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BearWithMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      builder: (context, child) {
        return DynamicBackground(
          child: child ?? const SizedBox.shrink(),
        );
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/processing-test') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ProcessingTestView(personalityType: args['personalityType']),
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
        '/personality-test': (context) => const PersonalityTestView(),
        '/home-chat': (context) => const ChatView(),
        '/profile-summary': (context) => const ProfileSummaryView(),
        '/mood-journal': (context) => const MoodJournalView(),
        '/cognitive-task': (context) => const CognitiveTaskView(),
      },
    );
  }
}
