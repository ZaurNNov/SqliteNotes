//
//  ShowNoteViewController.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "ShowNoteViewController.h"
#import "DBManager.h"

@interface ShowNoteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBofyTextView;
- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender;

@end

@implementation ShowNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteNameTextField.delegate = self;
    self.noteBofyTextView.delegate = self;
}


- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

-(void)updateData {
    // signal for delegate
    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
