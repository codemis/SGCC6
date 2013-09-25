#import "Article.h"

@interface ArticlesStore : NSObject

@property(readonly,nonatomic)NSUInteger count;

+(ArticlesStore *)sharedStore;
-(id)objectAtIndexedSubscript:(NSUInteger)index;
-(void)getArticles;

@end