//
//  MemberListViewController.h
//  MyMessenger
//
//  Created by xtol bruce on 2/11/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatViewController;
@class NetworkContoller;

@interface MemberListViewController : UIViewController
{
    
    ChatViewController *pChatViewController;
    NetworkContoller *pNetworkContoller;
    
}

-(void)ChatViewShow;
-(void)ServerConnect:(NSString *)pUserID PassWord:(NSString*)pPassword;

@property(weak,nonatomic) IBOutlet UITableView *pListView;
@property(weak,nonatomic) ChatViewController *pChatViewController;
@property(weak,nonatomic) NetworkContoller *pNetworkContoller;

@end
