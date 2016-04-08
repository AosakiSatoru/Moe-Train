//
//  SmartStageScene.m
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/12.
//  Copyright pika 2016年. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "SmartStageScene.h"
#import "SmartTrainScene.h"

// -----------------------------------------------------------------------
#pragma mark - SmartStageScene
// -----------------------------------------------------------------------

@implementation SmartStageScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (SmartStageScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a background
    CCSprite *titleBackGround = [CCSprite spriteWithImageNamed:@"timeField.png"];
    titleBackGround.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    titleBackGround.scaleX = self.contentSize.width/titleBackGround.contentSize.width;
    titleBackGround.scaleY = self.contentSize.height/titleBackGround.contentSize.height;
    [self addChild:titleBackGround];
   
    //Mode Select Button
    CCButton *smartStageOneButton = [CCButton buttonWithTitle:@"Smart Train Stage1" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                                   ];
    CCButton *smartStageTwoButton = [CCButton buttonWithTitle:@"Smart Train Stage2" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                                   ];
    CCButton *backButton = [CCButton buttonWithTitle:@"Back" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button.png"]
                            ];
    smartStageOneButton.positionType = CCPositionTypeNormalized;
    smartStageOneButton.position = ccp(0.15f, 0.85f);
    [smartStageOneButton setTarget:self selector:@selector(onSmartTrainStageOneClicked:)];
    smartStageTwoButton.positionType = CCPositionTypeNormalized;
    smartStageTwoButton.position = ccp(0.40f, 0.85f);
    [smartStageTwoButton setTarget:self selector:@selector(onSmartTrainStageTwoClicked:)];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.15f);
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:smartStageOneButton];
    [self addChild:smartStageTwoButton];
    [self addChild:backButton];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------
- (void)onSmartTrainStageOneClicked:(id)sender
{
    // start scene with transition
    [[CCDirector sharedDirector] replaceScene:[SmartTrainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}


- (void)onSmartTrainStageTwoClicked:(id)sender
{
    // start scene with transition
}

- (void)onBackClicked:(id)sender
{
    // start scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

// -----------------------------------------------------------------------
@end
