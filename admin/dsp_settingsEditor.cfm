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
<cfsilent>
	<cfset $.loadJSLib() />
	<cfset pluginConfig.addToHTMLHeadQueue('admin/htmlHeadQueueItems/qi_admin_js.cfm') />
	
	<cfset settings = application[pluginConfig.getPackage()].settingsService.getSiteSettings(session.siteid) />
	
	<cfset client_id = settings.facebook.client_id />
	<cfif pluginConfig.getSetting('client_id') EQ client_id>
		<cfset client_id = "" />
	</cfif>
</cfsilent>

<cfoutput>
	<span id="btnSave" class="btn">Save</span>
	
	<h3 class="separate">Facebook Settings</h3>
	<form action="" method="post" onsubmit="javascript:;">
		
		<ul>
			<li>
				<label for="client_id">Client ID</label>
				<input type="text" class="text" name="client_id" id="client_id" value="#client_id#" />
			</li>
		</ul>
		
	</form>
</cfoutput>