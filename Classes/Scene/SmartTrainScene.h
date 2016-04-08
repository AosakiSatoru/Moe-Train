//
//  SmartTrainScene.h
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/12.
//  Copyright pika 2016年. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"


@interface SmartTrainScene : CCScene
{
    CGPoint _preLoc;
    CGPoint _nextLoc;
    CGPoint _presentLoc;
    CGPoint _trainLoc;
    int _row;
    int _column;
    CGSize _tile;
    BOOL isPresentSelected;
    BOOL isNextSelected;
}
@property(nonatomic,retain)    CCSprite *train;
@property(nonatomic,retain)    CCSprite *Mesh;

@property(nonatomic,retain)    NSMutableArray *meshData;
@property(nonatomic,retain)    NSMutableArray *railGroup;

//Test
@property(nonatomic,retain)    CCLabelTTF *preLocLabel;
@property(nonatomic,retain)    CCLabelTTF *nextLocLabel;
@property(nonatomic,retain)    CCLabelTTF *presentLocLabel;

@property(nonatomic,retain) CCRenderTexture *pauseScreenShots;

+ (SmartTrainScene *)scene;
- (id)init;

@end