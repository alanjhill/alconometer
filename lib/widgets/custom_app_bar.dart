import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget title;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  CustomAppBar({Key? key, required this.title, this.automaticallyImplyLeading = false, this.leading, this.actions = const [], this.bottom})
      : preferredSize = /*const Size.fromHeight(10.0),*/
            Size.fromHeight(bottom == null ? 40 : bottom.preferredSize.height + 40),
        super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return AppBar(
      toolbarHeight: 40,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      leading: widget.leading,
      centerTitle: true,
      title: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            child: widget.title,
          );
        },
      ),
      actions: widget.actions,
      bottom: widget.bottom,
    );
  }
}
