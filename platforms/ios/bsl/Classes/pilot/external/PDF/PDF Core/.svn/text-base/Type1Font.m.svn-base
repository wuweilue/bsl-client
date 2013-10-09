#import "Type1Font.h"

@implementation Type1Font

- (id)initWithFontDictionary:(CGPDFDictionaryRef)dict
{
	if (self = [super initWithFontDictionary:dict])
	{
	}
	return self;
}


-(CGFloat)widthOfCharacter:(unichar)characher withFontSize:(CGFloat)fontSize{
    //若字体信息有fontDescriptor，则调用父类方法
    if (self.fontDescriptor) {
        return [super widthOfCharacter:characher withFontSize:fontSize];
    }
    
    //若字体为standard 14 fonts
    //将fontName转为ios支持的字体实例常量
    NSString *fontName;
    if ([self.baseFont hasPrefix:@"Helvetica"]) {
        fontName = @"Helvetica";
    }
    else if ([self.baseFont hasPrefix:@"Times"])
    {
        fontName = @"Times New Roman";
    }
    else if ([self.baseFont hasPrefix:@"Courier"]) {
        fontName = @"Courier New";
    }
    else if ([self.baseFont hasPrefix:@"Zapf"]) {
        fontName = @"Zapfino";
    }
    else {
        fontName = @"Helvetica";
    }
    CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef)fontName);
    
    CGRect boxRect= CGFontGetFontBBox(fontRef);
    
    CGFontRelease(fontRef);
    return boxRect.size.width;
}

- (CGFloat) maxY
{
    //若字体信息有fontDescriptor，则调用父类方法
    if (self.fontDescriptor) {
        return [super maxY];
    }
    //若字体为standard 14 fonts
    //将fontName转为ios支持的字体实例常量
    NSString *fontName;
    if ([self.baseFont hasPrefix:@"Helvetica"]) {
        fontName = @"Helvetica";
    }
    else if ([self.baseFont hasPrefix:@"Times"])
    {
        fontName = @"Times New Roman";
    }
    else if ([self.baseFont hasPrefix:@"Courier"]) {
        fontName = @"Courier New";
    }
    else if ([self.baseFont hasPrefix:@"Zapf"]) {
        fontName = @"Zapfino";
    }
    else {
        fontName = @"Helvetica";
    }
     CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef) fontName);
    
    CGFloat height = CGFontGetXHeight(fontRef) - CGFontGetLeading(fontRef);
    CGFontRelease(fontRef);
    return  height;
}

- (CGFloat) minY
{
    //若字体信息有fontDescriptor，则调用父类方法
    if (self.fontDescriptor) {
        return [super minY];
    }
    return  0;
}


@end
