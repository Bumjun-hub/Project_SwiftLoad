import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverJoinPage extends StatefulWidget {
  const DriverJoinPage({super.key});

  @override
  State<DriverJoinPage> createState() => _DriverJoinPageState();
}

class _DriverJoinPageState extends State<DriverJoinPage> {
  // 각 입력 필드를 위한 컨트롤러와 변수 선언
  final _nameController = TextEditingController();
  final _rrnController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bankNameController = TextEditingController(); // 입금은행 컨트롤러 추가
  final _accountNumberController = TextEditingController(); // 입금계좌번호 컨트롤러 추가
  final _addressController = TextEditingController();
  final _addressDetailController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _notesController = TextEditingController();

  // 메뉴
  String? _selectedVehicleSize;
  final List<String> _vehicleSizes = ['1톤','1.2톤', '2.5톤', '3.5톤', '5톤','11톤'];

  String? _selectedVehicleType;
  final List<String> _vehicleTypes = ['카고', '윙바디', '냉장탑', '냉동탑', '리프트','리프트윙', '플러스 카고', '플러스 윙바디'];

  String? _selectedBank; // 입금은행
  final List<String> _bankList = [
    '농협', '국민', '하나', '신한', '카카오', '우리', '우체국', '새마을', '수협', '기업'
  ];

  bool _isLoading = false;
  bool _isPledgeAgreed = false;

  Future<void> _saveDriverInfo() async {
    // 필수 필드 유효성 검사
    if (_nameController.text.isEmpty ||
        _rrnController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedBank == null ||
        _accountNumberController.text.isEmpty ||
        _selectedVehicleSize == null ||
        _selectedVehicleType == null ||
        _vehicleNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진, 주소, 요청사항, 확약서를 제외한 모든 항목을 입력해주세요.')),
      );
      return;
    }

    // 확약서 동의 여부 확인
    if (!_isPledgeAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('확약서에 동의해주셔야 등록이 가능합니다.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('drivers').add({
        'name': _nameController.text,
        'rrn': _rrnController.text,
        'phone': _phoneController.text,
        'bankName': _selectedBank,
        'accountNumber': _accountNumberController.text,
        'vehicleSize': _selectedVehicleSize,
        'vehicleType': _selectedVehicleType,
        'vehicleNumber': _vehicleNumberController.text,
        'notes': _notesController.text,
        'pledgeAgreed': _isPledgeAgreed,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기사님 정보가 성공적으로 등록되었습니다!')),
      );

      // 등록 성공 후 입력 필드 초기화
      _nameController.clear();
      _rrnController.clear();
      _phoneController.clear();
      _bankNameController.clear(); // 초기화 추가
      _accountNumberController.clear(); // 초기화 추가
      _addressController.clear();
      _addressDetailController.clear();
      _vehicleNumberController.clear();
      _notesController.clear();
      setState(() {
        _selectedVehicleSize = null;
        _selectedVehicleType = null;
        _selectedBank = null; // 초기화 추가
        _isPledgeAgreed = false;
      });

    } catch (e) {
      print("Firestore 저장 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 저장에 실패했습니다. 오류: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPhotoPlaceholder({required String label, required IconData icon}) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // 확약서 팝업을 보여주는 함수
  void _showPledgeDialog() {
    final List<String> pledgeItems = [
      "1. 본인은 서비스업에 맞게 친절, 안전, 신속한 배송을 하겠습니다.",
      "2. 본인은 고객과 다투거나, 욕설, 폭언 등을 하지 않겠습니다.",
      "3. 본인은 분실, 파손, 지연배송등의 본인 귀책사유로 배상책임 발행 시 회사에 그 책임을 전가하지 않겠으며, 본인이 100% 책임지고 배상하겠습니다.",
      "4. 본인은 고객님께 타사영수증, 타사 구폰판을 드리지 않겠습니다.",
      "5. 본인은 기사어플 사용동안 위치정보 및 사진 정보 사용에 동의합니다.",
      "6. 본인은 위 사항을 모두 확인 했으며 어길 시 퇴사에 동의합니다.",
      "7. 프로그램 사용료 1일 당 1000원/ 콜 수수료 20%가 차감됨을 인지하였습니다.",
    ];
    final List<bool> checkedStates = List<bool>.filled(pledgeItems.length, false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool allChecked = checkedStates.every((item) => item == true);
            return AlertDialog(
              title: const Text("확약서", textAlign: TextAlign.center),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pledgeItems.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: checkedStates[index],
                      onChanged: (bool? value) {
                        setDialogState(() {
                          checkedStates[index] = value!;
                        });
                      },
                      title: Text(pledgeItems[index], style: const TextStyle(fontSize: 14)),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: allChecked
                      ? () {
                    setState(() {
                      _isPledgeAgreed = true;
                    });
                    Navigator.of(context).pop();
                  }
                      : null,
                  child: const Text("모두 동의합니다"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rrnController.dispose();
    _phoneController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _addressController.dispose();
    _addressDetailController.dispose();
    _vehicleNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "기사님 정보 등록",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFBB00),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _rrnController,
                decoration: const InputDecoration(labelText: '주민등록번호'),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 24),

              const Text("증명사진", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildPhotoPlaceholder(label: "증명사진을 등록해주세요", icon: Icons.account_box),
              const SizedBox(height: 24),

              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '전화번호'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // --- 입금은행 및 계좌번호 입력란 추가 ---
              DropdownButtonFormField<String>(
                value: _selectedBank,
                decoration: const InputDecoration(labelText: '입금은행'),
                hint: const Text('은행을 선택하세요'),
                items: _bankList.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBank = newValue;
                  });
                },
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _accountNumberController,
                decoration: const InputDecoration(labelText: '입금계좌번호'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              // -----------------------------------

              const Text("주소", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: '주소 검색 버튼을 눌러주세요',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () { /* TODO: 주소 검색 API 연동 */ },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('주소 검색'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressDetailController,
                decoration: const InputDecoration(labelText: '상세주소 (선택)'),
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _selectedVehicleSize,
                decoration: const InputDecoration(labelText: '차량 크기'),
                hint: const Text('차량의 톤 수를 선택하세요'),
                items: _vehicleSizes.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedVehicleSize = newValue;
                  });
                },
              ),
              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: const InputDecoration(labelText: '차종'),
                hint: const Text('차종을 선택하세요'),
                items: _vehicleTypes.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedVehicleType = newValue;
                  });
                },
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(labelText: '차량번호'),
              ),
              const SizedBox(height: 24),

              const Text("운전면허증", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildPhotoPlaceholder(label: "운전면허증 사진을 등록해주세요", icon: Icons.add_a_photo_outlined),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _showPledgeDialog,
                icon: Icon(_isPledgeAgreed ? Icons.check_circle : Icons.edit_document),
                label: Text(_isPledgeAgreed ? '확약서 작성 완료' : '확약서 작성'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPledgeAgreed ? Colors.grey[700] : const Color(0xFFFFBB00),
                  foregroundColor: _isPledgeAgreed ? Colors.white : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: '요청사항 (선택입력)',
                  hintText: '기사님께서 전달하고 싶은 내용을 적어주세요.',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 40),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _saveDriverInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFBB00),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('등록하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
