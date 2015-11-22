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
UITableViewDelegate,
MCSessionDelegate
>

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSLog(@"Session: %@",self.session);
    
    NSLog(@"Connected Peers: %@", self.session.connectedPeers);
    
    NSMutableArray *player = [PlayerManager sharedInstance].player;
    
    NSLog(@"My player: %@", player);


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2 ;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section==0)
//    {
//        return [array1 count];
//    }
//    else{
//        return [array2 count];
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if(section == 0)
//        return @"Section 1";
//    else
//        return @"Section 2";
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
//    if (indexPath.section==0) {
//        ObjectData *theCellData = [array1 objectAtIndex:indexPath.row];
//        NSString *cellValue =theCellData.category;
//        cell.textLabel.text = cellValue;
//    }
//    else {

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
