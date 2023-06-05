

import '../../Controller/home_controller_provider.dart';
import '../../utils/exports.dart';

class Categories extends StatelessWidget {
Categories({super.key});
final homeControllerProvider = HomeControllerProvider();
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<dynamic>(
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
                    childAspectRatio:
                        1, //it increase or decrease height of picture.
                  ),
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final categoryProduct = snapshot.data![index];
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
                                  color: AppColors.primaryColor,
                                ),
                                child: Center(
                                    child: Text(
                                  categoryProduct,
                                  style: const TextStyle(color: Colors.white),
                                )),
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
          );
  }
}