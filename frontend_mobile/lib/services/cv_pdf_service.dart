import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/models/cv_data.dart';

enum CvPaperSize { a4, f4 }

extension CvPaperSizeX on CvPaperSize {
  String get label => switch (this) {
        CvPaperSize.a4 => 'A4',
        CvPaperSize.f4 => 'F4',
      };

  PdfPageFormat get format => switch (this) {
        CvPaperSize.a4 => PdfPageFormat.a4,
        CvPaperSize.f4 => const PdfPageFormat(612, 936),
      };
}

class CvPdfService {
  CvPdfService._();

  static Future<Uint8List> build(
    CvData data, {
    CvPaperSize paperSize = CvPaperSize.a4,
  }) async {
    final fontData = await rootBundle.load('assets/fonts/DMSans-Variable.ttf');
    final font = pw.Font.ttf(fontData);
    final document = pw.Document(
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
        italic: font,
        boldItalic: font,
      ),
    );
    final accent = switch (data.template) {
      CvTemplate.focus => PdfColor.fromHex('#327D76'),
      CvTemplate.classic => PdfColor.fromHex('#183B56'),
      CvTemplate.modern => PdfColor.fromHex('#D8A33D'),
    };

    document.addPage(
      pw.MultiPage(
         pageFormat: paperSize.format,
        margin: const pw.EdgeInsets.all(34),
        build: (context) {
          return [
            _header(data, accent),
            if (data.summary.trim().isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Ringkasan Profil', accent),
              pw.SizedBox(height: 6),
              pw.Text(
                data.summary.trim(),
                style: pw.TextStyle(fontSize: 9.5, lineSpacing: 2),
              ),
            ],
            if (data.education.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Pendidikan', accent),
              ...data.education.map((item) => _educationItem(item)),
            ],
            if (data.experiences.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Pengalaman', accent),
              ...data.experiences.map((item) => _experienceItem(item)),
            ],
            if (data.organizations.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Organisasi', accent),
              ...data.organizations.map((item) => _experienceItem(item)),
            ],
            if (data.projects.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Proyek', accent),
              ...data.projects.map((item) => _projectItem(item)),
            ],
            if (data.skills.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Keterampilan', accent),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 6,
                runSpacing: 6,
                children: data.skills
                    .map(
                      (skill) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#F3F6F5'),
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                        child: pw.Text(
                          skill,
                          style: pw.TextStyle(fontSize: 8.5),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (data.certificates.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Sertifikat', accent),
              ...data.certificates.map(
                (item) => pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Text(
                    '${item.name} - ${item.issuer}${item.year == null ? '' : ' (${item.year})'}',
                    style: pw.TextStyle(fontSize: 9.5),
                  ),
                ),
              ),
            ],
            if (data.languages.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _section('Bahasa', accent),
              ...data.languages.map(
                (item) => pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 5),
                  child: pw.Text(
                    '${item.name} - ${item.proficiency}',
                    style: pw.TextStyle(fontSize: 9.5),
                  ),
                ),
              ),
            ],
          ];
        },
      ),
    );

    return document.save();
  }

  static Future<void> share(
    CvData data, {
    CvPaperSize paperSize = CvPaperSize.a4,
  }) async {
    final bytes = await build(data, paperSize: paperSize);
    final safeName = data.fullName
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]+'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'CV_${safeName.isEmpty ? 'SiapKarier' : safeName}.pdf',
    );
  }

  static pw.Widget _header(CvData data, PdfColor accent) {
    final contacts = [
      if (data.email.trim().isNotEmpty) data.email.trim(),
      if (data.phone.trim().isNotEmpty) data.phone.trim(),
      ...data.links.map((link) => '${link.label}: ${link.url}'),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(height: 5, width: 54, color: accent),
        pw.SizedBox(height: 10),
        pw.Text(
          data.fullName.trim(),
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#183B56'),
          ),
        ),
        if (contacts.isNotEmpty) ...[
          pw.SizedBox(height: 6),
          pw.Text(
            contacts.join('  |  '),
            style: pw.TextStyle(
              fontSize: 8.5,
              color: PdfColor.fromHex('#71808A'),
            ),
          ),
        ],
      ],
    );
  }

  static pw.Widget _section(String title, PdfColor accent) {
    return pw.Row(
      children: [
        pw.Container(width: 3, height: 12, color: accent),
        pw.SizedBox(width: 6),
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 0.8,
            color: PdfColor.fromHex('#183B56'),
          ),
        ),
      ],
    );
  }

  static pw.Widget _educationItem(EducationEntry item) {
    final period = [
      if (item.startYear != null) item.startYear,
      if (item.endYear != null) item.endYear,
    ].whereType<String>().join(' - ');

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  item.institution,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              if (period.isNotEmpty)
                pw.Text(
                  period,
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColor.fromHex('#71808A'),
                  ),
                ),
            ],
          ),
          pw.Text(
            [item.major, if (item.degree != null) item.degree]
                .whereType<String>()
                .join(' - '),
            style: pw.TextStyle(fontSize: 9),
          ),
          if (item.description != null && item.description!.trim().isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 3),
              child: pw.Text(
                item.description!.trim(),
                style: pw.TextStyle(fontSize: 8.5, lineSpacing: 1.5),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _experienceItem(ExperienceEntry item) {
    final period = [
      if (item.startDate != null) item.startDate,
      if (item.endDate != null) item.endDate,
    ].whereType<String>().join(' - ');

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  item.title,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              if (period.isNotEmpty)
                pw.Text(
                  period,
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColor.fromHex('#71808A'),
                  ),
                ),
            ],
          ),
          pw.Text(
            item.organization,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColor.fromHex('#327D76'),
            ),
          ),
          if (item.description != null && item.description!.trim().isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 3),
              child: pw.Text(
                item.description!.trim(),
                style: pw.TextStyle(fontSize: 8.5, lineSpacing: 1.5),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _projectItem(ProjectEntry item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            item.name,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          if (item.role != null && item.role!.trim().isNotEmpty)
            pw.Text(
              item.role!.trim(),
              style: pw.TextStyle(
                fontSize: 8.5,
                color: PdfColor.fromHex('#327D76'),
              ),
            ),
          if (item.description != null && item.description!.trim().isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 3),
              child: pw.Text(
                item.description!.trim(),
                style: pw.TextStyle(fontSize: 8.5, lineSpacing: 1.5),
              ),
            ),
          if (item.result != null && item.result!.trim().isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                'Hasil: ${item.result!.trim()}',
                style: pw.TextStyle(fontSize: 8.5),
              ),
            ),
          if (item.tools.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                'Alat: ${item.tools.join(', ')}',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColor.fromHex('#71808A'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

