//
//  MySprite.m
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/3/16.
//  Copyright © 2016年 pika. All rights reserved.
//

#import "MySprite.h"
#import <Foundation/Foundation.h>

@implementation MySprite

-(CGPoint)origin
{
    return Origin;
}

-(void)setOriginX:(float)x OriginY:(float)y
{
    Origin.x = x;
    Origin.y = y;
}

@end