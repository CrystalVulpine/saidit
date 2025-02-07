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

<%namespace file="utils.m" import="plain_link"/>
<%namespace file="subreddit.m" import="permission_icons"/>

<%
  from r2.models import MultiReddit
  from r2.lib.pages import SubscribeButton
  is_multi = isinstance(c.site, MultiReddit)
%>

<div class="subscription-box">
  % if thing.prelink or thing.goldlink:
  <div class="box-top">
    % if thing.prelink:
    <span class="column centered">
      <a href="${thing.prelink[0]}">${thing.prelink[1]}</a>
    </span>
    % endif
    % if thing.goldlink:
    <span class="giftgold column">
    <a href="${thing.goldlink}">
      ${thing.goldmsg}
    </a>
    </span>
    % endif
  </div>
  % endif
  <div class="clear">
  % if thing.prelink or thing.goldlink:
    <div class="box-separator"></div>
  % endif
    <ul>
    %if thing.multi_path and thing.multi_text:
      ${plain_link(thing.multi_text, thing.multi_path, _class="title")}
      <div class="box-separator"></div>
    %endif
    %for sr in thing.reddits:
      <% is_spam = hasattr(sr, "_spam") and sr._spam %>
      <li>
        %if is_multi and is_spam:
          <span class="fancy-toggle-button">
            <span class="active banned">${_("banned")}</span>
          </span>
        %else:
          ${SubscribeButton(sr)}
        %endif

        %if is_spam:
          <span class="title banned">${sr.display_name}</span>
        %else:
          ${plain_link(sr.display_name, sr.path, _class="title")}
        %endif

        ${permission_icons(sr)}
      </li>
    %endfor
    </ul>
  </div>
</div>
