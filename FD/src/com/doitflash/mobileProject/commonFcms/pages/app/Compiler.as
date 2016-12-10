package com.doitflash.mobileProject.commonFcms.pages.app
{
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Position;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.Responder;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import install.Main;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.events.AlertEvent;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import com.doitflash.mobileProject.commonFcms.extraManager.TabButton;
	import com.doitflash.mobileProject.commonFcms.extraManager.InputText;
	import com.doitflash.mobileProject.commonFcms.extraManager.ExtraManager;
	
	import com.luaye.console.C;
	
	import com.adobe.net.URI;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/14/2012 3:57 PM
	 */
	public class Compiler extends MySprite 
	{
		private var _lastAppId:String = "my.special.scheme";
		private var _manifestAdditions:String;
		private var _extensions:String;
		
		private var _extraManager:ExtraManager = new ExtraManager();
		private var _formatInput:TextFormat;
		private var _formatLabel:TextFormat;
		
		private var _appNameStr:String = "AppName";
		private var _appNameTxt:InputText;
		private var _appIdStr:String = "";
		private var _appIdTxt:InputText;
		private var _appIconStr:String = "";
		private var _appIconTxt:InputText;
		private var _appVersionStr:String = "1.0";
		private var _appVersionTxt:InputText;
		private var _appGooglePlayStr:String = "false";
		private var _appGooglePlayTxt:InputText;
		private var _appFontsStr:String = 	"<item name=\"Univers Condensed\" src=\"universCondensed.swf\" />\r" +
											"<item name=\"Verdana\" src=\"verdana.swf\" />\r" +
											"<item name=\"Arimo\" src=\"arimo.swf\" />\r" +
											"<item name=\"PT Sans Narrow\" src=\"ptSansNarrow.swf\" />\r" +
											"<item name=\"Red Alert\" src=\"Red-Alert.swf\" />";
		private var _appFontsTxt:InputText;
		private var _appPermissionsTxt:InputText;
		private var _appExtensionTxt:InputText;
		private var _lastCompile:Date;
		private var _downloadLink:String;
		
		private var _inputWidth:Number = 500;
		
		protected var _saveBtn:TabButton;
		protected var _downloadBtn:TabButton;
		
		private var _scroller:*;
		protected var _body:MySprite = new MySprite();
		
		public function Compiler():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (_scroller)
			{
				this.removeChild(_scroller);
				_scroller = null;
			}
			
			if (_saveBtn)
			{
				_saveBtn.removeEventListener(MouseEvent.CLICK, onSave);
				this.removeChild(_saveBtn);
				_saveBtn = null;
				
				_downloadBtn.removeEventListener(MouseEvent.CLICK, onDownload);
				_downloadBtn.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				_downloadBtn.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				this.removeChild(_downloadBtn);
				_downloadBtn = null;
			}
			
			_body.y = 0;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			// set default valuse
			_appNameStr = String(_base.internalID).substring(String(_base.internalID).lastIndexOf(".") + 1)
			_appIdStr = generateAppId();
			_manifestAdditions = "<manifestAdditions><![CDATA[<manifest android:installLocation=\"auto\">\r\t" +
									"<uses-sdk android:minSdkVersion=\"8\" android:targetSdkVersion=\"10\" />\r\t" +
									"<uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\" />\r\t" +
									"<uses-permission android:name=\"android.permission.INTERNET\" />\r\t" +
									"<uses-permission android:name=\"android.permission.VIBRATE\" />\r\t" +
									"<uses-permission android:name=\"android.permission.WAKE_LOCK\" />\r\t" +
									"<uses-permission android:name=\"android.permission.DISABLE_KEYGUARD\" />\r\t" +
									"<uses-permission android:name=\"android.permission.WRITE_EXTERNAL_STORAGE\" />\r\t" +
									"<uses-feature android:required=\"true\" android:name=\"android.hardware.touchscreen.multitouch\" />\r\t" +
									"<application>\r\t\t" +
										"<activity>\r\t\t\t" +
											"<intent-filter>\r\t\t\t\t" +
												"<action android:name=\"android.intent.action.MAIN\" />\r\t\t\t\t" +
												"<category android:name=\"android.intent.category.LAUNCHER\" />\r\t\t\t" +
											"</intent-filter>\r\t\t\t" +
											"<intent-filter>\r\t\t\t\t" +
												"<action android:name=\"android.intent.action.VIEW\" />\r\t\t\t\t" +
												"<category android:name=\"android.intent.category.BROWSABLE\" />\r\t\t\t\t" +
												"<category android:name=\"android.intent.category.DEFAULT\" />\r\t\t\t\t" +
												"<data android:scheme=\"" + _lastAppId + "\" />\r\t\t\t" +
											"</intent-filter>\r\t\t" +
										"</activity>\r\t" +
									"</application>\r" +
									"</manifest>]]></manifestAdditions>";
			
			_extensions = 	"<extensions>\r\t" +
								//"<extensionID>com.adobe.mobile</extensionID>\r\t" + 
								"<extensionID>com.adobe.Vibration</extensionID>\r\t" + 
								//"<extensionID>com.ssd.ane.androidextensions</extensionID>\r\t" + 
								"<extensionID>pl.mateuszmackowiak.nativeANE.NativeAlert</extensionID>\r\t" + 
								"<extensionID>milkmidi.air3.demo</extensionID>\r\t" + 
								//"<extensionID>com.doitflash.air.extensions.toast</extensionID>\r\t" + 
								"<extensionID>com.doitflash.air.extensions</extensionID>\r" + 
							"</extensions>";
			
			// get information from the installed plugins
			_base.showPreloader(true);
			_base.gateway.call("plugins.Manage.getInstalledPlugins", new Responder(onInstalledPluginsResult, _base.onFault), _base.serverTime);
			
			onResize();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private

		private function onInstalledPluginsResult($result:Object):void
		{
			_base.showPreloader(false);
			if ($result.status != "true") return;
			
			_manifestAdditions = buildManifestAdditions($result.plugins);
			_extensions = buildExtensions($result.plugins);
			
			// get already saved manifest data
			_base.showPreloader(true);
			_base.gateway.call("compile.Process.getManifest", new Responder(onManifestGet, _base.onFault), _base.serverTime);
		}
		
		private function onManifestGet($result:Object):void
		{
			_base.showPreloader(false);
			if ($result.status != "true") return;
			
			if ($result.manifest)
			{
				// print already saved data from database
				_appNameStr = unescape($result.manifest.appName);
				_appIdStr = unescape($result.manifest.appID);
				_appIconStr = $result.manifest.appIcon;
				_appVersionStr = $result.manifest.appVersion;
				_appGooglePlayStr = $result.manifest.googlePlay;
				_appFontsStr = unescape($result.manifest.appFonts);
				_lastCompile = _base.convertToDate(String($result.manifest.lastCompile));
				_downloadLink = $result.manifest.apk;
			}
			
			initScroller();
			_extraManager.base = _base;
			if (!_formatInput) initFormat();
			if (!_appNameTxt) initFields();
			if (!_saveBtn) initButtons();
			
			_appPermissionsTxt.value = _manifestAdditions;
			_appExtensionTxt.value = _extensions;
			
			checkAppId();
			
			onResize();
			setTimeout(onResize, 20);
		}
		
		private function initScroller():void
		{
			_scroller = new _base.getScroller.getClass();
			_scroller.importProp = _base.getScroller.getDll.exportProp;
			_scroller.maskContent = _body;
			this.addChild(_scroller);
		}
		
		private function initFormat():void
		{
			_formatInput = new TextFormat();
			_formatInput.color = 0x333333;
			_formatInput.size = 13;
			_formatInput.font = "Arimo";
			
			_formatLabel = new TextFormat();
			_formatLabel.color = 0x333333;
			_formatLabel.size = 13;
			_formatLabel.font = "Arimo";
		}
		
		private function initFields():void
		{
			_appNameTxt = new InputText();
			_appNameTxt.extraOrientation = Orientation.HORIZONTAL;
			_appNameTxt.base = _base;
			_appNameTxt.labelFormat = _formatLabel;
			_appNameTxt.inputFormat = _formatInput;
			_appNameTxt.inputWidth = _inputWidth;
			_appNameTxt.value = _appNameStr;
			_appNameTxt.label = "Application Name:";
			_body.addChild(_appNameTxt);
			_appNameTxt.getListOfExtras.add(_extraManager.createNotice("Use words not numbers and start with<br>a capital letter!"));
			
			_appIdTxt = new InputText();
			_appIdTxt.extraOrientation = Orientation.HORIZONTAL;
			_appIdTxt.base = _base;
			_appIdTxt.labelFormat = _formatLabel;
			_appIdTxt.inputFormat = _formatInput;
			_appIdTxt.inputWidth = _inputWidth;
			_appIdTxt.value = _appIdStr;
			_appIdTxt.label = "Application ID:";
			_body.addChild(_appIdTxt);
			_appIdTxt.getListOfExtras.add(_extraManager.createNotice("The application ID must be a unique name and<br>to make sure that you are picking a unique id<br>for your app, use your domain name structure.<br>e.x if you're domain name is \"www.doitflash.com\"<br>write: \"com.doitflash\" and add your app name to<br>the end.<br><br>Optionally put \"air.\" to the beginning of the id<br>so users will know that your app has been built<br>with Adobe Air!"));
			_appIdTxt.getInputTxt.addEventListener(FocusEvent.FOCUS_IN, onAppIdFocusIn);
			_appIdTxt.getInputTxt.addEventListener(FocusEvent.FOCUS_OUT, onAppIdFocusOut);
			
			_appIconTxt = new InputText();
			_appIconTxt.extraOrientation = Orientation.HORIZONTAL;
			_appIconTxt.base = _base;
			_appIconTxt.labelFormat = _formatLabel;
			_appIconTxt.inputFormat = _formatInput;
			_appIconTxt.inputWidth = _inputWidth;
			_appIconTxt.value = _appIconStr;
			_appIconTxt.label = "Application Icon:";
			_body.addChild(_appIconTxt);
			_appIconTxt.getListOfExtras.add(_extraManager.createServerBrowse("/", _appIconTxt, "Choose your app icon...", "upload a 512 X 512 .png icon", "select", onIconChooseResult));
			
			_appVersionTxt = new InputText();
			_appVersionTxt.extraOrientation = Orientation.HORIZONTAL;
			_appVersionTxt.base = _base;
			_appVersionTxt.labelFormat = _formatLabel;
			_appVersionTxt.inputFormat = _formatInput;
			_appVersionTxt.inputWidth = _inputWidth;
			_appVersionTxt.value = _appVersionStr;
			_appVersionTxt.label = "Application Version:";
			_body.addChild(_appVersionTxt);
			_appVersionTxt.getListOfExtras.add(_extraManager.createNotice("Changing the version of the app will<br>notify all distributed apps about the<br>availbility of a new version of your<br>app to be download<br><br>Automatic notification happens only<br>if you've distributed your app outside<br>the Google Play."));
			
			_appGooglePlayTxt = new InputText();
			_appGooglePlayTxt.extraOrientation = Orientation.HORIZONTAL;
			_appGooglePlayTxt.base = _base;
			_appGooglePlayTxt.labelFormat = _formatLabel;
			_appGooglePlayTxt.inputFormat = _formatInput;
			_appGooglePlayTxt.inputWidth = _inputWidth;
			_appGooglePlayTxt.value = _appGooglePlayStr;
			_appGooglePlayTxt.label = "Set for Google Play:";
			_body.addChild(_appGooglePlayTxt);
			_appGooglePlayTxt.getListOfExtras.add(_extraManager.createNotice("if <i>true</i>, the apk will be compiled<br>ready to be published to Google Play"));
			
			_appFontsTxt = new InputText();
			_appFontsTxt.extraOrientation = Orientation.VERTICAL;
			_appFontsTxt.base = _base;
			_appFontsTxt.labelFormat = _formatLabel;
			_appFontsTxt.inputFormat = _formatInput;
			_appFontsTxt.inputWidth = _inputWidth;
			_appFontsTxt.inputHeight = 110;
			_appFontsTxt.value = _appFontsStr;
			_appFontsTxt.label = "Application Fonts:";
			_body.addChild(_appFontsTxt);
			_appFontsTxt.getListOfExtras.add(_extraManager.createServerBrowse("/fcms/assets/font/", _appFontsTxt, "Upload more fonts!", "upload swf font libraries here and add<br>them to the xml structure.", "ok"));
			
			// TODO: make the font installation process easier by downloading fonts from myappera.com
			//_appFontsTxt.getListOfExtras.add(_extraManager.createFontBrowse(_appFontsTxt, "Install fonts you would need in your app!", "Browse our font library and simply drag and drop the ones you want!", "ok", onFontSetup));

			_appPermissionsTxt = new InputText();
			_appPermissionsTxt.extraOrientation = Orientation.HORIZONTAL;
			_appPermissionsTxt.base = _base;
			_appPermissionsTxt.labelFormat = _formatLabel;
			_appPermissionsTxt.inputFormat = new TextFormat("Arimo", 10, 0x333333);
			_appPermissionsTxt.inputWidth = _inputWidth;
			_appPermissionsTxt.inputHeight = 250;
			_appPermissionsTxt.value = _manifestAdditions;
			_appPermissionsTxt.label = "Manifest Additions:";
			_body.addChild(_appPermissionsTxt);
			_appPermissionsTxt.getInputTxt.mouseEnabled = false;
			_appPermissionsTxt.getListOfExtras.add(_extraManager.createNotice("You don't have to change anything here!<br>it will be set automatically based on the<br>plugins you have installed."));
			
			_appExtensionTxt = new InputText();
			_appExtensionTxt.extraOrientation = Orientation.HORIZONTAL;
			_appExtensionTxt.base = _base;
			_appExtensionTxt.labelFormat = _formatLabel;
			_appExtensionTxt.inputFormat = new TextFormat("Arimo", 10, 0x333333);
			_appExtensionTxt.inputWidth = _inputWidth;
			_appExtensionTxt.inputHeight = 110;
			_appExtensionTxt.value = _extensions;
			_appExtensionTxt.label = "Manifest Extensions:";
			_body.addChild(_appExtensionTxt);
			_appExtensionTxt.getInputTxt.mouseEnabled = false;
			_appExtensionTxt.getListOfExtras.add(_extraManager.createNotice("You don't have to change anything here!<br>it will be set automatically based on the<br>plugins you have installed."));
			
		}
		
		private function onIconChooseResult($browser:*=null):void
		{
			if ($browser)
			{
				if (!$browser.window.selectedItem) _base.showAlert("Please select something before hitting the \"select\" button!", "Error!");
				else if ($browser.window.selectedItem.type != "file") _base.showAlert("You must choose a file!", "Error!");
				else 
				{
					var txt:InputText = $browser.data.target;
					_appIconStr = $browser.window.selectedItem.data.relativePath;
					txt.value = _appIconStr;
				}
			}
		}
		
		private function onFontSetup():void
		{
			//C.log("qwe")
		}
		
		private function initButtons():void
		{
			_saveBtn = new TabButton();
			_saveBtn.addEventListener(MouseEvent.CLICK, onSave);
			_saveBtn.buttonMode = true;
			_saveBtn.label = "<font face='Arimo' size='13' color='#333333'>Save and compiling a new .apk</font>";
			_saveBtn.icon = new _base.getGraphic.tickBtn();
			this.addChild(_saveBtn);
			
			_downloadBtn = new TabButton();
			_downloadBtn.addEventListener(MouseEvent.CLICK, onDownload);
			_downloadBtn.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_downloadBtn.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_downloadBtn.buttonMode = true;
			_downloadBtn.label = "<font face='Arimo' size='13' color='#333333'>Download your .apk</font>";
			_downloadBtn.icon = new _base.getGraphic.downloadBtn();
			_downloadBtn.iconPosition = Position.RIGHT;
			_downloadBtn.data = { alt:(_lastCompile)?"last compiled: " + _lastCompile.toLocaleString():"last compiled: Never" };
			this.addChild(_downloadBtn);
		}
		
		private function onSave(e:MouseEvent):void
		{
			/*C.log("0) save this information into freshapp_db, `manifest` table")
			C.log("1) Lock the Src code on our Ubuntu server so we can compile this one...")
			C.log("2) generate other icons in different dimensions")
			C.log("3) copy the icons to 'Src\\icons\\android\\icons'")
			C.log("4) update 'Src\\application.xml' with the new icons")
			C.log("5) edit 'fcms\\assets.xml' and add the fonts to it")
			C.log("6) copy fonts to 'Src\\bin\\assets\\font'")
			C.log("7) edit 'Src\\bin\\assets.xml' with the new fonts")
			C.log("8) update manifest details")
			C.log("9) update manifest permissions")
			C.log("10) update manifest extensions")
			C.log("11) Send back the generated .apk to the fcms so user can download it later")
			C.log("---------------------");
			for (var name:String in _data) 
			{
				C.log(name + " = " + _data[name]);
			}
			C.log("---------------------");*/
			
			var processTxt:String;
			var alertTitle:String;
			var alertWidth:Number = 600;
			var alertHeight:Number = 500;
			
			var steps:int = 9;
			var currStep:int = 1;
			
			var currProcessTxt:String = "";
			var timer:Timer = new Timer(100);
			var timerCount:int;
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			function onTimer(e:TimerEvent):void
			{
				timerCount++;
				currProcessTxt = currProcessTxt.concat(".");
				_base.getAlert.getDll.getContentTextField.htmlText = currProcessTxt;
				
				if (timerCount > 3)
				{
					timerCount = 0;
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
				}
			}
			
			// check if fields are not empty
			if (_appNameTxt.value.length < 1 || 
				_appIdTxt.value.length < 1 || 
				_appIconTxt.value.length < 1 ||
				_appVersionTxt.value.length < 1 ||
				_appGooglePlayTxt.value.length < 1 ||
				_appFontsTxt.value.length < 1 ||
				_manifestAdditions.length < 1 ||
				_extensions.length < 1)
			{
				processTxt = "Some fields are empty! make sure everything is set correctly before compiling your app!";
				alertTitle = "ERROR";
				
				_base.getAlert.getDll.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
				return;
			}
			
			// check if appName is equal to the last part of the app id
			if (_appIdTxt.value.substr(_appIdTxt.value.lastIndexOf(".") + 1) != _appNameTxt.value)
			{
				processTxt = "The last section of \"Application ID\" must be the same as your \"Application Name\".<br><br> for example, if your app name is <b>MyApp</b> and your domain name is www.domain.com, you should enter \"air.com.domain.<b><font color='#B94A48'>MyApp</font></b>\" for your App ID";
				alertTitle = "ERROR";
				
				_base.getAlert.getDll.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
				return;
			}
			
			// check if _appNameTxt contains any space?!
			if (_appNameTxt.value.indexOf(" ") != -1)
			{
				processTxt = "Your \"Application Name\" cannot have any spaces!";
				alertTitle = "ERROR";
				
				_base.getAlert.getDll.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
				return;
			}
			
			alertTitle = "Compiling your new .apk...";
			processTxt = "" + currStep + "/" + steps + ") Saving <b>" + _appNameTxt.value + "</b> data in database...";
			currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
			timer.start();
			
			
			// Step 1: Save data in database
			var obj:Object = { };
			obj.appName = escape(_appNameTxt.value);
			obj.appID = escape(_appIdTxt.value);
			obj.appIcon = _appIconTxt.value;
			obj.appVersion = _appVersionTxt.value;
			obj.googlePlay = escape(_appGooglePlayTxt.value);
			obj.appFonts = escape(_appFontsTxt.value);
			obj.appManifest = escape(_manifestAdditions);
			obj.appExtensions = escape(_extensions);
			
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.setApproveSkin("Wait...");
			_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
			_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onAlertClose);
			
			// step1: save manifest
			_base.gateway.call("compile.Process.saveManifest", new Responder(step1Result, _base.onFault), obj, _base.serverTime);
			
			function step1Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Preparing app icons...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step 2: Install the icons
					_base.gateway.call("compile.Process.saveIcons", new Responder(step2Result, _base.onFault), String(_base.xml.pluginDirectory.compiler.text()), "../" + _base.projectPath + _appIconTxt.value, {userId:_data.id, userEmail:_data.email}, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step2Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Installing fonts into fcms...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step 3: Install fonts into fcms
					_base.gateway.call("compile.Process.installFontsToFcms", new Responder(step3Result, _base.onFault), _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step3Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Installing fonts into the app...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step 4: Install fonts into the app
					_base.gateway.call("compile.Process.installFontsToApp", new Responder(step4Result, _base.onFault), String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step4Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Installing template tools...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step 5: copy blindTools from fcms to apk
					_base.gateway.call("compile.Process.installBlindTools", new Responder(step5Result, _base.onFault), String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step5Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Installing plugins into the app...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step 6: Install plugins into the app
					_base.gateway.call("compile.Process.installPlugins", new Responder(step6Result, _base.onFault), "step0", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step6Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{
					if ($result.extraSteps == "true")
					{
						processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" a) copying and Extracting Java plugins...");
						_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
						
						// Step a
						_base.gateway.call("compile.Process.installPlugins", new Responder(step_a, _base.onFault), "step1", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
						currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
						timer.start();
					}
					else
					{
						processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Editing the manifest xml...");
						_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
						
						// Step 7: Edit manifest
						_base.gateway.call("compile.Process.editManifest", new Responder(step7Result, _base.onFault), String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
						currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
						timer.start();
					}
					
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_a($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" b) copying Java plugin-center...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step b
					_base.gateway.call("compile.Process.installPlugins", new Responder(step_b, _base.onFault), "step2", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_b($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" c) Merging Java plugins into the plugin-center...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step c
					_base.gateway.call("compile.Process.installPlugins", new Responder(step_c, _base.onFault), "step3", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_c($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" d) Creating required directories...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step d
					_base.gateway.call("compile.Process.installPlugins", new Responder(step_d, _base.onFault), "step4", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_d($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" e) Building the java manifest...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step e
					_base.gateway.call("compile.Process.installPlugins", new Responder(step_e, _base.onFault), "step5", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_e($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" f) Merging java source codes...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step f
					_base.gateway.call("compile.Process.installPlugins", new Responder(step_f, _base.onFault), "step6", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_f($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" g) Setting php compiler files...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step g
					_base.gateway.call("compile.Process.installPlugins", new Responder(step_g, _base.onFault), "step7", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_g($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" h) Preparing java icons...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step h
					_base.gateway.call("compile.Process.installPlugins", new Responder(step_h, _base.onFault), "step8", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step_h($result:Object):void
			{
				timer.stop();
				//currStep++;
				
				if ($result.status == "true")
				{
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+" i) Finelizing the Java plugin-center...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step i
					_base.gateway.call("compile.Process.installPlugins", new Responder(step7Result, _base.onFault), "step9", String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step7Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Building the final apk...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step 8: build apk
					_base.gateway.call("compile.Process.buildApk", new Responder(step8Result, _base.onFault), String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step8Result($result:Object):void
			{
				timer.stop();
				currStep++;
				
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done</font><br>"+currStep+"/"+steps+") Transfering apk to your server...");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					
					// Step 9: transfer apk 
					_base.gateway.call("compile.Process.transferApk", new Responder(step9Result, _base.onFault), String(_base.xml.pluginDirectory.compiler.text()), { userId:_data.id, userEmail:_data.email }, _base.internalID, _base.serverTime);
					currProcessTxt = processTxt.substr(0, processTxt.lastIndexOf("..."))
					timer.start();
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function step9Result($result:Object):void
			{
				timer.stop();
				if ($result.status == "true")
				{	
					processTxt = processTxt.concat("<font color='#468847'> Done<br><br>All done successfully. You may close this window and download your new .apk cheers!");
					_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
					_base.getAlert.setApproveSkin("OK");
				}
				else
				{
					onStepError($result.msg);
				}
			}
			
			function onStepError($msg:String):void
			{
				processTxt = processTxt.concat("<font color='#B94A48'> Error!<br><br>" + $msg + "</font>");
				_base.getAlert.getDll.getContentTextField.htmlText = processTxt;
				_base.getAlert.setApproveSkin("Retry?!");
			}
		}
		
		private function onAlertClose(e:*):void
		{
			_base.getAlert.setApproveSkin("OK");
			_base.getAlert.getDll.removeEventListener(AlertEvent.CLOSE, onAlertClose);
			_base.getAlert.getDll.removeEventListener(AlertEvent.APPROVE, onAlertClose);
			
			// refresh the page
			stageRemoved();
			stageAdded();
		}

		private function onOver(e:MouseEvent):void
		{
			_base.getTooltip.mouseSpaceX = 20;
			_base.getTooltip.mouseSpaceY = -20;
			_base.getTooltip.delay = 0.5;
			_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>" + e.target.data.alt +"</font>", "ltr");
		}
		
		private function onOut(e:MouseEvent):void
		{
			_base.getTooltip.hide();
		}
		
		private function onDownload(e:MouseEvent):void
		{
			if (!_lastCompile)
			{
				_base.getAlert.getDll.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				_base.showAlert("Please compile your apk file first before trying to download it!", "Error", 450, 250);
				return;
			}
			
			//var fileRef:FileReference = new FileReference();
			//fileRef.download(new URLRequest(_downloadLink));
			
			navigateToURL(new URLRequest(_downloadLink), "_blank");
		}
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_scroller)
			{
				_scroller.x = _margin;
				_scroller.y = _margin;
				_scroller.maskWidth = _width - (_margin * 2) - (_scroller.scrollBarWidth + _scroller.scrollSpace);
				_scroller.maskHeight = _height - _saveBtn.height - (_margin * 2);
			}
			
			var w:Number = 655;
			var h:Number = 30;
			var y:Number = 0;
			
			if (_appNameTxt)
			{
				_appNameTxt.x = y;
				_appNameTxt.y = y;
				_appNameTxt.width = w;
				_appNameTxt.height = h;
				y += _appNameTxt.height + 15;
				
				_appIdTxt.x = _appNameTxt.x;
				_appIdTxt.y = y;
				_appIdTxt.width = w;
				_appIdTxt.height = h;
				y += _appIdTxt.height + 15;
				
				_appIconTxt.x = _appNameTxt.x;
				_appIconTxt.y = y;
				_appIconTxt.width = w;
				_appIconTxt.height = h;
				y += _appIconTxt.height + 15;
				
				_appVersionTxt.x = _appNameTxt.x;
				_appVersionTxt.y = y;
				_appVersionTxt.width = w;
				_appVersionTxt.height = h;
				y += _appVersionTxt.height + 15;
				
				_appGooglePlayTxt.x = _appNameTxt.x;
				_appGooglePlayTxt.y = y;
				_appGooglePlayTxt.width = w;
				_appGooglePlayTxt.height = h;
				y += _appGooglePlayTxt.height + 15;
				
				_appFontsTxt.x = _appNameTxt.x;
				_appFontsTxt.y = y;
				_appFontsTxt.width = w;
				_appFontsTxt.height = h;
				y += _appFontsTxt.height + 15;
				
				_appPermissionsTxt.x = _appNameTxt.x;
				_appPermissionsTxt.y = y;
				_appPermissionsTxt.width = w;
				_appPermissionsTxt.height = h;
				y +=_appPermissionsTxt.height + 15;
				
				_appExtensionTxt.x = _appNameTxt.x;
				_appExtensionTxt.y = y;
				_appExtensionTxt.width = w;
				_appExtensionTxt.height = h;
				y +=_appExtensionTxt.height + 15;
				
				/*_newPassConfirmTxt.x = _appNameTxt.x;
				_newPassConfirmTxt.y = y;
				_newPassConfirmTxt.width = w;
				_newPassConfirmTxt.height = h;
				y +=_newPassConfirmTxt.height + 2;*/
			}
			
			_body.width = w;
			_body.height = y;
			
			if (_saveBtn)
			{
				_saveBtn.width = _width/2;
				_saveBtn.height = 40;
				_saveBtn.y = _height - _saveBtn.height;
				_saveBtn.x = 0;
				
				_downloadBtn.width = _width / 2;
				_downloadBtn.height = 40;
				_downloadBtn.y = _height - _downloadBtn.height;
				_downloadBtn.x = _saveBtn.x + _saveBtn.width;
			}
		}
		
		private function buildManifestAdditions($plugins:Array):String
		{
			var currPlugin:Object;
			var currManifest:XML;
			var currManifestItem:String;
			//var finalManifest:String = _manifestAdditions.text();
			var finalManifest:String = _manifestAdditions;
			for (var i:int = 0; i < $plugins.length; i++) 
			{
				currPlugin = $plugins[i];
				currManifest = new XML(currPlugin.manifestAdditions);
				
				for (var j:int = 0; j < currManifest.item.length(); j++) 
				{
					currManifestItem = currManifest.item[j];
					
					if (currManifestItem.indexOf("<application>") > -1)
					{
						if (finalManifest.indexOf("<application>") < 0) // if this item is not available:
						{
							// just add the item to finalManifest
							finalManifest = finalManifest.replace("</manifest>", "\t" + currManifestItem + "\r</manifest>");
						}
						else
						{
							var currService:String = currManifestItem.substring(13, currManifestItem.length - 14);
							if (finalManifest.indexOf(currService) < 0) // if this service is not available:
							{
								// add the service to finalManifest
								finalManifest = finalManifest.replace("</application>", "\r\t\t" + currService + "</application>");
							}
						}
					}
					else
					{
						if (finalManifest.indexOf(currManifestItem) < 0) // if this item is not available:
						{
							// add the item to finalManifest
							finalManifest = finalManifest.replace("</manifest>", "\t" + currManifestItem + "\r</manifest>");
						}
					}
				}
			}
			
			if (finalManifest.indexOf("<application>") > -1)
			{
				finalManifest = finalManifest.replace("<application>", "<application>\r\t\t");
				finalManifest = finalManifest.replace("</application>", "\r\t</application>");
			}
			
			return finalManifest;
		}
		
		private function buildExtensions($plugins:Array):String
		{
			var currPlugin:Object;
			var currExtension:XML;
			var currExtensionItem:String;
			var finalExtensions:String = _extensions;
			for (var i:int = 0; i < $plugins.length; i++) 
			{
				currPlugin = $plugins[i];
				currExtension = new XML(currPlugin.extensions);
				for (var j:int = 0; j < currExtension.item.length(); j++) 
				{
					currExtensionItem = currExtension.item[j];
					if (finalExtensions.indexOf(currExtensionItem) < 0) // if this item is not available:
					{
						// add the item to finalExtensions
						finalExtensions = finalExtensions.replace("</extensions>", "\t" + currExtensionItem + "\r</extensions>");
					}
				}
			}
			
			return finalExtensions;
		}
		
		private function generateAppId():String
		{
			var uri:URI = new URI(root.loaderInfo.loaderURL);
			//var uri:URI = new URI("http://www.sub.doitflash.com.au/keke.swf");
			//var uri:URI = new URI("http://www.doitflash.com/keke.swf");
			
			// remove "www." if available in uri.authority
			var domain:String = uri.authority.replace("www.", "");
			var domainExt:String = domain.substr(domain.lastIndexOf(".") + 1);
			var domainName:String = domain.substring(0, domain.lastIndexOf("."));
			var packae:String = domainExt;
			if(domainName) packae += "."+domainName;
			
			return "air." + packae + "." + _appNameStr;
		}
		
		private function onAppIdFocusIn(e:FocusEvent):void
		{
			addEventListener(Event.ENTER_FRAME, checkAppId);
		}
		
		private function onAppIdFocusOut(e:FocusEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, checkAppId);
		}
		
		private function checkAppId(e:Event=null):void
		{
			if (!_appPermissionsTxt || !_appIdTxt) return;
			
			_manifestAdditions = _manifestAdditions.replace("<data android:scheme=\"" + _lastAppId + "\" />", "<data android:scheme=\"" + _appIdTxt.value + "\" />");
			_appPermissionsTxt.value = _manifestAdditions;
			
			_lastAppId = _appIdTxt.value;
		}
		
//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}