import 'package:flutter/material.dart';
import 'order_list_page.dart';

class CargoOrderPage extends StatefulWidget {
  const CargoOrderPage({super.key});

  @override
  State<CargoOrderPage> createState() => _CargoOrderPageState();
}

class _CargoOrderPageState extends State<CargoOrderPage> {
  // 차량선택
  String selectedCarType = '';
  // 물품정보
  bool isGoodsSelected = false;
  String quantity = '';
  // 상차시간
  String loadingTime = '';
  // 하차시간
  String unloadingTime = '';
  // 옵션
  List<String> options = [];
  // 승차방법
  String boardingMethod = '';

  // 하차방법
  String unloadingMethod = '';
  // 출발지 입력 필드
  final TextEditingController departureAddressController = TextEditingController();
  final TextEditingController departureDetailController = TextEditingController();
  final TextEditingController departureCompanyController = TextEditingController();
  final TextEditingController departureNameController = TextEditingController();
  final TextEditingController departureContactController = TextEditingController();

  // 도착지 입력 필드
  final TextEditingController arrivalAddressController = TextEditingController();
  final TextEditingController arrivalDetailController = TextEditingController();
  final TextEditingController arrivalCompanyController = TextEditingController();
  final TextEditingController arrivalNameController = TextEditingController();
  final TextEditingController arrivalContactController = TextEditingController();

  // 내용물/전달사항
  final TextEditingController contentController = TextEditingController();

  void toggleOption(String option) {
    setState(() {
      if (options.contains(option)) {
        options.remove(option);
      } else {
        options.add(option);
      }
    });
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
    super.dispose();
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

  Widget buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('화물 신청'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 차량 선택
            buildSectionTitle('차량선택'),
            Wrap(
              spacing: 8,
              children: [
                buildChoiceChip('톤 트럭', selectedCarType == '톤 트럭', () {
                  setState(() {
                    selectedCarType = '톤 트럭';
                  });
                }),
                buildChoiceChip('차종', selectedCarType == '차종', () {
                  setState(() {
                    selectedCarType = '차종';
                  });
                }),
              ],
            ),

            // 물품정보
            buildSectionTitle('물품정보'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isGoodsSelected = !isGoodsSelected;
                    });
                  },
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

            // 상차시간
            buildSectionTitle('상차시간'),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('지금 상차')),
                ElevatedButton(onPressed: () {}, child: const Text('예약하기')),
              ],
            ),

            // 하차시간
            buildSectionTitle('하차시간'),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('가는대로 하차')),
                ElevatedButton(onPressed: () {}, child: const Text('예약하기')),
              ],
            ),

            // 옵션
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

            // 승차방법
            buildSectionTitle('승차방법'),
            Wrap(
              spacing: 8,
              children: [
                buildChoiceChip('고객님이 상차', boardingMethod == '고객님이 상차', () {
                  setState(() {
                    boardingMethod = '고객님이 상차';
                  });
                }),
                buildChoiceChip('고객님이 지게차', boardingMethod == '고객님이 지게차', () {
                  setState(() {
                    boardingMethod = '고객님이 지게차';
                  });
                }),
              ],
            ),

            // 하차방법
            buildSectionTitle('하차방법'),
            Wrap(
              spacing: 8,
              children: [
                buildChoiceChip('고객님이 하차', unloadingMethod == '고객님이 하차', () {
                  setState(() {
                    unloadingMethod = '고객님이 하차';
                  });
                }),
                buildChoiceChip('고객님이 지게차', unloadingMethod == '고객님이 지게차', () {
                  setState(() {
                    unloadingMethod = '고객님이 지게차';
                  });
                }),
              ],
            ),

            // 출발지
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
                ElevatedButton(onPressed: () {/* 주소 검색 로직 */}, child: const Icon(Icons.search)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {/* 주소록 로직 */}, child: const Text('주소록')),
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

            // 도착지
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
                ElevatedButton(onPressed: () {/* 주소 검색 로직 */}, child: const Icon(Icons.search)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {/* 주소록 로직 */}, child: const Text('주소록')),
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

            // 내용물과 전달사항
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
                    MaterialPageRoute(builder: (context) => const OrderListPage()),
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
