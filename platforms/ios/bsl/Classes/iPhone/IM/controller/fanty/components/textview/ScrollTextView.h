/*!
 @header ScrollTextView.h
 @abstract iPhone
 @author fanty.xiao
 @version 1.0 */


#import <UIKit/UIKit.h>

@class ScrollTextView;

@protocol ScrollTextViewDelegate

@optional
- (BOOL)growingTextViewShouldBeginEditing:(ScrollTextView *)growingTextView;
- (BOOL)growingTextViewShouldEndEditing:(ScrollTextView *)growingTextView;

- (void)growingTextViewDidBeginEditing:(ScrollTextView *)growingTextView;
- (void)growingTextViewDidEndEditing:(ScrollTextView *)growingTextView;

- (BOOL)growingTextView:(ScrollTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)growingTextViewDidChange:(ScrollTextView *)growingTextView;

- (void)growingTextView:(ScrollTextView *)growingTextView willChangeHeight:(float)height;
- (void)growingTextView:(ScrollTextView *)growingTextView didChangeHeight:(float)height;

- (void)growingTextViewDidChangeSelection:(ScrollTextView *)growingTextView;
- (BOOL)growingTextViewShouldReturn:(ScrollTextView *)growingTextView;
@end

@interface ScrollTextView : UIView <UITextViewDelegate> {
	UITextView *internalTextView;
	
	int minHeight;
	int maxHeight;
	
	//class properties
	int maxNumberOfLines;
	int minNumberOfLines;
	
	BOOL animateHeightChange;
	
	//uitextview properties
	NSObject <ScrollTextViewDelegate> *__unsafe_unretained delegate;
	NSTextAlignment textAlignment; 
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;
    
    UIEdgeInsets contentInset;
}

//real class properties
@property int maxNumberOfLines;
@property int minNumberOfLines;
@property BOOL animateHeightChange;
@property (nonatomic, strong) UITextView *internalTextView;	


//uitextview properties
@property(unsafe_unretained) NSObject<ScrollTextViewDelegate> *delegate;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;    // default is UITextAlignmentLeft
@property(nonatomic) NSRange selectedRange;            // only ranges of length 0 are supported
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0);
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (assign) UIEdgeInsets contentInset;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;

//uitextview methods
//need others? use .internalTextView
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;

- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;

@end
