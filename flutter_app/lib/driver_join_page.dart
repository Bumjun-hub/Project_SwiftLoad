import 'package:flutter/material.dart';

class DriverJoinPage extends StatefulWidget {
  const DriverJoinPage({super.key});

  @override
  State<DriverJoinPage> createState() => _DriverJoinPageState();
}

class _DriverJoinPageState extends State<DriverJoinPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController detailAddressController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();

  bool agreePrivacy = false;

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    carNumberController.dispose();
    carTypeController.dispose();
    licenseController.dispose();
    addressController.dispose();
    detailAddressController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      if (!agreePrivacy) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('개인정보 수집 및 이용에 동의해주세요.')),
        );
        return;
      }
      // 가입 처리 로직 넣기 (API 호출 등)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가입 신청이 완료되었습니다.')),
      );
      Navigator.pop(context); // 완료 후 이전 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기사 가입 신청서'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('이름'),
              TextFormField(
                controller: nameController,
                validator: (value) => value == null || value.isEmpty ? '이름을 입력해주세요' : null,
              ),
              const SizedBox(height: 8),

              const Text('연락처'),
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? '연락처를 입력해주세요' : null,
              ),
              const SizedBox(height: 8),

              const Text('소유 차량번호'),
              TextFormField(controller: carNumberController),
              const SizedBox(height: 8),

              const Text('차종'),
              TextFormField(controller: carTypeController),
              const SizedBox(height: 8),

              const Text('운전면허'),
              TextFormField(controller: licenseController),
              const SizedBox(height: 8),

              const Text('주소'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(hintText: '주소 *'),
                      validator: (value) => value == null || value.isEmpty ? '주소를 입력해주세요' : null,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // 주소 검색 로직
                    },
                    icon: const Icon(Icons.search),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // 주소록 호출 로직
                    },
                    child: const Text('상세주소 *'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: detailAddressController,
                decoration: const InputDecoration(hintText: '상세 주소 입력'),
              ),
              const SizedBox(height: 16),

              const Text('추가정보'),
              TextFormField(
                controller: additionalInfoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '운행 가능 지역을 입력해주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: agreePrivacy,
                    onChanged: (value) {
                      setState(() {
                        agreePrivacy = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text('개인정보 수집 및 이용에 동의합니다.'),
                  ),
                ],
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('기사 가입하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
