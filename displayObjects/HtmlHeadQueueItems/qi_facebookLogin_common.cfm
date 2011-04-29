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
	<cfif NOT isDefined('$')>
		<cfset $ = application.serviceFactory.getBean("MuraScope").init(session.siteid) />
	</cfif>
	
	<cfset request.fbLoginReturnURL = "/" />
	<cfif structKeyExists(url,'returnURL')>
		<cfset request.fbLoginReturnURL = url.returnURL />
	</cfif>
</cfsilent>

<style>.hidden { display:none; }</style>

<cfoutput>
<script>
   var fbLogin = fbLogin || {};
   fbLogin.client_id = '#request.fbLogin.client_id#';
   fbLogin.facade = '#$.getConfigBean().getContext()#/plugins/#request.fbLogin.pluginDirectory#/proxy/ajax.cfc';
   fbLogin.returnURL = '#request.fbLoginReturnURL#';
</script>
<script type="text/javascript" src="#$.getConfigBean().getContext()#/plugins/#request.fbLogin.pluginDirectory#/js/json2.js"></script>
<script type="text/javascript" src="#$.getConfigBean().getContext()#/plugins/#request.fbLogin.pluginDirectory#/js/facebookLogin.js"></script>
</cfoutput>