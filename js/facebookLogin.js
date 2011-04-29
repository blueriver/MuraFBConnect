/* Copyright 2011 Blue River Interactive
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at

 *     http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * */
jQuery.noConflict();
jQuery(function($){
	$('#svLoginContainer').append($('#fbLoginContainer').html());
	$('#fbLoginContainer').remove();
	
	window.fbAsyncInit = function() {
	    FB.init({appId: fbLogin.client_id, status: true, cookie: true, xfbml: true});
	    FB.getLoginStatus(function(response){
			if (response.session){
				
				// user is logged in and has allowed our application
				// get the user's information
				FB.api('/me',function(response){
					// now that we have the user's object we need to send it back to the plugin so a user can be created
					var user = JSON.stringify(response);
					$.getJSON(
						fbLogin.facade,
						{method:"facebookLogin",user:user},
						function(result){
							if (result.success === true){
								window.location = fbLogin.returnURL;
							} else {
								FB.logout(function(response){
									alert('There was a problem while trying to log you in, please try again shortly.');
								});
							}
						}
					);
				});
				
				$('#fbLogin').remove();
				$('#fbLogout').show();
			}
		});
	};
	
	(function() {
		var e = document.createElement('script');
		e.type = 'text/javascript';
		e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
		e.async = true;
		document.getElementById('fb-root').appendChild(e);
	}());
	
	$('#fbLogin').live('click',function(){
		FB.login(function(response){
			if (response.session){
				// user is logged in and has allowed our application
				// get the user's information
				FB.api('/me',function(response){
					// now that we have the user's object we need to send it back to the plugin so a user can be created
					var user = JSON.stringify(response);
					$.getJSON(
						fbLogin.facade,
						{method:"facebookLogin",user:user},
						function(result){
							if (result.success === true){
								window.location = fbLogin.returnURL;
							} else {
								FB.logout(function(response){
									alert('There was a problem while trying to log you in, please try again shortly.');
								});
							}
						}
					);
				});
			}
		});
	});
	
	$('#fbLogout').live('click',function(){
		FB.logout(function(response){
			window.location = fbLogin.returnURL;
		});
	});
});