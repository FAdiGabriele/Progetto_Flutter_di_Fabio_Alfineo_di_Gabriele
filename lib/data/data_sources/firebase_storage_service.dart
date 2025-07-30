import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:offro_cibo/domain/utils/logger.dart';

abstract class FirebaseStorageServiceApi {
  Future<String> uploadImageFromFile({
    required File file,
    required String path,
  });
  Future<String> uploadImageFromBytes({
    required Uint8List bytes,
    required String path,
  });
  Future<String> fetchImageUrl(String path);
  Future<bool> deleteImage(String path);
}

class FirebaseStorageService implements FirebaseStorageServiceApi {
  @override
  Future<String> uploadImageFromFile({
    required File file,
    required String path,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref(path);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      AppLogger.logger.d("Firebase upload error: ${e.message}");
      rethrow;
    } catch (e) {
      AppLogger.logger.d("An unexpected error occurred during upload: $e");
      rethrow;
    }
  }

  @override
  Future<String> uploadImageFromBytes({
    required Uint8List bytes,
    required String path,
  }) async {
    try {
      final ref = FirebaseStorage.instance.ref(path);
      final uploadTask = ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      AppLogger.logger.d("Firebase upload error: ${e.message}");
      rethrow;
    } catch (e) {
      AppLogger.logger.d("An unexpected error occurred during upload: $e");
      rethrow;
    }
  }

  @override
  Future<String> fetchImageUrl(String path) async {
    try {
      final String downloadUrl = await FirebaseStorage.instance.ref(path).getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      AppLogger.logger.d("Failed to fetch download URL: ${e.message}");
      rethrow;
    } catch (e) {
      AppLogger.logger.d("An unexpected error occurred while fetching URL: $e");
      rethrow;
    }
  }

  @override
  Future<bool> deleteImage(String path) async {
    try {
      await FirebaseStorage.instance.ref(path).delete();
      return true;
    } on FirebaseException catch (e) {
      AppLogger.logger.d("Failed to delete file: ${e.message}");
      rethrow;
    } catch (e) {
      AppLogger.logger.d("An unexpected error occurred during file deletion: $e");
      rethrow;
    }
  }
}