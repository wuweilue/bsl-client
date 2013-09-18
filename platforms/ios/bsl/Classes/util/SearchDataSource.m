//
//  SearchBarUtil.m
//  Cube-iOS
//
//  Created by hibad(Alfredo) on 13/2/2.
//
//
#import "SearchDataSource.h"

@implementation SearchDataSource

//从数据源(CubeApplication)读取模块信息
+(NSMutableDictionary *)getIconArray:(id)delegate fromModules:(NSMutableDictionary *)moduleDic andConfig:(cellConfig)config{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSInteger localItemCount = 0;
    //应用
    for(int i = 0; i < [[moduleDic allKeys] count]; i++){
        NSString *key = [[moduleDic allKeys] objectAtIndex:i];
        NSArray *modules = [moduleDic objectForKey:key];
        NSMutableArray *iconArray = [[NSMutableArray alloc] init];
        for (CubeModule *eachModule in modules) {
            if(eachModule.local){               //本地模块
                IconButton *aButton = [[IconButton alloc] initWithModule:eachModule stauts:IconButtonStautsFirmware delegate:delegate];
                
                aButton.hidden = eachModule.hidden;
                [iconArray addObject:aButton];
                localItemCount++;
            }else{
                if(eachModule.isDownloading){       //下载中
                    IconButton *aButton = [[IconButton alloc] initWithModule:eachModule stauts:IconButtonStautsDownloading delegate:delegate];
                    
                    aButton.hidden = eachModule.hidden;
                    [iconArray addObject:aButton];
                    aButton.category=eachModule.category;
                }else{
                    CubeModule *updatable = [[CubeApplication currentApplication] updatableModuleModuleForIdentifier:eachModule.identifier];
                    if(updatable != nil){           //可更新
                        IconButton *aButton = [[IconButton alloc] initWithModule:eachModule stauts:IconButtonStautsNeedUpdate delegate:delegate];
                        
                        aButton.hidden = eachModule.hidden;
                        [iconArray addObject:aButton];
                        aButton.category=eachModule.category;
                    }else{
                        IconButton *aButton = [[IconButton alloc] initWithModule:eachModule stauts:IconButtonStautsUseable delegate:delegate];
                        
                        aButton.hidden = eachModule.hidden;
                        [iconArray addObject:aButton];
                        aButton.category=eachModule.category;
                    }
                }
            }
        }
        [result setValue:iconArray forKey:key];
    }
    return result;
}

//根据字符串过滤List内容,根据分类返回各类别的IconButton数组
+(NSMutableDictionary *)fliterTheDataSources:(NSString *)aFliterStr andSources:(NSMutableArray *)sourceArray andConfig:(cellConfig) config{
    //根据category分类显示
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    if ([sourceArray count]>0) {
        tempDic=[CubeApplication sortByCategroy:sourceArray];
        
        //过滤方法
        if ((!aFliterStr||[aFliterStr respondsToSelector:@selector(length)])&&aFliterStr.length>0) {
            for (NSString *curKey in [tempDic allKeys]) {
                NSLog(@"类型:%@",curKey);
                for (int i=0;i<[[tempDic objectForKey:curKey] count];i++) {
                    
                    CubeModule *tempCube=[[tempDic objectForKey:curKey] objectAtIndex:i];
                    if (!tempCube||[tempCube.name rangeOfString:aFliterStr].location == NSNotFound) {
                        //categroy有时候是空
                        
                        [[tempDic objectForKey:curKey] removeObject:tempCube];
                        i--;
                        if ([[tempDic objectForKey:curKey] count]==0) {
                            [tempDic removeObjectForKey:curKey];
                        }
                    }
                }
            }
        }
    }
    return tempDic;
}

//若数据源没有数据则返回空,否则,返回数据以Category为key的IconButton 数组
+(void)filterTheDataSources:(NSString *)aFliterStr forDelegate:(id<CubeSearchDelegate>)delegate{

    //过滤Module
    NSMutableDictionary *result = [SearchDataSource fliterTheDataSources:aFliterStr andSources:[delegate modulesToFilt] andConfig:delegate.myCellConfig];
    //生成IconButton,以模块为key,value为array
    NSMutableDictionary *iconsDic = [SearchDataSource getIconArray:delegate fromModules:result andConfig:delegate.myCellConfig];
    //同步数据到delegate
//    [delegate saveCurrentIconDic:iconsDic];
    //绘画view
    [delegate drawWithDataSource:iconsDic];
}


@end
