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
<cfcomponent output="false">
	
	<cffunction name="facebookLogin" access="remote" returntype="struct" output="false" returnformat="json">
		<cfargument name="user" type="string" required="true" />
		
		<cfset var local = {} />
		<cfset local.response = {} />
		<cfset local.response['success'] = true />
		<cfset local.user = deserializeJSON(arguments.user) />
		
		<cftry>
			
			<cfif NOT structKeyExists(session,'fbAuthService')>
				<cfset session.fbAuthService = CreateObject("component","fbconnect.com.blueriver.facebook.AuthService").init() />
			</cfif>
			
			<cfset session.fbAuthService.facebookLogin(local.user) />
			
			<cfcatch>
				<cfset local.response.success = false />
				<cfset local.response['message'] = cfcatch.Message />
			</cfcatch>
		</cftry>
		
		<cfreturn local.response />
	</cffunction>
	
	<cffunction name="saveSettings" access="remote" returntype="struct" output="false" returnformat="json">
		<cfargument name="settings" type="string" required="true" />
		
		<cfset var local = {} />
		<cfset local.response = {} />
		<cfset local.response['success'] = true />
		
		
		<!--- include the plugin config file to prevent unauthorized access --->
		<cfinclude template="../plugin/config.cfm" />
		
		<cftry>
			<cfset local.settings = deserializeJSON(arguments.settings) />
			
			<cfif structKeyExists(local.settings,'facebook') AND structKeyExists(local.settings.facebook,'client_id')>
				<cfif NOT len(trim(local.settings.facebook.client_id))>
					<cfset structDelete(local.settings.facebook,'client_id') />
				</cfif>
				<cfset application.fbconnect.settingsService.addSiteSetting(session.siteid,local.settings) />
			</cfif>
			
			<cfcatch>
				<cfset local.resonse.success = false />
				<cfset local.response['message'] = cfcatch.Message />
			</cfcatch>
		</cftry>
		
		<cfreturn local.response />
	</cffunction>
	
</cfcomponent>