import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:untitled5/all/color.dart';
import 'package:untitled5/all/map.dart';

String? m;
List<Map> k = [];
List<Map<String, dynamic>>tap=[];

class MyApp extends StatelessWidget {
  final String idu;
  final String nameu;

  const MyApp({Key? key, required this.idu, required this.nameu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: TrafficViolationForm(idu: idu, nameu: nameu), // ← التمرير هنا
      ),
    );
  }
}

class TrafficViolationForm extends StatefulWidget {
  final String idu;
  final String nameu;

  const TrafficViolationForm({Key? key, required this.idu, required this.nameu}) : super(key: key);

  @override
  _TrafficViolationFormState createState() => _TrafficViolationFormState();
}

class _TrafficViolationFormState extends State<TrafficViolationForm> {
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController violationPlaceController =
      TextEditingController();
  final TextEditingController vehicleSpecsController = TextEditingController();

  String plateType = 'خصوصي';
  String source = 'أ';
  String governorate = 'عدن';
  String violationType = 'تجاوز السرعة';
/// 📸 فتح الكاميرا + OCR
Future<void> scanPlateNumber() async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);

  if (image == null) return;

  final inputImage = InputImage.fromFile(File(image.path));
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
  textRecognizer.close();

  String plateNumber = '';

  // استخراج جميع الأرقام من الصورة
  for (final block in recognizedText.blocks) {
    for (final line in block.lines) {
      final cleanText = line.text.replaceAll(RegExp(r'[^\d\u0660-\u0669]'), '');
      if (cleanText.isNotEmpty) {
        plateNumber += cleanText;
      }
    }
  }

  if (plateNumber.isNotEmpty) {
    setState(() {
      // البحث عن المحافظة في القائمة حسب بداية الرقم
      final match = governorates.firstWhere(
        (g) => plateNumber.startsWith(g['code']!), // استخدم startsWith بدلاً من الرقم الأول فقط
        orElse: () => {'name': 'غير معروف', 'code': '0'},
      );

      governorate = match['name']!;

      // حذف كود المحافظة من الرقم قبل وضعه في TextField
      plateNumberController.text =
          plateNumber.substring(match['code']!.length);
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Acolor.body,
      appBar: AppBar(title: Text('تسجيل مخالفة',style: TextStyle(color: Colors.amber,fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w600,),), backgroundColor: Acolor.AppBar),
      body: Padding(
        
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            /// رقم اللوحة + الكاميرا
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: plateNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'رقم اللوحة',labelStyle: TextStyle(fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,
  ),
                      
                      
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Acolor.AppBar),
                    onPressed: scanPlateNumber,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            /// الفاصل + نوع اللوحة
            Row(
              children: [
              
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: plateType,
                    decoration: InputDecoration(
                      labelText: 'نوع اللوحة',
                      labelStyle: TextStyle(fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'خصوصي', child: Text('خصوصي',style: TextStyle(fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,),)),
                      DropdownMenuItem(value: 'تجاري', child: Text('تجاري',style: TextStyle(fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,),)),
                    ],
                    onChanged: (value) => setState(() => plateType = value!),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            /// المحافظة + مكان المخالفة
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: governorate.isNotEmpty ? governorate : null,
                    decoration: InputDecoration(
                      labelText: 'المحافظة',
                      labelStyle: TextStyle(fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,),
                      border: OutlineInputBorder(),
                    ),
                    items: governorates.map((g) {
      return DropdownMenuItem(
        value: g['name'],
        child: Text(g['name']!,style: TextStyle(fontSize: 14,fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,),),
      );
    }).toList(),
    onChanged: (value) => setState(() => governorate = value!),
  ),
),
                  
                
                
              ],
            ),

            SizedBox(height: 16),

            /// مواصفات المركبة
            TextField(
              style: TextStyle(fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,),
              
              controller: vehicleSpecsController,
              decoration: InputDecoration(
                labelText: 'مواصفات المركبة',
                labelStyle: TextStyle(fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w500,),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 24),
GestureDetector(
  onTap: () => _showViolationMultiSelect(context),
  child: AbsorbPointer(
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'نوع المخالفة',
        labelStyle: TextStyle(
          fontFamily: 'MyCustomFont',
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(
        text: selectedViolations.join(' ، '),
      ),
    ),
  ),
),

            SizedBox(height: 24),

            /// الأزرار
            Row(
              children: [
                Expanded(
                  child:ElevatedButton(
                    onPressed: (){
  if (vehicleSpecsController.text.isEmpty || plateNumberController.text.isEmpty) {
  // إظهار رسالة خطأ إذا كانت الحقول فارغة
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('يرجى تعبئة جميع الحقول المطلوبة (رقم اللوحة والمواصفات)'),
      backgroundColor: Colors.red,
    ),
  );
  return;
}

setState(() {
  tap.add({
    'name': (data.length + 1).toString().padLeft(3, '0'),
    'desc': plateNumberController.text,
    'val1': selectedViolations.join(' ، '),
    'val2': widget.nameu,
    'val3': plateType,
    'date': DateTime.now().toString().split(' ')[0],
    'idu': widget.idu,
  });

  // تفريغ الحقول بعد الحفظ
  plateNumberController.clear();
  violationPlaceController.clear();
  vehicleSpecsController.clear();
  selectedViolations.clear();
});

// إظهار رسالة نجاح بعد الحفظ مباشرة
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('تم حفظ المخالفة محلياً بنجاح'),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
  ),
);},
  style: ElevatedButton.styleFrom(
    backgroundColor: Acolor.AppBar,
  ),
  child: Text('حفظ',style: TextStyle(color:Acolor.body,
  fontFamily: 'MyCustomFont',
  fontWeight: FontWeight.w700, // Black

  ),),
),

                ),
              
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _showViolationMultiSelect(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'اختر نوع المخالفة',
          style: TextStyle(
            fontFamily: 'MyCustomFont',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: violations.map((v) {
                  return CheckboxListTile(
                    value: selectedViolations.contains(v),
                    title: Text(
                      v,
                      style: TextStyle(
                        fontFamily: 'MyCustomFont',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onChanged: (val) {
                      setStateDialog(() {
                        if (val == true) {
                          selectedViolations.add(v);
                        } else {
                          selectedViolations.remove(v);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: Text(
              'تم',
              style: TextStyle(
                fontFamily: 'MyCustomFont',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

}
