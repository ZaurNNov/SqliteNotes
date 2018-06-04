//
//  DBManager.h
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteData.h"

@interface DBManager : NSObject

//-(instancetype)initWithDBFilename:(NSString *)dbName;
-(NSArray *)loadDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

-(void)saveNewNote:(NoteData *)note;
-(void)saveOldNote:(NoteData *)note withID:(uint)noteId;
//-(void)saveOldNote:(NoteData *)note;

-(NSArray *)getAllNotedataArray;
-(int)getCurrentNoteId;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRow;
@property (nonatomic) long long lastInsertedRowID;

+(instancetype) sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));
-(instancetype) copy __attribute__((unavailable("copy not available, call sharedInstance instead")));

@end
