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
	<cfif not structKeyExists(request,'fbLogin')>
		<cfset request.fbLogin = {} />
	</cfif>
	
	<cfset request.fblogin.settings = application[pluginConfig.getPackage()].settingsService.getSiteSettings(session.siteid) />
	
	<cfset request.fbLogin.pluginDirectory = pluginConfig.getDirectory() />
	<!--- <cfset request.fbLogin.client_id = request.pluginConfig.getSetting("client_id") /> --->
	<cfset request.fbLogin.client_id = request.fbLogin.settings.facebook.client_id />
	
	<!--- We will need jQuery, make sure it's there --->
	<cfset $.loadJSLib() />
	<!--- inlcude the common html head items that need to be added --->
	<cfset pluginConfig.addToHTMLHeadQueue("displayObjects/HtmlHeadQueueItems/qi_facebookLogin_common.cfm") />
</cfsilent>

<cfoutput>
<div id="fbLoginContainer">
	<a id="fbLogin" href="javascript:;">
		<img src="#$.getConfigBean().getContext()#/plugins/#pluginConfig.getDirectory()#/images/connectwithfacebook.gif" alt="Connect with Facebook" />
	</a>
	<a id="fbLogout" href="javascript:;" class="hidden">
		<img src="#$.getConfigBean().getContext()#/plugins/#pluginConfig.getDirectory()#/images/logout_small.gif" alt="Log out of Facebook" />
	</a>
</div>
<div id="fb-root"></div><!--- this is used by the facebook javascript sdk for injecting the API script --->

</cfoutput>