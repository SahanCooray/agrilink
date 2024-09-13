import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:agrilink/screens/onboarding/screen_1.dart'; // Adjust the import according to your project structure
import 'package:agrilink/widgets/logo.dart';


class LanguageSelectionScreen extends StatelessWidget {
  final Function(Locale) changeLanguage;

  LanguageSelectionScreen({required this.changeLanguage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              image: const DecorationImage(
                image: AssetImage('assets/patterns/full.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Logo(),
                  const SizedBox(height: 50),
                  Text(
                    "Select Your Language",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildLanguageButton(
                    context,
                    label: "English",
                    onPressed: () {
                      changeLanguage(const Locale('en'));
                      _navigateToIntroScreen(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLanguageButton(
                    context,
                    label: "සිංහල",
                    onPressed: () {
                      changeLanguage(const Locale('si'));
                      _navigateToIntroScreen(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLanguageButton(
                    context,
                    label: "தமிழ்",
                    onPressed: () {
                      changeLanguage(const Locale('ta'));
                      _navigateToIntroScreen(context);
                    },
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.onBackground,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(FluentIcons.globe_12_filled, color: theme.colorScheme.primary),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _navigateToIntroScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Intro1(changeLanguage: changeLanguage),
      ),
    );
  }
}
