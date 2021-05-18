import 'package:client/UI/screens/search/components/search_field.dart';
import 'package:client/UI/screens/search/components/search_header.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SearchHeader(),
          SearchField(),
        ],
      ),
    );
  }
}
