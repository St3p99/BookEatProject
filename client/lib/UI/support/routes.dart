import 'package:client/UI/screens/home/home_screen.dart';
import 'package:client/UI/screens/search/search_screen.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  SearchScreen.routeName: (context) => SearchScreen(),
  // DetailsScreen.routeName: (context) => DetailsScreen(),
};
