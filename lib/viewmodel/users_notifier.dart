import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_tracker/models/report_model.dart';
import 'package:team_tracker/models/user_model.dart';
import 'package:team_tracker/services/users_service.dart';


class UsersNotifier extends ChangeNotifier {
  UsersApi _api = UsersApi();
  List<UserModel> _users;

  Future<List<UserModel>> getUsers() async {
    QuerySnapshot result = await _api.getCollection();
    _users = result.documents
        .map((document) => UserModel.fromMap(document.data))
        .toList();
    return _users;
  }

  // Future<Report> createNewReport(Report report) async {
  //   Map data = report.toJson();
  //   DocumentReference document = await _api.addDocument(data, report.id);
  //   return Report.fromMap(data, document.documentID);
  // }

  // Future<Report> updateReportDetails(Report report) async {
  //   Map data = report.toJson();
  //   DocumentReference document = await _api.updateDocument(report.id, data);
  //   return Report.fromMap(data, document.documentID);
  // }

  Future<Report> deleteUser(UserModel user) async {
    Map data = user.toJson();
    await _api.deleteDocument(user.uid);
    return Report.fromMap(data, user.uid);
  }

  Stream<QuerySnapshot> streamReports() {
    return _api.streamCollection();
  }
}