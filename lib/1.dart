import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:untitled5/all/color.dart';
import 'package:untitled5/all/map.dart';

class ViolationsScreen extends StatefulWidget {
  final String idu;
  final String nameu;

  ViolationsScreen({super.key, required this.idu, required this.nameu});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  List<Map<String, dynamic>> flter = [];
  final TextEditingController fromDateCtrl = TextEditingController();
  final TextEditingController toDateCtrl = TextEditingController();
  final TextEditingController plateCtrl = TextEditingController();

  bool from = true;

  @override
  void initState() {
    super.initState();
    flter = data
        .where((item) => item.containsKey('idu') && item['idu'] == widget.idu)
        .toList();
  }

  @override
  void dispose() {
    fromDateCtrl.dispose();
    toDateCtrl.dispose();
    plateCtrl.dispose();
    super.dispose();
  }

  void clear() {
    plateCtrl.clear();
    toDateCtrl.clear();
    fromDateCtrl.clear();
    setState(() {
      flter = data.where((item) => item['idu'] == widget.idu).toList();
    });
  }

  DateTime parseDate(String date) {
    try {
      String normalizedDate = date.replaceAll('/', '-');
      return DateFormat('yyyy-M-d').parse(normalizedDate);
    } catch (e) {
      return DateTime.now();
    }
  }

  void search(String value) {
    String plateQuery = plateCtrl.text.trim().toLowerCase();
    DateTime? fromDate = fromDateCtrl.text.isNotEmpty
        ? parseDate(fromDateCtrl.text)
        : null;
    DateTime? toDate = toDateCtrl.text.isNotEmpty
        ? parseDate(toDateCtrl.text)
        : null;

    setState(() {
      flter = data.where((item) {
        String itemPlate = item['desc']?.toString().toLowerCase() ?? '';
        String itemDateStr = item['date']?.toString() ?? '';

        bool plateMatch = plateQuery.isEmpty || itemPlate.contains(plateQuery);

        DateTime itemDate = parseDate(itemDateStr);
        bool dateMatch = true;

        if (fromDate != null && itemDate.isBefore(fromDate)) dateMatch = false;
        if (toDate != null && itemDate.isAfter(toDate)) dateMatch = false;

        bool userMatch = item['idu'] == widget.idu;

        return plateMatch && dateMatch && userMatch;
      }).toList();
    });
  }

  Future<void> pickDate(TextEditingController controller) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Acolor.body,
          child: Column(
            children: [
              Container(
                color: Acolor.AppBar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(color: Acolor.body),
                      ),
                    ),
                    Text(
                      "اختر التاريخ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("تم", style: TextStyle(color: Acolor.body)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      controller.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(newDate);
                      search(""); 
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Acolor.body,
      appBar: AppBar(
        backgroundColor: Acolor.AppBar,
        title: Text(
          'المخالفات المسجلة',
          style: TextStyle(
            color: Colors.amber,
            fontFamily: 'MyCustomFont',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: dateField(fromDateCtrl, 'من')),
                SizedBox(width: 10),
                Expanded(child: dateField(toDateCtrl, 'إلى')),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: plateCtrl,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "بحث برقم اللوحة",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: flter.isEmpty
                  ? const Center(child: Text("لا توجد بيانات تطابق البحث"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical, 
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: DataTable(
                          columnSpacing: 20,
                          dataRowMaxHeight: double
                              .infinity, 
                          dataRowMinHeight: 60,
                          border: TableBorder.all(color: Colors.grey.shade400),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'اللوحة',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'المخالفات',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'النوع',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'التاريخ',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                          rows: flter.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(Text(item['id']?.toString() ?? '')),
                                DataCell(Text(item['desc']?.toString() ?? '')),
                                DataCell(
                                  Container(
                                    width:
                                        140,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      item['val1']?.toString() ?? '',
                                      style: const TextStyle(fontSize: 12),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                DataCell(Text(item['val3']?.toString() ?? '')),
                                DataCell(Text(item['date']?.toString() ?? '')),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Acolor.AppBar,
        onPressed: clear,
        icon: Icon(Icons.refresh, color: Acolor.body),
        label: Text('إعادة', style: TextStyle(color: Acolor.body)),
      ),
    );
  }

  Widget dateField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      readOnly: true,
      onTap: () => pickDate(ctrl),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        labelText: label,
        suffixIcon: Icon(Icons.calendar_month),
        border: OutlineInputBorder(),
      ),
    );
  }
}
