import 'package:flutter/material.dart';
import 'order_list_page.dart';

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
    '플러스 축차',
    '플러스 축차 윙바디',
  ];
  bool showTonTab = true; // 현재 선택된 탭 (톤 트럭 or 차종)
  bool isDropdownOpen = false; // 드롭다운 열림 여부
  String? selectedTon;
  String? selectedCarType;

  // 기타 상태들
  bool isGoodsSelected = false;
  String quantity = '';
  List<String> options = [];
  String boardingMethod = '';
  String unloadingMethod = '';

  // 입력 컨트롤러들
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
  final orangeBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(
      color: Color(0xFFFFBB00), // ★ 주황색으로 변경
      width: 2,
    ),
  );

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

  Widget _vehicleTab(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.amber.shade200 : Colors.white,
          border: Border.all(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void toggleOption(String option) {
    setState(() {
      options.contains(option) ? options.remove(option) : options.add(option);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
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
            // 차량 선택
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
                      border: orangeBorder,           // 기본 테두리
                      enabledBorder: orangeBorder,    // 비활성 테두리
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
                      border: orangeBorder,           // 기본 테두리
                      enabledBorder: orangeBorder,    // 비활성 테두리
                      focusedBorder: orangeBorder,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),


            // 아래는 생략 없이 기존 그대로 유지
            buildSectionTitle('물품정보'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => isGoodsSelected = !isGoodsSelected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isGoodsSelected ? Colors.amber : Colors.grey[200],
                    foregroundColor: isGoodsSelected ? Colors.black : Colors.grey[700],
                  ),
                  child: const Text('물품선택'),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 150,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '수량 입력 / 선택',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (val) => quantity = val,
                  ),
                ),
              ],
            ),

            buildSectionTitle('상차시간'),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('지금 상차')),
                ElevatedButton(onPressed: () {}, child: const Text('예약하기')),
              ],
            ),

            buildSectionTitle('하차시간'),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('가는대로 하차')),
                ElevatedButton(onPressed: () {}, child: const Text('예약하기')),
              ],
            ),

            buildSectionTitle('옵션'),
            Wrap(
              spacing: 8,
              children: [
                buildChoiceChip('편도', options.contains('편도'), () => toggleOption('편도')),
                buildChoiceChip('왕복', options.contains('왕복'), () => toggleOption('왕복')),
                buildChoiceChip('독차', options.contains('독차'), () => toggleOption('독차')),
                buildChoiceChip('혼적', options.contains('혼적'), () => toggleOption('혼적')),
                buildChoiceChip('1인 동승', options.contains('1인 동승'), () => toggleOption('1인 동승')),
                buildChoiceChip('긴급', options.contains('긴급'), () => toggleOption('긴급')),
              ],
            ),

            buildSectionTitle('승차방법'),
            Wrap(
              spacing: 8,
              children: [
                buildChoiceChip('고객님이 상차', boardingMethod == '고객님이 상차',
                        () => setState(() => boardingMethod = '고객님이 상차')),
                buildChoiceChip('고객님이 지게차', boardingMethod == '고객님이 지게차',
                        () => setState(() => boardingMethod = '고객님이 지게차')),
              ],
            ),

            buildSectionTitle('하차방법'),
            Wrap(
              spacing: 8,
              children: [
                buildChoiceChip('고객님이 하차', unloadingMethod == '고객님이 하차',
                        () => setState(() => unloadingMethod = '고객님이 하차')),
                buildChoiceChip('고객님이 지게차', unloadingMethod == '고객님이 지게차',
                        () => setState(() => unloadingMethod = '고객님이 지게차')),
              ],
            ),

            buildSectionTitle('출발지'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: departureAddressController,
                    decoration: const InputDecoration(
                      hintText: '주소 *',
                      border: OutlineInputBorder(),
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
              decoration: const InputDecoration(
                hintText: '상세주소 *',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: departureCompanyController,
                    decoration: const InputDecoration(
                      hintText: '상호 (선택입력)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: departureNameController,
                    decoration: const InputDecoration(
                      hintText: '이름 *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: departureContactController,
              decoration: const InputDecoration(
                hintText: '연락처 *',
                border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                      hintText: '주소 *',
                      border: OutlineInputBorder(),
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
              decoration: const InputDecoration(
                hintText: '상세주소 *',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: arrivalCompanyController,
                    decoration: const InputDecoration(
                      hintText: '상호 (선택입력)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: arrivalNameController,
                    decoration: const InputDecoration(
                      hintText: '이름 *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: arrivalContactController,
              decoration: const InputDecoration(
                hintText: '연락처 *',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),

            const SizedBox(height: 24),
            buildSectionTitle('내용물과 전달사항'),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '상세히 입력해주세요. 예) 서류, 드라이아이스',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 32),

            // 바로 주문 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderListPage()),
                  );
                },
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
