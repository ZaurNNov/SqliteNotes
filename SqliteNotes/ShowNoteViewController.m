//
//  ShowNoteViewController.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 30/05/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "ShowNoteViewController.h"

@interface ShowNoteViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBofyTextView;
- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender;

@end

@implementation ShowNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)saveBarButtonAction:(UIBarButtonItem *)sender {
    
}

@end
