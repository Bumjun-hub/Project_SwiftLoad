// google_login_page.dart
import 'package:flutter/material.dart';
import 'cargo_order_page.dart';
import 'order_list_page.dart';

class GoogleLoginPage extends StatelessWidget {
  const GoogleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 240,
          height: 60,
          child: OutlinedButton(                 // ✅ 테두리 버튼
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CargoOrderPage(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,    // ✅ 내부 흰색
              side: const BorderSide(           // ✅ 주황 테두리
                color: Color(0xFFF4B800),
                width: 3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 📌 assets/google.png — 48x48 투명 배경 아이콘
                Image.asset(
                  'assets/google.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  '구글 로그인',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
