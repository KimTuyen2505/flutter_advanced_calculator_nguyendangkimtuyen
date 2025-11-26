import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../providers/calculator_provider.dart';

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // EXPORT CSV
  Future<void> exportCSV(BuildContext context) async {
    final history = Provider.of<HistoryProvider>(context, listen: false);

    List<List<dynamic>> rows = [
      ["Expression", "Result", "Timestamp"]
    ];

    for (final item in history.items) {
      rows.add([
        item.expression,
        item.result,
        item.timestamp.toString(),
      ]);
    }

    final csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/history_export.csv";
    final file = File(filePath);

    await file.writeAsString(csvData);

    Share.shareXFiles([XFile(filePath)], text: "History Export CSV");
  }

  // EXPORT PDF
  Future<void> exportPDF(BuildContext context) async {
    final history = Provider.of<HistoryProvider>(context, listen: false);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "-Export history ",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ["Expression", "Result", "Time"],
                data: history.items.map((item) {
                  return [
                    item.expression,
                    item.result,
                    item.timestamp.toString(),
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final calc = context.read<CalculatorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          // EXPORT PDF
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Export PDF",
            onPressed: () => exportPDF(context),
          ),
          // EXPORT CSV
          IconButton(
            icon: const Icon(Icons.table_view),
            tooltip: "Export CSV",
            onPressed: () => exportCSV(context),
          ),

          // CLEAR HISTORY
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Clear all history?'),
                      content: const Text('This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (ok) {
                await history.clear();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: history.items.length,
        itemBuilder: (context, index) {
          final item = history.items.reversed.toList()[index];

          return ListTile(
            title: Text(item.expression),
            subtitle: Text(item.result),
            onTap: () {
              calc.addToExpression(item.result);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
