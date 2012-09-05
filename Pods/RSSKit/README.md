
<h1>RSSKit</h1>
<hr />
<p>
RSSKit is an easy-to use iOS framework to make RSS feed processing simple. It consists of only 3 small classes, so it's extremely lightweight yet powerful. It supports both the RSS 2.0 and the Atom 1.0 feed formats.
</p>
<br>
<h2>How to use the framework</h2>
<ol>
  <li><pre><tt><code>#import < RSSKit/RSSKit.h ></code></tt></pre></li>
  <li>Define a class which conforms to the <tt>RSSParserDelegate</tt>, i. e.: <code><pre><tt>@interface MyParserDelegate: NSObject < RSSParserDelegate > </tt></pre></code></li>
  <li>Instantiate an <tt>RSSParser</tt> object using an NSString with an URL containing a valid RSS/Atom feed; e. g. <code><tt><pre>RSSParser *parser = [[RSSParser alloc] initWithUrl:@&quot;http://example.com/feed&quot;];</pre></tt></code></li>
  <li>Set an instance of your freshly declared delegate class as the parser's delegate, that is: <code><tt><pre>MyParserDelegate *theDelegateObject = [[MyParserDelegate alloc] init];
parser.delegate = theDelegateObject;</pre></tt></code></li>
  <li>Call <code><tt><pre>[parser parse];</pre></tt></code></li>
  <li>Implement the <tt>rssParser:didParseFeed:</tt> method in your delegate class. As the 2nd parameter it'll be passed an <tt>RSSFeed</tt> instance. The properties of this class are named meaningfully; the <tt>articles</tt> property will contain an <tt>NSArray</tt> of <tt>RSSEntry</tt> objects, representing the items/summaries of the feed, respectively (this class also has obviously-named properties).</li>
  <li>You can also implement <tt>rssParserDidStartParsing:</tt> and <tt>rssParser:didFailWithError:</tt>.</li>
