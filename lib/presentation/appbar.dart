import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return PreferredSize(
      child: Container(
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          top: statusBarHeight,
        ),
        color: Colors.transparent,
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(title),
          ),
          elevation: 4.0,
          actions: actions,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
        ),
      ),
      preferredSize: Size(size.width, 56),
    );
  }
}
