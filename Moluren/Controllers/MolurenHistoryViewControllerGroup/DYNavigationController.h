

@protocol DYNavigationControllerDelegate;

@interface DYNavigationController : UINavigationController

@property(nonatomic, retain) NSMutableArray *viewControllerStack;
@property (nonatomic, assign) int HistoryVCIndex;

- (id)initWithRootViewController1:(UIViewController*)rootViewController IndexSid:(NSInteger)IndexSid;
- (id)SetupHistoryViews;
- (void)pushViewController:(UIViewController *)viewController;
- (void)popViewController;

@end

@protocol DYNavigationControllerDelegate <NSObject>

@optional

@property(nonatomic, assign) DYNavigationController *navigator;

- (UIViewController *)viewControllerToPush;

@end
