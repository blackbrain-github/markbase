// Packages
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconLogInButton extends StatelessWidget {
  final Function function;
  final String? logoPath;
  final String title;
  const IconLogInButton({required this.function, this.logoPath, required this.title});

  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
      onPressed: () {
        function();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: const Color(0xFF202020),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (logoPath != null)
                ? SvgPicture.asset(
                    logoPath!,
                    height: 24,
                  )
                : const Icon(
                    Icons.email_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
