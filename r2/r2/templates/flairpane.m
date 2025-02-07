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

<%namespace name="utils" file="utils.m"/>
<div class="flair-settings fancy-settings">
  <h1>${_("flair settings")} | &#32;<strong>${c.site.display_name}</strong></h1>

  <div class="pretty-form">
    <form method="post" action="/post/flairconfig"
      onsubmit="return post_form(this, 'flairconfig');">
      <%utils:line_field title="${_('flair options')}">
        <input type="checkbox"
            id="sr_flair_enabled"
            name="flair_enabled"
            %if thing.flair_enabled:
              checked="checked"
            %endif
            />
        <label for="sr_flair_enabled">
            ${_("enable user flair in this sub")}
        </label>
        <br>
        <input type="checkbox"
            id="sr_flair_self_assign_enabled"
            name="flair_self_assign_enabled"
            %if thing.flair_self_assign_enabled:
              checked="checked"
            %endif
            />
        <label for="sr_flair_self_assign_enabled">
            ${_("allow users to assign their own flair")}
        </label>
        <br>
        <input type="checkbox"
            id="sr_link_flair_self_assign_enabled"
            name="link_flair_self_assign_enabled"
            %if thing.link_flair_self_assign_enabled:
              checked="checked"
            %endif
            />
        <label for="sr_link_flair_self_assign_enabled">
            ${_("allow submitters to assign their own link flair")}
        </label>
      </%utils:line_field>
      <%utils:line_field title="${_('user flair position')}">
        <table class="small-field">
          ${utils.radio_type('flair_position', "left", _("left"),
                             _("position flair to the left of the username"),
                             thing.flair_position == 'left')}
          ${utils.radio_type('flair_position', "right", _("right"),
                             _("position flair to the right of the username"),
                             thing.flair_position == 'right')}
        </table>
      </%utils:line_field>
      <%utils:line_field title="${_('link flair position')}">
        <table class="small-field">
          ${utils.radio_type('link_flair_position', "", _("none"),
                             _("don't show link flair"),
                             not thing.link_flair_position)}
          ${utils.radio_type('link_flair_position', "left", _("left"),
                             _("position flair to the left of the link"),
                             thing.link_flair_position == 'left')}
          ${utils.radio_type('link_flair_position', "right", _("right"),
                             _("position flair to the right of the link"),
                             thing.link_flair_position == 'right')}
        </table>
      </%utils:line_field>
      <div class="save-button">
        <button type="submit">${_("save options")}</button>
      </div>
    </form>
  </div>
</div>
${thing.tabs}
