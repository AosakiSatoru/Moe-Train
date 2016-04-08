//
//  PauseScene.m
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/13.
//  Copyright © 2016年 pika. All rights reserved.
//

#import "PauseScene.h"
#import "MoeTrainScene.h"
#import "SmartTrainScene.h"
#import "MoeStageScene.h"
#import "SmartStageScene.h"

// -----------------------------------------------------------------------
#pragma mark - PauseScene
// -----------------------------------------------------------------------

@implementation PauseScene
{
    BOOL isMoe;
}
// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------
+ (PauseScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

-(id)initWithParameter:(CCRenderTexture *)pauseScreenShot isMoeStage:(BOOL)isMoeStage{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    isMoe = isMoeStage;
    
    //Pause ScreenShot
    CCSprite *screenShot = [CCSprite spriteWithTexture:pauseScreenShot.texture];
    screenShot.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    screenShot.scaleX = self.contentSize.width/screenShot.contentSize.width;
    screenShot.scaleY = self.contentSize.height/screenShot.contentSize.height;
    [self addChild:screenShot];
    
    // Create a background
    CCSprite *menu = [CCSprite spriteWithImageNamed:@"menu.png"];
    menu.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    menu.scaleX = self.contentSize.width/menu.contentSize.width;
    menu.scaleY = self.contentSize.height/menu.contentSize.height;
    [self addChild:menu];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"menu_normal.png"]];
    backButton.scale = (self.contentSize.width/backButton.contentSize.width)*0.1f;
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.35f, 0.5f);
    if (isMoeStage) {
        [backButton setTarget:self selector:@selector(onBackToMoeStageClicked:)];
    }
    else{
        [backButton setTarget:self selector:@selector(onBackToSmartStageClicked:)];
    }
    [self addChild:backButton];
    
    // Create a resume button
    CCButton *resumeButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"return_normal.png"]];
    resumeButton.scale = (self.contentSize.width/resumeButton.contentSize.width)*0.1f;
    resumeButton.positionType = CCPositionTypeNormalized;
    resumeButton.position = ccp(0.65f, 0.5f);
    [resumeButton setTarget:self selector:@selector(onResumeClicked:)];
    [self addChild:resumeButton];
    
    // Create a retry button
    CCButton *retryButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"retry_normal.png"]];
    retryButton.scale = (self.contentSize.width/retryButton.contentSize.width)*0.1f;
    retryButton.positionType = CCPositionTypeNormalized;
    retryButton.position = ccp(0.5f, 0.5f);
    if (isMoeStage) {
        [retryButton setTarget:self selector:@selector(onMoeRetryClicked:)];
    }
    else{
        [retryButton setTarget:self selector:@selector(onSmartRetryClicked:)];
    }
    
    [self addChild:retryButton];

    // done
    return self;
}//initWithParameter

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onBackToMoeStageClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MoeStageScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}//onBackToMoeStageClicked

-(void)onBackToSmartStageClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[SmartStageScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}//onBackToMoeStageClicked


-(void)onResumeClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
    
    if(isMoe){
    [[OALSimpleAudio sharedInstance] playBg:@"BGM_1.wav" volume:0.5f pan:0.0f loop:YES];
    }
    
}//onResumeClicked

-(void)onMoeRetryClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MoeTrainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f]];
}//onMoeRetryClicked

-(void)onSmartRetryClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[SmartTrainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f]];
}//onSmartRetryClicked


// -----------------------------------------------------------------------
@end