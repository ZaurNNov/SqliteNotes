//
//  ShowNoteViewController.h
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowNoteViewControllerDelegate

-(void)updateData;

@end

@interface ShowNoteViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, ShowNoteViewControllerDelegate>

@property (nonatomic, strong) id<ShowNoteViewControllerDelegate> selfDelegate;


@end
