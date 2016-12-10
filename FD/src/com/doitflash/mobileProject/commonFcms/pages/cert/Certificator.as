package com.doitflash.mobileProject.commonFcms.pages.cert
{
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Position;
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
	 * @author Hadi Tavakoli - 8/1/2012 8:46 AM
	 */
	public class Certificator extends MySprite 
	{
		private var _extraManager:ExtraManager = new ExtraManager();
		private var _formatInput:TextFormat;
		private var _formatLabel:TextFormat;
		
		private var _infoStr:String;
		private var _info:TextArea;
		
		private var _cnStr:String;
		private var _ouStr:String;
		private var _oStr:String;
		private var _cStr:String;
		private var _validityPeriodStr:String;
		private var _keyTypeStr:String;
		private var _passwordStr:String;
		
		private var _cnTxt:InputText;
		private var _ouTxt:InputText;
		private var _oTxt:InputText;
		private var _cTxt:InputText;
		private var _validityPeriodTxt:InputText;
		private var _keyTypeTxt:InputText;
		private var _passwordTxt:InputText;
		
		private var _inputWidth:Number = 500;
		
		protected var _saveBtn:TabButton;
		
		private var _scroller:*;
		protected var _body:MySprite = new MySprite();
		
		public function Certificator():void 
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
			}
			
			_body.y = 0;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			// get current certificate information
			_base.showPreloader(true);
			_base.gateway.call("certificate.Cert.getCert", new Responder(onCertificateGet, _base.onFault), _base.serverTime);
			
			onResize();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private

		private function onCertificateGet($result:Object):void
		{
			_base.showPreloader(false);
			if ($result.status != "true") return;
			
			//C.log($result.certificate)
			
			if ($result.certificate)
			{
				// set already saved data in fields
				_cnStr = $result.certificate.cn;
				_ouStr = $result.certificate.ou;
				_oStr = $result.certificate.o;
				_cStr = $result.certificate.c;
				_validityPeriodStr = $result.certificate.validityPeriod;
				_keyTypeStr = $result.certificate.key_type;
				_infoStr = "<font face='Arimo' color='0x333333' size='13'><font color='#468847'>You have already generated the required certificate.</font> Recreating a new certification for your app is not recommended, this is something that should be done only once for each app.</font>";
			}
			else
			{
				// set default valuse
				_cnStr = "SelfSigned";
				_ouStr = "domain.com";
				_oStr = "Your Co";
				_cStr = "AU";
				_validityPeriodStr = "25";
				_keyTypeStr = "2048-RSA";
				_infoStr = "<font face='Arimo' color='0x333333' size='13'><font color='#990000'>You have not yet created your certificate.</font> please fill in the following information to generate a new certificate. you will not be able to create your app if you don't have a certification!</font>";
			}
			
			_passwordStr = "password";
			
			initScroller();
			_extraManager.base = _base;
			if (!_formatInput) initFormat();
			if (!_cnTxt) initFields();
			if (!_saveBtn) initButtons();
			
			_info.htmlText = _infoStr;
			
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
			_info = new TextArea();
			_info.autoSize = TextFieldAutoSize.LEFT;
			_info.antiAliasType = AntiAliasType.ADVANCED;
			_info.multiline = true;
			_info.wordWrap = true;
			_info.embedFonts = true;
			_info.selectable = false;
			
			_body.addChild(_info);
			
			
			_cnTxt = new InputText();
			_cnTxt.extraOrientation = Orientation.HORIZONTAL;
			_cnTxt.base = _base;
			_cnTxt.labelFormat = _formatLabel;
			_cnTxt.inputFormat = _formatInput;
			_cnTxt.inputWidth = _inputWidth;
			_cnTxt.value = _cnStr;
			_cnTxt.label = "-cn:";
			_body.addChild(_cnTxt);
			_cnTxt.getListOfExtras.add(_extraManager.createNotice("string assigned as the common name of<br>the new certificate. put \"SelfSigned\" if<br>you are not sure"));
			
			_ouTxt = new InputText();
			_ouTxt.extraOrientation = Orientation.HORIZONTAL;
			_ouTxt.base = _base;
			_ouTxt.labelFormat = _formatLabel;
			_ouTxt.inputFormat = _formatInput;
			_ouTxt.inputWidth = _inputWidth;
			_ouTxt.value = _ouStr;
			_ouTxt.label = "-ou:";
			_body.addChild(_ouTxt);
			_ouTxt.getListOfExtras.add(_extraManager.createNotice("string assigned as the organizational unit<br>issuing the certificate. you may enter<br>your domain address here like<br>\"myappera.com\""));
			
			_oTxt = new InputText();
			_oTxt.extraOrientation = Orientation.HORIZONTAL;
			_oTxt.base = _base;
			_oTxt.labelFormat = _formatLabel;
			_oTxt.inputFormat = _formatInput;
			_oTxt.inputWidth = _inputWidth;
			_oTxt.value = _oStr;
			_oTxt.label = "-o:";
			_body.addChild(_oTxt);
			_oTxt.getListOfExtras.add(_extraManager.createNotice("string assigned as the organization issuing the<br>certificate. you may enter your company name<br>like \"My Company Name\""));
			
			_cTxt = new InputText();
			_cTxt.extraOrientation = Orientation.HORIZONTAL;
			_cTxt.base = _base;
			_cTxt.labelFormat = _formatLabel;
			_cTxt.inputFormat = _formatInput;
			_cTxt.inputWidth = _inputWidth;
			_cTxt.value = _cStr;
			_cTxt.label = "-c:";
			_body.addChild(_cTxt);
			_cTxt.getListOfExtras.add(_extraManager.createNotice("two-letter ISO-3166 country code. search Google<br>if you don't know your country's code!"));
			
			_validityPeriodTxt = new InputText();
			_validityPeriodTxt.extraOrientation = Orientation.HORIZONTAL;
			_validityPeriodTxt.base = _base;
			_validityPeriodTxt.labelFormat = _formatLabel;
			_validityPeriodTxt.inputFormat = _formatInput;
			_validityPeriodTxt.inputWidth = _inputWidth;
			_validityPeriodTxt.value = _validityPeriodStr;
			_validityPeriodTxt.label = "validity period:";
			_body.addChild(_validityPeriodTxt);
			_validityPeriodTxt.getListOfExtras.add(_extraManager.createNotice("the number of years that the certificate will<br>be valid. If you want to put your app on<br>Google Play, you must put 25 atleast!"));
			
			_keyTypeTxt = new InputText();
			_keyTypeTxt.extraOrientation = Orientation.HORIZONTAL;
			_keyTypeTxt.base = _base;
			_keyTypeTxt.labelFormat = _formatLabel;
			_keyTypeTxt.inputFormat = _formatInput;
			_keyTypeTxt.inputWidth = _inputWidth;
			_keyTypeTxt.value = _keyTypeStr;
			_keyTypeTxt.label = "keyType:";
			_body.addChild(_keyTypeTxt);
			_keyTypeTxt.getListOfExtras.add(_extraManager.createNotice("type of key to use for the certificate,<br>either \"1024-RSA\" or \"2048-RSA\""));
			
			_passwordTxt = new InputText();
			_passwordTxt.extraOrientation = Orientation.HORIZONTAL;
			_passwordTxt.base = _base;
			_passwordTxt.labelFormat = _formatLabel;
			_passwordTxt.inputFormat = _formatInput;
			_passwordTxt.inputWidth = _inputWidth;
			_passwordTxt.value = _passwordStr;
			_passwordTxt.label = "password:";
			_body.addChild(_passwordTxt);
			_passwordTxt.getListOfExtras.add(_extraManager.createNotice("password for the new certificate"));
		}
		
		private function initButtons():void
		{
			_saveBtn = new TabButton();
			_saveBtn.addEventListener(MouseEvent.CLICK, onSave);
			_saveBtn.buttonMode = true;
			_saveBtn.label = "<font face='Arimo' size='13' color='#333333'>Generate Certification </font>";
			_saveBtn.icon = new _base.getGraphic.certBtn();
			this.addChild(_saveBtn);
		}
		
		private function onSave(e:MouseEvent):void
		{
			var processTxt:String;
			var alertTitle:String;
			var alertWidth:Number = 400;
			var alertHeight:Number = 300;
			
			// check if fields are not empty
			if (_cnTxt.value.length < 1 ||
				_ouTxt.value.length < 1 ||
				_oTxt.value.length < 1 ||
				_cTxt.value.length < 1 ||
				_validityPeriodTxt.value.length < 1 ||
				_keyTypeTxt.value.length < 1 ||
				_passwordTxt.value.length < 1)
			{
				processTxt = "Some fields are empty! make sure everything is set correctly before trying to generate a certification!";
				alertTitle = "ERROR";
				
				_base.getAlert.getDll.clearEvents();
				_base.getAlert.setApproveSkin("OK");
				_base.showAlert(processTxt, alertTitle, alertWidth, alertHeight);
				return;
			}
			
			var obj:Object = { };
			obj.cn = _cnTxt.value;
			obj.ou = _ouTxt.value;
			obj.o = _oTxt.value;
			obj.c = _cTxt.value;
			obj.validityPeriod = _validityPeriodTxt.value;
			obj.keyType = _keyTypeTxt.value;
			obj.password = _passwordTxt.value;
			
			_base.showPreloader(true);
			_base.gateway.call("certificate.Cert.setCert", new Responder(onSaveResult, _base.onFault), String(_base.xml.pluginDirectory.certificate.text()), {userId:_data.id, userEmail:_data.email}, _base.internalID, obj, _base.serverTime);
			
			function onSaveResult($result:Object):void
			{
				_base.showPreloader(false);
				if ($result.status == "true")
				{
					_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
					_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onAlertClose);
					_base.showAlert($result.msg, "certifaction successfull created", 400, 300);
				}
				else
				{
					_base.getAlert.getDll.clearEvents();
					_base.getAlert.setApproveSkin("OK");
					_base.showAlert($result.msg, "Error creating certification!", 400, 200);
				}
			}
		}
		
		private function onAlertClose(e:*):void
		{
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
			
			if (_cnTxt)
			{
				_info.x = y;
				_info.y = y;
				_info.width = w;
				y += _info.height + 15;
				
				_cnTxt.x = _info.x;
				_cnTxt.y = y;
				_cnTxt.width = w;
				_cnTxt.height = h;
				y += _cnTxt.height + 15;
				
				_ouTxt.x = _cnTxt.x;
				_ouTxt.y = y;
				_ouTxt.width = w;
				_ouTxt.height = h;
				y += _ouTxt.height + 15;
				
				_oTxt.x = _cnTxt.x;
				_oTxt.y = y;
				_oTxt.width = w;
				_oTxt.height = h;
				y += _oTxt.height + 15;
				
				_cTxt.x = _cnTxt.x;
				_cTxt.y = y;
				_cTxt.width = w;
				_cTxt.height = h;
				y += _cTxt.height + 15;
				
				_validityPeriodTxt.x = _cnTxt.x;
				_validityPeriodTxt.y = y;
				_validityPeriodTxt.width = w;
				_validityPeriodTxt.height = h;
				y += _validityPeriodTxt.height + 15;
				
				_keyTypeTxt.x = _cnTxt.x;
				_keyTypeTxt.y = y;
				_keyTypeTxt.width = w;
				_keyTypeTxt.height = h;
				y += _keyTypeTxt.height + 15;
				
				_passwordTxt.x = _cnTxt.x;
				_passwordTxt.y = y;
				_passwordTxt.width = w;
				_passwordTxt.height = h;
				y += _passwordTxt.height + 15;
			}
			
			_body.width = w;
			_body.height = y;
			
			if (_saveBtn)
			{
				_saveBtn.width = _width;
				_saveBtn.height = 40;
				_saveBtn.y = _height - _saveBtn.height;
				_saveBtn.x = 0;
			}
		}
		
//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}