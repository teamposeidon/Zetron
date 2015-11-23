//
//  GameOverViewController.m
//  PPBlueTooth
//
//  Created by Jamaal Sedayao on 11/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()
<
UITableViewDataSource,
UITableViewDelegate
//MCSessionDelegate
>
@property (strong, nonatomic) IBOutlet UITableView *gameTableView;
@property (nonatomic) NSMutableArray * healthyPlayers;

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.gameTableView.delegate = self;
    self.gameTableView.dataSource = self;
    
    NSLog(@"Session: %@",self.session);
    NSLog(@"Connected Peers: %@", self.session.connectedPeers);
    NSMutableArray *player = [PlayerManager sharedInstance].player;
    NSLog(@"My player: %@", player);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0){
        return 1;
    } else {
        //return self.healthyPlayers.count;
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"Zetron";
    } else {
        return @"Cyber-Devs";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.section==0) {
//        ObjectData *theCellData = [array1 objectAtIndex:indexPath.row];
//        NSString *cellValue =theCellData.category;
        cell.textLabel.text = @"Zetron";
    } else {
//        ObjectData *theCellData = [array2 objectAtIndex:indexPath.row];
//        NSString *cellValue =theCellData.category;
        cell.textLabel.text = @"Cyber-Dev";
    }
    return cell;
}

/*
 NSDictionary *dict = @{@"key1" : @"value1", @"key2" : @"value2", @"key3" : @"value3"};
 for (NSString *key in [dict allKeys]) {
 [self setValue:dict[key] forKey:key];
 }
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
