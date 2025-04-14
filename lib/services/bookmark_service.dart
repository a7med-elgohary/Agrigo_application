import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addBookmark(Map<String, dynamic> plant) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('bookmarks')
            .doc(plant['id'])
            .set(plant);
      }
    } catch (e) {
      print('Error adding bookmark: $e');
      throw Exception('Failed to add bookmark');
    }
  }

  Future<void> removeBookmark(String plantId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('bookmarks')
            .doc(plantId)
            .delete();
      }
    } catch (e) {
      print('Error removing bookmark: $e');
      throw Exception('Failed to remove bookmark');
    }
  }

  Future<bool> isBookmarked(String plantId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('bookmarks')
            .doc(plantId)
            .get();
        return doc.exists;
      }
      return false;
    } catch (e) {
      print('Error checking bookmark: $e');
      return false;
    }
  }

  Stream<QuerySnapshot> getBookmarksStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .snapshots();
    }
    return const Stream.empty();
  }
} 