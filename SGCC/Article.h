@interface Article : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *summary;
@property(nonatomic,strong)NSDate *publishedOn;
@property(nonatomic,copy)NSString *urlString;

-(id)initWithTitle:(NSString *)title
            author:(NSString *)author
           content:(NSString *)content
           summary:(NSString *)summary
       publishedOn:(NSDate *)publishedOn
         urlString:(NSString *)urlString;
@end