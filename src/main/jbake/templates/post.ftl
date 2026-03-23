<#include "header.ftl">

	<#include "menu.ftl">

	<div class="page-header">
		<h1><#escape x as x?xml>${content.title}</#escape></h1>
	</div>

	<p><em>${content.date?string("dd MMMM yyyy")}</em></p>

	<div class="row">

		<div class="col-md-9">
			<p>${content.body}</p>

			<div id="share"><#include "share_links.ftl"></div>
			
			<hr />

			<div id="disqus_thread"></div>
			<script type="text/javascript">
			    /* * * CONFIGURATION VARIABLES * * */
			    var disqus_shortname = 'opinguimacademicoq';

			    /* * * DON'T EDIT BELOW THIS LINE * * */
			    (function() {
			        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
			        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
			        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
			    })();
			</script>
			<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>

		</div>
			<div class="col-md-3">
			<form style="border:1px solid #ccc;padding:3px;text-align:center;" action="https://feedburner.google.com/fb/a/mailverify" method="post" target="popupwindow" onsubmit="window.open('https://feedburner.google.com/fb/a/mailverify?uri=the-j', 'popupwindow', 'scrollbars=yes,width=550,height=520');return true"><p>Enter your email address:</p><p><input type="text" style="width:140px" name="email"/></p><input type="hidden" value="the-j" name="uri"/><input type="hidden" name="loc" value="en_US"/><input type="submit" value="Subscribe" /><p>Delivered by <a href="https://feedburner.google.com" target="_blank">FeedBurner</a></p></form>
			<hr/>
			
			<a href="http://www.oracle.com/technetwork/java/javase/downloads/index.html"><img src="/images/global/getjavasesdk-120x30.png" alt="Get Java SE SDK" border="0" width="120" height="30" /></a>

			<br/>

			<a href="http://www.gentoo.org/"><img src="//www.gentoo.org/assets/img/badges/gentoo-badge.png" alt="Gentoo" style="border:0" /></a>

			<br/>

			<a href="https://community.oracle.com/community/technology_network_community/java/java-champions">
			<img src="/images/global/jc.png" alt="Java Champions" style="border:0" />
			</a>

			<hr/>

		    <a class="twitter-timeline"  href="https://twitter.com/tuxtor" data-widget-id="633158537896722432">Tweets by @tuxtor</a>
	            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
		</div>
	</div>

	

	

<#include "footer.ftl">
