import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:field_suggestion/field_suggestion.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ScanHcTypeOrder extends StatefulWidget {
  const ScanHcTypeOrder({super.key});

  @override
  State<ScanHcTypeOrder> createState() => _ScanHcTypeOrderState();
}

class _ScanHcTypeOrderState extends State<ScanHcTypeOrder> {
  final _formKey = GlobalKey<FormState>();
  String? _caseType;

  final TextEditingController _caseNoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _caseYearController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();
  final TextEditingController _signTypeController = TextEditingController();
  final TextEditingController _cmShortkeyController = TextEditingController();
  final boxControllerOrder = BoxController();
  Future<List<String>> future(String input) => Future<List<String>>.delayed(
        const Duration(seconds: 1),
        () => _orders
            .where((s) => s.toLowerCase().contains(input.toLowerCase()))
            .toList(),
      );
  List<String> caseTypes = [
    'A.S',
    'C.A',
    'C.C',
    'C.P',
    'C.C.C.A',
    'C.R.L.A',
    'C.R.L.P',
    'C.R.L.R.C',
    'C.R.P',
    'C.M.A',
    'W.P',
    'W.A'
  ]; // Sample case types

  DateTime _selectedDate = DateTime.now();

  todayDate(DateTime date) {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  List<String> _orders = ["Load"];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _orders = prefs.getStringList('orders') ?? [];
    });
  }

  void _saveOrder(String order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _orders.add(order);
    prefs.setStringList('orders', _orders);
  }

  Future<void> _validateForm(bool save) async {
    if (_formKey.currentState!.validate()) {
      _saveOrder(_orderController.text);
      var mydate;
      if (_dateController.text.isEmpty) {
        mydate = _selectedDate;
      } else {
        mydate = _dateController.text;
      }
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text("HIGH COURT FOR THE STATE OF TELANGANA",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 15)),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text("MAIN CASE NO: ",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14)),
                          pw.SizedBox(width: 5),
                          pw.Text(
                              '$_caseType NO. ${_caseNoController.text} of ${_caseYearController.text}',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14)),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text("PROCEEDING SHEET",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    ]),

                pw.SizedBox(height: 25),
                // Table

                pw.Container(
                  constraints:
                      const pw.BoxConstraints(maxHeight: double.infinity),
                  child: pw.Table(
                    border: const pw.TableBorder(
                        left: pw.BorderSide(color: PdfColors.black),
                        right: pw.BorderSide(color: PdfColors.black),
                        top: pw.BorderSide(color: PdfColors.black),
                        bottom: pw.BorderSide(color: PdfColors.black),
                        verticalInside: pw.BorderSide(color: PdfColors.black),
                        horizontalInside:
                            pw.BorderSide(color: PdfColors.white)),
                    children: [
                      // Header row
                      pw.TableRow(
                        children: [
                          _buildHeaderCell('S.NO'),
                          _buildHeaderCell('DATE'),
                          _buildHeaderCell('ORDER'),
                          _buildHeaderCell('OFFICE NOTE'),
                        ],
                      ),
                      // Sample data row
                      pw.TableRow(
                        children: [
                          _buildCell('1', 10),
                          _buildCell('${todayDate(mydate)}', 60),
                          _buildCell(_orderController.text, 200),
                          _buildCell('Sample note', 40),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          _buildCell('', 10),
                          _buildCell('', 60),
                          _buildCellEndBold(_signTypeController.text, 200),
                          _buildCell('', 40),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          _buildCell('', 10),
                          _buildCell('', 60),
                          _buildCellEnd(_cmShortkeyController.text, 200),
                          _buildCell('', 40),
                        ],
                      ),
                      // Add more rows as needed...
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
      String caseno =
          '$_caseType NO. ${_caseNoController.text} of ${_caseYearController.text}';
      // Save the PDF file using the case number
      final Uint8List bytes = await pdf.save();
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final File file = File('$dir/$caseno.pdf');
      if (save == true) {
        await file.writeAsBytes(bytes);
        print('PDF saved at ${file.path}');
      } else {
        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf.save());
      }
    }
  }

  List suggestionList = [];
  String hint = "";
  void typeAheadFilter(String value) {
    suggestionList.clear();

    if (value.isEmpty) {
      setState(() {});
      return;
    }

    for (String name in _orders) {
      if (name.toLowerCase().contains(value)) {
        suggestionList.add(name);
      }
    }

    if (suggestionList.isNotEmpty) {
      var firstSuggestion = suggestionList[0];

      setState(() => hint = firstSuggestion);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Type Hc Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _caseType,
                decoration: const InputDecoration(labelText: 'Case Type'),
                items: caseTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _caseType = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a case type' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _caseNoController,
                      decoration: const InputDecoration(labelText: 'Case No.'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter case number' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _caseYearController,
                      decoration: const InputDecoration(labelText: 'Case Year'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter case year' : null,
                    ),
                  ),
                ],
              ),

              // ],

              FieldSuggestion<String>.network(
                future: (input) => future.call(input),
                boxController: boxControllerOrder,
                textController: _orderController,
                maxLines: 6,
                inputDecoration: const InputDecoration(
                  hintText: 'Type order', // optional
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final result = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () => _orderController.text = result[index],
                          );

                          _orderController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: _orderController.text.length),
                          );

                          boxControllerOrder.close?.call();
                        },
                        child: Card(
                          child: ListTile(title: Text(result[index])),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  ).then((date) {
                    if (date != null && date != _selectedDate) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  });
                },
                child: const Text('PRESS TO CAHNGE Date (DD-MM-YYYY)'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _signTypeController,
                      decoration: const InputDecoration(labelText: 'Sign Type'),
                      validator: (value) => value!.isEmpty ? 'sign type' : null,
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: TextFormField(
                      controller: _cmShortkeyController,
                      decoration:
                          const InputDecoration(labelText: 'CM Shortkey'),
                      validator: (value) =>
                          value!.isEmpty ? 'CM shortkey' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _validateForm(true);
                    },
                    child: const Text('Save'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _validateForm(false);
                    },
                    child: const Text('Print'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  pw.Widget _buildHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildCell(String text, double width) {
    return pw.Container(
      width: width,
      padding: const pw.EdgeInsets.all(1),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 12),
      ),
    );
  }

  pw.Widget _buildCellEndBold(String text, double width) {
    return pw.Container(
      width: width,
      padding: const pw.EdgeInsets.all(1),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.end,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      ),
    );
  }

  pw.Widget _buildCellEnd(String text, double width) {
    return pw.Container(
      width: width,
      padding: const pw.EdgeInsets.all(1),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.end,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }
}
