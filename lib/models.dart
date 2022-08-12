import 'package:flutter/material.dart';

class ExpandableWidget {
  final String title;
  final String alertCount;
  final String svgUrl;
  final Widget expandedContent;
  bool? isExpanded;
  ExpandableWidget(
      {required this.title,
      required this.alertCount,
      required this.isExpanded,
      required this.svgUrl,
      required this.expandedContent});
}
