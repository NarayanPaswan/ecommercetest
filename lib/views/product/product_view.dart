import 'package:ecommercetest/Controller/cart_controller_provider.dart';
import 'package:ecommercetest/localdb/db_helper.dart';
import 'package:ecommercetest/models/cart_model.dart';
import 'package:ecommercetest/models/product_model.dart';
import 'package:ecommercetest/views/home/bottom_navigation_bar_view.dart';
import 'package:ecommercetest/views/home/drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../Controller/auth_controller_provider.dart';
import '../../Controller/home_controller_provider.dart';
import '../../utils/exports.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
 
   final authControllerProvider = AuthControllerProvider();
   final homeControllerProvider = HomeControllerProvider();

   DBHelper? dbHelper = DBHelper();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text("Product Page"),
        ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
             height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                     onChanged: (value) {
                        },
                     decoration:InputDecoration(
                       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                       hintText: 'Search your product here',
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(50),
                       )
                     ),
                    ),
                  ),
               
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,),
         
          FutureBuilder(
              future: homeControllerProvider.fetchAllProducts(),
              builder: (context, AsyncSnapshot<List<ProductModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child:  CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error.toString()}");
                } else {
                return  Consumer<CartControllerProvider>(
                   builder: (context, cartControllerProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,//it increase or decrease height of picture.
                            ),
                          scrollDirection: Axis.vertical, 
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                          final product = snapshot.data![index];        
                              return Card(
                                child: SizedBox(
                                   height: 250,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                         width: 160,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(product.image!),
                                            ),
                                          ),
                                        ),
                                      ),
                                     const SizedBox(height: 5,),
                                      InkWell(
                                        onTap: (){
                                      
                                      dbHelper!.insert(
                                          
                                          CartModel(
                                            id: index, 
                                            productId: product.id.toString(), 
                                            productTitle: product.title, 
                                            price: product.price, 
                                            productPrice: product.price, 
                                            quantity: 1, 
                                            image: product.image, 
                                            uuid: "cux6OFbSeLRpetFCR1c92EZQWUS2"
                                            )
                                          ).then((value) {
                                            // print("Product is added to cart");
                                            cartControllerProvider.addTotalPrice(double.parse(product.price.toString()));
                                            cartControllerProvider.addCounter();
                                          }).onError((error, stackTrace) {
                                            if (kDebugMode) {
                                              print('add to cart error: ${error.toString()}');
                                            }
                                          });
                                         
                                      },
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color:AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: const Center(child: Text("Add to Cart", style: TextStyle(color: Colors.white),)),
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      
                                    ],
                                  ),
                                ),
                              );
                            },
                          
                        ),
                    );
                   }
                );
         
                    }
                  },
                ),

          
        ],
      ),
      bottomNavigationBar: const bottomNavigationBarView(),
    );
  }
   

}