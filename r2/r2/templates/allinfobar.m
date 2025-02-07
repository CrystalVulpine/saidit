## The contents of this file are subject to the Common Public Attribution
## License Version 1.0. (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License at
## http://code.reddit.com/LICENSE. The License is based on the Mozilla Public
## License Version 1.1, but Sections 14 and 15 have been added to cover use of
## software over a computer network and provide for limited attribution for the
## Original Developer. In addition, Exhibit A has been modified to be
## consistent with Exhibit B.
##
## Software distributed under the License is distributed on an "AS IS" basis,
## WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
## the specific language governing rights and limitations under the License.
##
## The Original Code is reddit.
##
## The Original Developer is the Initial Developer.  The Initial Developer of
## the Original Code is reddit Inc.
##
## All portions of the code written by reddit are Copyright (c) 2006-2015
## reddit Inc. All Rights Reserved.
###############################################################################

<%namespace file="utils.m" import="plain_link, classes, _md"/>

<div ${classes("titlebox", "rounded", thing.css_class)}>
  <h1 class="hover redditname special">
    ${plain_link(thing.sr.display_name, thing.sr.path, _sr_path=False, _class="hover")}
  </h1>

  <div class="usertext">
    ${_md(thing.description, wrap=True)}
  </div>
</div>

%if thing.allminus_url:
  <div class="giftgold allminus-link">
    <a href="${thing.allminus_url}">${_("Exclude your subscribed subs")}</a>
  </div>
%endif

<div class="giftgold allminus-link">
    <a href="/me/f/all">${_("Exclude custom subs")}</a>
</div>

%if not thing.gilding_listing:
<div class="gilded-link">
  <a href="/${g.brander_community_abbr}/all/gilded">${_("See gilded comments and submissions")}</a>
</div>
%endif

