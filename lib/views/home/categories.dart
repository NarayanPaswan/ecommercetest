

import '../../Controller/home_controller_provider.dart';
import '../../utils/exports.dart';

class Categories extends StatelessWidget {
Categories({super.key});
final homeControllerProvider = HomeControllerProvider();
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(4.0),
      child: FutureBuilder<dynamic>(
              future: homeControllerProvider.fetchAllCategories(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error fetching categories: ${snapshot.error}');
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 300 / 150,
                          
                    ),
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final categoryProduct = snapshot.data![index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                          width: 300,
                          height: 150,
                      
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                     borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                              categoryProduct,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.white,
                                              
                                              ),),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}