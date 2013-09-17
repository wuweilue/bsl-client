//
//  XMPPShowImageViewController.m
//  cube-ios
//
//  Created by zhoujun on 13-6-9.
//
//

#import "XMPPShowImageViewController.h"

@interface XMPPShowImageViewController ()

@end

@implementation XMPPShowImageViewController
@synthesize image;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"图片浏览";
    }
    return self;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    lastDistance = 0;
    if(image)
    {
        
        _imageView = [[UIImageView alloc]init];
        float width = image.size.width;
        float height = image.size.height;
        if(width>self.view.frame.size.width)
        {
            float scala = self.view.frame.size.width/width;
            height = height * scala;
            width = self.view.frame.size.width;
            image = [self scaleToSize:image size:CGSizeMake(self.view.frame.size.width, height)];
        }
        CGRect frame =  CGRectMake((self.view.frame.size.width - width)/2, 30, width, height);
        _imageView.frame = frame;
        [_imageView setImage:image];
        [self.view addSubview:_imageView];
        imgStartWidth=_imageView.frame.size.width;
        imgStartHeight=_imageView.frame.size.height;
        
        [_imageView setUserInteractionEnabled:YES];
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)];
        
        [_imageView addGestureRecognizer:pinchRecognizer];
        
        pinchRecognizer.delegate = self;
        
        [pinchRecognizer release];
    
        UIPanGestureRecognizer *panGestureReconizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        
        [_imageView addGestureRecognizer:panGestureReconizer];
        
        panGestureReconizer.delegate = self;
        
        [panGestureReconizer release];
        
        [_imageView release];
    }
}

#pragma mark Gesture Handler


- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer {
    
    float scaleFactor = [recognizer scale];
    
    _imageView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
        
    }

    
//    CGPoint trans = [recognizer translationInView: self.view];
//    
//    _imageView.transform = CGAffineTransformMakeTranslation(trans.x, trans.y);
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	CGPoint p1;
	CGPoint p2;
	CGFloat sub_x;
	CGFloat sub_y;
	CGFloat currentDistance;
	CGRect imgFrame;
	
	NSArray * touchesArr=[[event allTouches] allObjects];
	
    NSLog(@"手指个数%d",[touchesArr count]);
    //    NSLog(@"%@",touchesArr);
	
	if ([touchesArr count]>=2) {
		p1=[[touchesArr objectAtIndex:0] locationInView:self.view];
		p2=[[touchesArr objectAtIndex:1] locationInView:self.view];
		
		sub_x=p1.x-p2.x;
		sub_y=p1.y-p2.y;
		
		currentDistance=sqrtf(sub_x*sub_x+sub_y*sub_y);
		
		if (lastDistance>0) {
			
			imgFrame=_imageView.frame;
			
			if (currentDistance>lastDistance+2) {
				NSLog(@"放大");
				
				imgFrame.size.width+=10;
				if (imgFrame.size.width>1000) {
					imgFrame.size.width=1000;
				}
				
				lastDistance=currentDistance;
			}
			if (currentDistance<lastDistance-2) {
				NSLog(@"缩小");
				
				imgFrame.size.width-=10;
				
				if (imgFrame.size.width<50) {
					imgFrame.size.width=50;
				}
				
				lastDistance=currentDistance;
			}
			
			if (lastDistance==currentDistance) {
				imgFrame.size.height=imgStartHeight*imgFrame.size.width/imgStartWidth;
                
                float addwidth=imgFrame.size.width-_imageView.frame.size.width;
                float addheight=imgFrame.size.height-_imageView.frame.size.height;
                
				_imageView.frame=CGRectMake(imgFrame.origin.x-addwidth/2.0f, imgFrame.origin.y-addheight/2.0f, imgFrame.size.width, imgFrame.size.height);
			}
			
		}else {
			lastDistance=currentDistance;
		}
        
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	lastDistance=0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
