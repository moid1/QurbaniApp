import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:qurbani_app/config/size.dart';
import 'package:qurbani_app/models/products.dart';

class ProductsList extends StatelessWidget {
  final List<ProductModel> productList;
  final String categoryName;
  const ProductsList(
      {Key key, @required this.productList, @required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).deviceWidth;
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(7),
        child: productList.length == 0
            ? Center(
                child: Text('Not Found'),
              )
            : ListView.builder(
                itemCount: productList.length,
                itemBuilder: (_, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            width: width * 0.30,
                            height: width * 0.20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  productList[index].image,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productList[index].address,
                                style: TextStyle(
                                    fontSize: width * 0.040,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                productList[index].userId,
                                style: TextStyle(
                                  fontSize: width * 0.040,
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                'Rs ${productList[index].price}',
                                style: TextStyle(
                                  fontSize: width * 0.040,
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(
                                  productList[index].createdAt.toDate(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Order Now'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(),
                    ],
                  );
                }),
      ),
    );
  }
}
