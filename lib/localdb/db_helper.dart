import 'package:ecommercetest/models/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'dart:io' as io;


class DBHelper{
  static Database? _db;

  Future<Database?> get db async{
    //if database is present then no need to create
    if(_db != null){
      return _db!;
    }
    //otherwise create database
    _db = await initDatabase();
  }
  initDatabase()async{
    //it is creating database in our mobile
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cartdatabase.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate,);
    return db;
  }

  _onCreate(Database db, int version)async{
      await db.execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productTitle TEXT, price INTEGER, productPrice INTEGER, quantity INTEGER, image TEXT, uuid TEXT)'
      );
  }

  Future<CartModel> insert (CartModel cart)async{
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

    Future<List<CartModel>> getCartList ()async{
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((e) => CartModel.fromMap(e)).toList();
    
    }

  Future<int> delete(int id)async{
     var dbClient = await db;
     return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id]
     );
  }

  Future<int> updateQuentity(CartModel cart)async{
     var dbClient = await db;
     return await dbClient!.update(
      'cart',
      cart.toMap(),
      where: 'id = ?',
      whereArgs: [cart.id]
      
     );
  }

}