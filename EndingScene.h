//
//  EndingScene.h
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/20.
//  Copyright © 2016年 pika. All rights reserved.
//

#ifndef EndingScene_h
#define EndingScene_h

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "AppDelegate.h"

// -----------------------------------------------------------------------

@interface EndingScene : CCScene

// -----------------------------------------------------------------------
+ (EndingScene *)scene;
- (id)initWithParameter:(CCRenderTexture *)pauseScreenShot score:(int)score;

// -----------------------------------------------------------------------
@end

#endif /* EndingScene_h */
