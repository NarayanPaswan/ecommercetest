import 'dart:async';
import 'package:ecommercetest/Controller/cart_controller_provider.dart';
import 'package:ecommercetest/localdb/db_helper.dart';
import 'package:ecommercetest/models/cart_model.dart';
import 'package:ecommercetest/models/product_model.dart';
import 'package:ecommercetest/views/home/bottom_navigation_bar_view.dart';
import 'package:ecommercetest/views/home/categories.dart';
import 'package:ecommercetest/views/home/drawer.dart';
import 'package:ecommercetest/views/home/slider.dart';
import 'package:ecommercetest/views/product/product_details.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../Controller/auth_controller_provider.dart';
import '../../Controller/home_controller_provider.dart';
import '../../utils/exports.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final authControllerProvider = AuthControllerProvider();
  final homeControllerProvider = HomeControllerProvider();
  TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;
  DBHelper? dbHelper = DBHelper();


  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }


  
  @override
  Widget build(BuildContext context) {
   
    // final cartControllerProvider = Provider.of<CartControllerProvider>(context);
    // print("widget rebuld");
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text("Home Page"),
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
                      controller: searchController,
                      // onChanged: (value) {
                      //   setState(() {
                          
                      //   });
                      // },
                        onChanged: (value) {
                          
                          if (_debounceTimer != null) {
                            _debounceTimer!.cancel();
                          }
        
                          _debounceTimer = Timer(const Duration(seconds: 2), () {
                            setState(() {
                              // isDataFound = true;
                            });
                          });
                        },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'Search your product here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),

          
          
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: Center(
              child: Column(
                children: [
                  //slider
                  SliderScreen(),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(text: "Categories", size: 14,)),
               )  ,

               Categories(),
            
         
           Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(text: "Products", size: 14,)),
               ),

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
                          String productName = product.title!;
                          if(searchController.text.isEmpty){
                          return Card(
                                child: SizedBox(
                                   height: 250,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductDetails(
                                                  productId: product.id.toString(),
                                                ),
                                              ),
                                            );
                                          },
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

                          }else if(productName.toLowerCase().contains(searchController.text.toLowerCase())){
                             return Card(
                                child: SizedBox(
                                   height: 250,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ProductDetails(
                                                  productId: product.id.toString(),
                                                ),
                                              ),
                                            );
                                          },
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

                          }else{

                           return Container();

                          }
                              
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
            ),
          ),
         
        ],
      ),
      bottomNavigationBar: const bottomNavigationBarView(),
    );
  }
}
