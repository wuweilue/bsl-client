//
//  NSString+Verification.m
//  Mcs
//
//  Created by wuzheng on 11/3/11.
//  Copyright 2011 RYTong. All rights reserved.
//

#import "NSString+Verification.h"


@implementation NSString (NSString_Verification)

-(BOOL)isPureInt:(NSString*)string{
    for (int i=0; i<[string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (c < '0' || c > '9') {
            return NO;
        }
    }
    return YES;
}

//身份证校验
-(BOOL)isIdCard{
    if ([self length] != 15 && [self length] != 18) {
        return FALSE;
    }
    if ([self length] == 15) {
        if (![self isPureInt:self]) {
            return FALSE;
        }
        //规则校验
        int iCheck[15];
        NSString *num;
        for(int i=0; i<15;i++)
        {
            num = [self substringWithRange:NSMakeRange(i, 1)];
            iCheck[i] = [num intValue]; 
        }
        int iMonth = iCheck[8]*10 + iCheck[9];
        if (iMonth <= 0 || iMonth > 12) {
            return FALSE;
        }
        int iDay = iCheck[10]*10 + iCheck[11];
        if (iDay <= 0 || iDay > 31) {
            return FALSE;
        }
        //end 校验规则
    }
    if ([self length] == 18) {
        NSString *checkNum = [self substringWithRange:NSMakeRange(0, 17)];
        NSString *check = [self substringWithRange:NSMakeRange(17, 1)];
        if (![self isPureInt:checkNum]){ 
            return FALSE;
        }
        if (![self isPureInt:check] && ![check isEqualToString:@"X"] && ![check isEqualToString:@"x"])
        {
            return FALSE;
        }
        //规则校验
        int iCheck[18];
        NSString *num;
        for(int i=0; i<17;i++)
        {
            num = [self substringWithRange:NSMakeRange(i, 1)];
            iCheck[i] = [num intValue]; 
        }
        int iYear = iCheck[6]*10 + iCheck[7];
        if (iYear < 19 || iYear >20)
        {
            return FALSE;
        }
        int iMonth = iCheck[10]*10 + iCheck[11];
        if (iMonth <= 0 || iMonth >12) {
            return FALSE;
        }
        int iDay = iCheck[12]*10 + iCheck[13];
        if (iDay <= 0 || iDay > 31) {
            return FALSE;
        }
        int sum=0;
        int wi[] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
        char list[11] = {'1', '0', 'X', '9', '8','7', '6' ,'5', '4', '3', '2'};
        for (int i = 0; i < 17; i++)
        {
            sum += iCheck[i]* wi[i];
        }
        int iCheckNum = sum % 11;
        char checkCode = list[iCheckNum];
        if ([check isEqualToString:@"x"] || [check isEqualToString:@"X"])
        {
            if (checkCode != 'X') {
                return FALSE;
            }
        }
        else
        {
            if ([check intValue] != (checkCode-'0'))
            {
                return FALSE;
            }
        }
        //end 校验规则
    }
    //规则校验
    return YES;
}

-(NSString *)checkSpecChar{
    if([self hasSpecChar]){
        return [self clearSpecChar];
    }else{
        return self;
    }
    
}

//检查是否有特殊字符
-(BOOL)hasSpecChar{
    NSError *error;
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"[^\\u0000-\\u007f\\u4E00-\\u9FA5\\uFF00-\\uFFA0\\u201C\\u201D\\u3002]" options:NSRegularExpressionCaseInsensitive error:&error];
    if([regularExpression numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])] > 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为不影响您数据上传，您输入的特殊字符将被过滤" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        [regularExpression release];
        
        return true;
    }
    
    [regularExpression release];
    return false;
}

//清除特殊字符
-(NSString *)clearSpecChar{
    NSError *error;
    NSRegularExpression *regularExpression = [[[NSRegularExpression alloc] initWithPattern:@"[^\\u0000-\\u007f\\u4E00-\\u9FA5\\uFF00-\\uFFA0\\u201C\\u201D\\u302A]" options:NSRegularExpressionCaseInsensitive error:&error]autorelease];
    return [regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
    
    
}

//是否是有效的邮箱地址
- (BOOL)isValidateddEmail{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]   
                                              initWithPattern:@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
                                              options:NSRegularExpressionCaseInsensitive   
                                              error:nil];  
    NSRange  rangeOfFirstMatch = [regularexpression rangeOfFirstMatchInString:self   
                                                                      options:NSMatchingReportProgress 
                                                                        range:NSMakeRange(0, self.length)];  
    
    [regularexpression release];  
    
    if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(0, self.length))) {
        return YES;
    }
    return NO;    
}

//是否时有效的手机号码
- (BOOL)isValidatedPhoneNumber{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]   
                                              initWithPattern:@"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)"
                                              options:NSRegularExpressionCaseInsensitive   
                                              error:nil];  
    NSRange  rangeOfFirstMatch  = [regularexpression rangeOfFirstMatchInString:self   
                                                                       options:NSMatchingReportProgress 
                                                                         range:NSMakeRange(0, self.length)];  
    
    [regularexpression release];  
    
    if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(0, self.length))) {
        return YES;
    }
    return NO;   
}

//校验是否是数字字符串
- (BOOL)isValidatedNumberString{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]   
                                              initWithPattern:@"^[0-9]+$"
                                              options:NSRegularExpressionCaseInsensitive   
                                              error:nil];  
    NSRange  rangeOfFirstMatch = [regularexpression rangeOfFirstMatchInString:self   
                                                                      options:NSMatchingReportProgress 
                                                                        range:NSMakeRange(0, self.length)];  
    
    [regularexpression release];  
    if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(0, self.length))) {
        return YES;
    }
    return NO; 
}

//匹配固定长度的数字字符串
- (BOOL)isValidatedNumberStringWithLength:(NSUInteger)l{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]   
                                              initWithPattern:[NSString stringWithFormat:@"^[0-9]{%u}", l]
                                              options:NSRegularExpressionCaseInsensitive   
                                              error:nil];  
    NSRange  rangeOfFirstMatch = [regularexpression rangeOfFirstMatchInString:self   
                                                                      options:NSMatchingReportProgress 
                                                                        range:NSMakeRange(0, self.length)];  
    
    [regularexpression release];  
    if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(0, self.length))) {
        return YES;
    }
    return NO; 
}

//匹配日期格式：2012-09-01 08:00:00或2012-09-01
- (BOOL)isDateString{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc] initWithPattern:[NSString stringWithFormat:@"^\\d{4}-\\d{2}-\\d{2}[ ]{1}\\d{2}:\\d{2}:\\d{2}|\\d{4}-\\d{2}-\\d{2}$"] options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange rangeOfFirstMatch = [regularexpression rangeOfFirstMatchInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    [regularexpression release];
    if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(0, self.length))) {
        return YES;
    }
    return NO;
}

//中文URL编码
- (NSString *)encodeToPercentEscapeString
{
    NSString *outputStr = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return [outputStr autorelease];
}


@end