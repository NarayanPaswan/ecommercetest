import 'package:ecommercetest/views/cart_view.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ecommercetest/views/home/home_view.dart';
import 'package:provider/provider.dart';
import '../../Controller/cart_controller_provider.dart';
import '../../Controller/home_controller_provider.dart';
import '../../utils/exports.dart';

// ignore: camel_case_types
class bottomNavigationBarView extends StatelessWidget {
  const bottomNavigationBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeControllerProvider = Provider.of<HomeControllerProvider>(context);
    final selectedIndex = homeControllerProvider.selectedIndex;

    void onItemTapped(int index) {
      homeControllerProvider.setIndex(index);
    }
    return BottomNavigationBar(
      items:  [
         BottomNavigationBarItem(
        label: 'Home',
        icon: IconButton(
          onPressed: () {
            PageNavigator(ctx: context).nextPage(page: const HomeView());
          },
          icon: const Icon(Icons.home))
      ),
      
       BottomNavigationBarItem(
        label: 'Cart',
          icon: badges.Badge(
            badgeContent: 
            Consumer<CartControllerProvider>(
              builder: (context, cartValue, child) {
                return Text(cartValue.getCounter().toString(), style: const TextStyle(color: Colors.white));
              }
              ),
            position: badges.BadgePosition.topEnd(top: 0, end: 0),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                 PageNavigator(ctx: context).nextPage(page: const CartView());
              },
            ),
          ),
      ),
      
      
       BottomNavigationBarItem(
        label: 'Profile',
       icon: IconButton(
         onPressed: () {},
        icon: const Icon(Icons.person))
      ),
      
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: onItemTapped,
      );
  }
}