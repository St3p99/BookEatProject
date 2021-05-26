import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
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
  String _what;
  String _where;
  List<String> categoryFilter = <String>[];
  FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
              height: SizeConfig.screenHeight*0.75,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrap(
                      //   children: List.generate(
                      //       categories.length,
                      //           (int index) {
                      //         return _buildCategoryChip(context, index);
                      //       }
                      //   ),
                      // ),
                      SizedBox(
                        height: SizeConfig.screenHeight*.1,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (BuildContext context, int index) =>
                                _buildCategoryChip(context, index),
                        ),
                      ),
                      // SizedBox(height: getProportionateScreenHeight(30)),
                      Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(primaryColor:  kPrimaryColor),
                          child: TextFormField(
                            onChanged: (value) => _where = value,
                            onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_focusNode),
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
                            validator: (value) {
                              if( value == null )
                                return AppLocalizations.of(context).translate("required");
                              else return null;
                            },
                            onChanged: (value) => _where = value,
                            onFieldSubmitted: (value) => _search(),
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
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => _search(),
                            child: Container(
                              height: SizeConfig.screenHeight*.05,
                              width: SizeConfig.screenWidth*.15,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: kPrimaryColor.withOpacity(0.5),
                                color: kPrimaryColor,
                                elevation: 5.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    // Text(
                                    // AppLocalizations.of(context).translate("search").toUpperCase(),
                                    // style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontWeight: FontWeight.bold),
                                    // ),
                                    Icon(Icons.search_rounded, color: Colors.white,)
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
    );
  }
  Widget _buildCategoryChip(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
          label: Text(
            // AppLocalizations.of(context).translate(categories[index]).toUpperCase(),
            categories[index].toUpperCase(),
            style:
            TextStyle(
              color: Colors.grey[700],
              fontWeight: categoryFilter.contains(categories[index]) ? FontWeight.w900 : FontWeight.w700,
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

  Widget _search() {
    // if(_formKey.currentState.validate()){
    //   _formKey.currentState.save();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Processing Data'),
    //         duration: Duration(seconds: 1),
    //       )
    //   );

  }
}
