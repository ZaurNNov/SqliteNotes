//
//  ShowNoteViewController.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "ShowNoteViewController.h"
#import "DBManager.h"
#import "NSObject+customCategory.h"

@interface ShowNoteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastEditdateLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBofyTextView;
- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender;

//-(void)loadNote;

@end

@implementation ShowNoteViewController

-(void)loadNote {
//    DBManager *db = [DBManager sharedInstance];
    [self updateSelfFieldsFromNote:self.noteData];
}

-(NoteData *)updateNoteFromFields {
    
    NoteData *note = [[NoteData alloc] init];
    NSDate *editedDate = [self dateFromText:self.dateLabel.text];
    NSDate *createdDate = [self dateFromText:self.lastEditdateLabel.text];
    
    note.noteName = self.noteNameTextField.text;
    note.noteBody = self.noteBofyTextView.text;
    note.createdDate = createdDate;
    note.editedDate = editedDate;
    
    return note;
}

-(void)updateSelfFieldsFromNote:(NoteData *)note {
    
    NSString *es = [self dateFofmattedFromDate:note.editedDate];
    NSString *cs = [self dateFofmattedFromDate:note.createdDate];
    
    self.lastEditdateLabel.text = es;
    self.dateLabel.text = cs;
    self.noteNameTextField.text = note.noteName;
    self.noteBofyTextView.text = note.noteBody;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteNameTextField.delegate = self;
    self.noteBofyTextView.delegate = self;
    self.noteData = [[NoteData alloc] init];

    if (!self.noteData) {
        self.noteData = [[NoteData alloc] init];
    }
    
    [self updateSelfFieldsFromNote:self.noteData];
}

- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    
    if ([self.noteNameTextField.text isEqualToString: @""] && self.noteNameTextField.text != nil) {
        self.noteNameTextField.text = @"template Notename";
    }

    DBManager *db = [DBManager sharedInstance];
    
    if (self.recordNoteID == -1) {
        
        self.noteData = [self updateNoteFromFields];
        [db saveNote:self.noteData];
        
    } else {
        [self updateNoteFromFields];
        [db saveNoteWithID:self.recordNoteID note:self.noteData];
    }
    
    // If the query was successfully executed then pop the view controller.
    if (db.affectedRow != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", db.affectedRow);
        
        // inform delegate controller
        [self.selfDelegate updateData];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        NSLog(@"Could not execute the query.");
    }

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



