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
	
	<cffunction name="init" access="public" returntype="AuthService" output="false">
		<cfset $ = application.serviceFactory.getBean("MuraScope").init(session.siteid) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="facebookLogin" access="public" returntype="void" output="false">
		<cfargument name="user" type="struct" required="true" />
		
		<cfset var local = {} />
		<cfset local.user = $.getBean("User").loadBy(remoteID=arguments.user.id) />
		
		<cfif local.user.getIsNew()>
			<!--- User is new, populate a new User bean and save it --->
			<!--- username is not supplied by facebook, using the username at the end of the profile link for now --->
			<cfset local.nametaken=true>
			<cfset local.nametakencount=0>
			<cfset local.usernamebase=arguments.user.first_name & " " & arguments.user.last_name>

			<cfloop condition="local.nametaken">
			
				<cfif local.nametakencount>
					<cfset local.username =  local.usernamebase & local.nametakencount>
				<cfelse>
					<cfset local.username =  local.usernamebase>
				</cfif>
				
				<cfset local.usernameCheck = $.getBean("User").loadBy(username=local.username) />
				
				<cfif local.usernameCheck.getIsNew()>
					<cfset local.nametaken=false>
				</cfif>

			</cfloop>
			
			<cfset local.user.setUsername(local.username) />
			<cfset local.user.setSubType("Facebook") />
			<cfset local.user.setFname(arguments.user.first_name) />
			<cfset local.user.setLname(arguments.user.last_name) />
			<!--- password is not supplied by facebook, using a hash of the user's name for now --->
			<cfset local.user.setPassword(createUUID()) />
			<cfset local.user.setRemoteID(arguments.user.id) />
			<cfset local.user.setEmail('fb.' & arguments.user.id & '@facebook.com') />
			<cfset local.user.setSiteID(session.siteid) />
			<cfset local.user.setGroupID(groupID=$.getBean("user").loadBy(groupname="Facebook").getUserID(),append=false)>
			
			
			<cfset local.user.save() />
		</cfif>
		
		<!--- login the user --->
		<cfset $.getBean("UserUtility").loginByUserID(local.user.getUserID(),local.user.getSiteID()) />
	</cffunction>
	
</cfcomponent>