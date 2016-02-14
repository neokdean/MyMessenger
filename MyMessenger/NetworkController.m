
//
//  NetworkController.m
//  MyMessenger
//
//  Created by xtol bruce on 2/12/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import "NetworkController.h"
#import "MemberListDataModel.h"
#import "ChanDataModel.h"
#import "MemberListViewController.h"
#import "ChanViewController.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>
#import <arpa/inet.h>

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

void SocketCallback(CFSocketRef s, CFSocketCallBackType callbackType, CFDataRef address, const void *data, void *info) {
    NetworkController *pNetworkcontroller = (__bridge NetworkController *)info;
    
    if(callbackType == kCFSocketDataCallBack) {
        if(pNetworkcontroller.pReturnData == nil) {
            pNetworkcontroller.pReturnData = [[NSMutableData alloc] init];
        }
        
        const UInt8 *buf = CFDataGetBytePtr((CFDataRef)data);
        long len = CFDataGetLength((CFDataRef)data);
        
        if(len)
            [pNetworkcontroller.pReturnData appendBytes:buf  length:len];
        NSString *receiveStr = [[NSString alloc] initWithData:pNetworkcontroller.pReturnData encoding:NSUTF8StringEncoding];
        
        if([receiveStr rangeOfString:@"\r\n"].location) !=NSNotFound) {
            switch (pNetworkcontroller.pStatus) {
                case CLOSED:
                    break;
                case CONN:
                {
                    pNetworkcontroller.pStatus = LOG:
                    [pNetworkcontroller sendLoginCommand];
                    break;
                }
                
                case LOG:
                {
                    int returnCode = [[receiveStr substringWithRange:NSMakeRange(0,3)] intValue];
                    if(returnCode == 200) {
                        pNetworkcontroller.pStatus = LIST;
                        [pNetworkcontroller SendListCommand];
                    } else {
                        pNetworkcontroller.pStatus = CONN;
                    }
                    
                    break;
                }
                    
                case LIST:
                {
                    [pNetworkcontroller setMemberList:receiveStr];
                    [pNetworkcontroller.pMemberListViewController.pListView reloadData];
                    pNetworkcontroller.pStatus = WAIT;
                    break;
                }
                
                case REQV:
                {
                    int returnCode = [[receiveStr substringWithRange:NSMakeRange(0,3)] intValue];
                    if(returnCode == 400)
                        [pNetworkcontroller startChat];
                    else
                        pNetworkcontroller = WAIT;
                    break;
                }

                case CHAT:
                {
                    [pNetworkcontroller ReceiveChatText:receiveStr];
                    break;
                }
                
                case TEXT:
                {
                    [pNetworkcontroller SendChatText];
                    break;
                }
                
                default:
                    break;
            }
            pNetworkcontroller.pReturnData = nil;
        }
        
    }
    
    if(callbackType == kCFSocketConnectCallBack) {
        pNetworkcontroller.pStatus = CONN;
    }
}


-(void)SendDataString:(NSString*)strMessage {
    if(self.pStatus == CLOSED)
        return;
    NSString *msg = [NSString stringWithFormat:@"%@", strMessage];
    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    CFSocketSendData(pSocket, NULL, (CFDataRef)msgData, 30);  m
}

-(void)SendLoginCommand {
    NSString *str = [NSString stringWithFormat:@"CONN %@ %@\r\n",pMyUserID, pMyPassword];
    [self SendDataString:str];
}

-(void)SendListCommand {
    NSString *str = [NSString stringWithFormat:@"LIST\r\n"];
    [self SendDataString:str];
}

-(void)SendChatTextCommand {
    pStatus = TEXT;
    NSString *str = [NSString stringWithFormat:@"TEXT\r\n"];
    [self SendDataString:str];
}

-(void)SendChatText {
    pStatus = CHAT;
    NSString *str = [NSString stringWithFormat:@"%@\r\n",pChatViewController.pTextView.text];
    [self SendDataString:str];
    [self addChatMessage:str DisTime:[self getTime] forDirection:true ReLoadData:true];
}

-(void)ReceiveChatText:(NSString*)strMessage {
    [self addChatMessage:strMessage DisTime:[self getTime] forDirection:false ReLoadData:true];
}

-(void)sendReqvCommand:(int)index {
    MemberListDataModel *rowData = [pMemberListData objectAtIndex:index];
    pStatus = REQV;
    NSString *str = [NSString stringWithFormat:@"REQV %@\r\n", rowData.pUserID];
    pChatTargetIndex = index;
    [self SendDataString:str];
}

-(void)ReceiveReqvCommand:(NSString*)strMessage {
    NSArray *messageArr = [strMessage componentsSeparatedByString:@" "];
    NSString *tId = [[messageArr objectAtIndex:1] substringToIndex:[[messageArr objectAtIndex:1] rangeOfString:@"\r\n"].location];
    pChatTargetIndex = [self searchUserID:tId];
    if(pChatTargetIndex == -1) {
        NSString *str = [NSString stringWithFormat:@"REPL %@ N\r\n", tId];
        [self SendDataString:str];
    } else {
        NSString *str = [NSString stringWithFormat:@"REPL %@ Y\r\n", tId];
        [self SendDataString:str];
        [self startChat];
    }
}

-(void)startChat {
    pStatus = CHAT;
    [self.pMemberListViewController ChatViewShow];
}

-(void)setMemberList:(NSString*)strMessage {
    NSArray *memberArr = [strMessage componentsSeparatedByString:@"#"];
    for(int i = 0; i < [memberArr count]; i++) {
        NSArray *memberInfo = [memberArr objectAtIndex:i];
        [self setMemberInformation:[memberInfo componentsS]]
    }
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
