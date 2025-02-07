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

<%!
   from r2.config import feature
   from r2.lib.filters import unsafe
   from r2.lib.pages.things import CommentButtons
   from r2.lib.pages import WrappedUser
%>

<%namespace file="utils.m" import="plain_link, thing_timestamp, edited, nsfw_stamp, quarantine_stamp" />
<%inherit file="comment_skeleton.m"/>

#####################
### specific fill-in functions for comment
##################

<%def name="midcol(display=True, cls = '')">
${parent.midcol(cls = cls)}
</%def>

<%def name="subreddit()" buffered="True">
  ${plain_link(thing.subreddit.display_name, thing.subreddit_path, _sr_path=False,
               _class="subreddit hover")}
</%def>

<%def name="link()" buffered="True">
  <%

    if thing.link.is_self:
      url = thing.link.url
      inbound_tracking_url = thing.link.tracking_link(url, thing, "title", site_name=False)
    else:
      url = thing.link.url
      inbound_tracking_url = None
  %>
  <a href="${url}" class="title"
     %if inbound_tracking_url and inbound_tracking_url != url:
       data-inbound-url="${inbound_tracking_url}"
       data-href-url="${url}"
     %endif
     %if thing.nofollow:
       rel="nofollow"
     %endif
     >
    ${thing.link.title}
  </a>
</%def>

<%def name="ParentDiv()">
  ${parent.ParentDiv()}
  %if not thing.deleted:
    <a name="${thing._id36}"></a>
  %endif
  %if c.profilepage:
    <%
      tagline_text = conditional_websafe(thing.taglinetext).replace(" ", "&#32;")
      tagline_attrs = dict(link=self.link(),
                   subreddit=self.subreddit(),
                   author=thing.link_author.render())
    %>
    ${unsafe(tagline_text % tagline_attrs)}
  %endif
</%def>

<%def name="tagline()">
  <%
     if c.user_is_admin:
       show = True
     else:
       show = not thing.deleted
  %>

  <a href="javascript:void(0)" class="expand" onclick="return togglecomment(this)">
    ${"[%s]" % ("+" if thing.collapsed else "–")}
  </a>

  %if show:
     %if thing.deleted:
       <em>${_("deleted comment from")}</em>&#32;
     %endif
     ${WrappedUser(thing.author, thing.attribs, thing)}
     &#32;
  %else:
     <em>${_("[deleted]")}</em>&#32;
  %endif

  %if thing.collapsed and show and hasattr(thing, "collapsed_reason"):
    <span class="collapsed-reason">${thing.collapsed_reason}</span>
  %endif

  %if show and thing.score_hidden:
    <span title="${_('this subreddit hides comment scores for %d minutes') % thing.subreddit.comment_score_hide_mins}">
      [${_("score hidden")}]
    </span>&#32;
  %elif show and not thing.score_hidden:
    ${unsafe(self.score(thing))}&#32;-&#32;
  %endif

  ${thing_timestamp(thing, thing.timesince, live=True, include_tense=True)}
  ${edited(thing, thing.lastedited)}
  ${self.gildings()}

  %if thing.is_sticky:
  &#32;
  <span class="stickied-tagline" title="${_("selected by this subreddit's moderators")}">${_("stickied comment")}</span>
  %endif

  &nbsp;
  <a href="javascript:void(0)" class="numchildren" onclick="return togglecomment(this)">
    (${thing.numchildren_text})
  </a>

  ${self.approval_checkmark()}
  %if getattr(thing, 'savedcategory', None) is not None:
    ${plain_link(_('category: %s') % thing.savedcategory,
                 '/user/%s/saved/%s' % (c.user.name, thing.savedcategory),
                 _class='save-category' + ('' if thing.savedcategory else ' hidden')
                )}
  %endif
</%def>

<%def name="Child()">
%if not c.profilepage and thing.link.contest_mode and hasattr(thing, "child") and not thing.parent_id:
  <a href="#" class="showreplies"
     onclick="$(this).hide();$(this).parent().find('.noncollapsed').show();return false;">
    [${_("show replies")}]
  </a>
  <div class="child noncollapsed" style="display:none">
%else:
  <div class="child">
%endif
  %if thing.childlisting:
    ${thing.childlisting}
  %endif
  </div>
</%def>

<%def name="fullContext()">
  <div class="md-container-small full-context-info full-context-info-${thing._fullname}" style="display:none;">
    <div class="md">
      <table>
        <tbody>
          <tr>
            <td>${thing.author_slow.name}</td>
            <td>
              <div class="arrow full-context-vote-${thing._fullname}"></div>
            </td>
            <td><a href="" class="full-context-op-${thing._fullname}"></a></td>
            <td class="full-context-vote-time-${thing._fullname}"></td>
          </tr>
          <tr>
            <td>${thing.author_slow.name}</td>
            <td>replied to</td>
            <td><a href="" class="full-context-op-${thing._fullname}"></a></td>
            <td class="full-context-comment-time-${thing._fullname}"></td>
          </tr>
          <tr>
            <td><a href="" class="full-context-op-${thing._fullname}"></a></td>
            <td>
              <div class="arrow full-op-vote-${thing._fullname}"></div>
            </td>
            <td>${thing.author_slow.name}</td>
            <td class="full-op-vote-time-${thing._fullname}"></td>
          </tr>
        </tbody>
      </table>
      <div class="parent">
        <strong>full context:</strong>
        <p class="full-context-comment-${thing._fullname}"></p>
      </div>
    </div>
  </div>
</%def>

<%def name="commentBody()">
  ${parent.commentBody()}
  %if getattr(thing, 'show_admin_context', None):
    ${self.fullContext()}
  %endif
</%def>

<%def name="arrows()">
  ${parent.midcol()}
</%def>

<%def name="buttons()">
  %if c.profilepage:
    %if thing.subreddit.quarantine:
      <li>
        <span class="quarantine-stamp stamp">${quarantine_stamp()}</span>
      </li>
    %endif
    %if thing.nsfw:
      <li>
        <span class="nsfw-stamp stamp">${nsfw_stamp()}</span>
      </li>
    %endif
  %endif
  ${CommentButtons(thing)}
  ${self.admintagline()}
</%def>
