#import "Article.h"

@interface ArticlesDataSource : NSObject

-(void)fetchArticles;
-(Article *)articleForIndexPath:(NSIndexPath *)indexPath;

@end