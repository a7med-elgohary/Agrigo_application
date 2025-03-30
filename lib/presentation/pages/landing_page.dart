import 'package:flutter/material.dart';
import 'package:agrigo_v3/core/constants/app_colors.dart';
import 'package:agrigo_v3/core/constants/app_strings.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BackGround.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.5)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text(
                    
                    textScaler : const TextScaler.linear(1.0),
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.primaryText,
                          shadows: _textShadows(),
                          fontFamily: 'Pacifico',
                          fontSize: 60 ,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.appSlogan,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.secondaryText,
                          shadows: _textShadows(),
                          fontSize: 15,
                          fontFamily: 'Pacifico',
                        ),
                  ),
                  
                  const SizedBox(height: 330),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryText,
                      foregroundColor: AppColors.buttonText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      AppStrings.getStarted,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'CustomFont',
                        letterSpacing: 1.2,
                      ),
                    ),
                    
                    
                  ),
                  
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Shadow> _textShadows() {
    return [
      const Shadow(
        blurRadius: 10,
        color: Colors.black54,
        offset: Offset(2, 2))
    ];
  }
}