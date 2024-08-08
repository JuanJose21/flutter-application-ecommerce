import 'package:flutter/material.dart';
import 'package:flutter_design_system_store/flutter_design_system_store.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Header(
            title: title,
            subtitle: subtitle,
            leading: leading,
            actions: actions));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
