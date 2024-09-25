import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio_filex_uploader/extensions/dio_extension.dart';
import 'constants/filex_type_constants.dart';
import 'filex_utilities/filex_utils.dart';
import 'typedefs/typedefs.dart';

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

  static EitherResponse<String> uploadMultiPartFileFromURL({
    required Map<String, dynamic> metaData,
    required String signedUrl,
    required File pickedFile,
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      final FormData formData = FormData.fromMap(metaData);

      final MultipartFile file = await _createMultiPartFile(pickedFile.path);

      formData.files.add(MapEntry(FileTypeConstants.file, file));

      final response = await _client.post(signedUrl, data: formData);

      return (response.statusCode ?? 500).isSuccessful
          ? right(successMessage ?? 'Upload successful')
          : left(errorMessage ?? 'Error Uploading');
    } on DioException catch (e) {
      return left(e.handleException(errorMessage: errorMessage));
    }
  }

  static EitherResponse<String> uploadFileBytes({
    required String signedUrl,
    required File pickedFile,
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      // Get the file bytes directly
      final fileBytes = await pickedFile.readAsBytes();

      final String? fileExtension = FileXUtils.getExtension(pickedFile.path);
      final String contentType = FileXUtils.getContentType(fileExtension);

      final response = await _client.put(
        signedUrl,
        data: fileBytes,
        options: Options(headers: {
          'Content-Type': contentType,
        }, validateStatus: (status) => status != null && status.isSuccessful),
      );
      return (response.statusCode ?? 500).isSuccessful
          ? right(successMessage ?? 'Upload successful')
          : left(errorMessage ?? 'Error Uploading');
    } on DioException catch (e) {
      return left(e.handleException(errorMessage: errorMessage));
    }
  }
}

// Extension for response status check
extension on int {
  bool get isSuccessful => this >= 200 && this < 300;
}
