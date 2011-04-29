<!---
   Copyright 2011 Blue River Interactive

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
<cfoutput>
<form action="" name="fbSetEmail" onsubmit="return validateForm(this);" novalidate="novalidate">
<input type="hidden" name="userid" value="#$.currentUser('userID')#" />
<input type="hidden" name="doaction" value="updateprofile" />
<input type="hidden" name="siteid" value="#HTMLEditFormat($.event('siteID'))#" />
<input type="hidden" name="returnURL" value="#HTMLEditFormat($.event('currentURL'))#" />
<input type="hidden" name="display" value="editprofile" />
<ul>
<li class="req">
<strong>#local.rbFactory.getKey('user.facebookemail')#</strong><br/>
<input type="text" name="email" id="email" class="text" validate="email" required="true" message="#local.rbFactory.getKey('user.facebookemailvalidate')#" value="#htmlEditFormat(local.email)#" />
</li>
</ul>
<div class="buttons">
<button type="submit" name="submit" class="submit">#HTMLEditFormat(local.rbFactory.getKey('user.updateprofile'))#</button>
</div>
</form>
</cfoutput>