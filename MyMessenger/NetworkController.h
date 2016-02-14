//
//  NetworkController.h
//  MyMessenger
//
//  Created by xtol bruce on 2/12/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberListViewController;
@class ChatViewController;

@interface NetworkController : UIViewController
{
    NSString *pMyUserID;
    NSString *pMyPassword;
    
    NSMutableArray *pMemberListData;
    NSMutableArray *pChatData;
    
    MemberListViewController *pMemberListViewController;
    ChatViewController *pChatViewController;
    
    //socket functions
    CFSocketRef pSocket;
    CFRunLoopSourceRef pRunSource;
    NSMutableData *pReturnData; // ????
    NetworkController *pNetworkController;
    int pStatus;
    int pChatTargetIndex;
    
}

@property(strong,nonatomic)UITableView *pListView;
@property(strong,nonatomic)NSMutableArray *pMemberListData;
@property(strong,nonatomic)NSMutableArray *pChatData;
@property(strong,nonatomic)NetworkController *pNetworkController;
@property(strong,nonatomic)NSMutableData *pReturnData;
@property(strong,nonatomic)MemberListViewController *pMemberListViewController;
@property(strong,nonatomic)ChatViewController *pChatViewController;
//@property(weak,nonatomic)int pStatus;
-(void)setMyUserInfo:(NSString*)strUserID Password:(NSString*)strPassword;
-(void)getServerConnect;
-(void)sendChatTextCommand;
-(void)sendReqvCommand:(int)index;

@end
