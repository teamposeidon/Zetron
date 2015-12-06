//
//  CustomZetronTableViewCell.h
//  PPBlueTooth
//
//  Created by Jamaal Sedayao on 12/5/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomZetronTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *peerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;

@end
