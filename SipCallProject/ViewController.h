//
//  ViewController.h
//  SipCallProject
//
//  Created by lhitservices on 08/04/2019.
//  Copyright © 2019 lhitservices. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SipCallProject-Swift.h"
#import "Single.h"
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pswdTF;
@property (weak, nonatomic) IBOutlet UITextField *callNumberTF;

@property PhoneManager * callManager;

- (IBAction)paswd:(id)sender;
- (IBAction)NPswdTap:(id)sender;
- (IBAction)SPswdTap:(id)sender;
- (IBAction)LPswdTap:(id)sender;

- (IBAction)callTap:(id)sender;
- (IBAction)callEndTap:(id)sender;
- (IBAction)loginTap:(id)sender;
- (IBAction)logoutTap:(id)sender;

@end

