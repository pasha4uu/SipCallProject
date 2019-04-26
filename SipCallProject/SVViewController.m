//
//  SVViewController.m
//  SipCallProject
//
//  Created by lhitservices on 24/04/2019.
//  Copyright © 2019 lhitservices. All rights reserved.
//

#import "SVViewController.h"

@interface SVViewController ()

@end

@implementation SVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)gotoTap:(id)sender {
    
    ViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
