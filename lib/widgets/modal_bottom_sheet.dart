import 'package:flutter/material.dart';

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
