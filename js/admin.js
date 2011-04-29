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
jQuery(function($){
	
	$(document).ajaxStop($.unblockUI);
	$('.btn').button();
	
	$('#btnSave').click(function(){
		var settings = {};
		settings['facebook'] = {};
		settings['facebook']['client_id'] = $('#client_id').val();
		
		settings = JSON.stringify(settings);
		
		$.blockUI({ message: '<h2>Saving your settings...</h2>' });
		
		$.getJSON(
			fbconnect.proxy,
			{method:'saveSettings',settings:settings},
			function(response){
				if (!response.success){
					alert(response.message);
				}
			}
		);
	});
	
});