//
//  RulesViewController.m
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/16/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "RulesViewController.h"

@interface RulesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *gotItButton;

@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gotItButton.layer.shadowOpacity = 1.0;
    
    self.gotItButton.layer.masksToBounds = NO;
    self.gotItButton.layer.shadowColor = [UIColor yellowColor].CGColor;
    self.gotItButton.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.gotItButton.layer.shadowRadius = 20.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneRulesButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
