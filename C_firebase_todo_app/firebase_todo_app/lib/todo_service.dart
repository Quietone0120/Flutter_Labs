import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? "";

  // Plan нэмэх
  Future<void> addPlan(String title) async {
    await _firestore.collection("users").doc(userId).collection("plans").add({
      "title": title,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // Plan stream
  Stream<QuerySnapshot> getPlans() {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // Task нэмэх
  Future<void> addTask(String planId, String title) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .doc(planId)
        .collection("tasks")
        .add({
          "title": title,
          "isDone": false,
          "timestamp": FieldValue.serverTimestamp(),
        });
  }

  // Task stream
  Stream<QuerySnapshot> getTasks(String planId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .doc(planId)
        .collection("tasks")
        .orderBy("isDone", descending: false)
        .snapshots();
  }

  // Task toggle
  Future<void> toggleTask(
    String planId,
    String taskId,
    bool currentValue,
  ) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .doc(planId)
        .collection("tasks")
        .doc(taskId)
        .update({"isDone": !currentValue});
  }

  // Task нэрийг засах
  Future<void> updateTask(String planId, String taskId, String newTitle) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .doc(planId)
        .collection("tasks")
        .doc(taskId)
        .update({"title": newTitle});
  }

  // Task delete
  Future<void> deleteTask(String planId, String taskId) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .doc(planId)
        .collection("tasks")
        .doc(taskId)
        .delete();
  }

  // Plan update
  Future<void> updatePlan(String planId, String newTitle) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .doc(planId)
        .update({"title": newTitle});
  }

  // Plan delete (Optional but good for CRUD completeness)
  Future<void> deletePlan(String planId) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("plans")
        .doc(planId)
        .delete();
  }

  // Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
