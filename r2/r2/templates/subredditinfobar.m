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
   from r2.lib.filters import websafe
   from r2.lib.strings import strings, Score
   from r2.lib.pages import WrappedUser, QuarantineOptoutButton, SubscribeButton
   from r2.lib.template_helpers import _ws, _wsf
   from r2.models.listing import ModListing
 %>

<%namespace file="utils.m" import="plain_link, thing_timestamp, text_with_links, _mdf"/>
<%namespace file="printablebuttons.m" import="ynbutton, state_button" />

<div class="titlebox">
  <h1 class="hover redditname">
    ${plain_link(thing.sr.display_name, thing.sr.path, _sr_path=False, _class="hover")}
  </h1>

  %if thing.quarantine:
    <div class="quarantine-notice">
      <div class="md-container">
        ${_mdf("This community is [quarantined](%(link)s) because of its shocking or highly offensive content.",
               wrap=True, link='https://reddit.zendesk.com/hc/en-us/articles/205701245')}
      </div>
      <form method='post' action='/api/quarantine_optout'>
        <input type="hidden" name="uh" value="${c.modhash}"/>
        <input type="hidden" name="sr_name" value="${thing.sr.display_name}"/>
        <button class="c-btn btn-quarantine" name="submit" value="submit" type="submit">
          ${_("Leave this community")}
        </button>
      </form>
    </div>
  %endif

  ${SubscribeButton(thing.sr)}
  %if not thing.sr.hide_num_users_info:
  <span class="subscribers">${unsafe(Score.readers(thing.subscribers))}</span>

    %if thing.active_visitors and thing.active_visitors.logged_in:
  <p class="users-online ${'fuzzed' if thing.active_visitors.logged_in.is_fuzzed else ''}" title="${_('logged-in users viewing this sub in the past 15 minutes')}">
    ${unsafe(Score.users_here_now(thing.active_visitors.logged_in.count, prepend='~' if thing.active_visitors.logged_in.is_fuzzed else ''))}
  </p>
    %endif
  %endif

  %if thing.sr.moderator:
    <div class="leavemoderator">
      ${text_with_links(ModListing.remove_self_title % dict(action='(%(action)s)'),
          _sr_path=True,
          action=dict(
            ## TRANSLATORS: this label links to the edit moderators page.
            link_text=_('change'),
            path='about/moderators'))}
    </div>
  %endif

  %if thing.sr.contributor:
    ${ynbutton(op='leavecontributor',
               title=_('leave'),
               executed=_('you are no longer an approved submitter'),
               question=_('stop being an approved submitter?'),
               format=_('you are an approved submitter on this sub. (%(leave)s)'),
               format_arg='leave',
               hidden_data=dict(
                 id=thing.sr._fullname),
               access_required=False,
              )}
  %endif

  %if thing.sr_style_toggle:
    <form class="toggle sr_style_toggle">
      <input id="sr_style_enabled" type="checkbox" name="sr_style_enabled"
        ${'checked="checked"' if thing.use_subreddit_style else ""}
      >
      <label for="sr_style_enabled">
        ${_("Show this sub's theme")}
      </label>
      <div id="sr_style_throbber" class="throbber"></div>
    </form>
  %endif

  %if thing.flair_prefs:
    ${thing.flair_prefs}
  %endif

  %if thing.description_usertext:
    ${thing.description_usertext}
  %endif

  <div class="bottom">
    %if thing.sr.author:
      ${_wsf("created by %(user)s", user=unsafe(thing.creator_text))}
    %endif
    
    <span class="age">
      ${_("a community for")}&#32;${thing_timestamp(thing.sr)}
    </span>  
  </div>

  %if c.user_is_admin:
    <div class="raisedbox spacer">
      %if thing.sr.ban_count:
        <p>
          ${strings.times_banned % thing.sr.ban_count}
        </p>
      %endif
      
      %if thing.sr._spam:
        ${ynbutton(op='approve',
                   title=_('approve this sub'), 
                   executed=_('approved'),
                   hidden_data = dict(id = thing.sr._fullname),
        )}
        
        <form id="banmessage-form" method="post" onsubmit="return post_form(this, 'admin/add_ban_message')">
          <input type="hidden" name="thing" value="${thing.sr._fullname}">
          <input type="hidden" name="system" value="subreddit">
          <textarea name="message" rows=4>
            %if getattr(thing.sr, 'ban_info', {}) and 'message' in thing.sr.ban_info:
              ${thing.sr.ban_info['message'] or ''}
            %endif
          </textarea>
          <input type="submit" class="notes-button" 
            value="Set public ban message (blank for default)">
        </form>
        
        %if hasattr(thing.sr, "banner"):
          <p>
           ${strings.banned_by % thing.sr.banner}
          </p>
        %endif
        %if getattr(thing.sr, 'ban_info', {}):
          <p>
            ${strings.time_banned % thing.sr.ban_info.get('banned_at') or 'N/A'}
          </p>
        %endif

      %else:
        ${ynbutton(op='remove',
                   title=_('ban this sub'), 
                   executed=_('banned'),
                   hidden_data = dict(id = thing.sr._fullname),
        )}
        %if getattr(thing.sr, 'ban_info', {}):
          <p>
            ${strings.time_approved % thing.sr.ban_info.get('unbanned_at') or 'N/A'}
          </p>
        %endif
      %endif
    </div>
    <div class="clear"></div>

    <div class="quarantine-tool raisedbox spacer collapsed">
      <div name="expander">
        <a href="javascript:void(0)" class="expand" onclick="return toggleSrQuarantine(this)">
          ${"[%s]" % "+"}
        </a>
        ${"Show unquarantine tool" if thing.sr.quarantine else "Show quarantine tool"}
      </div>
      <div class="quarantine-info">
        %if not thing.sr.quarantine:
          <%
            subject = "ATTN: Your subreddit has been quarantined"
            body = "Your subreddit has been [quarantined](https://reddit.zendesk.com/hc/en-us/articles/205701245) due to offensive content."
            button_label = "Quarantine and send modmail"
          %>
        %else:
          <%
            subject = "ATTN: Your subreddit is no longer quarantined"
            body = "Your subreddit has been unquarantined."
            button_label = "Unquarantine and send modmail"
          %>
        %endif
        <form id="quarantinemessage-form" method="post" onsubmit="return post_form(this, 'quarantine')">
          <input type="hidden" name="subreddit" value="${thing.sr._fullname}">
          <input type="hidden" name="quarantine" value="${not thing.sr.quarantine}">
          <label for="subject">Subject:</label>
          <br>
          <textarea name="subject">${subject}</textarea>
          <br>
          <label for="body">Body:</label>
          <br>
          <textarea name="body" rows=4>${body}</textarea>
          <br>
          <input type="submit" class="notes-button" value="${button_label}">
          <br>
          <label>Message will be sent by u/reddit and won't send if left blank</label>
        </form>
      </div>
    </div>
  %endif

  <div class="clear"> </div>
  

</div>

