import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/support/constants.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  String _what;
  String _where;
  List<String> categoryFilter = <String>[];
  FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight*0.75,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(primaryColor:  kPrimaryColor),
                    child: TextFormField(
                      onChanged: (value) => setState(() {
                        _what = value;
                      }),
                      onSaved: (value) =>
                          FocusScope.of(context).requestFocus(_focusNode),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                              vertical: getProportionateScreenWidth(9)),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: AppLocalizations.of(context)
                              .translate("search_what")
                              .capitalize,
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Container(
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(primaryColor:  kPrimaryColor),
                    child: TextFormField(
                      focusNode: _focusNode,
                      onSaved: (value) => _search(value),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                              vertical: getProportionateScreenWidth(9)),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: AppLocalizations.of(context)
                              .translate("search_where")
                              .capitalize,
                          prefixIcon: Icon(Icons.map)),
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.screenHeight*0.15,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildCategoryChip(context, index)
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildCategoryChip(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
          label: Text(
            // AppLocalizations.of(context).translate(categories[index]).toUpperCase(),
            categories[index].toUpperCase(),
            style:
            TextStyle(
              color: Colors.grey[800],
              fontWeight: categoryFilter.contains(categories[index]) ? FontWeight.w900 : FontWeight.w400,
            ),
          ),
          selected: categoryFilter.contains(categories[index]),
          onSelected: (bool val) {
            setState(() {
              if (val) {
                categoryFilter.add(categories[index]);
              } else {
                categoryFilter.removeWhere((String category){
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
                  width: categoryFilter.contains(categories[index]) ? 3 : 1))),
    );
  }

  void _search(String where) {
    if (where == '') {
      print("empty");
      return;
    }
    print('what:' + _what);
    print('where:' + where);
  }
}
