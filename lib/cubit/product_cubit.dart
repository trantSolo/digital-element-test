import 'package:connectivity/connectivity.dart';
import 'package:digital_element/model/product.dart';
import 'package:digital_element/services/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {

  ProductService _shopService = ProductService();
  List<Product> products = [];

  ProductCubit() : super(ProductInitialState()) {
    _init();
  }

  _init() async {
    await Connectivity().checkConnectivity() == ConnectivityResult.none 
    ? emit(ProductOfflineState())
    : fetchProducts();
    Connectivity().onConnectivityChanged.listen((status) {
      if (status == ConnectivityResult.none)
        emit(ProductOfflineState(products: products));
      else {
        products.isNotEmpty
        ? emit(ProductLoadedState(products: products))
        : fetchProducts();
      }
    });
  }

  fetchProducts() async {
    emit(ProductLoadingState());
    try {
      products = await _shopService.fetchProducts();
      emit(products.isNotEmpty 
        ? ProductLoadedState(products: products)
        : ProductEmptyState()
      );
    } catch (error) {
      emit(ProductErrorState(error.toString()));
    }
  }

}