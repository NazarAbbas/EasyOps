import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const SearchField({super.key, this.onChanged});

  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);

    final double height = isTablet ? 52 : 44;
    final double radius = isTablet ? 12 : 8;
    final double horizPad = isTablet ? 16 : 12;
    final double fontSize = isTablet ? 16 : 14;
    final double iconSize = isTablet ? 22 : 20;
    final double iconMinWidth = isTablet ? 48 : 40;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          hintText: 'Search Work Orders',
          hintStyle: TextStyle(color: AppColors.lightGray, fontSize: fontSize),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: horizPad),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              CupertinoIcons.search, // or Icons.search
              color: AppColors.lightGray,
              size: iconSize,
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minHeight: height,
            minWidth: iconMinWidth,
          ),
        ),
      ),
    );
  }
}
