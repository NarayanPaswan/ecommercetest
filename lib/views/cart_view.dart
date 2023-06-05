import 'package:ecommercetest/models/cart_model.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../Controller/cart_controller_provider.dart';
import '../localdb/db_helper.dart';
import '../utils/exports.dart';
import 'home/bottom_navigation_bar_view.dart';


class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
   DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cartControllerProvider = Provider.of<CartControllerProvider>(context);
    // print("rebuild widget");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Page"),
        ),
     body: FutureBuilder(
       future: cartControllerProvider.getDataFromLocalStorage(),
       builder: (context, AsyncSnapshot<List<CartModel>> snapshot){
         if(!snapshot.hasData){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(image: AssetImage(AssetsPath.emptyCartImage)),
                  AppText(text: Labels.exploreProducts, size: 13,)
                ],
              ),
            );
            
         }else{
           return Column(
             children: [
               Expanded(
                 child: ListView.builder(
                   itemCount: snapshot.data!.length,
                   itemBuilder: (context, index){
                       return Card(
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                height: 100,
                                width: 100,
                                image: NetworkImage(snapshot.data![index].image.toString()),
                              ),
                             const SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      Expanded(child: AppText(text: snapshot.data![index].productTitle.toString(),)),
                                       InkWell(
                                        onTap: (){
                                        dbHelper!.delete(snapshot.data![index].id!);
                                        cartControllerProvider.removeCounter();
                                        cartControllerProvider.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                        },
                                        child: const Icon(Icons.delete, color: Colors.red,),
                                        ),
                                      ],
                                    ),
                                    AppText(text: "Rs. ${snapshot.data![index].productPrice.toString()}", size: 12,),
                                    const SizedBox(width: 5,),
                                    const SizedBox(height: 15,),
                                  
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child:   InkWell(
                                      onTap: (){
              
                                      },
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color:AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0, right: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                               InkWell(
                                                onTap: (){
                                                  int quantity = snapshot.data![index].quantity!;
                                                  num price = snapshot.data![index].price!;
                                                  quantity --;
                                                  num? newPrice = price * quantity;
                                                  if(quantity> 0){

                                                  dbHelper!.updateQuentity(
                                                    CartModel(
                                                      id: snapshot.data![index].id, 
                                                      productId: snapshot.data![index].productId, 
                                                      productTitle: snapshot.data![index].productTitle, 
                                                      price: snapshot.data![index].price!, 
                                                      productPrice: newPrice, 
                                                      quantity: quantity, 
                                                      image: snapshot.data![index].image!, 
                                                      uuid: "cux6OFbSeLRpetFCR1c92EZQWUS2"
                                                      )
                                                  ).then((value) {
                                                    newPrice = 0;
                                                    quantity = 0;
                                                    cartControllerProvider.removeTotalPrice(double.parse(snapshot.data![index].price.toString()));
                                                  }).onError((error, stackTrace) {
                                                    if (kDebugMode) {
                                                      print(error.toString());
                                                    }
                                                  });
                                                  }
                                                },
                                                child: const Icon(Icons.remove, color: Colors.white,)
                                                ), 
                                               Text(snapshot.data![index].quantity.toString(), style: const TextStyle(color: Colors.white),), 
                                               InkWell(
                                                onTap: (){
                                                  int quantity = snapshot.data![index].quantity!;
                                                  num price = snapshot.data![index].price!;
                                                  quantity ++;
                                                  num? newPrice = price * quantity;
                                                  dbHelper!.updateQuentity(
                                                    CartModel(
                                                      id: snapshot.data![index].id, 
                                                      productId: snapshot.data![index].productId, 
                                                      productTitle: snapshot.data![index].productTitle, 
                                                      price: snapshot.data![index].price!, 
                                                      productPrice: newPrice, 
                                                      quantity: quantity, 
                                                      image: snapshot.data![index].image!, 
                                                      uuid: "cux6OFbSeLRpetFCR1c92EZQWUS2"
                                                      )
                                                  ).then((value) {
                                                    newPrice = 0;
                                                    quantity = 0;
                                                    cartControllerProvider.addTotalPrice(double.parse(snapshot.data![index].price.toString()));
                                                  }).onError((error, stackTrace) {
                                                    if (kDebugMode) {
                                                      print(error.toString());
                                                    }
                                                  });
                                                },
                                                child: const Icon(Icons.add, color: Colors.white,)
                                                ), 
                                              ],
                                            ),
                                          )
                                          
                                        ),
                                      ),
                                    ),
                                    
                                  ],
                                )
                              )
                            ],
                          )
                        ],
                        ),
                     )
                    );
                   }
                 ),
               ),
              Consumer<CartControllerProvider>(
              builder: (context, cartTotal, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    visible: cartTotal.getTotalPrice().toStringAsFixed(2) == "0.00" ? false : true,
                    child: Column(
                      children: [
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                          children: [
                          AppText(text: "Sub Total: ", size: 12,),  
                          AppText(text: "Rs ${cartTotal.getTotalPrice().toStringAsFixed(2)}", size: 12,)
                          
                          ],
                        )
                        
                        
                      ],
                    ),
                  ),
                );
              }),
             ],
           );
         }
       }),
       bottomNavigationBar: const bottomNavigationBarView(),   
    );
  }
}