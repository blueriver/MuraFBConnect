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
	
	<cffunction name="init" access="public" returntype="SettingsService" output="false">
		<cfargument name="settingsFilepath" type="string" required="true" />
		<cfargument name="settingsFileName" type="string" required="true" />
		<cfargument name="defaultSettings" type="struct" required="true" />
		<cfargument name="defaultKey" type="string" required="false" default="default" />
		
		<cfset variables.settingsFilePath = arguments.settingsFilePath />
		<cfset variables.settingsFileName = arguments.settingsFileName />
		<cfset variables.defaultSettings = duplicate(arguments.defaultSettings) />
		<cfset variables.defaultKey = arguments.defaultKey />
		<cfset variables.settings = {} />
		
		<cfset loadSettings() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllSettings" access="public" returntype="struct" output="false">
		<cfset var local = {} />
		<cfset local.settings = duplicate(variables.settings) />
		<cfset deleteKey(local.settings,variables.defaultKey) />
		<cfset structAppend(local.settings,duplicate(variables.defaultSettings)) />
		<cfreturn local.settings />
	</cffunction>
	
	<cffunction name="getSiteSettings" access="public" returntype="struct" output="false">
		<cfargument name="settingsKey" type="string" required="true" />
		
		<cfset var local = {} />
		
		<cfif NOT StructKeyExists(variables.settings,arguments.settingsKey)>
			<cfreturn duplicate(variables.defaultSettings[variables.defaultKey]) />
		</cfif>
		
		<cfif arguments.settingsKey NEQ variables.defaultKey AND StructKeyExists(variables.settings,arguments.settingsKey)>
			<cfset mergeStructs(variables.settings[arguments.settingsKey],duplicate(variables.defaultSettings[variables.defaultKey])) />
			<cfreturn variables.settings[arguments.settingsKey] />
		</cfif>
	</cffunction>
	
	<cffunction name="mergeStructs" access="private" returntype="void" output="false">
		<cfargument name="struct" type="struct" required="true" />
		<cfargument name="masterStruct" type="struct" required="true" />
		
		<cfset var local = {} />
		<cfset local.masterKeyList = structKeyList(arguments.masterStruct) />
		
		<cfloop list="#local.masterKeyList#" index="local.key">
			<cfif isStruct(arguments.masterStruct[local.key])>
				<cfif NOT StructKeyExists(arguments.struct,local.key)>
					<cfset arguments.struct[local.key] = {} />
				</cfif>
				<cfset mergeStructs(arguments.struct[local.key],arguments.masterStruct[local.key]) />
			<cfelse>
				<cfif NOT StructKeyExists(arguments.struct, local.key)>
					<cfset arguments.struct[local.key] = arguments.masterStruct[local.key] />
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="addSiteSetting" access="public" returntype="void" output="false">
		<cfargument name="siteKey" type="string" required="true" />
		<cfargument name="settings" type="struct" required="true" />
		
		<cfset var local = {} />
		<cfset structRemoveDuplicates(arguments.settings,variables.defaultSettings[variables.defaultKey]) />
		<cfset variables.defaultSettings[arguments.siteKey] = duplicate(arguments.settings) />
		<cfset saveSettings() />
		<cfset loadSettings() />
	</cffunction>
	
	<cffunction name="loadSettings" access="public" returntype="void" output="false">
		<cfset var local = {} />
		<cfset local.settings = {} />
		
		<cfif fileExists("#expandpath(variables.settingsFilePath & '/' & variables.settingsFileName)#")>
			<cffile action="read" file="#expandpath(variables.settingsFilePath & '/' & variables.settingsFileName)#" variable="local.settingsFile" />
			<cfif isStruct(deserializeJSON(local.settingsFile))>
				<cfset local.settings = deserializeJSON(local.settingsFile) />
			</cfif>
		</cfif>
		
		<cfset deleteKey(local.settings,variables.defaultKey) />
		<cfset variables.settings = local.settings />
	</cffunction>
	
	<cffunction name="saveSettings" access="private" returntype="void" output="false">
		<cfset var local = {} />
		<cfset local.settings = duplicate(variables.defaultSettings) />
		<cfset deleteKey(local.settings,variables.defaultKey) />
		
		<cffile action="write" file="#expandpath(variables.settingsFilePath & '/' & variables.settingsFileName)#" output="#serializeJSON(local.settings)#" />
	</cffunction>
	
	<cffunction name="deleteKey" access="private" returntype="void" output="false">
		<cfargument name="struct" type="struct" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfif StructKeyExists(arguments.struct,arguments.key)>
			<cfset StructDelete(arguments.struct,arguments.key) />
		</cfif>
	</cffunction>
	
	<cffunction name="structRemoveDuplicates" access="private" returntype="void" output="false">
		<cfargument name="struct" type="struct" required="true" />
		<cfargument name="masterStruct" type="struct" required="true" />
		
		<cfset var local = {} />
		<cfset local.keyList = structKeyList(arguments.struct) />
		
		<cfloop list="#local.keyList#" index="local.key">
			<cfif isStruct(arguments.struct[local.key])>
				<cfset structRemoveDuplicates(arguments.struct[local.key],arguments.masterStruct[local.key]) />
				<cfif NOT listLen(StructKeyList(arguments.struct[local.key]))>
					<cfset deleteKey(arguments.struct,local.key) />
				</cfif>
			<cfelse>
				<cfif arguments.struct[local.key] EQ arguments.masterStruct[local.key]>
					<cfset deleteKey(arguments.struct,local.key) />
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>