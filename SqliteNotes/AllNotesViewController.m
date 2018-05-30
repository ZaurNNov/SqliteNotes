//
//  AllNotesViewController.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "AllNotesViewController.h"

@interface AllNotesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewNotes;
- (IBAction)addNew:(UIBarButtonItem *)sender;

@end

@implementation AllNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addNew:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"showNote" sender:sender];
}
@end
