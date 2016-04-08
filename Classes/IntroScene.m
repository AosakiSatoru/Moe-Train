//
//  IntroScene.m
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/12.
//  Copyright pika 2016年. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "MoeStageScene.h"
#import "SmartStageScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
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
    CCSprite *titleBackGround = [CCSprite spriteWithImageNamed:@"backGround2.png"];
    titleBackGround.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    titleBackGround.scaleX = self.contentSize.width/titleBackGround.contentSize.width;
    titleBackGround.scaleY = self.contentSize.height/titleBackGround.contentSize.height;
    [self addChild:titleBackGround];
    
    //Create Logo
    CCSprite *logo = [CCSprite spriteWithImageNamed:@"titleLOGO.png"];
    logo.position = CGPointMake(self.contentSize.width/2, self.contentSize.height*0.65);
    logo.scale = (self.contentSize.width/logo.contentSize.width)*0.5;
    //[self addChild:logo];
    
    //Label title
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Moe Moe Train" fontName:@"HoeflerText-Regular" fontSize:26.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.75f); // position of screen
    [self addChild:label];
    
    //Mode Select Button
    CCButton *moeModeButton = [CCButton buttonWithTitle:@"Moe   Train" fontName:@"HoeflerText-Regular" fontSize:16.0f];
    moeModeButton.color = [CCColor colorWithCcColor3b:ccc3(11, 25, 83)];
    CCButton *smartModeButton = [CCButton buttonWithTitle:@"Smart Train" fontName:@"HoeflerText-Regular" fontSize:16.0f];
    smartModeButton.color = [CCColor colorWithCcColor3b:ccc3(11, 25, 83)];
    moeModeButton.positionType = CCPositionTypeNormalized;
    moeModeButton.position = ccp(0.5f, 0.25f);
    [moeModeButton setTarget:self selector:@selector(onMoeStageClicked:)];
    smartModeButton.positionType = CCPositionTypeNormalized;
    smartModeButton.position = ccp(0.5f, 0.13f);
    [smartModeButton setTarget:self selector:@selector(onSmartStageClicked:)];
    [self addChild:moeModeButton];
    [self addChild:smartModeButton];

    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onMoeStageClicked:(id)sender
{
    // start scene with transition
    [[CCDirector sharedDirector] replaceScene:[MoeStageScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

- (void)onSmartStageClicked:(id)sender
{
    // start scene with transition
    [[CCDirector sharedDirector] replaceScene:[SmartStageScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}

// -----------------------------------------------------------------------
@end
