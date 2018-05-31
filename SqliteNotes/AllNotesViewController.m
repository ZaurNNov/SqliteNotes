//
//  AllNotesViewController.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "AllNotesViewController.h"
#import "DBManager.h"
#import "ShowNoteViewController.h"
#import "NoteData.h"

@interface AllNotesViewController () <ShowNoteViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewNotes;
- (IBAction)addNew:(UIBarButtonItem *)sender;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrayFromDB;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSDate *currentDate;
@property (nonatomic) int recordNoteID;
@property (nonatomic, strong) NoteData *notedata;

-(void)loadData;

@end

@implementation AllNotesViewController

-(void)updateData {
    // load the data
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableVC
    self.tableViewNotes.delegate = self;
    self.tableViewNotes.dataSource = self;
    
    // dbase & note class init
    self.dbManager = [DBManager sharedInstance];
    self.notedata = [[NoteData alloc] init];
    
    // load the data
    [self updateData];
}

-(void)loadData {
    
    // query string
    NSString *query = @"select * from notes";
    
    // get result
    if (self.arrayFromDB) self.arrayFromDB = nil;
    
    self.arrayFromDB = [[NSArray alloc] initWithArray:[self.dbManager loadDB:query]];
    [self.tableViewNotes reloadData];
}


- (IBAction)addNew:(UIBarButtonItem *)sender {
    // Before performing the segue, set the -1 value
    self.recordNoteID = -1;
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"detailNote" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowNoteViewController *snVC = [segue destinationViewController];
    snVC.selfDelegate = self;
    if (!self.createdDate) {
        self.createdDate = [[NSDate alloc] init];
    }
    snVC.createdDate = self.createdDate;
    snVC.recordNoteID = self.recordNoteID;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

// TableView VC delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayFromDB.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger indexOfNotename = [self.dbManager.arrColumnNames indexOfObject:@"notename"];
    NSInteger indexOfNoteID = [self.dbManager.arrColumnNames indexOfObject:@"noteID"];
    NSInteger indexOfNotebody = [self.dbManager.arrColumnNames indexOfObject:@"notebody"];
    //    NSInteger indexOfNotecreated = [self.dbManager.arrColumnNames indexOfObject:@"notecreated"];
    //    NSInteger indexOfNoteedit = [self.dbManager.arrColumnNames indexOfObject:@"noteedit"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",
                           [[self.arrayFromDB objectAtIndex:indexPath.row] objectAtIndex:indexOfNotename]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %@. %@",
                                 [[self.arrayFromDB objectAtIndex:indexPath.row] objectAtIndex:indexOfNoteID],
                                 [[self.arrayFromDB objectAtIndex:indexPath.row] objectAtIndex:indexOfNotebody]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete selected row
        int recordIDToDelete = [[[self.arrayFromDB objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // prepare the query
        NSString *query = [NSString stringWithFormat:@"delete from notes where noteID=%d", recordIDToDelete];
        [self.dbManager executeQuery:query];
        
        // reload tableView
        [self updateData];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Get the record ID
    self.recordNoteID = [[[self.arrayFromDB objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    double dateDoudle = [[[self.arrayFromDB objectAtIndex:indexPath.row] objectAtIndex:3] floatValue];
    self.createdDate = [self dateFromTime:dateDoudle];
    
    // Prepare edit segue
    [self performSegueWithIdentifier:@"detailNote" sender:self];
}

-(NSDate *)dateFromTime:(double)time {
    NSDate *dateCreated = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    return dateCreated;
}

@end
