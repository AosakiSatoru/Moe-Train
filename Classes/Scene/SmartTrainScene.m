//
//  MoeTrainScene.m
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/12.
//  Copyright pika 2016年. All rights reserved.
//
// -----------------------------------------------------------------------

#import "SmartTrainScene.h"
#import "SmartStageScene.h"
#import "PauseScene.h"

#define COLUMNS 24
#define ROWS 14

#pragma mark--------------------------------------------------------------
#pragma mark - SmartTrainScene
#pragma mark--------------------------------------------------------------

@implementation SmartTrainScene

@synthesize pauseScreenShots;

#pragma mark--------------------------------------------------------------
#pragma mark - Create & Destroy
#pragma mark--------------------------------------------------------------

+ (SmartTrainScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

-(id)init{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //row and column of the Mesh
    _row = ROWS;
    _column = COLUMNS;
    _preLoc = CGPointMake(0, 0);
    _nextLoc = CGPointMake(0, 0);
    _trainLoc = CGPointMake(1, 5);
    _tile = CGSizeMake(self.contentSize.width/_column, self.contentSize.height/_row);
    
    isPresentSelected = false;
    isNextSelected = false;
    self.railGroup = [[NSMutableArray alloc] init];
    
    //init the Mesh
    self.meshData = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_column; i++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        for (int j=0; j<_row; j++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:6];
            [dic setObject:@"NO"    forKey:@"Upward"];
            [dic setObject:@"NO"    forKey:@"Downward"];
            [dic setObject:@"NO"    forKey:@"Leftward"];
            [dic setObject:@"NO"    forKey:@"Rightward"];
            [dic setObject:@"nil"   forKey:@"imageSource"];
            [dic setObject:@"NO"    forKey:@"isEdited"];
            [dic setObject:@"YES"   forKey:@"isRemovable"];
            [rowArray addObject:dic];
        }
        [self.meshData addObject:rowArray];
    }

    [self initScene];
    
    // done
	return self;
}//init

-(void)initScene{
    // Create a background
    CCSprite *titleBackGround = [CCSprite spriteWithImageNamed:@"backGround3.png"];
    titleBackGround.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    titleBackGround.scaleX = self.contentSize.width/titleBackGround.contentSize.width;
    titleBackGround.scaleY = self.contentSize.height/titleBackGround.contentSize.height;
    [self addChild:titleBackGround];
    
    [self createStage];
    
    // Create a sound button
    CCButton *soundButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"sound_normal.png"]];
    soundButton.scale = (self.contentSize.width/soundButton.contentSize.width)*0.05f;
    soundButton.position = CGPointMake(self.contentSize.width-self.contentSize.height*0.07f, self.contentSize.height*0.93f);
    //[soundButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:soundButton];
    
    // Create a pause button
    CCButton *pauseButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"pause_normal.png"]];
    pauseButton.scale = (self.contentSize.width/pauseButton.contentSize.width)*0.05f;
    //pauseButton.positionType = CCPositionTypeNormalized;
    pauseButton.position = CGPointMake(self.contentSize.height*0.07f, self.contentSize.height*0.93f);
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];
    
    //Test label
    self.preLocLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"(nil,nil)"] fontName:@"Symbol" fontSize:12.0f];
    self.preLocLabel.positionType = CCPositionTypeNormalized;
    self.preLocLabel.color = [CCColor whiteColor];
    self.preLocLabel.position = ccp(0.65f, 0.05f);
    [self addChild:self.preLocLabel];
    
    self.presentLocLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"(nil,nil)"] fontName:@"Symbol" fontSize:12.0f];
    self.presentLocLabel.positionType = CCPositionTypeNormalized;
    self.presentLocLabel.color = [CCColor whiteColor];
    self.presentLocLabel.position = ccp(0.5f, 0.85f);
    [self addChild:self.presentLocLabel];
    
    self.nextLocLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"(nil,nil)"] fontName:@"Symbol" fontSize:12.0f];
    self.nextLocLabel.positionType = CCPositionTypeNormalized;
    self.nextLocLabel.color = [CCColor whiteColor];
    self.nextLocLabel.position = ccp(0.85f, 0.05f);
    [self addChild:self.nextLocLabel];
    
}//initScene

-(void)dealloc{
    self.train            = nil;
    self.Mesh             = nil;
    self.meshData         = nil;
    self.railGroup        = nil;
    self.pauseScreenShots = nil;
    //Test
    self.preLocLabel      = nil;
    self.nextLocLabel     = nil;
    self.presentLocLabel  = nil;

}//dealloc

#pragma mark--------------------------------------------------------------
#pragma mark - Data Process
#pragma mark--------------------------------------------------------------

-(void)createStage{
    
    //[self createMesh];
    
    // Create the train
    _train = [CCSprite spriteWithImageNamed:@"train-right.png"];
    _train.position = CGPointMake((_trainLoc.x-1)*_tile.width+_tile.width/2.0f, (_trainLoc.y-1)*_tile.height+_tile.height/2.0f);
    if(_train.contentSize.width<_train.contentSize.height){
        _train.scale = _tile.height/_train.contentSize.height;
    }
    else{
        _train.scale = _tile.width/_train.contentSize.width;
    }
    [self addChild:_train];
    
}//createStage

-(void)createRailTargetX:(int)targetX TargetY:(int)targetY{
    
    NSString *Rightward = [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectForKey:@"Rightward"];
    NSString *Leftward  = [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectForKey:@"Leftward"];
    NSString *Upward    = [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectForKey:@"Upward"];
    NSString *Downward  = [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectForKey:@"Downward"];
    
    if ([Rightward isEqualToString:@"YES"] && [Leftward  isEqualToString:@"YES"]){
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"rail-left-right.png" forKey:@"imageSource"];
    }
    if ([Upward    isEqualToString:@"YES"] && [Downward  isEqualToString:@"YES"]){
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"rail-up-down.png"    forKey:@"imageSource"];
    }
    if ([Upward    isEqualToString:@"YES"] && [Leftward  isEqualToString:@"YES"]){
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"rail-up-left.png"    forKey:@"imageSource"];
    }
    if ([Upward    isEqualToString:@"YES"] && [Rightward isEqualToString:@"YES"]){
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"rail-up-right.png"   forKey:@"imageSource"];
    }
    if ([Downward  isEqualToString:@"YES"] && [Leftward  isEqualToString:@"YES"]){
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"rail-down-left.png"  forKey:@"imageSource"];
    }
    if ([Downward  isEqualToString:@"YES"] && [Rightward isEqualToString:@"YES"]){
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"rail-down-right.png" forKey:@"imageSource"];
    }
    
    if (![[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectForKey:@"imageSource"] isEqualToString:@"nil"]) {
        [[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] setObject:@"YES" forKey:@"isEdited"];
        CCSprite *sprite = [CCSprite spriteWithImageNamed:[[[self.meshData objectAtIndex:targetX] objectAtIndex:targetY] objectForKey:@"imageSource"]];
        sprite.position = CGPointMake(targetX*_tile.width+_tile.width/2.0f, targetY*_tile.height+_tile.height/2.0f);
        
        sprite.scaleY = _tile.height/sprite.contentSize.height;
        sprite.scaleX = _tile.width/sprite.contentSize.width;

        [self addChild:sprite];
        
        [self.railGroup addObject:sprite];
    }
}//createRail

-(void)createMesh{
    self.Mesh = [CCSprite spriteWithImageNamed:@"train-right.png"];
    self.Mesh.position = CGPointMake(0, 0);
    
    //Mesh.scaleX = _tile.width/Mesh.contentSize.width;
    //Mesh.scaleY = _tile.height/Mesh.contentSize.height;
    [self.Mesh setTextureRect:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    [self addChild:self.Mesh];
}//createMesh

-(void)clearMesh{
    for (int i=0; i<_column; i++) {
        for (int j=0; j<_row; j++) {
            [[[self.meshData objectAtIndex:i] objectAtIndex:j] setObject:@"NO"    forKey:@"Upward"];
            [[[self.meshData objectAtIndex:i] objectAtIndex:j] setObject:@"NO"    forKey:@"Downward"];
            [[[self.meshData objectAtIndex:i] objectAtIndex:j] setObject:@"NO"    forKey:@"Leftward"];
            [[[self.meshData objectAtIndex:i] objectAtIndex:j] setObject:@"NO"    forKey:@"Rightward"];
            [[[self.meshData objectAtIndex:i] objectAtIndex:j] setObject:@"nil"    forKey:@"imageSource"];
        }
    }

}//clearMesh

#pragma mark--------------------------------------------------------------
#pragma mark - Enter & Exit
#pragma mark--------------------------------------------------------------

-(void)onEnter{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}//onEnter

// -----------------------------------------------------------------------

-(void)onExit{
    // always call super onExit last
    [super onExit];
}//onExit

#pragma mark--------------------------------------------------------------
#pragma mark - Touch Handler
#pragma mark--------------------------------------------------------------

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLoc = [touch locationInNode:self];
    //select the start point
    _preLoc = CGPointMake((int)(touchLoc.x/_tile.width), (int)(touchLoc.y/_tile.height));
    
    //preLoc test
    [_preLocLabel setString:[NSString stringWithFormat:@"(%f,%f)",_preLoc.x,_preLoc.y]];
    
}//touchBegan

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLoc = [touch locationInNode:self];
    _nextLoc = CGPointMake((int)(touchLoc.x/_tile.width), (int)(touchLoc.y/_tile.height));
    
    //start to draw the line
    if (!isPresentSelected) {
        CGPoint diff = ccpSub(_nextLoc, _preLoc);
        if (diff.x!=0 | diff.y!=0) {
            //select the present point
            _presentLoc = _nextLoc;
            isPresentSelected = true;
            if (fabs(diff.x)>fabs(diff.y)) {
                if (diff.x > 0) {
                    //presentLoc is rightward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Leftward"];
                }
                else{
                    //presentLoc is leftward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Rightward"];
                }
            }
            else{
                if (diff.y > 0) {
                    //presentLoc is upward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Downward"];
                }
                else{
                    //presentLoc is downward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Upward"];
                }
            }
        }
    }
    else{
        //select the next point
        CGPoint diff = ccpSub(_nextLoc, _presentLoc);
        if (diff.x!=0 | diff.y!=0) {
            if (fabs(diff.x)>fabs(diff.y)) {
                if (diff.x > 0) {
                    //nextLoc is rightward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Rightward"];
                }
                else{
                    //nextLoc is leftward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Leftward"];
                }
            }
            else{
                if (diff.y > 0) {
                    //nextLoc is upward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Upward"];
                }
                else{
                    //nextLoc is downward
                    [[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] setObject:@"YES" forKey:@"Downward"];
                }
            }
            
            //When isEdited == NO,build the rail
            if ([[[[self.meshData objectAtIndex:(int)_presentLoc.x] objectAtIndex:(int)_presentLoc.y] objectForKey:@"isEdited"] isEqualToString:@"NO"]) {
                [self createRailTargetX:(int)_presentLoc.x TargetY:(int)_presentLoc.y];
                _preLoc = _presentLoc;
                _presentLoc = _nextLoc;
            }
            isPresentSelected = false;
        }
    }
    
    //test Label
    [_nextLocLabel setString:[NSString stringWithFormat:@"(%f,%f)",_nextLoc.x,_nextLoc.y]];
    [_presentLocLabel setString:[NSString stringWithFormat:@"(%f,%f)",_presentLoc.x,_presentLoc.y]];
    
}//touchMoved

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    isPresentSelected = false;
    [_presentLocLabel setString:[NSString stringWithFormat:@"(nil,nil)"]];
    
    //clear all meshs which hasn't be builed
    [self clearMesh];
    
}//touchEnded

#pragma mark--------------------------------------------------------------
#pragma mark - Button Callbacks
#pragma mark--------------------------------------------------------------

-(void)onPauseClicked:(id)sender{
    pauseScreenShots = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
    [pauseScreenShots begin];
    [self visit];
    [pauseScreenShots end];
    
    [[CCDirector sharedDirector] pushScene:[[PauseScene scene] initWithParameter:pauseScreenShots isMoeStage:false] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
}//onPauseClicked
// -----------------------------------------------------------------------
@end
