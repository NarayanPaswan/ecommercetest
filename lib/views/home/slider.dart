// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../Controller/home_controller_provider.dart';
import '../../models/slider_model.dart';
import '../../utils/exports.dart';
import 'package:shimmer/shimmer.dart';

class SliderScreen extends StatelessWidget {
   SliderScreen({super.key});
  final CarouselController carouselController = CarouselController();
    final homeControllerProvider = HomeControllerProvider();
  int sliderCurrentIndex = 0;
  final customCacheManager =CacheManager(
    Config(
      'customeCacheKey',
      stalePeriod: const Duration(days: 2),
      maxNrOfCacheObjects: 100,
      ),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 8.0),
      child: FutureBuilder<List<SliderModel>>(
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
                                      child: CachedNetworkImage(
                                        cacheManager: customCacheManager,
                                        key: UniqueKey(),
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          baseColor: Colors.grey.shade700,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(height: 200, width: double.infinity, color: Colors.white,),
                                          
                                        ),
    
                                         errorWidget: (context, url, error) => Container(
                                          color: Colors.grey,
                                          child:  const Icon(Icons.error, color: Colors.red, size: 40,)),
                                        imageUrl: item.downloadUrl!,
                                      
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
                      
                    ),
    );
  }
}