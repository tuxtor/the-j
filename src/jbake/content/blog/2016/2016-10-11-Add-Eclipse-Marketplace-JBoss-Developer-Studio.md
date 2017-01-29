title=[Quicktip] Add Eclipse Marketplace Client to JBoss Developer Studio
date=2016-10-11
type=post
tags=java
status=published
~~~~~~


<a href="/images/posts/jbossemc/devstudio10.png" target="_blank">
    <img src="/images/posts/jbossemc/devstudio10.png" alt="JBoss Developer Studio" style="width: 300px;"/>
</a>

Recently I'm in the need to do some reporting development. Although I've used iReport in the past I'm pretty **comfortable with having a one stop solution**, being at this time Red Hat JBoss Developer Studio (RHJDS).

Despite the fact that it contains an small marketplace, at this time it lacks a proper reporting solution like JasperSoft Studio, hence **I was in the need of installing it over my current RHJDS install**.

For those in the need of **installing Eclipse Marketplace plugins**, you can get it with two simple steps:

##Add support for Eclipse Update Sites
Create a **new repository** with the following sequence
Help -> Install New Software -> Add

The update URL for Eclipse Neon is:

    http://download.eclipse.org/releases/neon/

And choose a good name for the repo ("Eclipse Neon" maybe?)

<a href="/images/posts/jbossemc/marketplace.png" data-lightbox="image-1" title="marketplace" >
  <img src="/images/posts/jbossemc/marketplace.png">
</a>

## Search for Eclipse Marketplace Client
And install it . . .
<a href="/images/posts/jbossemc/emcinstall.png" data-lightbox="image-1" title="emc" >
  <img src="/images/posts/jbossemc/emcinstall.png">
</a>

So far **I'm not pretty sure about the potential impacts** of this mix of repositories, however you'll be able to install any Eclipse Marketplace plugin, and it looks good.

<a href="/images/posts/jbossemc/emc.png" data-lightbox="image-1" title="emc" >
  <img src="/images/posts/jbossemc/emc.png">
</a>


