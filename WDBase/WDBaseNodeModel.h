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

- (NSMutableArray *)stateName:(NSString *)stateName
                  textureName:(NSString *)name
                       number:(int)number;

/// 子类实现
- (void)changeArr;

@end

NS_ASSUME_NONNULL_END
