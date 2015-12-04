//
//  PoseidonProjectViewController.m
//  PPBlueTooth
//
//  Created by Fatima Zenine Villanueva on 11/15/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "PoseidonProjectViewController.h"
#import "StartScreenVC.h"

@interface PoseidonProjectViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *poseidonLogo;
@property (weak, nonatomic) IBOutlet UIImageView *projectLogo;
@property (weak, nonatomic) IBOutlet UIWebView *ppLogoWebView;
@property (nonatomic) NSString *pathImage;
@property (weak, nonatomic) IBOutlet UIView *ppLogoOneView;
@property (weak, nonatomic) IBOutlet UIView *ppLogoTwoView;
@property (nonatomic) NSInteger seconds;
@property (nonatomic,strong) NSTimer *countdownTimer;


@end

@implementation PoseidonProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
    self.seconds = 5;
}
-(void)countDown {
    self.seconds--;
    if (self.seconds == 0) {
        [self.countdownTimer invalidate];
        [self performSegueWithIdentifier:@"PushToStartScreen" sender:self];    }
}


- (void) uiFontStuff {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self settingTheAnimatedBackground];
    
    [self showAnimation];
}

- (void)settingTheAnimatedBackground {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"poseidon" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL *nullURL = nil;
    NSString *nullEncodingName = nil;
    
    [webViewBG loadData:gif
               MIMEType:@"image/gif"
       textEncodingName:nullEncodingName
                baseURL:nullURL];
    NSInteger height = 300;
    NSInteger heightPosition = self.view.frame.size.height - height + 50;
    webViewBG.userInteractionEnabled = NO;
    self.ppLogoWebView = webViewBG;
    self.ppLogoWebView.frame = CGRectMake(0.0,
                                        heightPosition,
                                          self.view.frame.size.width,
                                          height);
    
    [self.view addSubview:self.ppLogoWebView];
}

-(void)showAnimation {
    
    [self.view addSubview:self.ppLogoOneView];
    [self.view addSubview:self.ppLogoTwoView];

    self.ppLogoOneView.frame =  CGRectMake(-300,
                                           0,
                                           self.view.frame.size.width,
                                           100);
    
    self.ppLogoTwoView.frame =  CGRectMake(600,
                                           100,
                                           self.view.frame.size.width,
                                           100);

    [UIView animateWithDuration:5.0
                     animations:^{
                         self.ppLogoOneView.frame = CGRectMake(0,
                                                               0,
                                                               self.view.frame.size.width,
                                                               100);
                     }];
    
    [UIView animateWithDuration:5.0
                     animations:^{
                         self.ppLogoTwoView.frame = CGRectMake(0,
                                                               100,
                                                               self.view.frame.size.width,
                                                               100);
                     }];
}
- (void) pushToStartScreen {
    
//    StartScreenVC *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"StartScreen"];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
    
//    StartScreenVC *viewController = [[StartScreenVC alloc] init];
//    [self presentViewController:viewController animated:YES completion:nil];
//    
//    
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
