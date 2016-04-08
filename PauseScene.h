//
//  PauseScene.h
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/13.
//  Copyright © 2016年 pika. All rights reserved.
//

#ifndef PauseScene_h
#define PauseScene_h

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "AppDelegate.h"

// -----------------------------------------------------------------------

@interface PauseScene : CCScene

// -----------------------------------------------------------------------
+ (PauseScene *)scene;
- (id)initWithParameter:(CCRenderTexture *)pauseScreenShot isMoeStage:(BOOL)isMoeStage;

// -----------------------------------------------------------------------
@end

#endif /* PauseScene_h */
