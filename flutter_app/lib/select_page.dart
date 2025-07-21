import 'package:flutter/material.dart';
import 'driver_join_page.dart';
import 'google_login_page.dart';
import 'package:flutter_app/firebase_test_page.dart';
import 'package:flutter_app/order_list_page.dart'; // 이 줄을 추가합니다.

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OptionCard(
                imagePath: 'assets/box.png',
                title: '화물 신청하기',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoogleLoginPage()),
                  );
                },
              ),
              const SizedBox(height: 16),   //원래 32
              OptionCard(
                imagePath: 'assets/truck.png',
                title: '기사님 모집',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DriverJoinPage()),
                  );
                },
              ),
              const SizedBox(height: 16), // 카드와 버튼 사이에 간격을 줍니다.

              // ▼▼▼▼▼ 이 버튼 코드를 수정 ▼▼▼▼▼
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // 내부 여백 제거
                  minimumSize: const Size(50, 30), // 최소 크기 지정
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderListPage()), // OrderListPage로 변경
                  );
                },
                child: const Text(
                  '내 주문 리스트', // 텍스트 변경
                  style: TextStyle(color: Colors.grey, fontSize: 12), // 글자 크기도 작게
                ),
              ),
              // ▲▲▲▲▲ 여기까지 수정 ▲▲▲▲▲
            ],
          ),
        ),
      ),
    );
  }
}


class OptionCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 280,
        height: 240, // ✅ 고정 크기 줌! (여기서 통일됨)
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFFFFBB00),
              width: 3,
            ),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // ✅ 가운데 정렬
              children: [
                Image.asset(
                  imagePath,
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}