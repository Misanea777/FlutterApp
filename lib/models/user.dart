class CustomUser {
  final String uid;
  final String? displayName;
  final bool isNewUser;
  CustomUser({required this.uid, required this.isNewUser,this.displayName});

  CustomUser.fromJsonAndKey(Map<dynamic, dynamic> json, this.uid) :
      displayName = json['name'] as String,
      isNewUser = false;

}