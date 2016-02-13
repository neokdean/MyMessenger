//
//  MemberListViewController.m
//  MyMessenger
//
//  Created by xtol bruce on 2/11/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import "MemberListViewController.h"

@interface MemberListViewController ()

@end

@implementation MemberListViewController

@synthesize pChatViewController;
@synthesize pNetworkContoller;
@synthesize pListView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Partners";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    //    [self NetworkInit];
    }
    return self;
}

-(void)ServerConnect:(NSString *)pUserID PassWord:(NSString *)pPassword {
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
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
