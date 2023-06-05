import 'package:dio/dio.dart';
import 'package:ecommercetest/models/product_model.dart';
import 'package:flutter/foundation.dart';
import '../models/product_details_model.dart';
import '../models/slider_model.dart';
import '../utils/exports.dart';

class HomeControllerProvider extends ChangeNotifier {
  
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

 final dio = Dio();

 Future<ProductDetailsModel> getSingleProduct (productId)async{
  // print('your url is: ${AppUrl.productDetailsUri}$productId');
 final response = await dio.get('${AppUrl.productDetailsUri}$productId',
  
  options: Options(
        contentType: 'application/json',
    ),
  );
  return ProductDetailsModel.fromJson(response.data);
 }
 
 
 Future<List<SliderModel>> fetchAllSlider() async {
  try {
    const url = AppUrl.sliderUri;
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    // print(response.data);
    final List<dynamic> data = response.data;
    List<SliderModel> sliderList = data.map((json) {
      // print(json.toString());
      return SliderModel.fromJson(json);
    }).toList();

    return sliderList;
  } catch (error) {
    
    if (kDebugMode) {
      print('Error fetching products: $error');
    }
    // ignore: use_rethrow_when_possible
    throw error; 
  }
}



  Future<List<ProductModel>> fetchAllProducts() async {
  try {
    const url = AppUrl.allProductsUri;
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    // print(response.data);
    final List<dynamic> data = response.data;
    List<ProductModel> products = data.map((json) {
      return ProductModel.fromJson(json);
    }).toList();

    return products;
  } catch (error) {
    // Handle the error
    if (kDebugMode) {
      print('Error fetching products: $error');
    }
    // ignore: use_rethrow_when_possible
    throw error; 
  }
}

List<String> category = [];
Future<List<String>> fetchAllCategories() async {
  try {
    const url = AppUrl.allCategoriesUri;
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    final List<dynamic> data = response.data;
    category = data.map((e) {
      // print(e.toString());
      return e.toString();
    }).toList();
    
    return category;
  } catch (error) {
    // Handle the error
    if (kDebugMode) {
      print('Error fetching category: $error');
    }
    // ignore: use_rethrow_when_possible
    throw error; 
  }
}


  
}