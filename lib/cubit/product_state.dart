import 'package:digital_element/model/product.dart';
import 'package:flutter/foundation.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductEmptyState extends ProductState {}

class ProductLoadedState extends ProductState {
  List<Product> products;
  ProductLoadedState({@required this.products}) : assert(products != null);
}

class ProductOfflineState extends ProductState {
  List<Product> products = [];
  ProductOfflineState({this.products});
}

class ProductErrorState extends ProductState {
  String msg;
  ProductErrorState(this.msg);
}