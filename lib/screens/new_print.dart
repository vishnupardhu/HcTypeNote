// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;

// class PdfTableExample extends StatelessWidget {
//   const PdfTableExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('PDF Table Example')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final pdf = pw.Document();
//             final font = await PdfGoogleFonts.getFont('Bookman Old Style');

//             pdf.addPage(
//               pw.Page(
//                 build: (pw.Context context) {
//                   return pw.Center(
//                     child: pw.Table(
//                       border: pw.TableBorder(
//                         top: pw.BorderSide(width: 1, color: pw.PdfColors.black),
//                         bottom: pw.BorderSide(width: 1, color: pw.PdfColors.black),
//                         left: pw.BorderSide(width: 1, color: pw.PdfColors.black),
//                         right: pw.BorderSide(width: 1, color: pw.PdfColors.black),
//                         horizontalInside: pw.BorderSide(width: 0, color: pw.PdfColors.transparent),
//                         verticalInside: pw.BorderSide(width: 0, color: pw.PdfColors.transparent),
//                       ),
//                       children: [
//                         // Header Row
//                         pw.TableRow(
//                           children: [
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text('Header 1', style: pw.TextStyle(font: font)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text('Header 2', style: pw.TextStyle(font: font)),
//                             ),
//                           ],
//                         ),
//                         // Data Rows
//                         pw.TableRow(
//                           children: [
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text('Data 1', style: pw.TextStyle(font: font)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text('Data 2', style: pw.TextStyle(font: font)),
//                             ),
//                           ],
//                         ),
//                         pw.TableRow(
//                           children: [
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text('Data 3', style: pw.TextStyle(font: font)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text('Data 4', style: pw.TextStyle(font: font)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             );

//             await Printing.layoutPdf(
//               onLayout: (PdfPageFormat format) async => pdf.save(),
//             );
//           },
//           child: const Text('Generate PDF'),
//         ),
//       ),
//     );
//   }
// }