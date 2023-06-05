// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import '../../Controller/home_controller_provider.dart';
import '../../models/slider_model.dart';
import '../../utils/exports.dart';

class SliderScreen extends StatelessWidget {
   SliderScreen({super.key});
  final CarouselController carouselController = CarouselController();
    final homeControllerProvider = HomeControllerProvider();
  int sliderCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SliderModel>>(
                    future: homeControllerProvider.fetchAllSlider(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final urlImages = snapshot.data ?? [];
                        // print("url image length $urlImagesLength");
                        return CarouselSlider(
                                 items: urlImages
                              .map(
                                (item) => Container(
                                  color: AppColors.grey,
                                  width: double.infinity,
                                  child: Center(
                                    child: Image.network(
                                      item.downloadUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    
                                  ),                                
                                  ),
                              )
                              .toList(),
                          carouselController: carouselController,
                          options: CarouselOptions(
                            scrollPhysics: const BouncingScrollPhysics(),
                            autoPlay: false,
                            aspectRatio: 2.0,
                            viewportFraction: 2,
                            height: 150,
                            enableInfiniteScroll: true,
                            onPageChanged: (index, reason) {
                              sliderCurrentIndex = index;
                            },
                          ),
                        );
                      }
                    },
                    
                  );
  }
}