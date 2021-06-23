import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/components/restaurant_card.dart';
import 'package:client/UI/screens/detail/detail_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/Model.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/support/constants.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key key,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _searching = false;
  String _what;
  String _where;
  List<String> _categoriesFilter = <String>[];
  List<Restaurant> _searchResult;
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          top(),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          bottom()
        ]),
      ),
    );
  }

  Widget top() {
    return Container(
      height: SizeConfig.screenHeight * 0.28,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 5,
            color: kPrimaryColor.withOpacity(0.2),
          ),
        ],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Theme(
          data: Theme.of(context).copyWith(primaryColor: kPrimaryColor),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onSaved: (value) => _what = value,
                  onFieldSubmitted: (value) => _search(),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(20),
                          vertical: getProportionateScreenWidth(9)),
                      hintText: AppLocalizations.of(context)
                          .translate("search_what")
                          .capitalize,
                      prefixIcon: Icon(Icons.search)),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                TextFormField(
                  autofocus: true,
                  validator: (value) {
                    if (value.isEmpty)
                      return "* " +
                          AppLocalizations.of(context)
                              .translate("required")
                              .capitalize;
                    else
                      return null;
                  },
                  onSaved: (value) => _where = value,
                  onFieldSubmitted: (value) => _search(),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(20),
                          vertical: getProportionateScreenWidth(9)),
                      hintText: AppLocalizations.of(context)
                          .translate("search_where")
                          .capitalize,
                      prefixIcon: Icon(Icons.map)),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                Container(
                  height: SizeConfig.screenHeight * .05,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildCategoryChip(context, index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
          label: Text(
            AppLocalizations.of(context)
                .translate(categories[index])
                .toUpperCase(),
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: _categoriesFilter.contains(categories[index])
                  ? FontWeight.w900
                  : FontWeight.w700,
            ),
          ),
          selected: _categoriesFilter.contains(categories[index]),
          onSelected: (bool val) {
            setState(() {
              if (val) {
                _categoriesFilter.add(categories[index]);
              } else {
                _categoriesFilter.removeWhere((String category) {
                  return category == categories[index];
                });
              }
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.white,
          shape: StadiumBorder(
              side: BorderSide(
                  color: Colors.grey[800],
                  width:
                      _categoriesFilter.contains(categories[index]) ? 3 : 1))),
    );
  }

  Future<void> _loadMore() async {
    _currentPage++;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Processing Data'),
      duration: Duration(milliseconds: 200),
    ));

    setState(() {
      _searching = true;
    });

    List<Restaurant> result;
    if (_categoriesFilter.isEmpty && (_what == null || _what == '')) {
      result = await Model.sharedInstance
          .searchRestaurantByCity(_where, _currentPage);
    } else if (_categoriesFilter.isEmpty) {
      result = await Model.sharedInstance
          .searchRestaurantByNameAndCity(_what, _where, _currentPage);
    } else if (_what == null || _what == '') {
      result = await Model.sharedInstance.searchRestaurantByCityAndCategories(
          _where, _categoriesFilter, _currentPage);
    } else {
      result = await Model.sharedInstance
          .searchRestaurantByNameAndCityAndCategories(
              _what, _where, _categoriesFilter, _currentPage);
    }

    if (result.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)
                  .translate("no_more_result")
                  .capitalize),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    AppLocalizations.of(context).translate("close").capitalize,
                    style: TextStyle(color: Colors.black87),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      await Model.sharedInstance.loadRestaurantsReviews(result);
      setState(() {
        _searchResult.addAll(result);
      });
    }
    setState(() {
      _searching = false;
    });
  }

  Future<void> _search() async {
    _currentPage = 0;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Processing Data'),
        duration: Duration(milliseconds: 200),
      ));

      setState(() {
        _searching = true;
        _searchResult = null;
      });

      List<Restaurant> result;
      if (_categoriesFilter.isEmpty && (_what == null || _what == '')) {
        result = await Model.sharedInstance
            .searchRestaurantByCity(_where, _currentPage);
      } else if (_categoriesFilter.isEmpty) {
        result = await Model.sharedInstance
            .searchRestaurantByNameAndCity(_what, _where, _currentPage);
      } else if (_what == null || _what == '') {
        result = await Model.sharedInstance.searchRestaurantByCityAndCategories(
            _where, _categoriesFilter, _currentPage);
      } else {
        result = await Model.sharedInstance
            .searchRestaurantByNameAndCityAndCategories(
                _what, _where, _categoriesFilter, _currentPage);
      }
      await Model.sharedInstance.loadRestaurantsReviews(result);

      setState(() {
        _searchResult = result;
        _searching = false;
      });
    }
  }

  Widget bottom() {
    return _searching
        ? CircularProgressIndicator() // searching
        : _searchResult == null
            ? SizedBox.shrink()
            : _searchResult.isEmpty
                ? noResult()
                : buildContent();
  }

  Widget noResult() {
    return Center(
        child: SizedBox(
            height: SizeConfig.screenHeight * 0.10,
            width: SizeConfig.screenHeight * 0.10,
            child: Text(
                AppLocalizations.of(context).translate("no_result").capitalize +
                    "!")));
  }

  Widget buildContent() {
    return Container(
        height: SizeConfig.screenHeight * .63,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _searchResult.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _searchResult.length) {
                      return GestureDetector(
                          onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => new DetailScreen(
                                          restaurant: _searchResult[index])))
                              .then((value) => setState(() {})),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: RestaurantCard(
                                  restaurant: _searchResult[index])));
                    } else {
                      return Center(
                        child: FloatingActionButton(
                            backgroundColor: kPrimaryColor,
                            onPressed: () {
                              _loadMore();
                            },
                            child: Icon(Icons.arrow_downward_rounded)),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
