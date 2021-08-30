import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserClass {

  final box = GetStorage();

  String email;
  String firstName;
  String lastName;
  String lastSeen;
  String id;
  String imageUrl;
  String appIdentifier;
  Map<String, dynamic>? metadata;

  UserClass(
      {this.email = '',
      this.firstName =  '',
      this.lastName = '',
        this.lastSeen = '',
      this.id = '',
      this.imageUrl = '',
      this.metadata = const{'status':0},
      })
      : this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';



  factory UserClass.fromJson(Map<String, dynamic> parsedJson) {
    return new UserClass(
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



//Save User on Device
  saveUserGlobal()  {
    box.write('email', email);
    box.write('firstName', firstName );
    box.write('lastName', lastName );
    box.write('lastSeen',lastSeen);
    box.write('id',id);
    box.write('imageUrl',imageUrl);
    print('done writing');
  }

   static readUserOnDevice(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id=         prefs.getString('id') ?? id;
  }
   saveUserOnDevice (String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
  }

  static save(){
    print('classenaufruf');
  }

}
