//
//  TableViewCell.h
//  MyMessenger
//
//  Created by xtol bruce on 2/11/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property(weak,nonatomic) IBOutlet UIImageView *pImageView;
@property(weak,nonatomic) IBOutlet UILabel *pNameView;
@property(weak,nonatomic) IBOutlet UILabel *pContextView;
@property(weak,nonatomic) IBOutlet UIImageView *pBackImageView;

@end
