import 'dart:io';

class User {
  String email;
  String firstName;
  String lastName;
  String id;
  String imageUrl;
  String appIdentifier;

  User(
      {this.email = '',
      this.firstName = '',
      this.lastName = '',
      this.id = '',
      this.imageUrl = ''})
      : this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        id: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        imageUrl: parsedJson['imageUrl'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'id': this.id,
      'imageUrl': this.imageUrl,
      'appIdentifier': this.appIdentifier
    };
  }
}
