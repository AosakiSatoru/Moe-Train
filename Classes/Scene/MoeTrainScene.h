//
//  MoeTrainScene.h
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/12.
//  Copyright pika 2016年. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "AppDelegate.h"

// -----------------------------------------------------------------------


@interface MoeTrainScene : CCScene //<CCPhysicsCollisionDelegate>
@property(nonatomic,retain) CCRenderTexture *pauseScreenShots;
// -----------------------------------------------------------------------
+ (MoeTrainScene *)scene;
- (id)init;

// -----------------------------------------------------------------------
@end