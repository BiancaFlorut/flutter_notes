import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/cloud/firebase_cloud_storage.dart';
// import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/view/notes/notes_list_view.dart';
import '../../constants/routs.dart';
import '../../enums/menu_actions.dart';
import '../../services/cloud/cloud_note.dart';
import '../../utilities/dialog/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // late final NotesService _notesService;
  late final FirebaseCloudStorage _notesService;

  // String get userEmail =>
  //     AuthService
  //         .firebase()
  //         .currentUser!
  //         .email;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Notes"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();

                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                )
              ];
            })
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                      notes: allNotes.toList(),
                      onTap: (note) {
                        Navigator.of(context).pushNamed(
                          createUpdateNoteRoute,
                          arguments: note,
                        );
                      },
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(documentId: note.documentId);
                      });
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
    );
  }
}

//
// {
//
// const fb = FutureBuilder(
//   future: _notesService.getOrCreateUser(email: userEmail),
//   builder: (context, snapshot) {
//     switch (snapshot.connectionState) {
//       case ConnectionState.done:
//         return StreamBuilder(
//           stream: _notesService.allNotes,
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//               case ConnectionState.active:
//                 if (snapshot.hasData) {
//                   final allNotes = snapshot.data as List<DatabaseNote>;
//                   return NotesListView(
//                       notes: allNotes,
//                       onTap: (note) {
//                         Navigator.of(context).pushNamed(
//                           createUpdateNoteRoute,
//                           arguments: note,
//                         );
//                       },
//                       onDeleteNote: (note) async {
//                         await _notesService.deleteNote(id: note.id);
//                       });
//                 } else {
//                   return const CircularProgressIndicator();
//                 }
//               default:
//                 return const CircularProgressIndicator();
//             }
//           },
//         );
//       default:
//         return const CircularProgressIndicator();
//     }
//   },
// )
// ,}