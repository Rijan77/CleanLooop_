// import 'package:flutter/material.dart';
//
// class GreenMarketPage extends StatelessWidget {
//   final List<Map<String, dynamic>> products = [
//     {
//       'name': 'Reusable Water Bottle',
//       'price': '\$15',
//       'image': 'https://via.placeholder.com/150',
//     },
//     {
//       'name': 'Solar Lamp',
//       'price': '\$25',
//       'image': 'https://via.placeholder.com/150',
//     },
//     {
//       'name': 'Compost Bin',
//       'price': '\$30',
//       'image': 'https://via.placeholder.com/150',
//     },
//     {
//       'name': 'Organic Fertilizer',
//       'price': '\$10',
//       'image': 'https://via.placeholder.com/150',
//     },
//     {
//       'name': 'Indoor Plant',
//       'price': '\$20',
//       'image': 'https://via.placeholder.com/150',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Green Market'),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search products...',
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Product List
//             const Text(
//               'Available Products',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: GridView.builder(
//                 itemCount: products.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemBuilder: (context, index) {
//                   final product = products[index];
//                   return _buildProductCard(product);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add product listing functionality here
//         },
//         backgroundColor: Colors.green,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget _buildProductCard(Map<String, dynamic> product) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       elevation: 2,
//       child: InkWell(
//         onTap: () {
//           // Navigate to product details or action
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//                 child: Image.network(
//                   product['image'],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Text(
//                     product['name'],
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     product['price'],
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class GreenMarketPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Reusable Water Bottle',
      'price': '\$15',
      'image': 'https://images.unsplash.com/photo-1550317138-10000687a72b?w=200',
    },
    {
      'name': 'Solar Lamp',
      'price': '\$25',
      'image': 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400',
    },
    {
      'name': 'Compost Bin',
      'price': '\$30',
      'image': 'https://cdn.pixabay.com/photo/2017/07/02/09/04/compost-2468440_1280.jpg',
    },
    {
      'name': 'Organic Fertilizer',
      'price': '\$10',
      'image': 'https://images.unsplash.com/photo-1562577309-2592ab84b1bc?w=200',
    },
    {
      'name': 'Indoor Plant',
      'price': '\$20',
      'image': 'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=200',
    },
  ];

  GreenMarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Market'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product List
            const Text(
              'Available Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product, context);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add product listing functionality here
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to product details or action
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  product['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product['price'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Show eSewa payment dialog
                      _showPaymentDialog(context, product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Buy Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Purchase ${product['name']}'),
          content: const Text('Proceed to payment with eSewa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Integrate eSewa payment here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Payment for ${product['name']} initiated!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Pay with eSewa'),
            ),
          ],
        );
      },
    );
  }
}
