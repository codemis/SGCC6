#import "Article.h"

@implementation Article

-(id)init {
    return [self initWithTitle:@"Title" author:@"Author" content:@"Content" summary:@"Summary" publishedOn:[NSDate date] urlString:@"URL"];
}
-(id)initWithTitle:(NSString *)title
            author:(NSString *)author
           content:(NSString *)content
           summary:(NSString *)summary
       publishedOn:(NSDate *)publishedOn
         urlString:(NSString *)urlString {
    _title = title;
    _author = author;
    _content = content;
    _summary = summary;
    _publishedOn = publishedOn;
    _urlString = urlString;
    return self;
}
@end