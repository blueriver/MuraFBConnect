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

<!--- this tells the the config.cfm to secure access --->
<cfset secure="true">
<cfinclude template="plugin/config.cfm" />

<cfsilent>
	<!--- TODO: Implement code... --->
</cfsilent>

<cfsavecontent variable="variables.body">
	<cfoutput>
	<h2>#pluginConfig.getName()#</h2>	
	</cfoutput>
	
	<!--- settings editor --->
	<cfinclude template="admin/dsp_settingsEditor.cfm" />
</cfsavecontent>

<cfoutput>#$.getBean('pluginManager').renderAdminTemplate(body=variables.body,pageTitle=pluginConfig.getName())#</cfoutput>