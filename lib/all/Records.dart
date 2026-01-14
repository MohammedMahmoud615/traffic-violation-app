import 'package:flutter/material.dart';
import 'package:untitled5/all/color.dart';
import 'package:untitled5/all/map.dart';
import 'package:untitled5/all/recocded_viodations.dart';

class Records extends StatefulWidget {
  final String idu;
  final String nameu;
  const Records({super.key, required this.idu, required this.nameu});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  List<Map<String, dynamic>> filteredList = [];
  final TextEditingController fromDateCtrl = TextEditingController();
  final TextEditingController toDateCtrl = TextEditingController();
  final TextEditingController plateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredList = List.from(tap);
  }

  void clearFilters() {
    if (tap.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد سجلات جديدة لرفعها'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      data.addAll(tap);

      tap.clear();

      filteredList.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم رفع البيانات بنجاح إلى القاعدة',
          style: TextStyle(fontFamily: 'MyCustomFont'),
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  DateTime parseDate(String date) {
    final p = date.split('/');
    return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
  }

  void performSearch(String value) {
    String query = plateCtrl.text.trim().toLowerCase();
    DateTime? fromDate = fromDateCtrl.text.isNotEmpty
        ? parseDate(fromDateCtrl.text)
        : null;
    DateTime? toDate = toDateCtrl.text.isNotEmpty
        ? parseDate(toDateCtrl.text)
        : null;

    setState(() {
      filteredList = tap.where((item) {
        bool plateMatch =
            query.isEmpty ||
            item['plate'].toString().toLowerCase().contains(query);
        DateTime itemDate = parseDate(item['date']);
        bool dateMatch = true;

        if (fromDate != null && itemDate.isBefore(fromDate)) dateMatch = false;
        if (toDate != null && itemDate.isAfter(toDate)) dateMatch = false;

        return plateMatch && dateMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Acolor.body,
      appBar: AppBar(
        title: const Text(
          'سجل المخالفات المسجلة',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        centerTitle: true,
        backgroundColor: Acolor.AppBar,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      "لم تقم بتسجيل اي مخالفة اليوم",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(118, 0, 0, 0),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) =>
                        _buildViolationCard(filteredList[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Acolor.AppBar,
        onPressed: clearFilters,
        icon: Icon(Icons.refresh, color: Acolor.body),
        label: Text(
          'رفع إلي القاعدة',
          style: TextStyle(color: Acolor.body, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildViolationCard(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "رقم: ${widget.idu}",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(item['date'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const Divider(),
            _infoRow(Icons.directions_car, "رقم اللوحة:", item['desc']),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Text(value),
        ],
      ),
    );
  }
}
