// lib/api/models/cancel_work_order_request.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class CloseWorkOrderRequest {
  /// Server expects: { "status": "Cancel", "remark": "...", "comment": "..." }
  final String status; // usually fixed to "Cancel"
  final String remark; // required
  final String? comment; // optional

  const CloseWorkOrderRequest({
    this.status = 'Cancel',
    required this.remark,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
        'status': status,
        'remark': remark,
        if (comment != null) 'comment': comment,
      };

  // ---------- Helpers for multipart ----------

  /// Build the JSON part named "workOrder" with Content-Type: application/json
  MultipartFile toJsonPart() => MultipartFile.fromString(
        jsonEncode(toJson()),
        filename: 'workOrder.json',
        contentType: MediaType('application', 'json'),
      );

  /// Build FormData with this JSON part and one/many files (by file paths).
  FormData toFormDataWithPaths(List<String> filePaths) {
    final form = FormData();
    form.files.add(MapEntry('workOrder', toJsonPart()));
    for (final path in filePaths) {
      form.files.add(MapEntry(
        'files',
        MultipartFile.fromFileSync(
          path,
          filename: p.basename(path),
          // contentType optional; backend usually infers
        ),
      ));
    }
    return form;
  }

  /// Build FormData with in-memory files (bytes) if you already have them.
  /// Each tuple: (filename, bytes, optionalMediaType)
  FormData toFormDataWithBytes(
      List<({String name, Uint8List bytes, MediaType? type})> files) {
    final form = FormData();
    form.files.add(MapEntry('workOrder', toJsonPart()));
    for (final f in files) {
      form.files.add(MapEntry(
        'files',
        MultipartFile.fromBytes(
          f.bytes,
          filename: f.name,
          contentType: f.type, // can be null
        ),
      ));
    }
    return form;
  }
}
