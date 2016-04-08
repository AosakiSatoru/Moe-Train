//
//  MoeTrainScene.m
//  Cocos2D3.x-UIKit
//
//  Created by xiaozhong on 16/1/12.
//  Copyright pika 2016年. All rights reserved.
//
// -----------------------------------------------------------------------
#import "MoeTrainScene.h"
#import "MoeStageScene.h"
#import "PauseScene.h"
#import "EndingScene.h"
#import "MySprite.h"
// -----------------------------------------------------------------------
#pragma mark - MoeTrainScene
// -----------------------------------------------------------------------

@implementation MoeTrainScene
{
    //physical world
    //CCPhysicsNode *_physicsWorld;
    
    MySprite *selSprite;
    CCSprite *touchingSprite;
    CCSprite *currentBackGround;
    CCSprite *nextBackGround;
    CCSprite *platform;
    CCTexture *currentTexture;
    CCTexture *nextTexture;
    CCButton *pauseButton;
    CCButton *soundButton;
    NSMutableArray * cargoGroup;
    NSMutableArray * carriageGroup;
    NSMutableArray * lineGroup;
    NSMutableArray * trainGroup;
    NSArray *_images;
    NSArray *_selectedImages;
    NSArray *trainImages;
    NSArray *backGroundImages;
    NSTimer *timer;
    
    float _trainScale;
    float _trainHorizon;
    //Carriage Edge Scale
    float _carriageScale;
    
    //Stage options
    BOOL isHanging;
    float _cargoHeight;

    //BOOL LoopEnd;
    
    //Stage coefficient
    
    int _scoreOnce;
    int _extraScore;
    
    int _Score;
    int _life;

    int _predifLev;
    int _difficultyLevel;
    int _minDifficultyLevel;
    int _maxDifficultyLevel;
    
    int _cargoCount;
    int _minCargoCount;
    int _maxCargoCount;
    
    int _range;
    int _minRange;
    int _maxRange;
    
    float _timePeriod;
    float _minTimePeriod;
    float _maxTimePeriod;
    
    //Information
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_lifeLabel;
    //CCLabelTTF *_edgeLabel;
}
@synthesize pauseScreenShots;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------
+ (MoeTrainScene *)scene
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
    
    //String or not
    isHanging = true;
    
    //LoopEnd = false;
    
    _trainScale = 0.18f;
    _trainHorizon = 0.26f;
    _carriageScale = _trainScale/0.45f;
    _cargoHeight = 0.75f;
    
    //init of the coefficient, the coefficient should be moved into the config
    _scoreOnce = 200;
    _extraScore = 500;
    _Score = 0;
    _life = 3;
    
    _minDifficultyLevel = 1;
    _maxDifficultyLevel = 20;
    _difficultyLevel = _minDifficultyLevel;
    _predifLev = _difficultyLevel;
    
    _minCargoCount = 3;
    _maxCargoCount = 5;
    _cargoCount = _minCargoCount;
    
    _maxTimePeriod = 20.0f;
    _minTimePeriod = 10.0f;
    _timePeriod = _maxTimePeriod;
    
    _minRange = 3;
    //Array of resources to be load
    _images = [NSArray arrayWithObjects:@"square.png"     ,@"triangle.png",
                         @"circle.png"     ,@"star.png",
                         @"heart.png"      ,@"diamond.png",
                         @"echelon.png"    ,@"ring.png",
                         @"sector.png"     ,@"crossing.png",
                         nil];
    trainImages = [NSArray arrayWithObjects:@"train alter 3.png",
                                           @"train alter 4.png",
                                           @"train alter 5.png",
                                           nil];
    
    backGroundImages=[NSArray arrayWithObjects:@"bg/Moe_background1.png",
                        @"bg/Moe_background2.png",
                        @"bg/Moe_background3.png",
                        @"bg/Moe_background4.png",
                        @"backGround2.png",
                        @"backGround3.png",
                        @"backGround4.png",
                        nil];
    
    _maxRange = (int)_images.count;
    _range = _minRange;
    
    /*physical world
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    //_physicsWorld.debugDraw = YES;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];*/
    
    //BGM
    [[OALSimpleAudio sharedInstance] playBg:@"BGM_1.wav" volume:0.5f pan:0.0f loop:YES];
    
    //init the scene background
    [self initScene];
    
    //refresh the coefficient
    [self refreshTheCoefficient];
    
    //Run the train
    [self createMainObjects:0.0f];
    
    // done
	return self;
}//init

-(void)initScene{
    // Create a background
    currentBackGround = [CCSprite spriteWithImageNamed:[backGroundImages objectAtIndex:0]];
    currentBackGround.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    currentBackGround.scaleX = self.contentSize.width/currentBackGround.contentSize.width;
    currentBackGround.scaleY = self.contentSize.height/currentBackGround.contentSize.height;
    [self addChild:currentBackGround];
    //nextBackground preload
    nextBackGround = [CCSprite spriteWithImageNamed:[backGroundImages objectAtIndex:1]];
    nextBackGround.position = CGPointMake(self.contentSize.width*3/2, self.contentSize.height/2);
    nextBackGround.scaleX = self.contentSize.width/nextBackGround.contentSize.width;
    nextBackGround.scaleY = self.contentSize.height/nextBackGround.contentSize.height;
    [self addChild:nextBackGround];
    
    platform = [CCSprite spriteWithImageNamed:@"bg/platform.png"];
    platform.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    platform.scaleX = self.contentSize.width/platform.contentSize.width;
    platform.scaleY = self.contentSize.height/platform.contentSize.height;
    [self addChild:platform];
    
    //Rail
    /*CCSprite *rail = [CCSprite spriteWithImageNamed:@"rail.png"];
    rail.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/5);
    rail.scale = (self.contentSize.height/rail.contentSize.height)*0.13;
    [self addChild:rail];*/
    
    // Create a sound button
    soundButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"sound_normal.png"]];
    soundButton.scale = (self.contentSize.width/soundButton.contentSize.width)*0.05f;
    soundButton.position = CGPointMake(self.contentSize.width-self.contentSize.height*0.07f, self.contentSize.height*0.93f);
    [soundButton setTarget:self selector:@selector(onSoundClicked:)];
    [self addChild:soundButton];
    
    // Create a pause button
    pauseButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"pause_normal.png"]];
    pauseButton.scale = (self.contentSize.width/pauseButton.contentSize.width)*0.05f;
    //pauseButton.positionType = CCPositionTypeNormalized;
    pauseButton.position = CGPointMake(self.contentSize.height*0.07f, self.contentSize.height*0.93f);
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];
    
    _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"分数: %d",_Score] fontName:@"Symbol" fontSize:12.0f];
    _scoreLabel.positionType = CCPositionTypeNormalized;
    _scoreLabel.color = [CCColor whiteColor];
    _scoreLabel.position = ccp(0.65f, 0.05f);
    [self addChild:_scoreLabel];
    
    _levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"等级: %d",_difficultyLevel] fontName:@"Symbol" fontSize:12.0f];
    _levelLabel.positionType = CCPositionTypeNormalized;
    _levelLabel.color = [CCColor whiteColor];
    _levelLabel.position = ccp(0.15f, 0.05f);
    [self addChild:_levelLabel];
    
    _lifeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"剩余机会:❤ ❤ ❤"] fontName:@"Symbol" fontSize:12.0f];
    _lifeLabel.positionType = CCPositionTypeNormalized;
    _lifeLabel.color = [CCColor whiteColor];
    _lifeLabel.position = ccp(0.85f, 0.05f);
    [self addChild:_lifeLabel];
    
    /* edge test
    _edgeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"(null)"] fontName:@"Symbol" fontSize:12.0f];
    _edgeLabel.positionType = CCPositionTypeNormalized;
    _edgeLabel.color = [CCColor whiteColor];
    _edgeLabel.position = ccp(0.10f, 0.95f);
    [self addChild:_edgeLabel];
    */

}//initScene

-(void)createMainObjects:(CCTime)dt{
    //----------------Loop Start-------------------
    
    //Property of Train
    CCSprite *train = [CCSprite spriteWithImageNamed:[trainImages objectAtIndex:_cargoCount-3]];
    double trainScale = (self.contentSize.height/train.contentSize.height)*_trainScale;
    double trainWidth = train.contentSize.width*trainScale;
    double trainHorizon = self.contentSize.height*_trainHorizon;
    double firstCargo = 0.18f*trainWidth;
    double cargoOffset = 0.153f*trainWidth;
    
    train.position = CGPointMake(-trainWidth*0.5f, trainHorizon);
    /* edge test
    train.position = CGPointMake(trainWidth*0.5f, trainHorizon);
    */
    train.scale = trainScale;
    [self addChild:train];
    
    trainGroup = [[NSMutableArray alloc] init];
    [trainGroup removeAllObjects];
    [trainGroup addObject:train];
    
    
    [self refreshTheCoefficient];
    //create the cargoes on the train
    carriageGroup = [[NSMutableArray alloc] init];
    cargoGroup = [[NSMutableArray alloc] init];
    lineGroup = [[NSMutableArray alloc] init];
    
    [carriageGroup removeAllObjects];
    
    for(CCSprite *sprite in cargoGroup)
    {
        [sprite removeFromParentAndCleanup:YES];
    }
    
    [cargoGroup removeAllObjects];
    [lineGroup removeAllObjects];
    
    _selectedImages = [self randomSort:_images range:MAX(_range, _cargoCount) count:_cargoCount];
    
    for (int i = 0; i < _cargoCount; i++) {
        NSString *image = [_selectedImages objectAtIndex:i];
        CCSprite *sprite = [CCSprite spriteWithImageNamed:image];
        sprite.scale = (self.contentSize.height/sprite.contentSize.height)*0.04f;
        sprite.position = ccp((-trainWidth*0.5)+firstCargo-i*cargoOffset,trainHorizon);
        /* edge test
        sprite.position = ccp((trainWidth*0.5)+firstCargo-i*cargoOffset,trainHorizon);
        */
        sprite.name = image;
        [sprite setColor:[CCColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f]];
        [self addChild:sprite];
        /*
        sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, sprite.contentSize} cornerRadius:0];
        sprite.physicsBody.collisionGroup = @"markGroup";
        sprite.physicsBody.collisionType  = @"markCollision";
        sprite.physicsBody.collisionCategories = @[image];
        [_physicsWorld addChild:sprite];
        */
        [carriageGroup addObject:sprite];
    }
    
    //Add cargos randomly
    [self createCargo:[self randomSort:_selectedImages range:_cargoCount count:_cargoCount] count:_cargoCount];
    
    //Run Action
    
    CCAction *trainMove = [CCActionMoveBy actionWithDuration:_timePeriod position:CGPointMake(self.contentSize.width+trainWidth, 0)];
    CCAction *trainRemove = [CCActionRemove action];
    CCAction *endloop = [CCActionCallFunc actionWithTarget:self selector:@selector(LoopEnd)];
    [train runAction:[CCActionSequence actionWithArray:@[trainMove,trainRemove,endloop]]];
    
    for (CCSprite *carriage in carriageGroup){
        CCAction *carriageMove = [CCActionMoveBy actionWithDuration:_timePeriod position:CGPointMake(self.contentSize.width+trainWidth, 0)];
        CCAction *carriageRemove = [CCActionRemove action];
        
        [carriage runAction:[CCActionSequence actionWithArray:@[carriageMove,carriageRemove]]];
    }
    
    for (CCSprite *cargo in cargoGroup) {
        CCAction *cargoMove = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(0,-self.contentSize.height*(1-_cargoHeight)-self.contentSize.width*0.03f)];
        [cargo runAction:cargoMove];
    }
    if (isHanging) {
        for (CCSprite *line in lineGroup) {
            CCAction *lineMove = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(0,-self.contentSize.height*(1.0f-_cargoHeight))];
            [line runAction:lineMove];
        }
    }
    [[OALSimpleAudio sharedInstance] playEffect:@"train.mp3" volume:0.5f pitch:1.0f pan:0.0f loop:NO];
    //timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(Loop) userInfo:nil repeats:NO];
    
}//createMainObjects

-(void)LoopEnd{
    
    //----------------Loop Ended-------------------
    
    [self refreshTheCoefficient];
    
    //is complete
    if (cargoGroup.count!=0){
        _life-=1;
        switch (_life) {
            case 0://Ending the Game
                [_lifeLabel setString:[NSString stringWithFormat:@"剩余机会:     "]];
                pauseScreenShots = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
                [pauseScreenShots begin];
                [self visit];
                [pauseScreenShots end];
                
                [[OALSimpleAudio sharedInstance] stopBg];
                [[CCDirector sharedDirector] replaceScene:[[EndingScene scene] initWithParameter:pauseScreenShots score:_Score] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
                break;
            case 1:
                [_lifeLabel setString:[NSString stringWithFormat:@"剩余机会:    ❤"]];
                break;
            case 2:
                [_lifeLabel setString:[NSString stringWithFormat:@"剩余机会:  ❤ ❤"]];
                break;
            case 3:
                [_lifeLabel setString:[NSString stringWithFormat:@"剩余机会:❤ ❤ ❤"]];
                break;
            default:
                [_lifeLabel setString:[NSString stringWithFormat:@"Error Happenned in _life"]];
                break;
        }
    }
    else{
        //Extra Score
        _Score+=_extraScore;
    }
    
    //remove the lines smoothly
    if (isHanging) {
        for (CCSprite *line in lineGroup) {
            CCAction *lineMove = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(0,self.contentSize.height*(1.0f-_cargoHeight))];
            CCAction *lineRemove = [CCActionRemove action];
            [line runAction:[CCActionSequence actionWithArray:@[lineMove,lineRemove]]];
        }
    }
    //remove the cargos smoothly
    for (CCSprite *cargo in cargoGroup) {
        CCAction *cargoMove = [CCActionMoveBy actionWithDuration:1.0f position:CGPointMake(0,self.contentSize.height*(1-_cargoHeight)+self.contentSize.width*0.03f)];
        CCAction *cargoRemove = [CCActionRemove action];
        [cargo runAction:[CCActionSequence actionWithArray:@[cargoMove,cargoRemove]]];
    }
    
    [self refreshTheCoefficient];
    
    //refresh the label
    [_scoreLabel setString:[NSString stringWithFormat:@"分数: %d",_Score]];
    [_levelLabel setString:[NSString stringWithFormat:@"等级: %d",_difficultyLevel]];

    //load background texture
    currentTexture = [CCTexture textureWithFile:[backGroundImages objectAtIndex:(unsigned long)(_difficultyLevel-1)%backGroundImages.count]];
    nextTexture = [CCTexture textureWithFile:[backGroundImages objectAtIndex:(unsigned long)(_difficultyLevel)%backGroundImages.count]];
    
    if (_predifLev!=_difficultyLevel) {
        //Change the BackGround
        CCAction *cbgmoveSmooth = [CCActionMoveBy actionWithDuration:0.5f position:CGPointMake(-self.contentSize.width, 0)];
        CCAction *nbgmoveSmooth = [CCActionMoveBy actionWithDuration:0.5f position:CGPointMake(-self.contentSize.width, 0)];
        CCAction *cbgmoveBack = [CCActionMoveBy actionWithDuration:0.0f position:CGPointMake(self.contentSize.width, 0)];
        CCAction *nbgmoveBack = [CCActionMoveBy actionWithDuration:0.0f position:CGPointMake(self.contentSize.width, 0)];
        CCAction *changeCBG = [CCActionCallFunc actionWithTarget:self selector:@selector(changeCurrentBackGround)];
        CCAction *changeNBG = [CCActionCallFunc actionWithTarget:self selector:@selector(changeNextBackGround)];
        [currentBackGround runAction:[CCActionSequence actionWithArray:@[cbgmoveSmooth,changeCBG,cbgmoveBack]]];
        [nextBackGround runAction:[CCActionSequence actionWithArray:@[nbgmoveSmooth,nbgmoveBack,changeNBG]]];
        
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(createMainObjects:) userInfo:nil repeats:NO];
    
    //mark the previous difficulty level
    _predifLev = _difficultyLevel;
    
    
}//LoopEnd

-(void)changeCurrentBackGround{
    [currentBackGround setTexture:currentTexture];
}//changeCurrentBackGround

-(void)changeNextBackGround{
    [nextBackGround setTexture:nextTexture];
}//changeNextBackGround

-(void)createCargo:(NSArray *)images count:(int)count{
    
    for (int i = 0; i < count; i++) {
        NSString *image = [images objectAtIndex:i];
        MySprite *sprite = [MySprite spriteWithImageNamed:image];
        
        //offset
        float offsetFraction = ((float)(i+1))/(count+1);
        
        //String or not
        if (isHanging) {
            CCSprite *line = [CCSprite spriteWithImageNamed:@"string.png"];
            line.scaleY = self.contentSize.height/line.contentSize.height*(1.0f-_cargoHeight);
            line.position = ccp(self.contentSize.width*offsetFraction,self.contentSize.height+self.contentSize.height*(1.0f-_cargoHeight)*0.5f);
            [self addChild:line];
            [lineGroup addObject:line];
        }
        
        sprite.scale = (self.contentSize.width/sprite.contentSize.width)*0.06f;
        sprite.position = ccp(self.contentSize.width*offsetFraction,self.contentSize.height+self.contentSize.width*0.03f);
        [sprite setOriginX:sprite.position.x OriginY:self.contentSize.height*_cargoHeight];
        sprite.name = image;
        [self addChild:sprite];
        /*
        sprite.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, sprite.contentSize} cornerRadius:0];
        sprite.physicsBody.collisionGroup = @"dragGroup";
        sprite.physicsBody.collisionType  = @"dragCollision";
        sprite.physicsBody.collisionMask = @[image];
        [_physicsWorld addChild:sprite];
        */
        [cargoGroup addObject:sprite];
    }
    
}//createCargo

-(NSArray *)randomSort:(NSArray *)images range:(int)range count:(int)count{
    //NSArray[0-range]->NSMutableArray
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<range; i++) {
        [array addObject:[images objectAtIndex:i]];
    }
    //NSMutableArray->NSArray
    NSArray *sort = [NSArray arrayWithArray:array];
    sort = [sort sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        return (arc4random() % 3) - 1;
    }];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i=0; i<count; i++) {
        [temp addObject:[sort objectAtIndex:i]];
    }
    
    return temp;
}//randomSort

-(void)refreshTheCoefficient{
    //refresh the difficultyLevel
    if (_difficultyLevel >= _maxDifficultyLevel) {
        _difficultyLevel = _maxDifficultyLevel;
    }
    else{
    _difficultyLevel = _Score / 2000 + 1;
    }
    
    //refresh the cargoCount
    if (_cargoCount >= _maxCargoCount) {
        _cargoCount = _maxCargoCount;
    }
    else{
        //if _cargoCount increase,_completeness should add 1 to ensure the logic
        if (_cargoCount != (_difficultyLevel/3)+_minCargoCount) {
            _cargoCount = (_difficultyLevel / 3) + _minCargoCount;
        }
    }
    
    //refresh the time
    if (_timePeriod <= _minTimePeriod) {
        _timePeriod = _minTimePeriod;
    }
    else{
        _timePeriod = _maxTimePeriod-(_difficultyLevel-_minDifficultyLevel)*((_maxTimePeriod-_minTimePeriod)/(_maxDifficultyLevel-_minDifficultyLevel));
    }
    
    //refresh the range
    if (_range >= _maxRange) {
        _range = _maxRange;
    }
    else {
        _range = (int)(((float)(_maxRange-_minRange)/(float)(_maxDifficultyLevel-_minDifficultyLevel))*(_difficultyLevel-_minDifficultyLevel))+_minRange;
    }
    
    /*Coeifficient Check
    NSLog(@"---Score: %d",_Score);
    NSLog(@"---DifLev: %d",_difficultyLevel);
    NSLog(@"---CargoCount: %d",_cargoCount);
    NSLog(@"---TimeP: %f",_timePeriod);
    NSLog(@"---Range: %d",_range);
    NSLog(@"---cargoGroup: %@",cargoGroup);
    NSLog(@"---carriageGroup: %@",carriageGroup);
    NSLog(@"---lineGroup: %@",lineGroup);
    NSLog(@"---_images: %@",_images);
    NSLog(@"---_selectedImages: %@",_selectedImages);
    */
     
}//refreshTheCoefficient
 
// -----------------------------------------------------------------------

-(void)dealloc{
    cargoGroup = nil;
    carriageGroup = nil;
    lineGroup = nil;
    selSprite = nil;
}//dealloc

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

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

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    selSprite = nil;
    touchingSprite = nil;
    CGPoint touchLoc = [touch locationInNode:self];
    [self selectSpriteForTouch:touchLoc];
}//touchBegan

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLoc = [touch locationInNode:self];
    
    CGPoint oldTouchLoc = [touch previousLocationInView:touch.view];
    oldTouchLoc = [[CCDirector sharedDirector] convertToGL:oldTouchLoc];
    oldTouchLoc = [self convertToNodeSpace:oldTouchLoc];
    
    CGPoint translation = ccpSub(touchLoc, oldTouchLoc);
    [self panForTranslation:translation];
    
    /* edge test
    [self selectSpriteTouching:touchLoc];
    [_edgeLabel setString:[NSString stringWithFormat:@"%@",touchingSprite.name]];
    */
}//touchMoved

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLoc = [touch locationInNode:self];

    [self selectSpriteTouching:touchLoc];//select the cargo on the carriage
    
    if(selSprite&&touchingSprite){
        if (selSprite.name==touchingSprite.name) {//match
            //NSLog(@"Match");
            
            NSString *convert = touchingSprite.name;
            NSString *path = @"se/";
            convert = [convert substringWithRange:NSMakeRange(0, [convert length]-3)];
            convert = [convert stringByAppendingString:@"mp3"];
            convert = [path stringByAppendingString:convert];
            //NSLog(@"%@",convert);
            [[OALSimpleAudio sharedInstance] playEffect:convert];
            
            [touchingSprite setColor:[CCColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
            //[touchingSprite setColor:nil];
            //CCTexture *reload = [CCTexture textureWithFile:[touchingSprite name]];
            //[touchingSprite setTexture:reload];
            
            CCAction *jump = [CCActionJumpBy actionWithDuration:0.6f position:CGPointMake(0, 0) height:self.contentSize.height*0.04f jumps:2];
            
            [touchingSprite runAction:jump];
            
            [cargoGroup removeObject:selSprite];
            [selSprite removeFromParentAndCleanup:YES];
            
            //Score
            _Score+=_scoreOnce;
            
            [self refreshTheCoefficient];
            [_scoreLabel setString:[NSString stringWithFormat:@"分数: %d",_Score]];
            
            if (cargoGroup.count==0) {
                CCSprite *temp = [trainGroup objectAtIndex:0];
                CGFloat curPos = temp.position.x;
                CCActionInterval *leave = [CCActionMoveTo actionWithDuration:3.0f position:CGPointMake(temp.contentSize.width*0.5f+self.contentSize.width, self.contentSize.height*_trainHorizon)];
                CCAction *trainSpeedUp = [CCActionEaseIn actionWithAction:leave rate:2.0f];
                CCAction *endloop = [CCActionCallFunc actionWithTarget:self selector:@selector(LoopEnd)];
                CCAction *remove = [CCActionRemove action];
                [temp stopAllActions];
                [temp runAction:[CCActionSequence actionWithArray:@[trainSpeedUp,remove,endloop]]];
                for (CCSprite *sprite in carriageGroup) {
                    [sprite stopAllActions];
                    CCActionInterval *leave = [CCActionMoveBy actionWithDuration:3.0f position:CGPointMake(temp.contentSize.width*0.5f+self.contentSize.width-curPos, 0)];
                    CCAction *cargoSpeedUp = [CCActionEaseIn actionWithAction:leave rate:2.0f];
                    [sprite runAction:[CCActionSequence actionWithArray:@[cargoSpeedUp,remove]]];
                }
                [touchingSprite runAction:jump];
            }
            
            //reset the selected pointer
            selSprite = nil;
            touchingSprite = nil;
            
            return;
        }
    }

    [selSprite stopAllActions];
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.5f position:[selSprite origin]];
    CCActionScaleBy *sc = [CCActionScaleBy actionWithDuration:0.0f scale:1/1.5f];
    [selSprite runAction:[CCActionSequence actionWithArray:@[sc,actionMove]]];
    touchingSprite = nil;

}//touchEnded

-(void)panForTranslation:(CGPoint)translation{
    if(selSprite){
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
    }
}//panForTranslation

-(void)selectSpriteForTouch:(CGPoint)touchLocation{
    MySprite * newSprite = nil;
    for (MySprite *sprite in cargoGroup) {
        if(CGRectContainsPoint(sprite.boundingBox, touchLocation)){
            newSprite = sprite;
            //[[OALSimpleAudio sharedInstance] playEffect:@"pew-pew-lei.caf"];
            break;
        }
    }
    
    if(newSprite != selSprite){
        //[selSprite stopAllActions];
        selSprite = newSprite;
        CCAction *sc = [CCActionScaleBy actionWithDuration:0.0f scale:1.5f];
        [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
        [selSprite runAction:sc];
    }
}//selectSpriteForTouch

-(void)selectSpriteTouching:(CGPoint)touchLocation{
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in carriageGroup) {
        //if(CGRectIntersectsRect(sprite.boundingBox, selSprite.boundingBox)){
        float carriageScale = 0.4f;
        if(CGRectContainsPoint(CGRectMake(sprite.position.x-self.contentSize.width*_trainScale*carriageScale*0.5f, sprite.position.y-self.contentSize.height*_trainScale*carriageScale*0.5f, self.contentSize.width*_trainScale*carriageScale, self.contentSize.height*_trainScale*carriageScale), touchLocation)){
            newSprite = sprite;
            break;
        }
    }
    
    if(newSprite != touchingSprite){
        touchingSprite = newSprite;
    }
}//selectSpriteTouching

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

-(void)onPauseClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    pauseScreenShots = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height];
    [pauseScreenShots begin];
    [self visit];
    [pauseScreenShots end];
    
    [[OALSimpleAudio sharedInstance] stopBg];
    
    [[CCDirector sharedDirector] pushScene:[[PauseScene scene] initWithParameter:pauseScreenShots isMoeStage:true] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionInvalid duration:1.0f]];
}//onPauseClicked

-(void)onSoundClicked:(id)sender{
    [[OALSimpleAudio sharedInstance] playEffect:@"drop.mp3"];
    if ([[OALSimpleAudio sharedInstance] bgPlaying]) {
        [[OALSimpleAudio sharedInstance] stopBg];
    }
    else{
        [[OALSimpleAudio sharedInstance] playBg:@"BGM_1.wav" volume:0.5f pan:0.0f loop:YES];
    }
}//onSoundClicked
// -----------------------------------------------------------------------
@end
