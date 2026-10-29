import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_mobile/data/models/cv_data.dart';
import 'package:frontend_mobile/services/cv_pdf_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('membuat PDF CV yang valid', () async {
    const data = CvData(
      fullName: 'Raka Aditya',
      email: 'raka@example.com',
      summary: 'Mahasiswa yang tertarik pada produk digital.',
      education: [
        EducationEntry(
          institution: 'Universitas Contoh',
          major: 'Sistem Informasi',
          startYear: '2023',
          endYear: 'Sekarang',
        ),
      ],
      skills: ['Riset pengguna', 'Excel'],
    );

    final bytes = await CvPdfService.build(data);

    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');

    final f4Bytes = await CvPdfService.build(
      data,
      paperSize: CvPaperSize.f4,
    );
    expect(f4Bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(f4Bytes.take(4)), '%PDF');
  });
}
