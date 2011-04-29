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
<cfcomponent extends="mura.plugin.pluginGenericEventHandler">
	
	<cfset variables.rbFactories={}>
		
	<cffunction name="onApplicationLoad" access="public" returntype="void" output="false">
		<cfargument name="$" />
		<cfset var local={}>
		<cfset local.rsSites=variables.pluginConfig.getAssignedSites()>
	
		<cfloop query="local.rsSites">
			<!--- Get the siteBean--->
			<cfset local.site=$.getBean("settingsManager").getSite(local.rsSites.siteID)>
			<!--- Create an instance of a resource bundle factory for each site and set it int he plugin application object --->
			<cfset variables.rbFactories[local.rsSites.siteID]=createObject("component","mura.resourceBundle.resourceBundleFactory").init(local.site.getRBFactory(),"#expandPath('/plugins')#/#pluginConfig.getDirectory()#/resourceBundles/",local.site.getJavaLocale())>
			<!--- Make sure that the Facebook subtype is created.
			 	  user type eq 1, group eq 2--->
			<cfset variables.configBean.getClassExtensionManager().getSubTypeByName("2","Facebook",local.rsSites.siteID).save()>
			
			<!--- Make sure that the Facebook user group is created --->
			<cfset local.group=$.getBean("user").loadBy(groupname="Facebook",siteid=local.rsSites.siteID)>
			<cfif local.group.getIsNew()>
				<cfset local.group.setSiteID(local.rsSites.siteID).setType(1).setGroupName("Facebook").setIsPublic(1).save()>
			</cfif>
		</cfloop>
		
		<cfset variables.pluginConfig.addEventHandler(this)>
	</cffunction>
	
	<cffunction name="onGlobalRequestStart" access="public" returntype="void" output="false">
		<cfargument name="$" />
		
		<cfif NOT structKeyExists(application,pluginConfig.getPackage())>
			<cfset application[pluginConfig.getPackage()] = {} />
			<cfset application[pluginConfig.getPackage()]['settingsService'] = CreateObject('component','#pluginConfig.getPackage()#.com.blueriver.SettingsService').init(
						application.configBean.getContext() & '/plugins/' & pluginConfig.getDirectory(),
						'ps' & hash('#pluginConfig.getPackage()#') & '.json',
						getDefaultSettings(),
						'default'
					) />
		</cfif>
	</cffunction>
	
	<cffunction name="onSiteRequestStart" access="public" returntype="void" output="false">
		<cfargument name="$" />
		<cfset onGlobalRequestStart(arguments.$) />
	</cffunction>
	
	<cffunction name="onRenderStart" access="public" returntype="void" output="false">
		<cfargument name="$" />

		<cfif $.currentUser('isLoggedIn') and listLast($.currentUser("email"),"@") eq "facebook.com" and $.event('display') neq 'editProfile'>
			<cflocation addtoken="no" url="#$.siteConfig('EditProfileURL')#&returnURL=#URLEncodedFormat($.getCurrentURL())#" />
		</cfif>
	
	</cffunction>

	<cffunction name="onSiteLoginPromptRender" access="public" returntype="string" output="false">
		<cfargument name="$" />
		
		<cfset var outout = "" />
		
		<cfsavecontent variable="output">
			<cfoutput>#$.dspObject_Include(theFile="dsp_login.cfm")#</cfoutput><!--- Output the login form --->
			<cfinclude template="../displayObjects/dsp_facebookLogin.cfm" /><!--- include / ouput the facebook login button --->
		</cfsavecontent>
		
		<cfreturn trim(output) />
	</cffunction>
	
	<cffunction name="onSiteEditProfileRender" access="public" returntype="string" output="false">
		<cfargument name="$" />
		
		<cfset var local = {} />
		
		<cfset local.email = $.currentUser("email") />
		<cfif listLast($.currentUser("email"),'@') IS 'facebook.com'>
			<cfset local.email = "" />
		</cfif>
		
		<cfset local.rbFactory=variables.rbFactories[$.event('siteID')]>
		
		<cfsavecontent variable="local.output">
			<cfif listLast($.currentUser("email"),'@') IS 'facebook.com'>
				<cfinclude template="../displayObjects/dsp_facebookEmail.cfm">
			<cfelse>
				<cfinclude template="../displayObjects/dsp_edit_profile.cfm">
			</cfif>
		</cfsavecontent>
		
		<cfreturn trim(local.output) />
	</cffunction>
	
	<cffunction name="getDefaultSettings" access="private" returntype="struct" output="false">
		<cfset var local = {} />
		<cfset local.settings = {} />
		<cfset local.settings['default'] = {} />
		<cfset local.settings['default']['facebook'] = {} />
		<cfset local.settings['default']['facebook']['client_id'] = pluginConfig.getSetting('client_id') />
		
		<cfreturn local.settings />
	</cffunction>

</cfcomponent>