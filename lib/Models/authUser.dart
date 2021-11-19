class AuthUser {
  int? id;
  String? username;
  String? password;
  String? email;
  String? token;
  String? firstname;
  String? lastname;
  String? tel;
  int? maturityPrefer;
  int? quota;

  List<RecentDurian>? recentDurians;

  AuthUser(
      {this.id,
      this.username,
      this.password,
      this.email,
      this.token,
      this.firstname,
      this.lastname,
      this.tel,
      this.maturityPrefer,
      this.quota,
      this.recentDurians});
}

class RecentDurian {
  int id;
  int user;
  String knockSound;
  int maturityScore;
  DateTime createdOn;
  String locationLat;
  String locationLng;

  RecentDurian({
    required this.id,
    required this.user,
    required this.knockSound,
    required this.maturityScore,
    required this.createdOn,
    required this.locationLat,
    required this.locationLng,
  });
}
