//
//  Single.h
//  SipCallProject
//
//  Created by lhitservices on 25/04/2019.
//  Copyright © 2019 lhitservices. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Single : NSObject

@property BOOL isCallManager ;

+(Single *)SharedInstance ;
@end

NS_ASSUME_NONNULL_END
