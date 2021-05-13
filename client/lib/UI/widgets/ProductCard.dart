import 'package:client/model/objects/Product.dart';
import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  final Product product;


  ProductCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              product.name,
              style: TextStyle(
                fontSize: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              product.description,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
