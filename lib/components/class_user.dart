import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String firstName;
  String lastName;
  String lastSeen;
  String id;
  String imageUrl;
  String appIdentifier;
  Map<String, dynamic>? metadata;

  User(
      {this.email = '',
      this.firstName = '',
      this.lastName = '',
        this.lastSeen = '',
      this.id = '',
      this.imageUrl = '',
      this.metadata = const{'status':0},
      })
      : this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        id: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        imageUrl: parsedJson['imageUrl'] ?? '',
        metadata: parsedJson['metadata'] ?? const{'status':0},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'id': this.id,
      'imageUrl': this.imageUrl,
      'appIdentifier': this.appIdentifier,
      'metadata' : this.metadata,
    };
  }
}
