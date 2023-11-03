import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/model/task.dart';

import 'model/myuser.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTaskCollection(String uId) {
    return getUsersCollections()
        .doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()!),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTaskCollection(uId);
    var docRef = taskCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTaskCollection(uId).doc(task.id).delete();
  }

  static CollectionReference<MyUser> getUsersCollections() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionsName)
        .withConverter<MyUser>(
            fromFirestore: (snapshot, options) =>
                MyUser.fromFireStore(snapshot.data()!),
            toFirestore: (user, options) => user.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollections().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserToFireStore(String uId) async {
    var docSnapshot = await getUsersCollections().doc(uId).get();
    return docSnapshot.data();
  }
}
