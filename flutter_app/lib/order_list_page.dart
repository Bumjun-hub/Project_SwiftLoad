// order_list_page.dart
import 'package:flutter/material.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 주문 리스트'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('주문 리스트', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 20),

            // 주문 리스트 샘플 카드 1
            Card(
              child: ListTile(
                title: const Text('서울삼성병원'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('10kg'),
                    Text('100,000원'),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('배차중', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text('지난 리스트', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 20),

            // 지난 리스트 샘플 카드 1
            Card(
              child: ListTile(
                title: const Text('서울삼성병원'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('10kg'),
                    Text('100,000원'),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('배송완료', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
