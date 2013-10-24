@interface Article : NSManagedObject

@property(nonatomic,retain)NSString *author;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSDate *publishedOn;
@property(nonatomic,retain)NSString *summary;
@property(nonatomic,retain)NSNumber *supplierId;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *urlString;

@end