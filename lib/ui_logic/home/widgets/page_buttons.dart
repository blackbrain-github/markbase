import 'package:Markbase/dome/widgets/buttons/custom_small_button.dart';
import 'package:flutter/material.dart';

class PageButtons extends StatefulWidget {
  final PageController pageController;
  const PageButtons(this.pageController, {Key? key}) : super(key: key);

  @override
  State<PageButtons> createState() => _PageButtonsState();
}

class _PageButtonsState extends State<PageButtons> {
  bool isHomeSelected() {
    if (widget.pageController.positions.isNotEmpty) {
      if (widget.pageController.page == 0) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool isDatabaseSelected() {
    if (widget.pageController.positions.isNotEmpty) {
      if (widget.pageController.page == 1) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSmallButton(
          onPressed: () {
            if (widget.pageController.positions.isNotEmpty) {
              if (widget.pageController.page == 1.0) {
                widget.pageController.jumpToPage(0);
              }
            }
          },
          title: 'Home',
          selected: isHomeSelected(),
        ),
        const SizedBox(width: 5),
        CustomSmallButton(
          onPressed: () {
            if (widget.pageController.positions.isNotEmpty) {
              if (widget.pageController.page == 0.0) {
                widget.pageController.jumpToPage(1);
              }
            }
          },
          title: 'Database',
          selected: isDatabaseSelected(),
        ),
      ],
    );
  }
}
