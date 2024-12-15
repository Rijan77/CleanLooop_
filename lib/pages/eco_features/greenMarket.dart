

import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';

class GreenMarketPage extends StatelessWidget {
  const GreenMarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Green Market'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Eco-Friendly Products'),
              Tab(text: 'Sustainable Alternatives'),
              Tab(text: 'Local Vendors'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EcoFriendlyProductMarketplace(),
            SustainableAlternatives(),
            LocalVendors(),
          ],
        ),
      ),
    );
  }
}

class EcoFriendlyProductMarketplace extends StatefulWidget {
  const EcoFriendlyProductMarketplace({super.key});

  @override
  _EcoFriendlyProductMarketplaceState createState() =>
      _EcoFriendlyProductMarketplaceState();
}

class _EcoFriendlyProductMarketplaceState
    extends State<EcoFriendlyProductMarketplace> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  // List of products with names and image URLs
  List<Map<String, String>> products = [
    {
      'name': 'Flower Bouquet',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkLLUtxpbCKtmZi4hWvFNgceCyoc_X0JEbWA&s',
    },
    {
      'name': 'Apple',
      'image': 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=600',
    },
    {
      'name': 'Pot',
      'image': 'https://www.shutterstock.com/image-photo/clay-flower-pot-soil-isolated-600nw-2374368675.jpg',
    },
    {
      'name': 'Pot Flower',
      'image': 'https://www.shutterstock.com/image-vector/spring-colorful-flowers-pots-vector-260nw-99149603.jpg',
    },
    {
      'name': 'Tomato',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4t2GRCI-vxm730F6OC76aQIhTeoEVnGLYOQ&s',
    },
  ];

  esewapaymentcall() {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: StaticValue.CLIENT_ID,
          secretId: StaticValue.SECRET_KEY,
        ),
        esewaPayment: EsewaPayment(
          productId: "1d71jd81",
          productName: "Product One",
          productPrice: "20",
          callbackUrl: '',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult data) {
          debugPrint(":::SUCCESS::: => $data");
          // verifyTransactionStatus(data);
        },
        onPaymentFailure: (data) {
          debugPrint(":::FAILURE::: => $data");
        },
        onPaymentCancellation: (data) {
          debugPrint(":::CANCELLATION::: => $data");
        },
      );
    } on Exception catch (e) {
      debugPrint("EXCEPTION : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search Products',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                searchQuery = query;
              });
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 250, // Set fixed height for each card
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              String productImage = products[index]['image']!;
              String productName = products[index]['name']!;
              return productName.contains(searchQuery) || searchQuery.isEmpty
                  ? Card(
                elevation: 5,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10)),
                      child: Image.network(
                        productImage,
                        fit: BoxFit.cover,
                        height: 120, // Adjusted image height
                        width: double.infinity,
                        loadingBuilder:
                            (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes !=
                                  null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ??
                                      1)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          const Text('\$20.00'),
                          ElevatedButton(
                            onPressed: () {
                              _showPaymentMethodDialog(context);
                            },
                            child: const Text('Buy'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  : Container();
            },
          ),
        ),
      ],
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: ListTile(
            title: const Text('eSewa'),
            leading: const Icon(Icons.payment),
            onTap: () {
              esewapaymentcall();
            },
          ),
        );
      },
    );
  }

  void _showPaymentSuccessDialog(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Text('Payment via $method has been successfully processed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class StaticValue {
  static var CLIENT_ID = "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R";
  static var SECRET_KEY = "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==";
}

class SustainableAlternatives extends StatelessWidget {
  const SustainableAlternatives({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        ListTile(
          title: Text('Reusable Water Bottles'),
          subtitle: Text('Say goodbye to single-use plastic bottles and opt for durable, eco-friendly water bottles.'),
        ),
        ListTile(
          title: Text('Compostable Kitchenware'),
          subtitle: Text('Compostable plates, cups, and utensils for eco-conscious dining.'),
        ),
        ListTile(
          title: Text('Bamboo Toothbrushes'),
          subtitle: Text('Sustainable alternatives to plastic toothbrushes made from bamboo.'),
        ),
        ListTile(
          title: Text('Eco-Friendly Clothing'),
          subtitle: Text('Clothing made from sustainable fabrics like organic cotton, hemp, and recycled materials.'),
        ),
      ],
    );
  }
}

class LocalVendors extends StatelessWidget {
  const LocalVendors({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        ListTile(
          title: Text('Green Earth Grocers'),
          subtitle: Text('Local organic grocery store offering fresh produce and eco-friendly products.'),
        ),
        ListTile(
          title: Text('Sustainable Clothing Co.'),
          subtitle: Text('Locally-made clothing line focused on using sustainable materials.'),
        ),
        ListTile(
          title: Text('The Green Market Farm'),
          subtitle: Text('Farm offering organic fruits and vegetables, promoting sustainable agriculture.'),
        ),
        ListTile(
          title: Text('Recycled Goods Shop'),
          subtitle: Text('Store specializing in upcycled and recycled goods from local artisans.'),
        ),
      ],
    );
  }
}
