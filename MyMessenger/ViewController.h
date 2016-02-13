//
//  ViewController.h
//  MyMessenger
//
//  Created by xtol bruce on 2/11/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberListViewController;
@class SetupViewController;

@interface ViewController : UITabBarController <UITabBarControllerDelegate>
-(void)Login:(NSString*)pUser Password:(NSString*)pPass;
@property(strong,nonatomic) MemberListViewController *pMemberListViewController;
@property(strong,nonatomic) SetupViewController *pSetupViewController;
@property(strong,nonatomic) NSString *pUserId;


@end

