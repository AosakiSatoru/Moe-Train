//
//  MySprite.h
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/3/16.
//  Copyright © 2016年 pika. All rights reserved.
//
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface MySprite : CCSprite

{CGPoint Origin;}
-(CGPoint)origin;
-(void)setOriginX:(float)x OriginY:(float)y;

@end