import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurbani_app/bloc/category/category_event.dart';
import 'package:qurbani_app/bloc/category/category_state.dart';
import 'package:qurbani_app/models/category.dart';
import 'package:qurbani_app/models/products.dart';
import 'package:qurbani_app/services/auth_service.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final _auth = FirebaseAuth.instance;
  final AuthenticationService _authenticationService;

  CategoryBloc(AuthenticationService _authenticationService)
      : assert(_authenticationService != null),
        _authenticationService = _authenticationService,
        super(CategoryLoading());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is GoToCategory) {
      yield* _mapGoToCategoryToState(event);
    } else if (event is LoadCategories) {
      yield* _mapLoadCategoriesToState(event);
    }
  }

  Stream<CategoryState> _mapGoToCategoryToState(GoToCategory event) async* {
    print('GoToCategory Event Fired ');
    print('Category id is ${event.id}');
    yield CategoryLoading();

    List<ProductModel> productsList =
        await _authenticationService.getProducts(event.id);

    yield ProductsLoaded(
        productsList: productsList, categoryName: event.categoryName);
  }

  Stream<CategoryState> _mapLoadCategoriesToState(LoadCategories event) async* {
    yield CategoryLoading();
    print('BLOC me agaya');
    List<CategoryModel> categories =
        await _authenticationService.getCurrentCategories();
    yield CategoryLoaded(categoryList: categories);
  }
}
