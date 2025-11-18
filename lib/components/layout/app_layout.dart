import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigation;

  final List<Widget>? bottomActions;
  final NotchedShape? bottomBarShape;
  final Color? bottomBarColor;
  final double? bottomBarElevation;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? fabLocation;

  final bool useSafeArea;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  const AppLayout({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigation,
    this.bottomActions,
    this.bottomBarShape,
    this.bottomBarColor,
    this.bottomBarElevation,
    this.floatingActionButton,
    this.fabLocation,
    this.useSafeArea = true,
    this.contentPadding,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;
    if (contentPadding != null) {
      content = Padding(padding: contentPadding!, child: content);
    }
    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    final hasBottomActions = bottomActions != null && bottomActions!.isNotEmpty;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,

      appBar: appBar,
      body: content,

      bottomNavigationBar:
          bottomNavigation ??
          (hasBottomActions
              ? BottomAppBar(
                  color: bottomBarColor,
                  elevation: bottomBarElevation,
                  shape:
                      bottomBarShape ??
                      (floatingActionButton != null
                          ? const CircularNotchedRectangle()
                          : null),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: bottomActions!),
                      if (fabLocation ==
                          FloatingActionButtonLocation.centerDocked)
                        const SizedBox(width: 48),
                    ],
                  ),
                )
              : null),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: fabLocation,
    );
  }
}
