import 'package:digital_element/cubit/product_cubit.dart';
import 'package:digital_element/cubit/product_state.dart';
import 'package:digital_element/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {

  final Color _appBarColor = Color(0xffEEEFF1);
  final Color _productBackgroundColor = Color(0xffE9E9EB);
  final Color _grayColor = Color(0xffB3B3B3);
  final ProductCubit _cubit = ProductCubit();

  @override
  build(context) => BlocProvider<ProductCubit>(
    create: (_) => _cubit,
    child: Scaffold(
      appBar: PreferredSize(
        child: BlocBuilder(
          cubit: _cubit,
          builder: (_, state) {
            if (state is ProductOfflineState)
            return AppBar(
              centerTitle: true,
              backgroundColor: Colors.red,
              title: Text(
                "Нет подключения к сети...",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                ),
              ),
              brightness: Brightness.dark,
              elevation: 0.0,
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 1),
                child: Container(height: 1, color: _grayColor)
              ),
            );

            else return AppBar(
              centerTitle: true,
              backgroundColor: _appBarColor,
              title: Text(
                "Список товаров",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700
                ),
              ),
              brightness: Brightness.light,
              elevation: 0.0,
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 1),
                child: Container(height: 1, color: _grayColor)
              ),
            );
          }
        ),
        preferredSize: AppBar().preferredSize
      ),
      body: _buildBody(context),
    ),
  );

  _buildBody(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        if (state is ProductInitialState || state is ProductLoadingState) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_grayColor)));
        } 

        else if (state is ProductEmptyState) {
          _buildEmptyListMessage();
        }

        else if (state is ProductLoadedState || state is ProductOfflineState) {
          return _buildProductsGrid(context, state.products);
        }

        else if (state is ProductErrorState) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                state.msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _grayColor
                ),
              ),
            ),
          );
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Что-то пошло не так...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: _grayColor
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () async => await _cubit.fetchProducts(),
                  child: Text("Обновить", style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ),
        );
      }
    );

  }

  _buildEmptyListMessage() {
    return Center(
      child: Text(
        "Здесь ничего нет...",
        style: TextStyle(
          fontSize: 16,
          color: _grayColor
        ),
      ),
    );
  }

  _buildProductsGrid(BuildContext context, List<Product> products) {
    double width = (MediaQuery.of(context).size.width / 2) - 20 - 20 - 10;
    return products != null
    ? GridView.builder(
      padding: EdgeInsets.only(top: 20, bottom: 20 + MediaQuery.of(context).viewPadding.bottom, right: 20, left: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        childAspectRatio: 0.5,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: width * 1.6,
              decoration: BoxDecoration(
                color: _productBackgroundColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: product.image != null
              ? Image(image: NetworkImage(product.image))
              : SizedBox()
            ),
            SizedBox(height: 7),
            Container(
              height: width * 0.6,
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.article,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12
                    )
                  ),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(product.price != null ? "${product.price.toString()} руб." : "unknown",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                    )
                  )
                ],
              ),
            )
          ],
        );
      }
    )
    : _buildEmptyListMessage();
  }
  
}