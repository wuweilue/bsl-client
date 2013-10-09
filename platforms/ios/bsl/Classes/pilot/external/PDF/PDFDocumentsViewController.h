


#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "SearchResultListViewController.h"
#import "MBProgressHUD.h"
#import "Scanner.h"
#import "PDFDocumentsCheckBoxCell.h"

@interface PDFDocumentsViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate,ReaderViewControllerDelegate,SearchResultListViewControllerDelegate,MBProgressHUDDelegate,ScannerDelegate,PDFDocumentsCheckBoxCellDelegate> {
	


}

@property (nonatomic, assign) id delegate;
//added by Joy Zeng 2012/9/13
@property (nonatomic, retain) NSArray *documents;
@property (nonatomic, retain) NSDictionary *urlsByName;

- (void)loadDocuments;
//end added
- (void)didSelectEbook:(Ebook*)ebook showPage:(NSUInteger)page keyWord:(NSString*)aKeyWord;


@property (nonatomic, retain) NSMutableArray *filteredListContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic,retain) NSString *bookType;


@end
