// const dbName = 'notes.db';
// const notesTable = 'notes';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const noteColumn = 'notes';
// const syncColumn = 'is_synced_to_cloud';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//         "id"	INTEGER NOT NULL,
//         "email"	TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
// const createNotesTable = '''CREATE TABLE IF NOT EXISTS "notes" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "notes"	TEXT,
//         "is_synced_to_cloud"	INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT),
//         PRIMARY KEY("notes")
//       );''';
