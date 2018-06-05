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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *eraseAllButton;
- (IBAction)eraseAllAction:(UIBarButtonItem *)sender;

//@property (strong, nonatomic) NSDate *createdDate;
//@property (strong, nonatomic) NSDate *currentDate;
@property (nonatomic) int recordNoteID;
@property (nonatomic, strong) NoteData *notedata;
@property (nonatomic, strong) NSArray *allNotes;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // load the data
    [self updateData];
}

-(void)loadData {
    self.allNotes = [[DBManager sharedInstance] getAllNotedataArray];
    
    if (self.allNotes.count > 0) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    
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
    
    NSDate *createdDate = [NSDate date];
    NSDate *editedDate = [NSDate date];
    
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
    snVC.recordNoteID = self.recordNoteID;
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
    
    NoteData *note = self.allNotes[indexPath.row];
    NSLog(@"\n%@, %@, %u, %@, %@\n", note.noteName, note.noteBody, note.noteID, note.editedDate, note.createdDate);
    
    cell.textLabel.text = note.noteName;
    cell.detailTextLabel.text = note.noteBody;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete selected row
        
        NoteData *note = self.allNotes[indexPath.row];
        [[DBManager sharedInstance] deleteNoteWithID:note.noteID];

        // reload tableView
        [self updateData];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    self.notedata = [self.allNotes objectAtIndex:indexPath.row];
    self.recordNoteID = self.notedata.noteID;

    // Prepare edit segue
    [self performSegueWithIdentifier:@"detailNote" sender:self];
}

- (IBAction)eraseAllAction:(UIBarButtonItem *)sender {
    [[DBManager sharedInstance] clearAll];
    
    // load the data
    [self updateData];
}
@end
