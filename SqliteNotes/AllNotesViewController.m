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

//@property (strong, nonatomic) NSDate *createdDate;
//@property (strong, nonatomic) NSDate *currentDate;
@property (nonatomic) int recordNoteID;
@property (nonatomic, strong) NoteData *notedata;
@property (nonatomic, strong) NSArray *allNotes;
@property (nonatomic, strong) NSArray *allNotes2;

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
    self.notedata = [[NoteData alloc] init];
    
    // load the data
    [self updateData];
}

-(void)loadData {
    self.allNotes = [[DBManager sharedInstance] getAllNotedataArray];
    [self.tableViewNotes reloadData];
}


- (IBAction)addNew:(UIBarButtonItem *)sender {
    // Before performing the segue, set the -1 value
    self.recordNoteID = -1;
    self.notedata = [self prepareNewNote];
    // Perform the segue.
    [self performSegueWithIdentifier:@"detailNote" sender:self];
}

-(NoteData *)prepareNewNote {
    
    NoteData *note = [[NoteData alloc] init];
    NSDate *editedDate = [NSDate date];
    NSDate *createdDate = editedDate;
    
    note.noteName = nil;
    note.noteBody = nil;
    note.createdDate = createdDate;
    note.editedDate = editedDate;
    
    return note;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowNoteViewController *snVC = [segue destinationViewController];
    snVC.selfDelegate = self;
    snVC.noteData = self.notedata;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

// TableView VC delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allNotes.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ///DBG
    NoteData *note = self.allNotes[indexPath.row];
    NSLog(@"\n%@, %@, %u, %@, %@\n", note.noteName, note.noteBody, note.noteID, note.editedDate, note.createdDate);
    
    cell.textLabel.text = note.noteName;
//    cell.detailTextLabel.text = note.noteBody;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete selected row
        DBManager *db = [DBManager sharedInstance];
        
        int recordIDToDelete = [[[self.allNotes objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // prepare the query
        NSString *query = [NSString stringWithFormat:@"delete from notes where noteID=%d", recordIDToDelete];
        [db executeQuery:query];
        
        // reload tableView
        [self updateData];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Get the record ID
    int recordID = [[[self.allNotes objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    self.notedata.noteName = [[self.allNotes objectAtIndex:indexPath.row] objectAtIndex:1];
    self.notedata.noteBody = [[self.allNotes objectAtIndex:indexPath.row] objectAtIndex:2];
    self.notedata.editedDate = [NSDate date];

    self.recordNoteID = recordID;
    
    // Prepare edit segue
    [self performSegueWithIdentifier:@"detailNote" sender:self];
}

//-(NSDate *)dateFromTime:(double)time {
//    NSDate *dateCreated = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
//    return dateCreated;
//}

@end
