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

@property (retain, nonatomic) NSDate *currentDate;

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ShowNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteNameTextField.delegate = self;
    self.noteBofyTextView.delegate = self;
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
    
    NSInteger day = [weekdayComponents day];
    NSInteger weekday = [weekdayComponents weekday];
    
    self.currentDate = [[NSDate alloc] init];
    self.createdDate = self.currentDate;
    
    // Init DBase
    self.dbManager = [[DBManager alloc] initWithDBFilename:@"noteDB.sql"];
    
}


- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    
    // Prepare the query string
    NSString *query = [NSString stringWithFormat:@"insert into notes values(null, '%@', '%@', %f, %f)", self.noteNameTextField.text, self.noteBofyTextView.text, [self.createdDate timeIntervalSinceReferenceDate], [self.currentDate timeIntervalSinceReferenceDate]];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRow != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRow);
        
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
