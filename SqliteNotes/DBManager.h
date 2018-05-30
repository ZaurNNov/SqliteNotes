//
//  DBManager.h
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

-(instancetype)initWithDBFilename:(NSString *)dbName;
-(NSArray *)loadDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRow;
@property (nonatomic) long long lastInsertedRowID;

@end
