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
<cfcomponent extends="mura.plugin.plugincfc">

	<cffunction name="init" returntype="any" access="public" output="false">
		<cfargument name="pluginConfig" type="any" default="" />

		<cfset variables.pluginConfig = arguments.pluginConfig />

		<cfreturn this />
	</cffunction>

	<cffunction name="install" returntype="void" access="public" output="false">
		<cfset cleanUp() />
		<cfset minify() />
	</cffunction>

	<cffunction name="update" returntype="void" access="public" output="false">
		<cfset cleanUp() />
		<cfset minify() />
	</cffunction>

	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfset cleanUp() />
	</cffunction>
	
	<cffunction name="cleanUp" access="private" returntype="void" output="false">
		<cfif StructKeyExists(session,'fbAuthService')>
			<cfset structDelete(session,'fbAuthService') />
		</cfif>
		<cfif structKeyExists(application,variables.pluginConfig.getPackage())>
			<cfset structDelete(application,variables.pluginConfig.getPackage()) />
		</cfif>
	</cffunction>
	
	<cffunction name="minify" access="private" returntype="void" output="false">
		<!--- integration with the minification service plugin --->
		<cfset application.eventManager.announceEvent("onMinificationEvent",CreateObject("component","mura.event").init({rootDir="#application.configBean.getContext()#/plugins/#variables.pluginConfig.getDirectory()#"})) />
	</cffunction>

</cfcomponent>