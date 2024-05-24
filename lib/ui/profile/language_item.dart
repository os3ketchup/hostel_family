import 'package:flutter/material.dart';

class LanguageItem extends StatefulWidget {
  const LanguageItem({super.key, required this.onTap, required this.title, required this.isClicked});

  final VoidCallback onTap;
  final String title;
  final bool isClicked;

  @override
  State<LanguageItem> createState() => _LanguageItemState();
}

class _LanguageItemState extends State<LanguageItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          widget.isClicked ? Icon(Icons.done) : Container()
        ],
      ),
    );
  }
}
