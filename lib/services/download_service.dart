import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<String> downloadAudio({
    required String url,
    required String fileName,
    required void Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDirectory = Directory('${directory.path}/downloads');

    if (!await downloadsDirectory.exists()) {
      await downloadsDirectory.create(recursive: true);
    }

    // Use a temporary file until the download completes.
    final tempPath = '${downloadsDirectory.path}/$fileName.part';
    final finalPath = '${downloadsDirectory.path}/$fileName';

    try {
      await _dio.download(
        url,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            onProgress(received / total);
          }
        },
      );

      final tempFile = File(tempPath);

      if (!await tempFile.exists() || await tempFile.length() == 0) {
        throw Exception('Downloaded file is empty');
      }

      // Rename only after a successful download.
      await tempFile.rename(finalPath);

      return finalPath;
    } catch (_) {
      final tempFile = File(tempPath);

      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      rethrow;
    }
  }

  Future<void> deleteAudio(String path) async {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }

  void dispose() {
    _dio.close();
  }
}
