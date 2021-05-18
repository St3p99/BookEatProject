import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
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
  FocusNode _focusNode;
  TextEditingController _searchWhatController = TextEditingController();
  TextEditingController _searchWhereController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth*0.75,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  // gradient: kPrimaryGradientColor,
                  color: kSecondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor:  kPrimaryColor),
                  child: TextField(
                    onChanged: (value) => setState(() {
                      _what = value;
                    }),
                    onSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_focusNode),
                    controller: _searchWhatController,
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
                width: SizeConfig.screenWidth * 0.8,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor:  kPrimaryColor),
                  child: TextField(
                    focusNode: _focusNode,
                    onSubmitted: (value) => _search(value),
                    controller: _searchWhereController,
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
            ],
          ),
        ));
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
