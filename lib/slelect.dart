import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextEditingController tex_1 = TextEditingController();
TextEditingController tex_2 = TextEditingController();

List<Map> q = [
  {"name": "محمد", "id": 1, "ids": 2565, "sal1": 5015, "sal2": 0, "sal3":5015,'n':'حكومي'},
  {"name": "محمد", "id": 1, "ids": 2525,"sal1": 5015, "sal2": 0, "sal3":5015},
  {"name": "محمد", "id": 4, "ids": 2545,"sal1": 5015, "sal2": 0, "sal3":5015},
  {"name": "محمد", "id": 5, "ids": 2555,"sal1": 5015, "sal2": 0, "sal3":5015},
];
List<Map> flter = []; 
bool hasSearched = false; 

class slelect extends StatefulWidget {
    slelect({super.key});

  @override
  State<slelect> createState() => _slelectState();
}

class _slelectState extends State<slelect> {
  String? nnnn;

  void sear() {
    final idInput = tex_2.text.trim();
    final idsInput = tex_1.text.trim();

    if (idInput.isEmpty || idsInput.isEmpty) {
      setState(() {
        flter = [];
        hasSearched = false;
      });
      return;
    }

    setState(() {
      flter = q.where((element) {
        bool matchId = element['id'].toString() == idInput;
        bool matchIds = element['ids'].toString() == idsInput;
        bool matchN = nnnn == null ? true : element['n'] == nnnn;
        return matchId && matchIds && matchN;
      }).toList();

      hasSearched = true;
    });
  }
  @override
  void initState() {
    super.initState();
    sear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:   Text('البحث', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin:   EdgeInsets.all(10),
              padding:   EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                isExpanded: true, // بدل Expanded ❗
                borderRadius: BorderRadius.circular(10),
                hint:   Text("اختر"),
                value: nnnn,
                underline:   SizedBox(), // لإزالة الخط السفلي
                items:   [
                  DropdownMenuItem(value: 'اجرة', child: Text("اجرة")),
                  DropdownMenuItem(value: 'حكومي', child: Text("حكومي")),
                  DropdownMenuItem(value: 'خصوصي', child: Text("خصوصي")),
                ],
                onChanged: (String? value) {
                  setState(() {
                    nnnn = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              height: 120,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 30,
                          child: Padding(
                            padding:   EdgeInsets.only(top: 4),
                            child: Text(
                              "اليمن",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 2),
                              left: BorderSide(width: 2),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 30,
                          child: Padding(
                            padding:   EdgeInsets.only(top: 4),
                            child: Text(
                              nnnn == null ? "حدد الفاصل" : nnnn.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 86,
                          child: Padding(
                            padding:   EdgeInsets.only(top: 4),
                            child: Center(
                              child: TextField(
                                controller: tex_1,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],

                                decoration:   InputDecoration(
                                  counterText: "", // لإخفاء العداد إذا أحببت
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),

                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(width: 2)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextField(
                            controller: tex_2,

                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 1,
                            decoration:   InputDecoration(
                              counterText: "", // لإخفاء العداد إذا أحببت
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                color: nnnn == 'اجرة'
                    ? Colors.amber
                    : nnnn == 'خصوصي'
                    ? Colors.blue
                    : nnnn == 'حكومي'
                    ?   Color.fromARGB(255, 255, 17, 0)
                    : Colors.transparent,
              ),
            ),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding:   EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      sear();
                    });
                  },
                  label: Text("بحث"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding:   EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: Card
              (
                child: !hasSearched
                    ? null
                    : (flter.isEmpty
                          ? Center(child: Text("لا توجد نتائج"))
                          : Center(
                            child: Padding(
                              padding:   EdgeInsets.only(right:  100,top: 50),
                              child: ListView.builder(
                                  itemCount: flter.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient:   LinearGradient(
                                                  begin: Alignment
                                                      .topCenter, // البداية من الأعلى
                                                  end: Alignment
                                                      .bottomCenter, // النهاية في الأسفل
                                                  colors: [
                                                    Color.fromARGB(255, 32, 64, 90),
                                                    Color.fromARGB(
                                                      255,
                                                      13,
                                                      115,
                                                      199,
                                                    ), // اللون الفاتح أسفل
                                                  ],
                                                ),
                                    
                                                border: Border.all(
                                                  color:   Color.fromARGB(
                                                    255,
                                                    122,
                                                    103,
                                                    31,
                                                  ),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(
                                                  7,
                                                ),
                                              ),
                                    
                                              child: Padding(
                                                padding:   EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  'المبلغ المخالفات',
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient:   LinearGradient(
                                                  begin: Alignment
                                                      .topCenter, // البداية من الأعلى
                                                  end: Alignment
                                                      .bottomCenter, // النهاية في الأسفل
                                                  colors: [
                                                    Color.fromARGB(
                                                      255,
                                                      160,
                                                      110,
                                                      110,
                                                    ), // اللون الغامق أعلى
                                                    Color.fromARGB(
                                                      255,
                                                      255,
                                                      255,
                                                      255,
                                                    ), // اللون الفاتح أسفل
                                                  ],
                                                ),
                                    
                                                border: Border.all(
                                                  color:   Color.fromARGB(
                                                    255,
                                                    122,
                                                    103,
                                                    31,
                                                  ),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(
                                                  7,
                                                ),
                                              ),
                                              child: Padding(
  padding:   EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),                                                child: Text(
                                                  flter[index]['sal1'].toString(),style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient:   LinearGradient(
                                                  begin: Alignment
                                                      .topCenter, // البداية من الأعلى
                                                  end: Alignment
                                                      .bottomCenter, // النهاية في الأسفل
                                                  colors: [
                                                    Color.fromARGB(255, 32, 64, 90),
                                                    Color.fromARGB(
                                                      255,
                                                      13,
                                                      115,
                                                      199,
                                                    ), // اللون الفاتح أسفل
                                                  ],
                                                ),
                                    
                                                border: Border.all(
                                                  color:   Color.fromARGB(
                                                    255,
                                                    122,
                                                    103,
                                                    31,
                                                  ),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(
                                                  7,
                                                ),
                                              ),
                                    
                                              child: Padding(
                                                padding:   EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  'المبلغ التخفيض',
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient:   LinearGradient(
                                                  begin: Alignment
                                                      .topCenter, // البداية من الأعلى
                                                  end: Alignment
                                                      .bottomCenter, // النهاية في الأسفل
                                                  colors: [
                                                    Color.fromARGB(
                                                      255,
                                                      160,
                                                      110,
                                                      110,
                                                    ), // اللون الغامق أعلى
                                                    Color.fromARGB(
                                                      255,
                                                      255,
                                                      255,
                                                      255,
                                                    ), // اللون الفاتح أسفل
                                                  ],
                                                ),
                                    
                                                border: Border.all(
                                                  color:   Color.fromARGB(
                                                    255,
                                                    122,
                                                    103,
                                                    31,
                                                  ),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(
                                                  7,
                                                ),
                                              ),
                                              child: Padding(

                                                  padding:   EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  flter[index]['sal2'].toString(),style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient:   LinearGradient(
                                                  begin: Alignment
                                                      .topCenter, // البداية من الأعلى
                                                  end: Alignment
                                                      .bottomCenter, // النهاية في الأسفل
                                                  colors: [
                                                    Color.fromARGB(255, 32, 64, 90),
                                                    Color.fromARGB(
                                                      255,
                                                      13,
                                                      115,
                                                      199,
                                                    ), // اللون الفاتح أسفل
                                                  ],
                                                ),
                                    
                                                border: Border.all(
                                                  color:   Color.fromARGB(
                                                    255,
                                                    122,
                                                    103,
                                                    31,
                                                  ),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(
                                                  7,
                                                ),
                                              ),
                                    
                                              child: Padding(
                                                padding:   EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  'المبلغ المستحق',
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient:   LinearGradient(
                                                  begin: Alignment
                                                      .topCenter, // البداية من الأعلى
                                                  end: Alignment
                                                      .bottomCenter, // النهاية في الأسفل
                                                  colors: [
                                                    Color.fromARGB(
                                                      255,
                                                      160,
                                                      110,
                                                      110,
                                                    ), // اللون الغامق أعلى
                                                    Color.fromARGB(
                                                      255,
                                                      255,
                                                      255,
                                                      255,
                                                    ), // اللون الفاتح أسفل
                                                  ],
                                                ),
                                    
                                                border: Border.all(
                                                  color:   Color.fromARGB(
                                                    255,
                                                    122,
                                                    103,
                                                    31,
                                                  ),
                                                  width: 2,
                                                ),
                                                borderRadius: BorderRadius.circular(
                                                  7,
                                                ),
                                              ),
                                              child: Padding(
                                                  padding:   EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  flter[index]['sal3'].toString(),style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                            ),
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
