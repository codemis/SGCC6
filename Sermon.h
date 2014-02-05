@interface Sermon : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * remoteUrlString;
@property (nonatomic, retain) NSDate * publishedOn;
@property (nonatomic, retain) NSNumber * supplierID;
@property (nonatomic, retain) NSString * localUrlString;

@end
