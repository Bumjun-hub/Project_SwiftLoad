import 'dart:io'; // 모바일에서만 사용
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTestPage extends StatefulWidget {
  const FirebaseTestPage({super.key});

  @override
  State<FirebaseTestPage> createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;
  bool _isUploading = false;

  // 갤러리에서 이미지를 선택하는 함수
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
          _uploadedImageUrl = null;
        });
      }
    } catch (e) {
      print("이미지 선택 오류: $e");
    }
  }

  // 데이터를 Firestore에 저장하는 함수 (웹/모바일 호환)
  Future<void> _saveData() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이름과 전화번호를 모두 입력해주세요.")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? imageUrl;
    /*
    if (_image != null) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        // 로그인한 사용자가 있으면 그 사용자 ID를, 없으면 'guest_uploads'를 임시로 사용
        final String userId = user?.uid ?? 'guest_uploads';

        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_data')
            .child(userId)
            .child(fileName);

        // --- 웹/모바일 분기 처리 ---
        if (kIsWeb) {
          // 웹 환경일 경우
          final imageData = await _image!.readAsBytes();
          final UploadTask uploadTask = storageRef.putData(imageData);
          final TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        } else {
          // 모바일 환경일 경우
          final UploadTask uploadTask = storageRef.putFile(File(_image!.path));
          final TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        }
        // --------------------------

        setState(() {
          _uploadedImageUrl = imageUrl;
        });

      } catch (e) {
        print("이미지 업로드 오류: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("이미지 업로드 실패: $e")));
        setState(() { _isUploading = false; });
        return;
      }
    }
    */

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'profileImageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("데이터가 성공적으로 저장되었습니다.")));
      _nameController.clear();
      _phoneController.clear();
      setState(() {
        _image = null;
        _uploadedImageUrl = null;
      });

    } catch (e) {
      print("Firestore 저장 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("데이터 저장 실패: $e")));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // --- 선택된 이미지를 보여주는 위젯 (웹/모바일 호환) ---
  Widget _buildImageWidget() {
    if (_image == null) {
      return const Center(child: Text("프로필 사진"));
    }

    if (kIsWeb) {
      // 웹 환경일 경우
      return ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.network(_image!.path, fit: BoxFit.cover), // 웹에서는 XFile.path가 URL처럼 작동
      );
    } else {
      // 모바일 환경일 경우
      return ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.file(File(_image!.path), fit: BoxFit.cover),
      );
    }
  }
  // ------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore & Storage 테스트"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildImageWidget(), // 수정된 이미지 위젯 호출
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("사진 선택"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '전화번호', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              if (_isUploading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _saveData,
                  child: const Text('정보 저장하기'),
                ),
              if (_uploadedImageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      const Text("성공적으로 업로드된 이미지:"),
                      const SizedBox(height: 10),
                      Image.network(_uploadedImageUrl!, height: 100),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}