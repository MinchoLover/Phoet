import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poet/models/poem_model.dart';

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});

class FirestoreRepository {
  final FirebaseFirestore _firestore;

  FirestoreRepository(this._firestore);

  CollectionReference get _poems => _firestore.collection('poems');

  Future<void> createPoem(PoemModel poem) {
    return _poems.doc(poem.id).set(poem.toJson());
  }

  Stream<List<PoemModel>> getPoems(String userId) {
    return _poems
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PoemModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updatePoem(PoemModel poem) {
    return _poems.doc(poem.id).update(poem.toJson());
  }

  Future<void> deletePoem(String poemId) {
    return _poems.doc(poemId).delete();
  }
}
