// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:notesapp/extensions/list/filter.dart';
// import 'package:notesapp/sevices/crud/crud_constants.dart';
// import 'package:notesapp/sevices/crud/crud_exceptions.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class NotesService {
//   Database? _db;
//   DatabaseUser? _user;

//   List<DatabaseNotes> _notes = [];

//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNotes>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;

//   late final StreamController<List<DatabaseNotes>> _notesStreamController;

//   Stream<List<DatabaseNotes>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotesExceptioin();
//         }
//       });

//   Future<void> _cacheNotes() async {
//     final allnotes = await getAllNotes();
//     _notes = allnotes.toList();
//     // _notes.addAll(allnotes);
//     _notesStreamController.add(_notes);
//   }

//   // the following are the database notes table functions
//   Future<DatabaseNotes> updateNotes({
//     required DatabaseNotes note,
//     required String text,
//   }) async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     await getNote(id: note.id);

//     final updateCount = await db.update(
//       notesTable,
//       {
//         noteColumn: text,
//         syncColumn: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//     if (updateCount == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => updatedNote.id == note.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   Future<Iterable<DatabaseNotes>> getAllNotes() async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(notesTable);
//     return notes.map((rowIterator) => DatabaseNotes.fromRow(rowIterator));
//   }

//   Future<DatabaseNotes> getNote({required int id}) async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       notesTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNoteException();
//     } else {
//       final note = DatabaseNotes.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = await db.delete(notesTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletions;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       notesTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNoteException();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     //make sure the owner exists
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUserException();
//     }

//     const text = '';
//     final noteId = await db.insert(notesTable, {
//       userIdColumn: owner.id,
//       noteColumn: text,
//       syncColumn: 1,
//     });

//     final note = DatabaseNotes(
//       id: noteId,
//       userId: owner.id,
//       notes: text,
//       isSyncedToCloud: true,
//     );

//     _notes.add(note);
//     _notesStreamController.add(_notes);

//     return note;
//   }

//   //the following are the database user table functions

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     // await _ensuredbIsOpen();
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUserException {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFindUserException();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExistsException();
//     }
//     final userId = await db.insert(
//       userTable,
//       {emailColumn: email.toLowerCase()},
//     );
//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensuredbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     // await _ensuredbIsOpen();
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensuredbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) throw DatabaseAlreadyOpenException();
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       //create the user table
//       await db.execute(createUserTable);
//       // create the notes table
//       await db.execute(createNotesTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsException();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String notes;
//   final bool isSyncedToCloud;

//   DatabaseNotes({
//     required this.id,
//     required this.userId,
//     required this.notes,
//     required this.isSyncedToCloud,
//   });

//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         notes = map[noteColumn] as String,
//         isSyncedToCloud = (map[syncColumn] as int) == 1 ? true : false;

//   @override
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;

//   @override
//   String toString() {
//     return 'Note: id = $id,user_id=$userId,synced to cloud = $isSyncedToCloud,notes = $notes';
//   }
// }
