# Amazon-Mobile-Kit

I wanted to make a mobile app with procedurally generated affiliate links relating to user content (basically, my own, custom advertising).  Unfortunately, the Amazon Mobile SDK is **not** easy to work with.  So I made my own.

**Note that this is not a secure implementation.** If you would like to learn why, go [here](http://stackoverflow.com/a/1732454/1586231).  I intend this to be a fun project people can use to learn about Amazon and make small personal projects, but if you need a secure solution that won't break when it hits some wierd product description full of emojis and {}s or something, this isn't it.  Enjoy <3

Make an AmazonQuery like this:

<pre><code>
#import "AmazonQuery.h"
AmazonQuery* query = [[AmazonQuery alloc] init];
NSArray* queries = [query searchResultArray:@"your_amazon_affiliate_id" query:@"whatever it is you want to buy"];</code></pre>

then iterate over your queries like this:

<pre><code>
for (AmazonQuery* query in queries) {
  NSLog(@"PRODUCT NAME: %@ \n PRODUCT URL: %@ \n PRODUCT IMAGE: %@ \n", query.productName, query.productUrl.absoluteString, query.productImageUrl.absoluteString);
}</code></pre>

Feel free to fork, use, etc.  Accreditation would be appreciated.

Note that if you pass NULL for the affiliateId then it will return normal rather than affiliate Amazon links.  Also, I am not responsible for your following of the Amazon Affiliate Program rules.  Don't be a jerk.  Be nice to Amazon.  They're nice, too.
