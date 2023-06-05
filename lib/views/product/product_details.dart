import 'package:ecommercetest/utils/exports.dart';

import '../../Controller/home_controller_provider.dart';
import '../../models/product_details_model.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  String productId;
   ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final homeControllerProvider = HomeControllerProvider();
    @override
  void initState() {
    super.initState();
    // print('Your product id is: ${widget.productId}');
    // homeControllerProvider.getSingleProduct(widget.productId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: homeControllerProvider.getSingleProduct(widget.productId),
            builder: (context, AsyncSnapshot<ProductDetailsModel> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                if (snapshot.data == null) {  
                  return const Center(
                    child: Text("Product details not available !"),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        width: 160,
                        height: 200.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(snapshot.data!.image!),
                          ),
                        ),
                      ),
                    ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                         children: [
                           Expanded(child: Center(child: Text(snapshot.data?.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),))),
                         ],
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           AppText(text: "Price ", size: 14,),
                           AppText(text: "Rs ${snapshot.data?.price.toString() ?? ''}", size: 14,)
                           
                         ],
                       ),
                     ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(
                                        color: Colors.black,
                                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(snapshot.data?.description ?? '')),
                          ],
                        ),
                      )
                  ],
                );
              }
            }),
      ),
    );
  }
}