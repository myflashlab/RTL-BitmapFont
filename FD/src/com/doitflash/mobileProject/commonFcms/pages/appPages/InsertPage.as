package com.doitflash.mobileProject.commonFcms.pages.appPages
{
	import com.doitflash.text.modules.MySprite
	import com.doitflash.consts.Orientation;
	import com.doitflash.text.TextArea;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import com.doitflash.mobileProject.commonFcms.extraManager.InsertData;
	import com.doitflash.mobileProject.commonFcms.extraManager.InputText;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/14/2011 12:14 PM
	 */
	public class InsertPage extends InsertData 
	{
		private var _nameStr:String = "<font face='PT Sans Narrow' color='#526896' size='20'>Page Name</font>";
		private var _iconStr:String = "";
		private var _pluginStr:String = "";
		
		private var _nameTxt:InputText;
		private var _iconTxt:InputText;
		private var _pluginTxt:InputText;
		private var _localDbTxt:InputText;
		private var _remoteDbPrefixTxt:InputText;
		
		public function InsertPage():void 
		{
			super();
		}
		
		override protected function init():void
		{
			//_base.showPreloader(true);
			//_base.gateway.call("designControl.Logo.getData", new Responder(initNow, _base.onFault));
			
			if(!_nameTxt) initFields();
		}
		
		private function initNow():void
		{
			
			
			// make sure to show what is saved in database
			//_iconTxt.value = _iconStr;
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initFields():void
		{
			_nameTxt = new InputText();
			_nameTxt.extraOrientation = Orientation.HORIZONTAL;
			_nameTxt.base = _base;
			_nameTxt.labelFormat = _formatLabel;
			_nameTxt.inputFormat = _formatInput;
			_nameTxt.inputWidth = _inputWidth;
			_nameTxt.inputHeight = 70;
			_nameTxt.value = _nameStr;
			_nameTxt.label = "Page Name:";
			_body.addChild(_nameTxt);
			_nameTxt.getListOfExtras.add(_extraManager.createPreview(_nameTxt, _base.projectPath));
			
			_iconTxt = new InputText();
			_iconTxt.extraOrientation = Orientation.HORIZONTAL;
			_iconTxt.base = _base;
			_iconTxt.labelFormat = _formatLabel;
			_iconTxt.inputFormat = _formatInput;
			_iconTxt.inputWidth = _inputWidth;
			_iconTxt.value = _iconStr;
			_iconTxt.label = "Page Icon:";
			_body.addChild(_iconTxt);
			_iconTxt.getListOfExtras.add(_extraManager.createServerBrowse("/", _iconTxt, "Choose an icon for your page", "Browse server or upload the icon to server<br>Recommended size for your icons are: <b>96 X 96 pixels</b>", "SELECT", onIconChooseResult));
			//_iconTxt.getListOfExtras.add(_extraManager.createNotice("Add the location of this product relative to the<br>secret folder"));
			//_iconTxt.getListOfExtras.add(_extraManager.createPreview(_iconTxt, _base.projectPath));
			
			_pluginTxt = new InputText();
			_pluginTxt.extraOrientation = Orientation.HORIZONTAL;
			_pluginTxt.base = _base;
			_pluginTxt.labelFormat = _formatLabel;
			_pluginTxt.inputFormat = _formatInput;
			_pluginTxt.inputWidth = _inputWidth;
			_pluginTxt.value = "";
			_pluginTxt.label = "Used Plugin:";
			_body.addChild(_pluginTxt);
			_pluginTxt.getListOfExtras.add(_extraManager.createPluginBrowse(_pluginTxt, "Pick the plugin you wish to use with this page", "Click to see the list of installed plugins<br><br>Please note that changing the plugin<br>name will erase all the currently<br>saved content for this page", "SELECT", onPluginChooseResult));
			
			_localDbTxt = new InputText();
			_localDbTxt.base = _base;
			_localDbTxt.labelFormat = _formatLabel;
			_localDbTxt.inputFormat = _formatInput;
			_localDbTxt.inputWidth = _inputWidth;
			_localDbTxt.value = "";
			_localDbTxt.label = "Cache database:";
			_body.addChild(_localDbTxt);
			_localDbTxt.getListOfExtras.add(_extraManager.createNotice("Some plugins are designed to save data<br>to local cache on mobile devices for<br>better performance. Make sure to specify<br>a unique name for each page"));
			
			_remoteDbPrefixTxt = new InputText();
			_remoteDbPrefixTxt.base = _base;
			_remoteDbPrefixTxt.labelFormat = _formatLabel;
			_remoteDbPrefixTxt.inputFormat = _formatInput;
			_remoteDbPrefixTxt.inputWidth = _inputWidth;
			_remoteDbPrefixTxt.value = "";
			_remoteDbPrefixTxt.label = "Remote DB prefix:";
			_body.addChild(_remoteDbPrefixTxt);
			_remoteDbPrefixTxt.getListOfExtras.add(_extraManager.createNotice("Some plugins need to save their data in database<br>to make sure this information is saved in a unique<br>table in the fcms db, please enter a prefix name<br>for them."));
			
		}
		
		private function onIconChooseResult($browser:*=null):void
		{
			if ($browser)
			{
				if (!$browser.window.selectedItem) _base.showAlert("Please select something before hitting the \"SELECT\" button!", "Error!");
				else if ($browser.window.selectedItem.type != "file") _base.showAlert("You must choose a file!", "Error!");
				else 
				{
					var txt:InputText = $browser.data.target;
					_iconStr = $browser.window.selectedItem.data.relativePath;
					txt.value = _iconStr;
					
					/*for (var name:String in $browser.window.selectedItem.data) 
					{
						C.log(name + " = " + $browser.window.selectedItem.data[name])
					}*/
				}
			}
		}
		
		private function onPluginChooseResult($pluginName:String, $target:*):void
		{
			var txt:InputText = $target;
			_pluginStr = $pluginName;
			txt.value = _pluginStr;
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			var w:Number = 555;
			var h:Number = 30;
			var y:Number = 0;
			
			if (_nameTxt)
			{
				_nameTxt.x = y;
				_nameTxt.y = y;
				_nameTxt.width = w;
				_nameTxt.height = h;
				y += _nameTxt.height + 15;
				
				_iconTxt.x = _nameTxt.x;
				_iconTxt.y = y;
				_iconTxt.width = w;
				_iconTxt.height = h;
				y += _iconTxt.height + 15;
				
				_pluginTxt.x = _nameTxt.x;
				_pluginTxt.y = y;
				_pluginTxt.width = w;
				_pluginTxt.height = h;
				y += _pluginTxt.height + 15;
				
				_localDbTxt.x = _nameTxt.x;
				_localDbTxt.y = y;
				_localDbTxt.width = w;
				_localDbTxt.height = h;
				y += _localDbTxt.height + 15;
				
				_remoteDbPrefixTxt.x = _nameTxt.x;
				_remoteDbPrefixTxt.y = y;
				_remoteDbPrefixTxt.width = w;
				_remoteDbPrefixTxt.height = h;
				y += _remoteDbPrefixTxt.height + 2;
			}
			
			_body.width = w;
			_body.height = y;
		}
		
		override protected function toSaveNew():void
		{
			// check if fields are not empty
			if (_nameTxt.value.length < 1 ||
				_iconTxt.value.length < 1 ||
				_pluginTxt.value.length < 1)
			{
				_base.getAlert.getDll.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				_base.showAlert("you need to set a \"name\", \"page icon\" and a \"plugin name\" for your page atleast!", "ERROR", 450, 250);
				return;
			}
			
			// get the highest record id availble in db
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.highestRecordId", new Responder(onHighestRecordsResult, _base.onFault), _base.serverTime);
		}
		
		override protected function toSaveUpdate():void
		{
			// check if fields are not empty
			if (_nameTxt.value.length < 1 ||
				_iconTxt.value.length < 1 ||
				_pluginTxt.value.length < 1)
			{
				_base.getAlert.getDll.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				_base.showAlert("you need to set a \"name\", \"page icon\" and a \"plugin name\" for your page atleast!", "ERROR", 450, 250);
				return;
			}
			
			// save the updated details
			_data.name = escape(_nameTxt.value);
			_data.icon = _iconTxt.value;
			_data.type = _pluginTxt.value;
			_data.localDb = _localDbTxt.value;
			_data.remoteDbPrefix = _remoteDbPrefixTxt.value;
			
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.updateItem", new Responder(onUpdateResult, _base.onFault), _data, _base.serverTime);
		}
		
		private function onHighestRecordsResult($result:Number):void
		{
			// save all the data that is supposed to be saved on server
			_data = { };
			_data.name = escape(_nameTxt.value);
			_data.icon = _iconTxt.value;
			_data.type = _pluginTxt.value;
			_data.localDb = _localDbTxt.value;
			_data.remoteDbPrefix = _remoteDbPrefixTxt.value;
			_data.itemOrder = $result + 1;
			_data.itemActive = 1;
			
			// insert information of the new product to database...
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.insertNewItem", new Responder(onInsertResult, _base.onFault), _data, _base.serverTime);
		}
		
		

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override public function fieldsInfo($info:Object):void
		{
			super.fieldsInfo($info);
			
			if (!$info) return;
			
			_nameTxt.value = unescape(_data.name);
			_iconTxt.value = _data.icon;
			_pluginTxt.value = _data.type;
			_localDbTxt.value = _data.localDb;
			_remoteDbPrefixTxt.value = _data.remoteDbPrefix;
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		
		
	}
	
}