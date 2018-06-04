//
//  DBManager.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "NSObject+customCategory.h"

@interface DBManager()

@property (nonatomic, strong) NSString *dd;
@property (nonatomic, strong) NSString *dbFilename;
@property (nonatomic, strong) NSMutableArray *resultMutableArray;

//-(void)copyDBIntoAppFolder;
//-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager

//Create Singleton
+(instancetype) sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;

    dispatch_once(&onceToken, ^{
        _sharedObject = [[super alloc] initUniqueInstance];
    });
    return _sharedObject;
}

//In it method
-(instancetype) initUniqueInstance {
    self = [super init];
    if(self)
        {
        //Do your custom initialization
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.dd = [paths objectAtIndex:0];
        
        self.dbFilename = @"noteDB.sql";
        [self copyDBIntoAppFolder];
        NSLog(@"DocumentsDirectory: %@", self.dd);
        }
    return self;
}

-(void)copyDBIntoAppFolder
{
    NSString *destinationPath = [self.dd stringByAppendingPathComponent:self.dbFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dbFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        if (error != nil) {
            NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            NSLog(@"%@", error.localizedDescription);
        }
    }
}

-(NSArray *)loadDB:(NSString *)query
{
    // the query string is converted to a char* object & returned the loaded result
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray *)self.resultMutableArray;
}

-(NSArray *)getAllNotedataArray {
    
    NSMutableArray *notes = [NSMutableArray new];
    
    NSString *query = @"select noteID, notename, notebody, notecreated, noteedit from notes order by noteedit asc";
    
    NSString *databasePath = [self.dd stringByAppendingPathComponent:self.dbFilename];
    
    sqlite3 *sqlite3Database;
    // Open the database.
    if((sqlite3_open([databasePath UTF8String], &sqlite3Database) == SQLITE_OK)) {
        
        sqlite3_stmt *compiledStatement;
        if((sqlite3_prepare_v2(sqlite3Database, [query UTF8String], -1, &compiledStatement, NULL)) == SQLITE_OK) {
            
            NoteData *note;
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                note = [[NoteData alloc] init];
                note.noteID = sqlite3_column_int(compiledStatement, 0);
                char *dbDataAsCharsName = (char *)sqlite3_column_text(compiledStatement, 1);
                char *dbDataAsCharsBody = (char *)sqlite3_column_text(compiledStatement, 2);
                
                if (dbDataAsCharsName != NULL) {
                    note.noteName = [NSString stringWithUTF8String:dbDataAsCharsName];
                }
                
                if (dbDataAsCharsBody != NULL) {
                    note.noteBody = [NSString stringWithUTF8String:dbDataAsCharsBody];
                }
                
                double cd = sqlite3_column_double(compiledStatement, 3);
                double ed = sqlite3_column_double(compiledStatement, 4);
                note.createdDate = [self dateFromTime:cd];
                note.editedDate = [self dateFromTime:ed];
                
                [notes addObject:note];
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    // close connection
    sqlite3_close(sqlite3Database);
    
    return notes;
}

-(int)getCurrentNoteId {
    int lastNoteId = 0;
    
    NSString *query = @"select noteID from notes order by noteID asc";
    
    NSString *databasePath = [self.dd stringByAppendingPathComponent:self.dbFilename];
    
    sqlite3 *sqlite3Database;
    // Open the database.
    if((sqlite3_open([databasePath UTF8String], &sqlite3Database) == SQLITE_OK)) {
        
        sqlite3_stmt *compiledStatement;
        if((sqlite3_prepare_v2(sqlite3Database, [query UTF8String], -1, &compiledStatement, NULL)) == SQLITE_OK) {
            
            //NoteData *note;
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
               lastNoteId = sqlite3_column_int(compiledStatement, 0);
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    // close connection
    sqlite3_close(sqlite3Database);
    
    return (lastNoteId);
}

-(void)executeQuery:(NSString *)query
{
    // run the query and indicate that is executable
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

-(void)deleteNoteWithID:(int)deleteID {
    // Delete selected row
    
    // prepare the query
    NSString *queryString = [NSString stringWithFormat:@"delete from notes where noteID=%d", deleteID];
    const char* query = [queryString UTF8String];
    
    // Create a sqlite object & path
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.dd stringByAppendingPathComponent:self.dbFilename];
    
    // Open the database.
    if((sqlite3_open([databasePath UTF8String], &sqlite3Database) == SQLITE_OK)) {
        
        sqlite3_stmt *compiledStatement;
        if((sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL)) == SQLITE_OK) {
            
            if(sqlite3_step(compiledStatement) == SQLITE_OK) {
                NSLog(@"row %d delete!", deleteID);
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    // close connection
    sqlite3_close(sqlite3Database);
}

-(void)clearAll {
    
    int count = [self getCurrentNoteId];
    for (int i = 0; i <= count; i++) {
        [self deleteNoteWithID:i];
    }
    
    NSLog(@"%d notes was delete!", count);
}

-(void)saveNewNote:(NoteData *)note {
    // for create new
    NSString *query = [NSString stringWithFormat:@"insert into notes values(null, '%@', '%@', %f, %f)", note.noteName, note.noteBody, [note.createdDate timeIntervalSinceReferenceDate], [note.editedDate timeIntervalSinceReferenceDate]];
    
    // Execute the query.
    [self executeQuery:query];
}

-(void)saveOldNote:(NoteData *)note withID:(uint)noteId {
    NoteData *oldNote = note;
    oldNote.noteID = noteId;
    [self runUpdateQueryNote:(NoteData *) oldNote];
}

-(void)runUpdateQueryNote:(NoteData *)note {
    
    NSString *queryString = [NSString stringWithFormat:@"update notes set notename='%@', notebody='%@', notecreated=%f, noteedit=%f where noteID=%d", note.noteName, note.noteBody, [note.createdDate timeIntervalSinceReferenceDate], [note.editedDate timeIntervalSinceReferenceDate], note.noteID];
    
    const char* query = [queryString UTF8String];
    
    // Create a sqlite object & path
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.dd stringByAppendingPathComponent:self.dbFilename];
    
    // Open the database.
    if((sqlite3_open([databasePath UTF8String], &sqlite3Database) == SQLITE_OK)) {
        
        sqlite3_stmt *compiledStatement;
        if((sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL)) == SQLITE_OK) {
            
            if(sqlite3_step(compiledStatement) == SQLITE_OK) {
                
                // For text and tade time
                // SQLITE_API int sqlite3_bind_text(sqlite3_stmt*,int,const char*,int,void(*)(void*));
                // SQLITE_API int sqlite3_bind_double(sqlite3_stmt*, int, double);
                
                const char *charsName = [note.noteName UTF8String];
                const char *charsBody = [note.noteBody UTF8String];
                double cd = [self dateDoubleFromDate:note.createdDate];
                double ed = [self dateDoubleFromDate:note.editedDate];
                
                
                sqlite3_bind_text(compiledStatement, 1, charsName, -1, NULL);
                sqlite3_bind_text(compiledStatement, 2, charsBody, -1, NULL);
                sqlite3_bind_double(compiledStatement, 3, cd);
                sqlite3_bind_double(compiledStatement, 4, ed);
                
                sqlite3_step(compiledStatement);
            }
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    // close connection
    sqlite3_close(sqlite3Database);
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable
{
    // Create a sqlite object & path
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.dd stringByAppendingPathComponent:self.dbFilename];
    
    // Initialize the results & column names arrays.
    self.resultMutableArray = [[NSMutableArray alloc] init];
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    // Open the database.
    if((sqlite3_open([databasePath UTF8String], &sqlite3Database) == SQLITE_OK)) {
        // Declare a sqlite3_stmt object & load all data from database to memory.
        sqlite3_stmt *compiledStatement;
        if((sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL)) == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable) {
                // In this case data must be loaded from the database.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    arrDataRow = [[NSMutableArray alloc] init];
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);

                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.resultMutableArray addObject:arrDataRow];
                    }
                }
            } else {
                // This is the case of an executable query (insert, update, ...).
                
                if ((sqlite3_step(compiledStatement)) == SQLITE_DONE) {
                    // Keep the affected rows & last inserted row ID.
                    self.affectedRow = sqlite3_changes(sqlite3Database);
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                } else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        } else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}


@end
