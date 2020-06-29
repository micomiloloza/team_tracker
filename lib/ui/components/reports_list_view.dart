import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:team_tracker/models/report_model.dart';
import 'package:team_tracker/constants/report_type.dart';
import 'package:team_tracker/pages/report_detail.dart';
import 'package:team_tracker/models/models.dart';
import 'package:team_tracker/viewmodel/reports_notifier.dart';
import 'package:team_tracker/ui/components/report_type_image_view.dart';
import 'package:team_tracker/helpers/firestore_helper.dart';
import 'package:provider/provider.dart';
import 'package:team_tracker/services/services.dart';

class ReportsListView extends StatefulWidget {
  final OnClickCallback<Report> onRsvpClicked;

  const ReportsListView(this.onRsvpClicked);

  @override
  State<StatefulWidget> createState() => _ReportsListViewState();
}

class _ReportsListViewState extends State<ReportsListView> {
  ReportsNotifier _reportsNotifer;
  UserModel _user;
  bool _admin = false;
  List<Report> _reports = [];
  OnClickCallback<Report> get _onRsvpClicked => widget.onRsvpClicked;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    _reportsNotifer = Provider.of<ReportsNotifier>(context);
    _user = Provider.of<UserModel>(context);
    final height = MediaQuery.of(context).size.height;

    _isUserAdmin();

    return Container(
      height: height,
      child: RefreshIndicator(
        child: StreamBuilder(
        stream: _reportsNotifer.streamReports(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
            if (_admin) {
              _reports = snapshot.data.documents
                .map((item) => Report.fromMap(item.data, item.documentID))
                .toList();
            } else {
              _reports = snapshot.data.documents
                .where((element) => element['id'] == _user.uid)
                .map((item) => Report.fromMap(item.data, item.documentID))
                .toList();
            }

            
            if (_reports.isNotEmpty) {
              return ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, position) {
                  return _ReportsListItemView(
                    _reports[position],
                    _onRsvpClicked,
                  );
                },
              );
            } else {
              return Center(
                child: Text("No reports found."),
              );
            }
            
          } else {
            return Center(
              child: Text("No reports found."),
            );
          }
        },
      ), 
        onRefresh: () async {
          _refreshList();
          print("Refreshano");
        })
    );
  }

  Future<Null> _refreshList() async {
    setState(() {
      _reportsNotifer.getReports();
    });
  }

  _isUserAdmin() async {
    bool _isAdmin = await AuthService().isAdmin();
    if (mounted) {
      setState(() {
        _admin = _isAdmin;
      });
    }
  }
}

class _ReportsListItemView extends StatelessWidget {
  final Report report;
  final OnClickCallback<Report> onRsvpClick;
  const _ReportsListItemView(this.report, this.onRsvpClick);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ReportDetailScreen.routeName,
          arguments: ReportDetailScreenArgs(report)
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: ReportTypeImageView(
                        height: 100,
                        width: 150,
                        type: EnumToString.fromString(
                          ReportType.values,
                          "Bio je report type" + report.pain.toString(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                              report.title,
                              style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            ),
                          ),
                          Text(
                            "Author: " + report.author
                          ),
                          // Text(
                          //   "Uploaded: " + FirestoreHelper.getReadableTime(report.timestamp),
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            margin: const EdgeInsets.only(
                              top: 15,
                            ),
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Text(
                              "Energy level: " + report.energyLevel.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                // ButtonBar(
                //   children: <Widget>[
                //     FlatButton(
                //       child: Row(
                //         children: <Widget>[
                //           Icon(Icons.favorite_border),
                //           SizedBox(width: 8),
                //           Text('Add to Favorites')
                //         ],
                //       ),
                //       onPressed: () {},
                //     ),
                //     FlatButton(
                //       child: Text('RSVP'),
                //       onPressed: () {
                //         if (onRsvpClick != null) {
                //           onRsvpClick(report);
                //         }
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
