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
@property (weak, nonatomic) IBOutlet UIImageView *borderFrame;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

// Timer for Shadow
@property (nonatomic) BOOL countDown;
@property (nonatomic) double counter;

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
    
    [self setupSpriteView];
    
    // Setup drop shadow
    [self setUpDropShadowSideBar];

}

- (void)setupSpriteView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SpriteView" owner:self options:nil];
    SpriteView *spriteView = [views firstObject];
    
    //    spriteView.showsDrawCount = YES;
    //    spriteView.showsFPS = YES;
    //    spriteView.showsNodeCount = YES;
    spriteView.frameInterval = 2;
    spriteView.backgroundColor = [SKColor clearColor];
    
    //adding new view container
    
    UIView *rulesViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 375, 375, 60)];
    rulesViewContainer.layer.borderColor = [UIColor clearColor].CGColor;
    rulesViewContainer.layer.borderWidth = 2.0;
    
    [self.view addSubview:rulesViewContainer];
    [rulesViewContainer addSubview:spriteView];
    
    //set up game scene
    
    RulesScene *newScene = [[RulesScene alloc] initWithSize:CGSizeMake(375, 110)];
    [spriteView presentScene:newScene];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneRulesButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark
#pragma mark - Drop Shadow Side Bar
- (void)setUpDropShadowSideBar {
    
    // Side Bar Timer Animation
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.09
                                                  target:self
                                                selector:@selector(updateShadowTimer)
                                                userInfo:nil
                                                 repeats:YES];
    
    [timer fire];
    
    self.counter = 2.0;
    self.countDown = NO;
    
    // Side Bar Setup Drop Shadow
    [self dropShadowSideBar:self.borderFrame];
    
    // Setup the background animation
    [self animationChangeBGLogo];
}

- (void)dropShadowSideBar:(UIView *)glowView {
    glowView.layer.masksToBounds = NO;
    glowView.layer.shadowColor = [UIColor yellowColor].CGColor;
    glowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    glowView.layer.shadowRadius = 10.0f;
    glowView.layer.shadowOpacity = 1.0f;
}

- (void)updateShadowTimer {
    NSString *num = [NSString stringWithFormat:@"0.%f",self.counter];
    float opacity = [num floatValue];
    
    if (self.countDown == NO){
        self.counter++;
        if (self.counter == 9) {
            
            self.countDown = YES;
        }
    } else if (self.countDown == YES){
        self.counter--;
        if (self.counter == 2){
            self.countDown = NO;
        }
    }
    
    self.borderFrame.layer.shadowOpacity = opacity;
}

#pragma mark
#pragma mark - Show Animation BG
- (void)animationChangeBGLogo {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 8; i++){
        NSString *object = [NSString stringWithFormat:@"tmp-%d", i];
        [tempArray addObject:[UIImage imageNamed:object]];
    }
    
    NSArray *animationFrames = [NSArray arrayWithArray:tempArray];
    
    
    self.backgroundView.animationDuration = 0.6;
    self.backgroundView.animationImages = animationFrames;
    
    //    [self.view addSubview:self.zetronMainLogo];
    [self.backgroundView startAnimating];
    
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
