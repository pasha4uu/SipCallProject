//
//  ViewController.m
//  SipCallProject
//
//  Created by lhitservices on 08/04/2019.
//  Copyright © 2019 lhitservices. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController
//@synthesize callManager ;
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self makeACall];
    if (![[Single SharedInstance]isCallManager]) {
        self.callManager = [PhoneManager new];
    }else{
        NSLog(@"already instance there ----->>>");
    }

  //  Single.SharedInstance.isCallManager = YES;
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)makeACall
{
    
   // LinphoneManager * aa = [LinphoneManager new] ;
}


- (IBAction)paswd:(id)sender {
    
    self.userNameTF.text = @"RahimP_a";
    self.pswdTF.text = @"1d90b6c1-e262-4b6f-8f17-195e773705e3";
    
}

- (IBAction)NPswdTap:(id)sender {
     self.userNameTF.text = @"NagarajuK_a";
     self.pswdTF.text = @"14ab68c3-394f-4879-8c2e-1dd4ae7714ad";

}

- (IBAction)SPswdTap:(id)sender {
    
    [_callManager calls];
     self.userNameTF.text = @"SrilathaS_a";
     self.pswdTF.text = @"90ac1a02-3b1a-4ae9-ad6f-2229db3a8d41";
   
}

- (IBAction)LPswdTap:(id)sender {
    
    [_callManager setElements];
    
 //   self.callManager = [PhoneManager new];
    
    
//     self.userNameTF.text = @"";
//     self.pswdTF.text = @"";
  //   self.userNameTF.text = @"Lanka_a";
   //  self.pswdTF.text = @"a3db082a-9692-40e2-b282-282b95b199f9";
   
}

- (IBAction)callTap:(id)sender {
   // PhoneManager * callManager = [PhoneManager new];
    [_callManager  call_phoneWithCallAcc:@"+919959488143"];
}



- (IBAction)callEndTap:(id)sender {
   // PhoneManager * callManager = [PhoneManager new];
    [_callManager  call_reject];
   // self.callManager = [PhoneManager new];
}

- (IBAction)loginTap:(id)sender {
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userNameTF.text forKey:@"phonecallusername"];
    [defaults setObject:self.pswdTF.text forKey:@"phonecallsecret"];
    [defaults synchronize];
}

- (IBAction)logoutTap:(id)sender {
   // self.userNameTF.text = @"" ;
   // self.pswdTF.text = @"";
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
@end
