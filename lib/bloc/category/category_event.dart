import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GoToCategory extends CategoryEvent {
  final String id;

  GoToCategory({@required this.id});

  @override
  List<Object> get props => [
        id,
      ];
}

class LoadCategories extends CategoryEvent {}
