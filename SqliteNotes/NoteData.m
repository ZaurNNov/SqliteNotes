//
//  NoteData.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 31/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "NoteData.h"
#import "DBManager.h"

@interface NoteData()


@end

@implementation NoteData

-(instancetype)initWithNoteName:(NSString *)noteName
                       noteBody:(NSString *)noteBody
                    createdDate:(NSDate *)createdDate
                     editedDate:(NSDate *)editedDate {
    
    self = [super init];
    
    if (self) {
        _noteName = [noteName copy];
        _noteBody = [noteBody copy];
        _createdDate = [createdDate copy];
        _editedDate = [editedDate copy];
    }
    
    return self;
}

- (instancetype)initWithNoteDates {
    
    self = [super init];
    if (self) {
        _createdDate = [NSDate date];
        _editedDate = [NSDate date];
    }
    
    return self;
}

@end
