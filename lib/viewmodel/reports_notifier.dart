import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_tracker/models/report_model.dart';
import 'package:team_tracker/services/auth_service.dart';
import 'package:team_tracker/services/reports_service.dart';

class ReportsNotifier extends ChangeNotifier {
  ReportsApi _api = ReportsApi();
  List<Report> _reports;

  Future<List<Report>> getReports() async {
    AuthService _auth = AuthService();
    String userId = await _auth.getUserId();

    QuerySnapshot result = await _api.getCollection();
    _reports = result.documents
        .where((element) => element.data['id'] != userId)
        .map((document) => Report.fromMap(document.data, document.documentID))
        .toList();
    print(_reports.first.id);
    return _reports;
  }

  Future<Report> createNewReport(Report report) async {
    Map data = report.toJson();
    DocumentReference document = await _api.addDocument(data, report.id);
    return Report.fromMap(data, document.documentID);
  }

  Future<Report> updateReportDetails(Report report) async {
    Map data = report.toJson();
    DocumentReference document = await _api.updateDocument(report.id, data);
    return Report.fromMap(data, document.documentID);
  }

  Future<Report> deleteReport(Report report) async {
    Map data = report.toJson();
    await _api.deleteDocument(report.id);
    return Report.fromMap(data, report.id);
  }

  Stream<QuerySnapshot> streamReports() {
    return _api.streamCollection();
  }
}
