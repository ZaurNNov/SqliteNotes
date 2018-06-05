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

@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *editedDate;

@end

@implementation ShowNoteViewController

-(void)loadNote {
    [self updateSelfFieldsFromNote:self.noteData];
}

-(NoteData *)updateNoteFromFields {
    
    NoteData *newNote = [[NoteData alloc] init];
    newNote.noteName = self.noteNameTextField.text;
    newNote.noteBody = self.noteBofyTextView.text;
    newNote.createdDate = self.createdDate;
    newNote.editedDate = self.editedDate;
    self.noteData.editedDate = self.editedDate;
//    self.noteData.createdDate = self.createdDate;
    
    return newNote;
}

-(void)updateSelfFieldsFromNote:(NoteData *)note {
    
    NSString *es = [self setCustomStringFromDate:note.editedDate];
    NSString *cs = [self setCustomStringFromDate:note.createdDate];
    
    self.lastEditdateLabel.text = es;
    self.dateLabel.text = cs;
    self.noteNameTextField.text = note.noteName;
    self.noteBofyTextView.text = note.noteBody;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteNameTextField.delegate = self;
    self.noteBofyTextView.delegate = self;

    if (!self.noteData) {
        self.noteData = [[NoteData alloc] init];
    }
    
//    self.createdDate = [NSDate date];
    self.createdDate = self.noteData.createdDate;
    self.editedDate = self.noteData.editedDate;
    [self updateSelfFieldsFromNote:self.noteData];
}

- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    
    if ([self.noteNameTextField.text isEqualToString: @""] && self.noteNameTextField.text != nil) {
        self.noteNameTextField.text = @"template Notename";
    }
    
    self.noteData = [self updateNoteFromFields];
    self.noteData.editedDate = [NSDate date];
    
    if (self.recordNoteID == -1) {
        // save new note
        [[DBManager sharedInstance] saveNewNote:self.noteData];
    } else {
        // edit old note
        [[DBManager sharedInstance] saveOldNote:self.noteData withID:self.recordNoteID];
    }
    
    // inform delegate controller
    [self.selfDelegate updateData];
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
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



