//
//  AbstractTableViewController.h
//  pilot
//
//  Created by Sencho Kong on 13-2-5.
//  Copyright (c) 2013年 chen shaomou. All rights reserved.
//  抽象TableViewController 

#import <UIKit/UIKit.h>

@interface AbstractTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
  @protected
     UITextField *aActiveField;
}

@property(nonatomic,retain)IBOutlet UITableView* tableView;         //tablview  默认都是group样式
@property(nonatomic,retain)NSString*    titleOfBackItem;   //返回按钮字符，默认是“返回”
@property(assign)CGFloat tableViewWidth;

// iPhone数字键盘自定义的完成按钮
@property (nonatomic, retain) UIButton *doneInKeyboardButton;

//返回按钮回调方法，子类实现
-(void)back:(id)sender;

//设置背景图片
-(void)setBackImage:(NSString*)imageName;

//UITableView delelgate 子类实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
