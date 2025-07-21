import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 주문 리스트'),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('estimates').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('주문 내역이 없습니다.'));
          }
          final ongoingOrders = snapshot.data!.docs
              .where((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            return data != null && data.containsKey('status') && data['status'] == 'waiting';
          })
              .toList();
          final completedOrders = snapshot.data!.docs
              .where((doc) {
            final data = doc.data() as Map<String, dynamic>?;
            return data != null && data.containsKey('status') && data['status'] == 'completed';
          })
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text('주문 리스트',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 10),
              if (ongoingOrders.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('현재 진행중인 주문이 없습니다.')),
                )
              else
                ...ongoingOrders.map((doc) => OrderCard(order: doc)),
              const SizedBox(height: 30),
              const Text('지난 리스트',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 10),
              if (completedOrders.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('완료된 주문이 없습니다.')),
                )
              else
                ...completedOrders.map((doc) => OrderCard(order: doc)),
            ],
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final QueryDocumentSnapshot order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final data = order.data() as Map<String, dynamic>? ?? {};
    final formatCurrency = NumberFormat.simpleCurrency(locale: "ko_KR", name: "원");

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(data['arrivalAddress'] as String? ?? '도착지 정보 없음'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('상세주소: ${data['arrivalDetail'] as String? ?? '정보 없음'}'),
            Text('받는사람: ${data['arrivalName'] as String? ?? '정보 없음'}'),
            Text('연락처: ${data['arrivalContact'] as String? ?? '정보 없음'}'),
            Text('예상 가격: ${formatCurrency.format(data['calculatedPrice'] ?? 0)}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (data['status'] == '배차중' || data['status'] == '배차완료' || data['status'] == '배송중') ? Colors.amber : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            data['status'] as String? ?? '상태 정보 없음',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}