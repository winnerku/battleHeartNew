//
//  WDBaseNodeModel.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseNodeModel : NSObject

/// 技能释放后展示的效果
@property (nonatomic,copy)NSArray <SKTexture *>*skill1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill2Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill3Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill4Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*skill5Arr;

/// 技能释放后的效果
@property (nonatomic,copy)NSArray <SKTexture *>*effect1Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*effect2Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*effect3Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*effect4Arr;
@property (nonatomic,copy)NSArray <SKTexture *>*effect5Arr;

/// 站立
@property (nonatomic,copy)NSArray <SKTexture *>*standArr;
/// 跑
@property (nonatomic,copy)NSArray <SKTexture *>*runArr;
/// 步行
@property (nonatomic,copy)NSArray <SKTexture *>*walkArr;
/// 死亡
@property (nonatomic,copy)NSArray <SKTexture *>*diedArr;

/// 攻击1
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr1;
/// 攻击2
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr2;
/// 攻击3
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr3;
/// 被攻击硬直
@property (nonatomic,copy)NSArray <SKTexture *>*beHurtArr;
/// 状态<减速>
@property (nonatomic,copy)NSArray <SKTexture *>*statusReduceArr;

/// 初始化
- (void)setNormalTexturesWithName:(NSString *)name
                      standNumber:(int)standNumber
                        runNumber:(int)runNumber
                       walkNumber:(int)walkNumber
                       diedNumber:(int)diedNumber
                    attack1Number:(int)attackNumber;

/// 释放技能的特效
- (void)setSkillTexturesWithName:(NSString *)name
                    skill1Number:(int)skill1Number
                    skill2Number:(int)skill2Number
                    skill3Number:(int)skill3Number
                    skill4Number:(int)skill4Number
                    skill5Number:(int)skill5Number;

/// 释放技能的效果
- (void)setEffectTexturesWithName:(NSString *)name
                     skill1Number:(int)skill1Number
                     skill2Number:(int)skill2Number
                     skill3Number:(int)skill3Number
                     skill4Number:(int)skill4Number
                     skill5Number:(int)skill5Number;


- (NSMutableArray *)stateName:(NSString *)stateName
                  textureName:(NSString *)name
                       number:(int)number;

/// 子类实现
- (void)changeArr;

@end

NS_ASSUME_NONNULL_END
