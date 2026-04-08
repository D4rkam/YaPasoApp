import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class QuestionLink extends StatelessWidget {
  final Widget view;
  final ColorScheme colors;
  final String questionText;
  final String linkText;
  const QuestionLink(
      {super.key,
      required this.view,
      required this.colors,
      required this.questionText,
      required this.linkText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(questionText),
        const SizedBox(width: 5),
        RichText(
          text: TextSpan(
            text: linkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => view));
              },
            style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                color: colors.secondary),
          ),
        ),
      ],
    );
  }
}
