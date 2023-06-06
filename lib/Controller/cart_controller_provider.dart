import 'package:ecommercetest/localdb/db_helper.dart';
import 'package:ecommercetest/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/exports.dart';

class CartControllerProvider extends ChangeNotifier {
  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  //_getPrefItems() method call to the constructor. when data added pref then it run
  CartControllerProvider() {
    _getPrefItems();
  }

  late Future<List<CartModel>> _cart;
  Future<List<CartModel>> get cart => _cart;

  Future<List<CartModel>> getDataFromLocalStorage ()async{
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

   void _getPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

   void addTotalPrice (double productPrice){
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice (double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice (){
    _getPrefItems();
    return _totalPrice; 
   
  }

  void addCounter (){
    _counter ++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter (){
    _counter --;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter (){
    // _getPrefItems();
    return _counter;
  }

  Future deleteAllDataFromCartTable()async{
   db.deleteAllFromCartTable();
   notifyListeners();
  }
  //delete all data from shared Pref
  void clearPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  }


}