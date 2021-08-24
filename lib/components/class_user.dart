import 'dart:io';

class User {
  String email;
  String firstName;
  String secondName;
  String userID;
  String profilePictureURL;
  String appIdentifier;

  User(
      {this.email = '',
      this.firstName = '',
      this.secondName = '',
      this.userID = '',
      this.profilePictureURL = ''})
      : this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['fistName'] ?? '',
        secondName: parsedJson['secondName'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'fistName': this.firstName,
      'secondName': this.secondName,
      'id': this.userID,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}
