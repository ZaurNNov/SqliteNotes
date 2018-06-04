//
//  NoteData.h
//  SqliteNotes
//
//  Created by Zaur Giyasov on 31/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteData : NSObject

@property (nonatomic, unsafe_unretained) uint noteID;
@property (nonatomic, strong) NSString *noteName;
@property (nonatomic, strong) NSString *noteBody;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *editedDate;


@end
