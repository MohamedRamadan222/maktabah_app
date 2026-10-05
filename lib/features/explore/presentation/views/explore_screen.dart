import 'package:flutter/material.dart';

import '../../../../core/constants/common/custom_text_from_field.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 13),
        child: Column(children: [CustomTextFromField()]),
      ),
    );
  }
}
