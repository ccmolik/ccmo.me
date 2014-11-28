---
layout: page
title: archive
---

## Blog Posts

{% for post in site.posts %}
  * {{ post.date | date_to_string }} &raquo; [ {{ post.title }} ]({{ post.url }}){% if post.comments %}[comments]({{post.url}}#disqus_thread){%endif%}
{% endfor %}
<script type="text/javascript">
var disqus_shortname = 'ccmome';

(function () {
var s = document.createElement('script'); s.async = true;
s.type = 'text/javascript';
s.src = '//' + disqus_shortname + '.disqus.com/count.js';
(document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
}());
</script>

