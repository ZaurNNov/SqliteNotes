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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;

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
    
    self.createdDate = self.noteData.createdDate;
    self.editedDate = self.noteData.editedDate;
    [self updateSelfFieldsFromNote:self.noteData];
    
    // disable save button
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self changeBuckBarButton];
}

- (void)saveChangesNote {
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
}

-(BOOL)noteChanged {
    
    BOOL bodyTextChanged = ![self textFrom:self.noteData.noteBody isEqual:self.noteBofyTextView.text];
    BOOL nameTextChanged = ![self textFrom:self.noteData.noteName isEqual:self.noteNameTextField.text];
    
    if (bodyTextChanged || nameTextChanged) return YES;
    
    return NO;
}

-(BOOL)textFrom:(NSString *)text isEqual:(id)viewTextParametr {
    if ([text isEqualToString:viewTextParametr]) {
        return YES;
    }
    return NO;
}

- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    
    [self saveChangesNote];
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self autoHideSaveBarButton];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self autoHideSaveBarButton];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self autoHideSaveBarButton];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self autoHideSaveBarButton];
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self autoHideSaveBarButton];
    return YES;
}

-(void)updateData {
    // signal for delegate
    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

// Alert action
- (void)noteHasChangesAlert {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Data changed!"
                                 message:@"Are You Sure Want to Update Current Note?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [self saveChangesNote];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Back without changes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"Alert closed");
    }];
}

-(void)autoHideSaveBarButton {
    // save as new note with new edited date
    self.navigationItem.rightBarButtonItem.enabled = [self noteChanged];
}

-(void)changeBuckBarButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Notes"
                                                                              style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(backButtonTapped)];
}

-(void)backButtonTapped {
    NSLog(@"   ===   AAAAAAAAAAAAAAAAAAAA   ===   ");
    if ([self noteChanged]) {
        [self noteHasChangesAlert];
    }
    
    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
}





@end



