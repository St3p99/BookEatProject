import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/components/restaurant_card.dart';
import 'package:client/UI/screens/detail/detail_screen.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/support/constants.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/model/Model.dart';

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
  FocusNode _focusNode;
  List<Restaurant> _searchResult;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
              children: [
                top(),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                bottom()
              ]
            ),
        ),
    );
  }

  Widget top(){
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
            blurRadius: 5,
            spreadRadius: 5,
            color: Colors.black12,
          )],
          borderRadius: BorderRadius.only(
                bottomLeft:Radius.circular(20),
                bottomRight:Radius.circular(20)
          ),
        ),
        height: SizeConfig.screenHeight*.3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20,0),
          child: Theme(
            data: Theme.of(context).copyWith(primaryColor: kPrimaryColor),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: SizeConfig.screenHeight*.05,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) =>
                          _buildCategoryChip(context, index),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  TextFormField(
                      onChanged: (value) => _what = value,
                      onFieldSubmitted: (value) => _focusNode.requestFocus(),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                              vertical: getProportionateScreenWidth(9)),
                          hintText: AppLocalizations.of(context)
                              .translate("search_what")
                              .capitalize,
                          prefixIcon: Icon(Icons.search)),
                    ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: SizeConfig.screenWidth* .7,
                          child: TextFormField(
                            autofocus: true,
                            focusNode: _focusNode,
                            validator: (value) {
                              if (value.isEmpty)
                                return "* " +
                                    AppLocalizations.of(context)
                                        .translate("required")
                                        .capitalize;
                              else
                                return null;
                            },
                            onChanged: (value) => _where = value,
                            onFieldSubmitted: (value) => _search(),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                    getProportionateScreenWidth(20),
                                    vertical: getProportionateScreenWidth(9)),
                                hintText: AppLocalizations.of(context)
                                    .translate("search_where")
                                    .capitalize,
                                prefixIcon: Icon(Icons.map)),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 20)),
                        GestureDetector(
                            onTap: () => _search(),
                            child: Container(
                              height: SizeConfig.screenHeight*.07,
                              width: SizeConfig.screenWidth*.15,
                              child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: kPrimaryColor.withOpacity(0.5),
                                  color: kPrimaryColor,
                                  elevation: 5.0,
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  )),
                            )
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildCategoryChip(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
          label: Text(
            AppLocalizations.of(context).translate(categories[index]).toUpperCase(),
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

  Future<void> _search() async {
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
        result = await Model.sharedInstance.searchRestaurantByCity(_where);
      }
      else if (_categoriesFilter.isEmpty) {
        result = await Model.sharedInstance.searchRestaurantByNameAndCity(_what, _where);
      }
      else if (_what == null || _what == '') {
          result = await Model.sharedInstance.searchRestaurantByCityAndCategories(_where, _categoriesFilter);
      }
      else {
          result = await Model.sharedInstance.searchRestaurantByNameAndCityAndCategories(_what, _where, _categoriesFilter);
      }

      await Model.sharedInstance.loadRestaurantReviews(result);

      setState(() {
        _searchResult = result;
        _searching = false;
      });
    }

  }
  Widget bottom() {
    return _searching ?
    CircularProgressIndicator() // searching
        : _searchResult == null ?
    SizedBox.shrink() : _searchResult.isEmpty ?
    noResult() : buildContent();
  }
  Widget noResult(){
    return Center(
        child: SizedBox(
            height: SizeConfig.screenHeight * 0.10,
            width: SizeConfig.screenHeight * 0.10,
            child: Text(AppLocalizations.of(context).translate("no_result").capitalize+"!")
        )
    );
  }

  Widget buildContent(){
    return Container(
      height: SizeConfig.screenHeight*.55,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _searchResult.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () =>
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                  new DetailScreen(
                                      restaurant: _searchResult[index]))).then((
                              value) => setState(() {})),
                      child: RestaurantCard(restaurant: _searchResult[index]));
                }),
          ),
        ],
      ),
    );
  }
}


