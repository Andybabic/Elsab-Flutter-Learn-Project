import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsab/components/class_einsatz.dart';
import 'package:elsab/components/class_user.dart';
import 'package:elsab/constants/app_constants.dart';
import 'package:elsab/pages/chat/rooms.dart';
import 'package:elsab/pages/einseatze/einsatz_details_screen.dart';
import 'package:elsab/pages/home/home_page.dart';
import 'package:elsab/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.room,
    required this.isUserRoom,
  }) : super(key: key);

  final types.Room room;
  final bool isUserRoom;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;
  bool _isRoomAdmin = false;
  bool _isEinsatzRoom = false;

  //UserClass? _currentUser;
  User? _currentUser;
  bool _refreshAllowed = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getRoomRole();
    getRoomType();
  }

  void getRoomType() async {
    _isEinsatzRoom = widget.room.metadata?.containsKey("einsatzID") ?? false;
  }

  void getCurrentUser() async {
    //_currentUser = UserConst.currentUser; => not working...
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  void getRoomRole() async {
    bool response = await ChatConst.getRoomRole(widget.room.id);
    setState(() {
      _isRoomAdmin = response;
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path;
      final file = File(filePath ?? '');

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath ?? ''),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } on FirebaseException catch (e) {
        _setAttachmentUploading(false);
        print(e);
      }
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) async {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );

    FirebaseFirestore.instance.collection("rooms").doc(widget.room.id).set(
      {
        "metadata": {
          "lastMessage": {_currentUser?.uid ?? "Namenlos": message.text}
        }
      },
      SetOptions(merge: true),
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Abbrechen"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Fortfahren"),
      onPressed: () {
        ChatConst.deleteRoom(widget.room.id);
        setState(() {
          _refreshAllowed = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RoomsPage()),
          (route) => false,
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Raum löschen"),
      content: Text(
          "Möchtest du als Admin dieses Raumes den Raum wirklich löschen?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void goToEinsatzDetails() async {
    await FirebaseFirestore.instance
        .collection("Einsätze")
        .where("einsatzID", isEqualTo: widget.room.metadata?["einsatzID"])
        .get()
        .then((value) => Get.to(() =>
            EinsatzDetailScreen(Einsaetze.fromJson(value.docs.first.data()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: (widget.room.type == types.RoomType.direct)
            ? Text('Chat mit ${widget.room.users.last.firstName}')
            : Text("Chat ${widget.room.name}"),
        actions: <Widget>[
          if (_isRoomAdmin && widget.room.type != types.RoomType.direct)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Raum löschen',
              onPressed: () {
                showAlertDialog(context);
              },
            ),
          if (_isEinsatzRoom)
            IconButton(
              icon: const Icon(Icons.article_outlined),
              tooltip: 'Zu den Details',
              onPressed: () => {goToEinsatzDetails()},
            ),
        ],
      ),
      body: _refreshAllowed
          ? StreamBuilder<types.Room>(
              initialData: widget.room,
              stream: FirebaseChatCore.instance.room(widget.room.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  print("hmm");
                } else if (snapshot.hasData) {
                  return StreamBuilder<List<types.Message>>(
                    initialData: const [],
                    stream: FirebaseChatCore.instance.messages(snapshot.data!),
                    builder: (context, snapshot) {
                      return Chat(
                        // theme: MyChatTheme(
                        //   attachmentButtonIcon: Icon(Icons.attach_file),
                        //   backgroundColor: Colors.blueGrey,
                        //   dateDividerTextStyle: TextStyle(color:Colors.white),
                        //   deliveredIcon: Icon(Icons.message),
                        //   documentIcon: Icon(Icons.wallpaper),
                        //   emptyChatPlaceholderTextStyle: TextStyle(color: Colors.orange),
                        //   errorColor: Colors.red,
                        //   errorIcon: Icon(Icons.error),
                        //   inputBackgroundColor: Colors.black26,
                        //   inputBorderRadius: BorderRadius.all(Radius.circular(10.0)),
                        //   inputTextStyle: TextStyle(),
                        //   inputTextColor: Colors.white,
                        //   messageBorderRadius: 10.0,
                        //   primaryColor: Colors.white,
                        //   receivedMessageBodyTextStyle: TextStyle(),
                        //   receivedMessageCaptionTextStyle: TextStyle(),
                        //   receivedMessageDocumentIconColor: Colors.orangeAccent,
                        //   receivedMessageLinkDescriptionTextStyle: TextStyle(),
                        //   receivedMessageLinkTitleTextStyle: TextStyle(),
                        //   secondaryColor: Colors.blueGrey,
                        //   seenIcon: Icon(Icons.air),
                        //   sendButtonIcon: Icon(Icons.arrow_forward),
                        //   sentMessageBodyTextStyle: TextStyle(),
                        //   sentMessageCaptionTextStyle: TextStyle(),
                        //   sentMessageDocumentIconColor: Colors.orangeAccent,
                        //   sentMessageLinkDescriptionTextStyle: TextStyle(),
                        //   sentMessageLinkTitleTextStyle: TextStyle(),
                        //   userAvatarNameColors: [Colors.blue, Colors.yellow, Colors.green],
                        //   userAvatarTextStyle: TextStyle(),
                        //   userNameTextStyle: TextStyle(),
                        //   sendingIcon: null,
                        // ),
                        showUserNames: true,
                        isAttachmentUploading: _isAttachmentUploading,
                        messages: snapshot.data ?? [],
                        onAttachmentPressed: _handleAtachmentPressed,
                        onMessageTap: _handleMessageTap,
                        onPreviewDataFetched: _handlePreviewDataFetched,
                        onSendPressed: _handleSendPressed,
                        user: types.User(
                          id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                        ),
                      );
                    },
                  );
                }
                // if room suddenly does not exist, go back to roomspage
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("UPS! Dieser Raum existiert nicht mehr..."),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            child: Text("hier gehts zurück"),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              onSurface: ThemeConst.lightPrimary,
                              backgroundColor: ThemeConst.accent,
                              padding: EdgeInsets.all(12),
                            ),
                            onPressed: () {
                              try {
                                Get.to(() => RoomsPage());
                              } catch (_) {}
                            }),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
