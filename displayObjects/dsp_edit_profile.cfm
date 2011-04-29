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
<cfif not isObject($.event("userBean"))>
<cfset $.event("userBean", $.getBean("userManager").read($.currentUser("userID")) ) />
</cfif>
<cfset local.userBean=$.event("userBean")>

<cfparam name="msg" default="#local.rbFactory.getKey('user.message')#">
<cfparam name="request.categoryID" default="">
<cfset $.addToHTMLHeadQueue("fckeditor.cfm")>
</cfsilent>
<cfoutput>

<#$.getHeaderTag('headline')#><cfif not $.currentUser().isLoggedIn()>#local.rbFactory.getKey('user.createprofile')#<cfelse>
#local.rbFactory.getKey('user.editprofile')#</cfif></#$.getHeaderTag('headline')#>
<div id="svEditProfile">
<cfif not(structIsEmpty(local.userBean.getErrors()) and $.event("doaction") eq 'createprofile')>

<cfif not structIsEmpty(local.userBean.getErrors()) >
 <div id="editProfileMsg" class="required">#$.getBean("utility").displayErrors(local.userBean.getErrors())#</div>
<cfelse>
  <div id="editProfileMsg" class="required">#msg#</div>
</cfif>
	<!--- <a id="editSubscriptions" href="##">Edit Email Subscriptions</a> --->
	<form name="profile" id="profile" action="?nocache=1" method="post" onsubmit="return validate(this);"  enctype="multipart/form-data" novalidate="novalidate">
	<fieldset>
	<legend>#local.rbFactory.getKey('user.contactinformation')#</legend>
	<ul>
	<li>
	<label for="firstName">#local.rbFactory.getKey('user.fname')#<span class="required">*</span></label>
	<input type="text" id="firstName" class="text" name="fname" value="#HTMLEditFormat(local.userBean.getfname())#" required="true" message="#htmlEditFormat(local.rbFactory.getKey('user.fnamerequired'))#" maxlength="50"/>
	</li>
	<li>
	<label for="lastName">#local.rbFactory.getKey('user.lname')#<span class="required">*</span></label>
	<input type="text" id="lastName" class="text" name="lname" value="#HTMLEditFormat(local.userBean.getlname())#" required="true" message="#htmlEditFormat(local.rbFactory.getKey('user.lnamerequired'))#" maxlength="50"/>
	</li>
	<li>
	<label for="usernametxt">#local.rbFactory.getKey('user.username')#<span class="required">*</span></label>
	<input name="username" id="usernametxt" type="text" value="#HTMLEditFormat(local.userBean.getusername())#" class="text"  required="yes" message="#htmlEditFormat(local.rbFactory.getKey('user.usernamerequired'))#" maxlength="50">
	</li>	
	
	<li>
	<label for="companytxt">#local.rbFactory.getKey('user.organization')#</label>
	<input name="company" id="companytxt" type="text" value="#htmlEditFormat(local.userBean.getCompany())#" class="text" maxlength="50"/>
	</li>

       
<cfif not $.currentUser().isLoggedIn()>
	<li>
	<label for="emailtxt">#local.rbFactory.getKey('user.email')#<span class="required">*</span></label>
	<input name="email" id="emailtxt" validate="email" type="text" value="#local.userBean.getEmail()#" class="text"  required="true" message="#HTMLEditFormat(local.rbFactory.getKey('user.emailvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="email2xt">#local.rbFactory.getKey('user.emailconfirm')#<span class="required">*</span></label>
	<input name="email2" id="email2txt" type="text" value="" class="text" validate="match" matchfield="email" required="true" message="#HTMLEditFormat(local.rbFactory.getKey('user.emailconfirmvalidate'))#" maxlength="50">
	
	<!--- Comment out the following two password fields to automatically create a random password for the user instead of letting them pick one themselves --->
	<li>
	<label for="passwordtxt">#local.rbFactory.getKey('user.password')#<span class="required">*</span></label>
	<input name="passwordNoCache" validate="match" matchfield="password2" type="password" value="" class="text"  message="#HTMLEditFormat(local.rbFactory.getKey('user.passwordvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="password2txt">#local.rbFactory.getKey('user.passwordconfirm')#<span class="required">*</span></label>
	<input  name="password2" id="password2txt" type="password" value="" required="true" class="text"  message="#HTMLEditFormat(local.rbFactory.getKey('user.passwordconfirmrequired'))#" maxlength="50">
	</li>
	<!--- <cfinclude template="dsp_captcha.cfm" > --->
	#$.dspObject_include("dsp_form_protect.cfm")#
<cfelse>
 	 <li>
	<label for="emailtxt">#local.rbFactory.getKey('user.email')#<span class="required">*</span></label>
	<input name="email" id="emailtxt" validate="email" type="text" value="#htmlEditFormat(local.userBean.getEmail())#" class="text"  required="true" message="#HTMLEditFormat(local.rbFactory.getKey('user.emailvalidate'))#" maxlength="50">
	</li>
	<cfif local.userBean.getSubType() neq "Facebook">
	<li>
	<label for="passwordtxt">#local.rbFactory.getKey('user.password')#</label>
	<input name="passwordNoCache" validate="match" matchfield="password2" type="password" value="" class="text"  message="#HTMLEditFormat(local.rbFactory.getKey('user.passwordvalidate'))#" maxlength="50">
	</li>
	<li>
	<label for="password2txt">#local.rbFactory.getKey('user.passwordconfirm')#</label>
	<input  name="password2" id="password2txt" type="password" value="" required="false" class="text"  message="#HTMLEditFormat(local.rbFactory.getKey('user.passwordconfirmrequired'))#" maxlength="50">
	</li>
	<cfelse>
	<li>
	<label for="passwordtxt">#local.rbFactory.getKey('user.password')#</label>
	<em>#local.rbFactory.getKey('user.logsInFromFacebook')#<em>
	</li>
	</cfif>

</cfif>

</ul>
</fieldset>

<cfif $.getBean('categoryManager').getCategoryCount($.event('siteID'))>
<fieldset>
	<legend>#local.rbFactory.getKey('user.interests')#:</legend>		
			<cf_dsp_categories_nest siteid="#$.event('siteID')#">
</fieldset>
</cfif>
<!--- This *should* work if you want to allow an avatar, but it hasn't been fully tested. If you need help with it, hit us up in the Mura forum.
<fieldset>
	<legend>Upload Your Photo</legend>
		<ul class="columns2">
			<li class="col">
				<p class="inputNote">Photo must be JPG format optimized for up to 150 pixels wide.</p>
					<input type="file" name="newFile" validate="regex" regex="(.+)(\.)(jpg|JPG)" message="Your logo must be a .JPG" value=""/>
			</li>
			<li class="col">
				<cfif len(local.userBean.getPhotoFileID())>
							<img src="#application.configBean.getContext()#/tasks/render/small/?fileid=#local.userBean.getPhotoFileID()#" alt="your photo" />
			<input type="checkbox" name="removePhotoFile" value="true"> Remove current logo 
			</cfif>
			</li>
		</ul>
</fieldset>
--->

<!--- extended attributes as defined in the class extension manager --->
<cfsilent>
<cfif local.userBean.getIsNew()>
	<cfset local.userBean.setSiteID($.event("siteid"))>
</cfif>
<cfif local.userBean.getIsPublic()>
<cfset local.userPoolID=application.settingsManager.getSite(local.userBean.getSiteID()).getPublicUserPoolID()>
<cfelse>
<cfset local.userPoolID=application.settingsManager.getSite(local.userBean.getSiteID()).getPrivateUserPoolID()>
</cfif>
<cfset local.extendSets=application.classExtensionManager.getSubTypeByName(local.userBean.gettype(),local.userBean.getsubtype(),local.userPoolID).getExtendSets(true) />
</cfsilent>
<cfif arrayLen(local.extendSets)>
<cfloop from="1" to="#arrayLen(local.extendSets)#" index="local.s">	
	<cfset local.extendSetBean=local.extendSets[local.s]/>
		<cfsilent>
		<cfset local.started=false />
		<cfset local.attributesArray=local.extendSetBean.getAttributes() />
		</cfsilent>
		
		<cfloop from="1" to="#arrayLen(local.attributesArray)#" index="local.a">	
		<cfset local.attributeBean=local.attributesArray[local.a]/>
		<cfset local.attributeValue=local.userBean.getExtendedAttribute(local.attributeBean.getAttributeID(),true)/>
			<cfif local.attributeBean.getType() neq "hidden">
			<cfif not local.started>
			<fieldset>
			<legend>#local.extendSetBean.getName()#</legend>
				<input name="extendSetID" type="hidden" value="#local.extendSetBean.getExtendSetID()#"/>
				<ul>
				<li>
				<cfif not listFind("TextArea,MultiSelectBox",local.attributeBean.getType())>
					<label for="ext#local.attributeBean.getAttributeID()#"><cfif local.attributeBean.getRequired()><b>*</b></cfif>#local.attributeBean.getLabel()#<!--- <cfif len(local.attributeBean.gethint())><br />#local.attributeBean.gethint()#</cfif> ---></label>
				<cfelse>
					<label for="ext#local.attributeBean.getAttributeID()#"><cfif local.attributeBean.getRequired()><b>*</b></cfif>#local.attributeBean.getLabel()#<cfif len(local.attributeBean.gethint())><br/>#local.attributeBean.gethint()#</cfif></label>
				</cfif>
			</cfif>
				<cfif local.attributeBean.getType() neq 'TextArea'>		
					#local.attributeBean.renderAttribute(local.attributeValue,true)#
					<cfif local.attributeBean.getType() neq "MultiSelectBox" and len(local.attributeBean.gethint())>
						<div class="inputBox rightCol" >
							<p class="fieldDescription">#local.attributeBean.gethint()#</p>
						</div>	
					</cfif>
					<cfif local.attributeBean.getType() eq "File" and len(local.attributeValue) and local.attributeValue neq 'useMuraDefault'>
						<div class="inputBox rightCol">
							<a href="#application.configBean.getContext()#/tasks/render/file/?fileID=#local.attributeValue#" target="_blank">[Download]</a> 
							<br/><input type="checkbox" name="extDelete#local.attributeBean.getAttributeID()#" value="true"/> 
							Delete
						</div>
					</cfif>
				<cfelse>
				#local.attributeBean.renderAttribute(local.attributeValue)#
				</cfif>	
			</cfif>
			</li>
			<cfif not local.started>
			</ul>
			</fieldset>
			<cfset local.started=true>
			</cfif>
		</cfloop>
		
</cfloop>
</cfif>

<div class="buttons">
	<cfif $.currentUser().isLoggedIn()>
		<input name="submit" type="submit"  value="#HTMLEditFormat(local.rbFactory.getKey('user.updateprofile'))#" />
		<input type="hidden" name="userid" value="#$.currentUser('userID')#"/>
		<input type="hidden" name="doaction" value="updateprofile">
	<cfelse>
		<input type="hidden" name="userid" value=""/>
		<input type="hidden" name="isPublic" value="1"/>
		<input type="hidden" name="inactive" value="0"/> <!--- Set the value to "1" to require admin approval of new accounts --->
		<input name="submit" type="submit"  value="#HTMLEditFormat(local.rbFactory.getKey('user.createprofile'))#"/>
		<input type="hidden" name="doaction" value="createprofile">
		<!--- <input type="hidden" name="groupID" value="[userid from Group Detail page url]"> Add users to a specific group --->
	</cfif> 

	<input type="hidden" name="siteid" value="#HTMLEditFormat($.event('siteID'))#" />
	<input type="hidden" name="returnURL" value="#HTMLEditFormat($.event('returnURL'))#" />
	<input type="hidden" name="display" value="editprofile" />
</div>
</form>
</div>
<script type="text/javascript"> 
document.getElementById("profile").elements[0].focus();
setHTMLEditors(200,500);
</script>
<cfelse>
<!--- This is where the script for a newly created account does if inactive is default to 1 for new accounts--->
<cfsilent>
<cfif local.userBean.getInActive() and len($.siteConfig("ExtranetPublicRegNotify"))>
<cfsavecontent variable="local.notifyText"><cfoutput>
A new registration has been submitted to #getSite().getSite()#

Date/Time: #now()#
#local.rbFactory.getKey('user.email')#: #local.userBean.getEmail()#
#local.rbFactory.getKey('user.username')#: #local.userBean.getUserName()#
#local.rbFactory.getKey('user.fname')#: #local.userBean.getFname()#
#local.rbFactory.getKey('user.lname')#: #local.userBean.getLname()#
</cfoutput></cfsavecontent>
<cfset local.email=$.getBean('mailer') />
<cfset local.email.sendText(local.notifyText,
				$.siteConfig("ExtranetPublicRegNotify"),
				getSite().getSite(),
				'#$.siteConfig("site")# Public Registration',
				$.event('siteID') ) />

</cfif>
</cfsilent>

<cfif local.userBean.getInActive()>
<div id="editProfileMsg" class="required">
<p class="success">#local.rbFactory.getKey('user.thankyouinactive')#</p>
</div>
<cfelse>
<div id="editProfileMsg" class="required"><p class="notice">#local.rbFactory.getKey('user.thankyouactive')#</p></div>
</cfif>
</cfif>
</cfoutput>
