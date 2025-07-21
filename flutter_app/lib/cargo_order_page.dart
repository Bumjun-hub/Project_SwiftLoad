import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // 날짜/시간
import 'package:flutter_app/payment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CargoOrderPage extends StatefulWidget {
  const CargoOrderPage({super.key});
  @override
  State<CargoOrderPage> createState() => _CargoOrderPageState();
}

class _CargoOrderPageState extends State<CargoOrderPage> {
  // 차량 선택 관련 상태
  final List<String> tonList = [
    '1톤 트럭',
    '1.2톤 트럭',
    '1.5톤 트럭',
    '2.5톤 트럭',
    '3.5톤 트럭',
    '5톤 트럭',
    '11톤 트럭',
  ];
  final List<String> carTypeList = [
    '카고',
    '윙바디',
    '냉장탑',
    '냉동탑',
    '리프트',
    '리프트윙',
    '플러스 카고',
    '플러스 윙바디',
  ];
  bool showTonTab = true; // 현재 선택된 탭 (톤 트럭 or 차종)
  bool isDropdownOpen = false; // 드롭다운 열림 여부
  String? selectedTon;
  String? selectedCarType;

  // 물품 선택 관련 상태 추가
  String? _selectedItemType;
  final List<String> _itemTypes = ['팔레트', '박스', '가구집기', '기타'];
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _otherItemNameController = TextEditingController();

  // 시간 선택 관련 상태 추가
  String? _pickupTimeOption; // '지금 상차' 또는 '예약'
  DateTime? _pickupDateTime; // 예약 시 선택된 날짜와 시간
  String? _dropoffTimeOption; // '가는대로 하차' 또는 '예약'
  DateTime? _dropoffDateTime; // 예약 시 선택된 날짜와 시간

  // 옵션, 승차방법, 하차방법 단일 선택 상태 추가
  String? _selectedOption; // 옵션 단일 선택
  String? _selectedBoardingMethod; // 승차방법 단일 선택
  String? _selectedUnloadingMethod; // 하차방법 단일 선택

  // 승차방법, 하차방법 선택지 목록
  final List<String> _boardingMethods = [
    '고객님이 상차', '지게차이용', '기사님이 혼자', '고객님과 같이'
  ];
  final List<String> _unloadingMethods = [
    '고객님이 하차', '지게차이용', '기사님이 혼자', '고객님과 같이',
  ];

  final TextEditingController departureAddressController = TextEditingController();
  final TextEditingController departureDetailController = TextEditingController();
  final TextEditingController departureCompanyController = TextEditingController();
  final TextEditingController departureNameController = TextEditingController();
  final TextEditingController departureContactController = TextEditingController();
  final TextEditingController arrivalAddressController = TextEditingController();
  final TextEditingController arrivalDetailController = TextEditingController();
  final TextEditingController arrivalCompanyController = TextEditingController();
  final TextEditingController arrivalNameController = TextEditingController();
  final TextEditingController arrivalContactController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool _isLoading = false; // 로딩 상태 추가

  final orangeBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(
      color: Color(0xFFFFBB00),
      width: 2,
    ),
  );

  // 날짜 시간 선택
  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) return null;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  // 운임 계산 함수
  double _calculatePrice() {
    double basePrice = 0.0;

    // 1. 차량 톤 별 기본 가격
    final Map<String, double> tonBasePrices = {
      '1톤 트럭': 50000.0,
      '1.2톤 트럭': 50000.0,
      '1.5톤 트럭': 70000.0,
      '2.5톤 트럭': 80000.0,
      '3.5톤 트럭': 100000.0,
      '5톤 트럭': 110000.0,
      '11톤 트럭': 200000.0,
    };
    basePrice = tonBasePrices[selectedTon] ?? 0.0; // 선택된 톤에 해당하는 기본 가격 적용

    // 2. 왕복 선택 시 X2
    const double roundTripMultiplier = 2.0;
    if (_selectedOption == '왕복') {
      basePrice *= roundTripMultiplier;
    }

    // 3. 물건 갯수가 20개 이상이면 3만원 추가
    const double quantityAddOn = 30000.0;
    if (_selectedItemType != '기타') {
      int quantity = int.tryParse(_itemQuantityController.text) ?? 0;
      if (quantity >= 20) {
        basePrice += quantityAddOn;
      }
    }

    // 4. 지게차 이용 선택 시 5만원 추가
    // 승차방법 또는 하차방법에 '지게차이용'이 포함된 경우
    const double forkliftAddOn = 50000.0;
    if (_selectedBoardingMethod == '지게차이용' || _selectedUnloadingMethod == '지게차이용') {
      basePrice += forkliftAddOn;
    }

    return basePrice;
  }

  // Firestore에 화물 신청 정보 저장
  Future<void> _saveOrderInfo() async {
    // 필수 필드 유효성 검사 (필요에 따라 추가/수정)
    if (selectedTon == null ||
        selectedCarType == null ||
        _selectedItemType == null ||
        (_selectedItemType != '기타' && _itemQuantityController.text.isEmpty) ||
        (_selectedItemType == '기타' && _otherItemNameController.text.isEmpty) ||
        _pickupTimeOption == null || // 상차시간 선택 여부
        _dropoffTimeOption == null || // 하차시간 선택 여부
        _selectedOption == null || // 옵션 선택 여부 추가
        _selectedBoardingMethod == null || // 승차방법 선택 여부 추가
        _selectedUnloadingMethod == null || // 하차방법 선택 여부 추가
        departureAddressController.text.isEmpty ||
        departureNameController.text.isEmpty ||
        departureContactController.text.isEmpty ||
        arrivalAddressController.text.isEmpty ||
        arrivalNameController.text.isEmpty ||
        arrivalContactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 항목을 모두 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String itemDetails = '';
    if (_selectedItemType == '기타') {
      itemDetails = '기타: ${_otherItemNameController.text}';
    } else {
      itemDetails = '$_selectedItemType: ${_itemQuantityController.text}개';
    }

    final double calculatedPrice = _calculatePrice(); // 운임 계산

    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection('estimates').add({
        'selectedTon': selectedTon,
        'selectedCarType': selectedCarType,
        'itemType': _selectedItemType,
        'itemDetails': itemDetails, // 물품 상세 정보
        'pickupTimeOption': _pickupTimeOption, // 상차시간 옵션
        'pickupDateTime': _pickupDateTime, // 상차 예약 시간 (null 가능)
        'dropoffTimeOption': _dropoffTimeOption, // 하차시간 옵션
        'dropoffDateTime': _dropoffDateTime, // 하차 예약 시간 (null 가능)
        'selectedOption': _selectedOption, // 옵션 단일 선택 저장
        'selectedBoardingMethod': _selectedBoardingMethod, // 승차방법 단일 선택 저장
        'selectedUnloadingMethod': _selectedUnloadingMethod, // 하차방법 단일 선택 저장
        'departureAddress': departureAddressController.text,
        'departureDetail': departureDetailController.text,
        'departureCompany': departureCompanyController.text,
        'departureName': departureNameController.text,
        'departureContact': departureContactController.text,
        'arrivalAddress': arrivalAddressController.text,
        'arrivalDetail': arrivalDetailController.text,
        'arrivalCompany': arrivalCompanyController.text,
        'arrivalName': arrivalNameController.text,
        'arrivalContact': arrivalContactController.text,
        'content': contentController.text,
        'calculatedPrice': calculatedPrice, // 계산된 운임 저장
        'createdAt': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser?.uid, // 현재 사용자 UID 저장
        'status': '견적대기',
      });

      Map<String, dynamic> orderInfoForPayment = {
        'orderId': docRef.id, // Firestore 문서 ID를 orderId로 사용
        'price': calculatedPrice.toInt(),
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'hospitalName': departureAddressController.text,
        'weight': itemDetails, //물품 상세 정보를 무게로 전달
        'status': '견적대기', // 초기 상태
      };

      // 저장 성공 후 결제 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentPage(orderData: orderInfoForPayment)),
      );

      // 성공 후 필드 초기화
      departureAddressController.clear();
      departureDetailController.clear();
      departureCompanyController.clear();
      departureNameController.clear();
      departureContactController.clear();
      arrivalAddressController.clear();
      arrivalDetailController.clear();
      arrivalCompanyController.clear();
      arrivalNameController.clear();
      arrivalContactController.clear();
      contentController.clear();
      _itemQuantityController.clear();
      _otherItemNameController.clear();

      setState(() {
        selectedTon = null;
        selectedCarType = null;
        _selectedItemType = null;
        _pickupTimeOption = null;
        _pickupDateTime = null;
        _dropoffTimeOption = null;
        _dropoffDateTime = null;
        _selectedOption = null;
        _selectedBoardingMethod = null;
        _selectedUnloadingMethod = null;
      });

    } catch (e) {
      print("Firestore 저장 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("화물 신청에 실패했습니다. 오류: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    departureAddressController.dispose();
    departureDetailController.dispose();
    departureCompanyController.dispose();
    departureNameController.dispose();
    departureContactController.dispose();
    arrivalAddressController.dispose();
    arrivalDetailController.dispose();
    arrivalCompanyController.dispose();
    arrivalNameController.dispose();
    arrivalContactController.dispose();
    contentController.dispose();
    _itemQuantityController.dispose();
    _otherItemNameController.dispose();
    super.dispose();
  }

  Widget buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget buildChoiceChip(String label, bool selected, VoidCallback onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: Colors.amber.shade200,
      labelStyle: TextStyle(color: selected ? Colors.black : Colors.grey[800]),
    );
  }

  // 시간 선택 버튼을 위한 위젯 (재사용성을 위해 분리)
  Widget _buildTimeOptionButton({
    required String label,
    required String optionValue,
    required String? selectedOption,
    required VoidCallback onPressed,
    String? displayDateTime,
  }) {
    final bool isSelected = selectedOption == optionValue;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: isSelected ? Colors.amber : Colors.grey.shade400, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(displayDateTime ?? label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('화물 신청'),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 차량선택 섹션
            buildSectionTitle('차량선택'),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTon,
                    items: tonList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedTon = val),
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: '톤 트럭',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCarType,
                    items: carTypeList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCarType = val),
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: '차종',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 물품 정보
            buildSectionTitle('물품정보'),
            DropdownButtonFormField<String>(
              value: _selectedItemType,
              decoration: InputDecoration(
                labelText: '물품 종류',
                hintText: '물품 종류를 선택하세요',
                border: orangeBorder,
                enabledBorder: orangeBorder,
                focusedBorder: orangeBorder,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _itemTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedItemType = newValue;
                  _itemQuantityController.clear();
                  _otherItemNameController.clear();
                });
              },
            ),
            const SizedBox(height: 12),

            if (_selectedItemType != null)
              _selectedItemType == '기타'
                  ? TextField(
                controller: _otherItemNameController,
                decoration: InputDecoration(
                  hintText: '물품명 입력',
                  border: orangeBorder,
                  enabledBorder: orangeBorder,
                  focusedBorder: orangeBorder,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              )
                  : TextField(
                controller: _itemQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '수량 입력',
                  border: orangeBorder,
                  enabledBorder: orangeBorder,
                  focusedBorder: orangeBorder,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            const SizedBox(height: 20),

            // 상차시간 섹션
            buildSectionTitle('상차시간'),
            Wrap(
              spacing: 8,
              children: [
                _buildTimeOptionButton(
                  label: '지금 상차',
                  optionValue: '지금 상차',
                  selectedOption: _pickupTimeOption,
                  onPressed: () {
                    setState(() {
                      _pickupTimeOption = '지금 상차';
                      _pickupDateTime = null;
                    });
                  },
                ),
                _buildTimeOptionButton(
                  label: _pickupDateTime != null
                      ? DateFormat('MM/dd HH:mm').format(_pickupDateTime!) // 날짜/시간 포맷
                      : '예약하기',
                  optionValue: '예약',
                  selectedOption: _pickupTimeOption,
                  onPressed: () async {
                    final DateTime? selected = await _selectDateTime(context);
                    if (selected != null) {
                      setState(() {
                        _pickupDateTime = selected;
                        _pickupTimeOption = '예약';
                      });
                    }
                  },
                  displayDateTime: _pickupDateTime != null
                      ? DateFormat('MM/dd HH:mm').format(_pickupDateTime!) : null,
                ),
              ],
            ),

            // 하차시간
            buildSectionTitle('하차시간'),
            Wrap(
              spacing: 8,
              children: [
                _buildTimeOptionButton(
                  label: '가는대로 하차',
                  optionValue: '가는대로 하차',
                  selectedOption: _dropoffTimeOption,
                  onPressed: () {
                    setState(() {
                      _dropoffTimeOption = '가는대로 하차';
                      _dropoffDateTime = null;
                    });
                  },
                ),
                _buildTimeOptionButton(
                  label: _dropoffDateTime != null
                      ? DateFormat('MM/dd HH:mm').format(_dropoffDateTime!) // 날짜/시간 포맷
                      : '예약하기',
                  optionValue: '예약',
                  selectedOption: _dropoffTimeOption,
                  onPressed: () async {
                    final DateTime? selected = await _selectDateTime(context);
                    if (selected != null) {
                      setState(() {
                        _dropoffDateTime = selected;
                        _dropoffTimeOption = '예약';
                      });
                    }
                  },
                  displayDateTime: _dropoffDateTime != null
                      ? DateFormat('MM/dd HH:mm').format(_dropoffDateTime!) : null,
                ),
              ],
            ),

            // 옵션 수정
            buildSectionTitle('옵션'),
            Wrap(
              spacing: 8,
              children: [
                ...['편도', '왕복', '독차', '혼적', '1인 동승', '긴급'].map((label) {
                  return buildChoiceChip(
                    label,
                    _selectedOption == label,
                        () => setState(() {
                      _selectedOption = label;
                    }),
                  );
                }).toList(),
              ],
            ),

            // 승차방법 수정
            buildSectionTitle('승차방법'),
            Wrap(
              spacing: 8,
              children: [
                ..._boardingMethods.map((label) {
                  return buildChoiceChip(
                    label,
                    _selectedBoardingMethod == label,
                        () => setState(() {
                      _selectedBoardingMethod = label;
                    }),
                  );
                }).toList(),
              ],
            ),

            // 하차방법 수정
            buildSectionTitle('하차방법'),
            Wrap(
              spacing: 8,
              children: [
                ..._unloadingMethods.map((label) {
                  return buildChoiceChip(
                    label,
                    _selectedUnloadingMethod == label,
                        () => setState(() {
                      _selectedUnloadingMethod = label;
                    }),
                  );
                }).toList(),
              ],
            ),

            buildSectionTitle('출발지'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: departureAddressController,
                    decoration: InputDecoration(
                      hintText: '주소 *',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Icon(Icons.search)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text('주소록')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: departureDetailController,
              decoration: InputDecoration(
                hintText: '상세주소 *',
                border: orangeBorder,
                enabledBorder: orangeBorder,
                focusedBorder: orangeBorder,
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: departureCompanyController,
                    decoration: InputDecoration(
                      hintText: '상호 (선택입력)',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: departureNameController,
                    decoration: InputDecoration(
                      hintText: '이름 *',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: departureContactController,
              decoration: InputDecoration(
                hintText: '연락처 *',
                border: orangeBorder,
                enabledBorder: orangeBorder,
                focusedBorder: orangeBorder,
                isDense: true,
              ),
            ),

            const SizedBox(height: 24),
            buildSectionTitle('도착지'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: arrivalAddressController,
                    decoration: InputDecoration(
                      hintText: '주소 *',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Icon(Icons.search)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text('주소록')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: arrivalDetailController,
              decoration: InputDecoration(
                hintText: '상세주소 *',
                border: orangeBorder,
                enabledBorder: orangeBorder,
                focusedBorder: orangeBorder,
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: arrivalCompanyController,
                    decoration: InputDecoration(
                      hintText: '상호 (선택입력)',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: arrivalNameController,
                    decoration: InputDecoration(
                      hintText: '이름 *',
                      border: orangeBorder,
                      enabledBorder: orangeBorder,
                      focusedBorder: orangeBorder,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: arrivalContactController,
              decoration: InputDecoration(
                hintText: '연락처 *',
                border: orangeBorder,
                enabledBorder: orangeBorder,
                focusedBorder: orangeBorder,
                isDense: true,
              ),
            ),

            const SizedBox(height: 24),
            buildSectionTitle('내용물과 전달사항'),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '상세히 입력해주세요. 예) 서류, 드라이아이스',
                border: orangeBorder,
                enabledBorder: orangeBorder,
                focusedBorder: orangeBorder,
                isDense: true,
              ),
            ),
            const SizedBox(height: 32),

            // 바로 주문 버튼
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _saveOrderInfo, // Call the new save function
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('바로 주문'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}