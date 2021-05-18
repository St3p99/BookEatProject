import 'package:flutter/material.dart';

import 'components/search_field.dart';
import 'components/search_header.dart';

class SearchScreen extends StatelessWidget {
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
