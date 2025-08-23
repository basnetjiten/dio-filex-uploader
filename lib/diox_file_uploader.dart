import 'dart:io';
import 'package:dio/dio.dart';
import 'extensions/int_extension.dart';
import 'constants/filex_type_constants.dart';
import 'filex_utilities/filex_utils.dart';

/// Wrapper to upload file using Dio client
class DioFileXUploader {
  ///http request client
  static Dio get _client => Dio();

  /// creates multipart files from [filePath]
  static Future<MultipartFile> _createMultiPartFile(String filePath) async =>
      await MultipartFile.fromFile(filePath);

  /// Uploads file to the server
  ///
  /// *[uploadUrl]: url to upload the file in server (aws, firebase etc)
  ///
  /// *[filePath]: actual file path of the selected file (pdf, images etc)
  ///
  /// *[contentType]: content type of provided file
  ///

  ///Returns either success or failure response based on server status code

  static Future<Map<String, dynamic>?> uploadMultiPartFileFromURL({
    required Map<String, dynamic>? metaData,
    required String signedUrl,
    required String filePath,
    String? successMessage,
    String? errorMessage,
    void Function(int sentBytes, int totalBytes)? onProgress,
  }) async {
    try {
      final FormData formData = FormData.fromMap(metaData ?? {});

      final MultipartFile file = await _createMultiPartFile(filePath);

      formData.files.add(MapEntry(FileTypeConstants.file, file));

      final response = await _client.post(
        signedUrl,
        data: formData,
        onSendProgress: onProgress,
      );

      if ((response.statusCode ?? 500).isSuccessful) {
        return response.data;
      }
      return {};
    } on DioException catch (e) {
      return null;
    }
  }

  static Future<bool> uploadFileBytes({
    required String signedUrl,
    required File pickedFile,
    String? successMessage,
    String? errorMessage,
    void Function(int sentBytes, int totalBytes)? onProgress,
  }) async {
    try {
      // Get the file bytes directly
      final fileBytes = await pickedFile.readAsBytes();

      final String? fileExtension = FileXUtils.getExtension(pickedFile.path);
      final String contentType = FileXUtils.getContentType(fileExtension);

      final response = await _client.put(signedUrl,
          data: fileBytes,
          options: Options(headers: {
            'Content-Type': contentType,
          }, validateStatus: (status) => status != null && status.isSuccessful),
          onSendProgress: onProgress);
      return (response.statusCode ?? 500).isSuccessful;
    } on DioException catch (e) {
      return false;
    }
  }
}
