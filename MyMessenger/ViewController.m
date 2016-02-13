//
//  ViewController.m
//  MyMessenger
//
//  Created by xtol bruce on 2/11/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import "ViewController.h"
#import "SetupViewController.h"
#import "MemberListViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize pMemberListViewController;
@synthesize pSetupViewController;
@synthesize pUserId;

- (void)viewDidLoad {
    
    self.pMemberListViewController = [[MemberListViewController alloc] initWithNibName:@"MemberListViewController" bundle:nil];
    self.pSetupViewController = [[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil];
    self.viewControllers = @[self.pSetupViewController, self.pMemberListViewController];
    self.delegate = self;
    pSetupViewController.pRootViewController = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Login:(NSString *)pUser Password:(NSString *)pPass {
    [pMemberListViewController ServerConnect:pUser Password:pPass];
}

@end
