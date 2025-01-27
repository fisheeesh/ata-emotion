import 'package:emotion_check_in_app/screens/main/check_in_success_screen.dart';
import 'package:emotion_check_in_app/screens/main/home_screen.dart';
import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionCheckInScreen extends StatefulWidget {
  const EmotionCheckInScreen({Key? key}) : super(key: key);

  @override
  State<EmotionCheckInScreen> createState() => _EmotionCheckInScreenState();
}

class _EmotionCheckInScreenState extends State<EmotionCheckInScreen> {
  int _selectedTabIndex =
      0; // Tracks the selected tab (0: Negative, 1: Neutral, 2: Positive)
  String?
      _selectedEmotion; // Tracks the selected emotion (only one can be selected)

  // List of emotions for each tab
  final Map<int, List<Map<String, dynamic>>> _emotions = {
    0: [
      {'icon': '😴', 'label': 'tired'},
      {'icon': '😩', 'label': 'stressed'},
      {'icon': '😴', 'label': 'bored'},
      {'icon': '😡', 'label': 'frustrated'},
      {'icon': '😞', 'label': 'disappointed'},
      {'icon': '😭', 'label': 'sad'},
      {'icon': '😰', 'label': 'anxious'},
      {'icon': '😒', 'label': 'annoyed'},
      {'icon': '😠', 'label': 'mad'},
    ],
    1: [
      {'icon': '😐', 'label': 'neutral'},
      {'icon': '😌', 'label': 'calm'},
      {'icon': '😑', 'label': 'meh'},
      {'icon': '😶', 'label': 'indifferent'},
      {'icon': '🙂', 'label': 'okay'},
      {'icon': '😕', 'label': 'unsure'},
      {'icon': '🤔', 'label': 'curious'},
      {'icon': '🙃', 'label': 'playful'},
      {'icon': '🫤', 'label': 'uncertain'},
    ],
    2: [
      {'icon': '😀', 'label': 'happy'},
      {'icon': '😄', 'label': 'excited'},
      {'icon': '😍', 'label': 'loved'},
      {'icon': '😁', 'label': 'joyful'},
      {'icon': '🥳', 'label': 'celebratory'},
      {'icon': '😎', 'label': 'confident'},
      {'icon': '😊', 'label': 'grateful'},
      {'icon': '🤩', 'label': 'thrilled'},
      {'icon': '😇', 'label': 'peaceful'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: ESizes.md, right: ESizes.md, top: ESizes.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _headerSection(context),
              const SizedBox(height: 20),
        
              // Container for Tab Bar and Emoji Grid
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Tab Bar
                    _tabBarSection(),
                    // Emoji Grid
                    _emojiGridSection(),
                  ],
                ),
              ),
        
              const SizedBox(height: 15),
        
              // Text Field Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  cursorColor: EColors.grey,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: ETexts.HINT,
                    hintStyle: TextStyle(color: EColors.grey),
                    // Border when the field is focused
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ESizes.roundedXs),
                      borderSide: BorderSide(color: EColors.lightBlue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ESizes.roundedXs),
                      borderSide: BorderSide(color: EColors.lightBlue, width: 2),
                    ),
                  ),
                ),
              ),
        
              const SizedBox(height: 15),
        
              _submitButton(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: ESizes.md),
      decoration: BoxDecoration(
        color: EColors.secondary,
        border: Border.all(color: EColors.white),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFB4D2F1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 0)),
        ],
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: _selectedEmotion != null
              ? () {
                  debugPrint("Selected Emotion: $_selectedEmotion");
                  // Handle Submit Logic
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckInSuccessScreen()));
                }
              : null, // Disable button if no emotion is selected
          style: ElevatedButton.styleFrom(
            backgroundColor: EColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ESizes.roundedLg),
            ),
            minimumSize: const Size.fromHeight(100),
          ),
          child: Text(
            ETexts.SUBMIT,
            style: GoogleFonts.lexend(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: EColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _headerSection(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        const SizedBox(width: 10),
        Text(
          ETexts.QUES,
          style: ETextTheme.lightTextTheme.headlineMedium,
        )
      ],
    );
  }

  Widget _tabBarSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabItem(0, "Negative"),
        _buildTabItem(1, "Neutral"),
        _buildTabItem(2, "Positive"),
      ],
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
          _selectedEmotion = null; // Reset selection when switching tabs
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? EColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: EColors.primary),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _emojiGridSection() {
    final emotions = _emotions[_selectedTabIndex]!;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemCount: emotions.length,
      itemBuilder: (context, index) {
        final emotion = emotions[index];
        final isSelected = _selectedEmotion == emotion['label'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedEmotion = emotion['label']; // Select emotion
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade100 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? EColors.primary : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emotion['icon'],
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 2),
                Text(
                  emotion['label'],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
