import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store/main_screens/cart.dart';
import 'package:multi_store/main_screens/visit_store.dart';
import 'package:multi_store/minor_screens/full_screen_view.dart';
import 'package:multi_store/models/product_model.dart';
import 'package:multi_store/providers/cart_provider.dart';
import 'package:multi_store/providers/wish_provider.dart';
import 'package:multi_store/widgets/appbar_widgets.dart';
import 'package:multi_store/widgets/snackbar.dart';
import 'package:multi_store/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({super.key, required this.proList});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();

  late var existingItemWishlist = context
      .read<Wishlist>()
      .getWishlistItems
      .firstWhereOrNull(
          (product) => product.documentId == widget.proList['proid']);

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];
  @override
  Widget build(BuildContext context) {
    late var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        (product) => product.documentId == widget.proList['proid']);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullscreenView(
                            imagesList: imagesList,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                              );
                            },
                            itemCount: imagesList.length,
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proList['proname'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'USD ',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.proList['price'].toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                existingItemWishlist != null
                                    ? context
                                        .read<Wishlist>()
                                        .removeThis(widget.proList['proid'])
                                    : context.read<Wishlist>().addWishlistItem(
                                          widget.proList['proname'],
                                          widget.proList['price'],
                                          1,
                                          widget.proList['instock'],
                                          widget.proList['proimages'],
                                          widget.proList['proid'],
                                          widget.proList['sid'],
                                        );
                              },
                              icon: context
                                          .watch<Wishlist>()
                                          .getWishlistItems
                                          .firstWhereOrNull((product) =>
                                              product.documentId ==
                                              widget.proList['proid']) !=
                                      null
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                            ),
                          ],
                        ),
                        widget.proList['instock'] == 0
                            ? const Text(
                                'this item is out of stock',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              )
                            : Text(
                                (widget.proList['instock'].toString()) +
                                    (' pieces available in stock'),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                        ProDetailsHeader(
                          label: '    Item Description    ',
                        ),
                        Text(
                          widget.proList['prodesc'],
                          textScaleFactor: 1.1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        ProDetailsHeader(
                          label: '   Similar  Items   ',
                        ),
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'This category \n\n has no items yet!',
                                    style: GoogleFonts.acme(
                                      fontSize: 26,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                child: StaggeredGridView.countBuilder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  crossAxisCount: 2,
                                  itemBuilder: (context, index) {
                                    return ProductModel(
                                      products: snapshot.data!.docs[index],
                                    );
                                  },
                                  staggeredTileBuilder: (context) =>
                                      const StaggeredTile.fit(1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisitStore(suppId: widget.proList['sid']),
                            ),
                          );
                        },
                        icon: const Icon(Icons.store),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(
                                back: AppBarBackButton(),
                              ),
                            ),
                          );
                        },
                        icon: Badge(
                          showBadge: context.read<Cart>().getItems.isEmpty
                              ? false
                              : true,
                          padding: const EdgeInsets.all(2),
                          badgeColor: Colors.yellow,
                          badgeContent: Text(
                            context.watch<Cart>().getItems.length.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                          ),
                        ),
                      ),
                    ],
                  ),
                  YellowButton(
                    label: existingItemCart != null
                        ? 'added to cart'
                        : 'ADD TO CART',
                    onPressed: () {
                      if (widget.proList['instock'] == 0) {
                        MyMessageHandler.showSnackBar(
                            _scaffoldKey, 'this item is out of stock');
                      } else if (existingItemCart != null) {
                        MyMessageHandler.showSnackBar(
                            _scaffoldKey, 'this item already exists');
                      } else {
                        context.read<Cart>().addItem(
                              widget.proList['proname'],
                              widget.proList['price'],
                              1,
                              widget.proList['instock'],
                              widget.proList['proimages'],
                              widget.proList['proid'],
                              widget.proList['sid'],
                            );
                      }
                    },
                    width: 0.55,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
