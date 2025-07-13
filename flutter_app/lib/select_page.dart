import 'package:flutter/material.dart';

import 'driver_join_page.dart';
import 'google_login_page.dart';

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
              const SizedBox(height: 32),
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
