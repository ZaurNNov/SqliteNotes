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
@property (weak, nonatomic) IBOutlet UILabel *lastEditdateLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBofyTextView;
- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender;

@property (retain, nonatomic) NSDate *currentDate;
@property (nonatomic, strong) DBManager *dbManager;

-(void)loadNote;

@end

@implementation ShowNoteViewController

-(void)loadNote {
    // Create query & array
    NSString *query = [NSString stringWithFormat:@"select * from notes where noteID=%d", self.recordNoteID];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDB:query]];
    
    //The time & text input
    double timeCreated = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notecreated"]] doubleValue];
    double timeEdited = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"noteedit"]] doubleValue];
    NSString *name = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notename"]];
    NSString *body = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notebody"]];
    
    // Set the loaded data to the textfields.
    [self previewDataForDateLabel:[self formattedDataFromDbase:timeCreated]
                lastEditLabelText:[self formattedDataFromDbase:timeEdited]
                     noteNameText: name
                     noteBodyText: body];
}

-(NSString *)formattedDataFromDbase:(double)time {
    //Example:
    //double timeCreated = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notecreated"]] doubleValue];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"YYYY-MM-dd HH:MM:ss";
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    //NSLog(@"Time NSDateFormatter: %@", [dateFormat stringFromDate:[self dateFromTime:time]]);
    return [dateFormat stringFromDate:[self dateFromTime:time]];
}

-(NSDate *)dateFromTime:(double)time {
    NSDate *dateCreated = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    return dateCreated;
}

-(void)previewDataForDateLabel:(NSString* )dateLabelText lastEditLabelText:(NSString *)lastEditText noteNameText:(NSString *)noteName noteBodyText:(NSString *)bodyText {
    // Set the loaded data to the textfields.
    self.dateLabel.text = dateLabelText;
    self.lastEditdateLabel.text = lastEditText;
    self.noteNameTextField.text = noteName;
    self.noteBofyTextView.text = bodyText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteNameTextField.delegate = self;
    self.noteBofyTextView.delegate = self;
    
    self.currentDate = [[NSDate alloc] init];
    if (!self.createdDate) {
        self.createdDate = self.currentDate;
    }
    
    // Init DBase
    self.dbManager = [[DBManager alloc] initWithDBFilename:@"noteDB.sql"];
    
    // Check new note or editing.
    if (self.recordNoteID != -1) {
        // Load the record with the specific ID from the database.
        [self loadNote];
    } else {
        [self previewDataForDateLabel:[self formattedDataFromDbase:[self.createdDate timeIntervalSinceReferenceDate]]
                    lastEditLabelText:[self formattedDataFromDbase:[self.currentDate timeIntervalSinceReferenceDate]]
                         noteNameText:nil noteBodyText:@"Enter some note text..."];
    }
}

- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    
    if ([self.noteNameTextField.text isEqualToString: @""] && self.noteNameTextField.text != nil) {
        self.noteNameTextField.text = @"template Notename";
    }
    
    // If record ID has property - update Dbase, else create new row
    // Prepare the query string
    NSString *query;
    if (self.recordNoteID == -1) {
        query = [NSString stringWithFormat:@"insert into notes values(null, '%@', '%@', %f, %f)", self.noteNameTextField.text, self.noteBofyTextView.text, [self.createdDate timeIntervalSinceReferenceDate], [self.currentDate timeIntervalSinceReferenceDate]];
    } else {
        query = [NSString stringWithFormat:@"update notes set notename='%@', notebody='%@', notecreated=%f, noteedit=%f where noteID=%d", self.noteNameTextField.text, self.noteBofyTextView.text, [self.createdDate timeIntervalSinceReferenceDate], [self.currentDate timeIntervalSinceReferenceDate], self.recordNoteID];
    }
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRow != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRow);
        
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

//    NSDate *today = [NSDate date];
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *weekdayComponents =
//    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
//    NSInteger day = [weekdayComponents day];
//    NSInteger weekday = [weekdayComponents weekday];
