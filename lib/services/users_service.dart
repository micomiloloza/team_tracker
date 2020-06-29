import 'package:team_tracker/services/firestore_service.dart';

class UsersApi extends FirestoreApi {
  static final String usersApi = "users";
  UsersApi() : super(usersApi);
}