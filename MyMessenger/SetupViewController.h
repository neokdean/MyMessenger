//
//  SetupViewController.h
//  MyMessenger
//
//  Created by xtol bruce on 2/11/16.
//  Copyright © 2016 xtol bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SetupViewController : UIViewController

-(IBAction)Login;
@property(weak,nonatomic)IBOutlet UITextField *pUserID;
@property(weak,nonatomic)IBOutlet UITextField *pPassword;
@property(strong,nonatomic)ViewController *pRootViewController;

@end
