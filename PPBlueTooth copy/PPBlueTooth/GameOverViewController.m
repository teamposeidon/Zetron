//
//  GameOverViewController.m
//  PPBlueTooth
//
//  Created by Jamaal Sedayao on 11/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameResultsView;

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameResultsView.layer.cornerRadius = 4.0f;
    
    if ([self.gameEndStatus isEqualToString:@"central"]){
        self.gameEndLabel.text = @"You have survived The Zetron Virus!";
        self.gameEndLabel.textColor = [UIColor greenColor];
        
    } else if ([self.gameEndStatus isEqualToString:@"peripheral"]){
        
        self.gameEndLabel.text = @"Zetron!!! Continue To Infect Benign Systems!";
        self.gameEndLabel.textColor = [UIColor redColor];
    }
    // Do any additional setup after loading the view.
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
