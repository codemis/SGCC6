#import "Article.h"

@interface ArticlesStore : NSObject

@property(readonly,nonatomic)NSUInteger count;

+(ArticlesStore *)sharedStore;
-(void)updateArticlesFromWeb;

@end