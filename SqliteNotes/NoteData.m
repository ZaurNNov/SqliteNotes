//
//  NoteData.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 31/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "NoteData.h"

@interface NoteData()

//@property (nonatomic, strong) NSString *noteName;
//@property (nonatomic, strong) NSString *noteBody;
//@property (nonatomic, strong) NSDate *createdDate;
//@property (nonatomic, strong) NSDate *editedDate;
//@property (nonatomic) NSInteger noteID;

@end

@implementation NoteData

- (instancetype)initWithNoteName:(NSString *)noteName
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


@end
