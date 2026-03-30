import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class ReportService {
  static Future<void> generateClinicalReport({
    required String userName,
    required String personality,
    required List<String> distortions,
    required double averageMood,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('REPORTE DE EVOLUCIÓN EMOCIONAL', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text('Paciente: $userName'),
                pw.Text('Perfil MBTI: $personality'),
                pw.Text('Fecha: ${DateTime.now().toString().split(' ')[0]}'),
                pw.SizedBox(height: 30),
                
                pw.Text('Resumen de Bienestar', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Estado de ánimo promedio: ${(averageMood * 10).toStringAsFixed(1)} / 10'),
                pw.SizedBox(height: 20),

                pw.Text('Patrones de Pensamiento Detectados (TCC)', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                if (distortions.isEmpty)
                  pw.Text('No se han detectado distorsiones significativas.')
                else
                  pw.Bullet(text: distortions.join('\n')),
                
                pw.Spacer(),
                pw.Divider(),
                pw.Text('Generado automáticamente por BearWithMe AI - Protocolo TCC', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
