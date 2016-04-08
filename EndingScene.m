//
//  EndingScene.m
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/20.
//  Copyright © 2016年 pika. All rights reserved.
//

#import "EndingScene.h"
#import "MoeTrainScene.h"
#import "MoeStageScene.h"

// -----------------------------------------------------------------------
#pragma mark - PauseScene
// -----------------------------------------------------------------------

@implementation EndingScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------
+ (EndingScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

-(id)initWithParameter:(CCRenderTexture *)pauseScreenShot score:(int)score{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
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
    
    // Create the Score info
    CCLabelTTF *infoLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"恭喜！你的得分是：%d",score] fontName:@"Symbol" fontSize:16.0f];
    infoLabel.positionType = CCPositionTypeNormalized;
    infoLabel.color = [CCColor whiteColor];
    infoLabel.position = ccp(0.5f, 0.5f);
    [self addChild:infoLabel];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"menu_normal.png"]];
    backButton.scale = (self.contentSize.width/backButton.contentSize.width)*0.1f;
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.35f, 0.35f);
    [backButton setTarget:self selector:@selector(onBackToStageClicked:)];
    [self addChild:backButton];
    
    // Create a retry button
    CCButton *retryButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"retry_normal.png"]];
    retryButton.scale = (self.contentSize.width/retryButton.contentSize.width)*0.1f;
    retryButton.positionType = CCPositionTypeNormalized;
    retryButton.position = ccp(0.65f, 0.35f);
    [retryButton setTarget:self selector:@selector(onRetryClicked:)];
    [self addChild:retryButton];
    
    // done
    return self;
}//initWithParameter

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onBackToStageClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MoeStageScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}//onBackToStageClicked

-(void)onRetryClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] stopEverything];
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MoeTrainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.5f]];
}//onRetryClicked


// -----------------------------------------------------------------------
@end
