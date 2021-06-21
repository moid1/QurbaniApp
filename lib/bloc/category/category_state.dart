import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:qurbani_app/models/category.dart';
import 'package:qurbani_app/models/products.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categoryList;

  CategoryLoaded({@required this.categoryList});

  @override
  List<Object> get props => [categoryList];
}

class CategoryFailure extends CategoryState {
  final String error;

  CategoryFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class ProductsLoaded extends CategoryState {
  final List<ProductModel> productsList;
  final String categoryName;

  ProductsLoaded({
    @required this.productsList,
    @required this.categoryName,
  });

  @override
  List<Object> get props => [productsList, categoryName];
}
