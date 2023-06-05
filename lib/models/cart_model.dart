class CartModel {
  int? id;
  String? productId;  
  String? productTitle;
  num? price;
  num? productPrice;
  int? quantity;
  String? image;
  String? uuid;  
  
  CartModel({
   required this.id,
   required this.productId,
   required this.productTitle,
   required this.price,
   required this.productPrice,
   required this.quantity,
   required this.image,
   required this.uuid
  });

  CartModel.fromMap(Map<dynamic, dynamic> res) {  
     id = res['id'];
     productId = res['productId'];
     productTitle = res['productTitle'];
     price = res['price'];
     productPrice = res['productPrice'];
     quantity = res['quantity'];
     image = res['image'];
     uuid = res['uuid'];
  }

   Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'productId' : productId,
      'productTitle' : productTitle,
      'price' : price,
      'productPrice' : productPrice,
      'quantity' : quantity,
      'image' : image,
      'uuid' : uuid,
    };
    
  }

}


