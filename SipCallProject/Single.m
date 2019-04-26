//
//  Single.m
//  SipCallProject
//
//  Created by lhitservices on 25/04/2019.
//  Copyright © 2019 lhitservices. All rights reserved.
//

#import "Single.h"


static Single *instance = nil;
static dispatch_once_t onceToken;

@implementation Single

+(Single *)SharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Single alloc]init];
    });
    return instance ;
}
@end
