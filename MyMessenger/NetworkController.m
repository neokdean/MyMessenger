//
//  NetworkController.m
//  MyMessenger
//
//  Created by xtol bruce on 2/12/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import "NetworkController.h"

@interface NetworkController ()

@end

#define CLOSED  0
#define CONN    1
#define LOG     2
#define LIST    3
#define WAIT    4
#define REQV    5
#define REPL    6
#define CHAT    7
#define TEXT    8

@implementation NetworkController

@synthesize pListView;
@synthesize pMemberListData;
@synthesize pChatData;
@synthesize pNetworkController;
@synthesize pReturnData;
@synthesize pMemberListViewController;
@synthesize pChatViewController;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        pStatus = CLOSED;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMyUserInfo:(NSString *)strUserID Password:(NSString *)strPassword {
    pMyUserID = strUserID;
    pMyPassword = strPassword;
    
}

-(void)getServerConnect {
    CFSocketContext socketContext = { 0, (__bridge void*)self, NULL, NULL, NULL};
    pSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, 0, kCFSocketReadCallBack | kCFSocketDataCallBack | kCFSocketConnectCallBack | kCFSocketWriteCallBack,
                             (CFSocketCallback)SocketCallback, &socketContext);
    struct sockaddr_in sockAddr;
    sockAddr.sin_port = htons(9500);
    sockAddr.sin_family = AF_INET;
    sockAddr.sin_addr.s_addr = inet_addr("");
    
    CFDataRef addressData = CFDataCreate(NULL, (void*)&sockAddr, sizeof(struct sockaddr_in));
    CFSocketConnectToAddress(pSocket, addressData, 30);
    pRunSource = CFSocketCreateRunLoopSource(NULL, pSocket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), pRunSource, kCFRunLoopCommonModes);
    CFRelease(addressData);

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
