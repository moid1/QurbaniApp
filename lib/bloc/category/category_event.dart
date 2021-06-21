import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:qurbani_app/models/products.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GoToCategory extends CategoryEvent {
  final String id;
  final String categoryName;

  GoToCategory({
    @required this.id,
    @required this.categoryName,
  });

  @override
  List<Object> get props => [id,categoryName];
}

class LoadCategories extends CategoryEvent {}
