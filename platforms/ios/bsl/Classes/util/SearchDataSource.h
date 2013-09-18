//
//  SearchBarUtil.h
//  Cube-iOS
//
//  Created by 甄健鹏 hibad(Alfredo) on 13/2/2.
//
//  数据源
//

#define kSearchCombineBar CGRectMake(0,0,320,40)

#import <Foundation/Foundation.h>
#import "CubeApplication.h"
#import "IconButton.h"
#import "SwitchButton.h"
typedef enum
{
    EDELETE=0,
    EADD,
    EUPDATE,
    ENONE
}cellConfig;

@protocol CubeSearchDelegate <NSObject>
@property (readwrite,nonatomic) cellConfig myCellConfig;
@required
-(void)drawWithDataSource:(NSMutableDictionary*)tempDic;
-(NSMutableArray *)modulesToFilt;
-(void)saveCurrentIconDic:(NSMutableDictionary *)iconDic;
@optional
@end

//可过滤数据源 
@interface SearchDataSource : NSObject

+(NSMutableDictionary *)getIconArray:(id)delegate fromModules:(NSMutableDictionary *)moduleDic andConfig:(cellConfig)config;
+(NSMutableDictionary *)fliterTheDataSources:(NSString *)aFliterStr andSources:(NSMutableArray *)sourceArray andConfig:(cellConfig) config;
//当filterStr为空时默认返回所有IconButton
+(void)filterTheDataSources:(NSString *)aFliterStr forDelegate:(id<CubeSearchDelegate>)delegate;

@end
