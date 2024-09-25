import 'package:dio_filex_uploader/constants/filex_type_constants.dart';
import 'package:path/path.dart' as path;

class FileXUtils {
  static String? getExtension(String? filePath) {
    return (filePath != null && filePath.isNotEmpty)
        ? path.extension(filePath)
        : filePath;
  }

  static String getContentType(String? fileExtension) {
    const contentTypes = {
      '.jpeg': FileTypeConstants.imageJpeg,
      '.jpg': FileTypeConstants.imageJpeg,
      '.jfif': FileTypeConstants.imageJpeg,
      '.png': FileTypeConstants.imagePng,
      '.pdf': FileTypeConstants.applicationPdf,
      '.doc': FileTypeConstants.applicationMSword,
      '.docx': FileTypeConstants.applicationMSword,
    };

    return contentTypes[fileExtension?.toLowerCase()] ??
        FileTypeConstants.imageJpeg;
  }
}
