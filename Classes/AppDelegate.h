//
//  AppDelegate.h
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/12.
//  Copyright pika 2016年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"

@interface AppDelegate : CCAppDelegate
@end

@protocol passValueDelegate

-(void)passValue:(CCRenderTexture*)value;

@end