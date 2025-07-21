import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For number formatting
import 'package:flutter_app/order_list_page.dart'; // order_list_page 임포트 추가

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  PaymentPage({super.key, required this.orderData});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _depositorNameController = TextEditingController();
  String _paymentStatus = '대기중'; // Initial status (내부적으로만 사용)
  String? _selectedBank; // 선택된 은행
  bool _disclaimerAccepted = false; // 주의사항 동의 체크박스 상태

  final List<String> _banks = [
    '기업은행',
    '우체국',
    '신한은행',
    '농협은행',
    '국민은행',
    '카카오뱅크',
    '우리은행',
    '하나은행',
    '새마을금고',
  ];

  @override
  void dispose() {
    _depositorNameController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_disclaimerAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('결제 전 유의사항에 동의해야 합니다.')),
      );
      return;
    }

    // Simulate payment processing
    setState(() {
      _paymentStatus = '결제 처리 중...';
    });

    try {
      // Determine the amount to save
      int amountToSave = 0;
      final dynamic priceValue = widget.orderData['price'];
      if (priceValue is num) {
        amountToSave = priceValue.toInt();
      } else if (priceValue is String) {
        final String cleanedPriceString = priceValue.replaceAll(RegExp(r'[^\d.]'), '').trim();
        try {
          amountToSave = double.parse(cleanedPriceString).toInt();
        } catch (e) {
          print('ERROR: Failed to parse price string for saving: "$cleanedPriceString". Error: $e');
          amountToSave = 0;
        }
      }

      // Save payment details to Firestore
      await FirebaseFirestore.instance.collection('payments').add({
        'orderId': widget.orderData['orderId'],
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'amount': amountToSave, // Use the parsed integer amount
        'depositorName': _depositorNameController.text,
        'selectedBank': _selectedBank, // 선택된 은행 저장
        'timestamp': FieldValue.serverTimestamp(),
        'status': '결제 완료',
      });

      setState(() {
        _paymentStatus = '결제 완료!';
      });

      // 결제 완료 팝업 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('주문이 완료되었습니다. 목록에서 확인 해 주세요.')),
      );

      // 팝업 표시 후 order_list_page로 이동
      // pushReplacement를 사용하여 뒤로가기 시 결제 페이지로 돌아오지 않도록 합니다.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderListPage()),
      );

    } catch (e) {
      setState(() {
        _paymentStatus = '결제 실패: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('결제 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat('#,###', 'ko_KR');
    final dynamic priceValue = widget.orderData['price']; // Get the raw price value

    int price = 0; // Default price
    if (priceValue is num) {
      price = priceValue.toInt(); // If it's already a number, convert to int
      print('DEBUG (PaymentPage): Price received as num: $priceValue, converted to int: $price'); // 디버그 출력
    } else if (priceValue is String) {
      // If it's a string, clean and parse it
      final String cleanedPriceString = priceValue.replaceAll(RegExp(r'[^\d.]'), '').trim();
      try {
        price = double.parse(cleanedPriceString).toInt();
        print('DEBUG (PaymentPage): Price received as string: "$priceValue", cleaned: "$cleanedPriceString", converted to int: $price'); // 디버그 출력
      } catch (e) {
        print('ERROR: Failed to parse price for display: "$cleanedPriceString". Error: $e');
        price = 0; // Fallback to 0 on parsing error
      }
    } else {
      print('DEBUG (PaymentPage): Price received as unexpected type: ${priceValue.runtimeType}, value: $priceValue'); // 디버그 출력
    }
    // If priceValue is neither num nor String, price remains 0.

    final String formattedPrice = currencyFormatter.format(price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주문 금액: $formattedPrice원', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // 회사 은행 정보 섹션 (노란색 테두리로 감싸기)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('은행명: 기업은행', style: TextStyle(fontSize: 16)),
                  Text('계좌번호: 12-345-6478', style: TextStyle(fontSize: 16)),
                  Text('받는사람: SwiftLoad', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 입금할 은행 선택 드롭다운
            DropdownButtonFormField<String>(
              value: _selectedBank,
              decoration: InputDecoration(
                labelText: '입금할 은행 선택',
                hintText: '은행을 선택하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
              ),
              items: _banks.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedBank = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            const Text('입금자명', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _depositorNameController,
              decoration: const InputDecoration(
                hintText: '입금자명을 입력하세요',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            const SizedBox(height: 30),

            // SwiftLoad 서비스 결제 전 유의사항 안내
            const Text(
              'SwiftLoad 서비스 결제 전 유의사항 안내',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'SwiftLoad는 원활한 화물 운송 서비스 제공을 위해 다음과 같은 정보를 수집하며, 다양한 상황에 따라 추가 요금이 발생할 수 있습니다. 아래 내용을 충분히 숙지하신 후 결제를 진행해 주세요.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 15),

            const Text(
              '1. 개인정보 제공 동의',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'SwiftLoad 서비스를 이용하고 결제를 진행하시는 경우, 아래 정보를 수집합니다:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            const Text(
              '수집 항목: 이름, 휴대전화번호, 배송지 정보, 결제수단, 수령인 정보 등',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              '수집 목적: 원활한 배송 진행 및 상담, 고객관리, 클레임 대응, 서비스 고지 및 품질 개선 등',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              '※ 수집에 동의하지 않으실 경우 서비스 이용이 제한될 수 있습니다.',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 15),

            const Text(
              '2. 추가 요금 안내',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              '다음 상황에 따라 기본요금 외에 추가 비용이 부과될 수 있습니다:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            const Text('긴급 배송 요청: 기본요금의 2배', style: TextStyle(fontSize: 14)),
            const Text('과적/과대 물품: 주문 시 확인', style: TextStyle(fontSize: 14)),
            const Text('왕복 배송 요청: 편도요금의 2배', style: TextStyle(fontSize: 14)),
            const Text('대기 시간 발생 시: 10분당 3,000원', style: TextStyle(fontSize: 14)),
            const Text('픽업지 도착 후 취소:', style: TextStyle(fontSize: 14)),
            const Text('  오토바이: 5,000원', style: TextStyle(fontSize: 14)),
            const Text('  다마스/라보: 10,000원', style: TextStyle(fontSize: 14)),
            const Text('  1톤: 20,000원', style: TextStyle(fontSize: 14)),
            const Text('  1톤 초과: 30,000원 ~ 50,000원', style: TextStyle(fontSize: 14)),
            const Text('야간/휴일/눈길/명절/한파 운행 시: 3,000원 ~ 5,000원 추가 요금 발생', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 15),

            const Text(
              '3. 기타',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              '요금은 수수료 및 거리, 시간, 날씨, 도로 상황 등을 반영하여 책정됩니다.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),

            // 최종 결제 금액 강조 및 체크박스
            Text(
              '최종 결제 금액은 견적에 기반해 산정되며, 상황에 따라 변경될 수 있습니다.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[700]),
            ),
            CheckboxListTile(
              title: const Text('위 유의사항을 모두 확인하고 동의합니다.'),
              value: _disclaimerAccepted,
              onChanged: (bool? newValue) {
                setState(() {
                  _disclaimerAccepted = newValue ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading, // 체크박스를 왼쪽에 배치
              activeColor: Colors.amber, // 체크박스 활성화 시 색상
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text( // 텍스트를 '결제하기'로 고정
                  '결제하기',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}