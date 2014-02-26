#import "Sermon.h"

@interface SermonsDataSource : NSObject

-(void)fetchSermons;
-(Sermon *)sermonForIndexPath:(NSIndexPath *) indexPath;

@end
