import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 테스트 전용 페이지 위젯
 class FirebaseTestPage extends StatefulWidget {
     const FirebaseTestPage({super.key});

     @override
     State<FirebaseTestPage> createState() => _FirebaseTestPageState();
   }

 class _FirebaseTestPageState extends State<FirebaseTestPage> {
     // 입력 필드를 제어하기 위한 컨트롤러
     final TextEditingController _nameController = TextEditingController();
     final TextEditingController _phoneController = TextEditingController();
     bool _isLoading = false; // 로딩 상태를 관리할 변수

     // 데이터 전송 함수
     Future<void> _sendDataToFirebase() async {
       // 이름이나 연락처가 비어있으면 함수 종료
       if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('이름과 연락처를 모두 입력해주세요.')),
         );
         return;
       }

       // 로딩 시작
       setState(() {
         _isLoading = true;
       });

       try {
         // 'test_data' 라는 컬렉션에 데이터를 추가합니다.
         // 이 컬렉션은 자동으로 생성됩니다.
         await FirebaseFirestore.instance.collection('test_data').add({
           'name': _nameController.text,
          'phone': _phoneController.text,
          'createdAt': FieldValue.serverTimestamp(), // 현재 서버 시간 기록
        });

         // 성공 메시지 표시
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('데이터 전송 성공! Firebase 콘솔을 확인하세요.')),
         );
         // 성공 후 이전 화면으로 돌아가기
         Navigator.pop(context);

       } catch (e) {
         // 실패(오류) 메시지 표시
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $e')),
        );
       } finally {
         // 로딩 종료
         setState(() {
           _isLoading = false;
         });
       }
     }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: const Text('Firebase 연결 테스트'),
           backgroundColor: Colors.blueGrey,
         ),
         body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               TextField(
                 controller: _nameController,
                 decoration: const InputDecoration(labelText: '이름'),
               ),
               const SizedBox(height: 16),
              TextField(
                 controller: _phoneController,
                 decoration: const InputDecoration(labelText: '연락처'),
                keyboardType: TextInputType.phone,
               ),
               const SizedBox(height: 32),
               // _isLoading이 true이면 로딩 인디케이터를, false이면 버튼을 보여줌
               _isLoading
                   ? const Center(child: CircularProgressIndicator())
                   : ElevatedButton(
                      onPressed: _sendDataToFirebase,
                       child: const Text('데이터 전송'),
                     ),
             ],
           ),
         ),
       );
     }
   }