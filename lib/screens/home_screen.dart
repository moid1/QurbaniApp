import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurbani_app/bloc/category/category_bloc.dart';
import 'package:qurbani_app/bloc/category/category_event.dart';
import 'package:qurbani_app/bloc/category/category_state.dart';
import 'package:qurbani_app/models/category.dart';

import 'package:qurbani_app/models/user.dart';
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
      ),
      drawer: Drawer(),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(authService)..add(LoadCategories()),
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoaded) {
                return _gridView(context, state.categoryList);
              } else if (state is CategoryLoading) {
                return CircularProgressIndicator(
                  strokeWidth: 2,
                );
              } else if (state is CategoryFailure) {
                // _showError(state.error, context);
                return Container();
              }
              return Container();
            },
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
            print(value.name);
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
