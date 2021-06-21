import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurbani_app/bloc/category/category_bloc.dart';
import 'package:qurbani_app/bloc/category/category_event.dart';
import 'package:qurbani_app/bloc/category/category_state.dart';
import 'package:qurbani_app/models/category.dart';

import 'package:qurbani_app/models/user.dart';
import 'package:qurbani_app/screens/products_list.dart';
import 'package:qurbani_app/services/auth_service.dart';

class HomePage extends StatefulWidget {
  final UserDetail user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.name.toUpperCase()),
              accountEmail: Text(widget.user.phoneNo),
              decoration: BoxDecoration(
                color: const Color(0xFF00897b),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? const Color(0xFF00897b)
                        : Colors.white,
                child: Text(
                  widget.user.name[0].toUpperCase(),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.shop),
              title: Text('My Orders'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.shopping_cart_outlined),
              title: Text('My Carts'),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(authService)..add(LoadCategories()),
          child: BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is ProductsLoaded) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProductsList(
                          productList: state.productsList,
                          categoryName: state.categoryName,
                        )));
              } else if (state is CategoryLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }
            },
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  return _gridView(context, state.categoryList);
                } else if (state is CategoryLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                } else if (state is CategoryFailure) {
                  // _showError(state.error, context);
                  return Container();
                }
                return Text('Loading');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridView(context, List<CategoryModel> categories) {
    return GridView.count(
      crossAxisCount: 2,
      controller: ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: categories.map((CategoryModel value) {
        return InkWell(
          onTap: () {
            BlocProvider.of<CategoryBloc>(context)
              ..add(GoToCategory(id: value.id, categoryName: value.name));

            print(value.id);
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: CachedNetworkImageProvider(value.image),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(value.name),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _showError(String error, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    ));
  }
}
