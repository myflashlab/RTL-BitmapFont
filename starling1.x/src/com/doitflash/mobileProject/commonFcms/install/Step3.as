package com.doitflash.mobileProject.commonFcms.install
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import com.doitflash.text.TextArea;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import com.doitflash.mobileProject.commonFcms.extraManager.InputText;
	import com.doitflash.mobileProject.commonFcms.extraManager.ExtraManager;
	
	//import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 1/8/2012 10:35 AM
	 */
	public class Step3 extends MySprite 
	{
		private var _extraManager:ExtraManager = new ExtraManager();
		
		private var _scroller:*;
		protected var _body:MySprite = new MySprite();
		
		private var _formatInput:TextFormat;
		private var _formatLabel:TextFormat;
		
		private var _txt:TextArea;
		
		private var _adminFirstName:InputText;
		private var _adminLastName:InputText;
		private var _adminEmail:InputText;
		private var _adminPass:InputText;
		private var _adminPassConfirm:InputText;
		
		private var _inputWidth:Number = 370;
		
		public function Step3():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeChild(_scroller);
			_scroller = null;
			
			_adminFirstName.value;
			_adminLastName.value;
			_adminEmail.value;
			_adminPass.value;
			_adminPassConfirm.value;
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_extraManager.base = _base;
			
			initScroller();
			if (!_formatInput) initFormat();
			if (!_txt) initTxt();
			if(!_adminFirstName) initFields();
			
			onResize();
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
			_formatInput.size = 12;
			_formatInput.font = "Verdana";
			
			_formatLabel = new TextFormat();
			_formatLabel.color = 0x333333;
			_formatLabel.size = 12;
			_formatLabel.font = "Verdana";
		}
		
		private function initTxt():void
		{
			_txt = new TextArea();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = true;
			_txt.selectable = false;
			_txt.defaultTextFormat = _formatLabel;
			_txt.htmlText = "You need to create a user for accessing your fCMS. make sure to write down your username and password because you will need them right after the installation.";
			_body.addChild(_txt);
		}
		
		private function initFields():void
		{
			_adminFirstName = new InputText();
			_adminFirstName.base = _base;
			_adminFirstName.labelFormat = _formatLabel;
			_adminFirstName.inputFormat = _formatInput;
			_adminFirstName.inputWidth = _inputWidth;
			_adminFirstName.value = "";
			_adminFirstName.label = "First Name:";
			//_adminFirstName.notice = 		"asdads";
			_body.addChild(_adminFirstName);
			
			// ------------------------------------------------------------------------------
			
			_adminLastName = new InputText();
			_adminLastName.base = _base;
			_adminLastName.labelFormat = _formatLabel;
			_adminLastName.inputFormat = _formatInput;
			_adminLastName.inputWidth = _inputWidth;
			_adminLastName.value = "";
			_adminLastName.label = "Last Name:";
			//_adminLastName.notice = 		"asdads";
			_body.addChild(_adminLastName);
			
			// ------------------------------------------------------------------------------
			
			_adminEmail = new InputText();
			_adminEmail.base = _base;
			_adminEmail.labelFormat = _formatLabel;
			_adminEmail.inputFormat = _formatInput;
			_adminEmail.inputWidth = _inputWidth;
			_adminEmail.value = "";
			_adminEmail.label = "Email:";
			_body.addChild(_adminEmail);
			_adminEmail.getListOfExtras.add(_extraManager.createNotice("This will be the admin username"));
			
			// ------------------------------------------------------------------------------
			
			_adminPass = new InputText();
			_adminPass.displayAsPassword = true;
			_adminPass.base = _base;
			_adminPass.labelFormat = _formatLabel;
			_adminPass.inputFormat = _formatInput;
			_adminPass.inputWidth = _inputWidth;
			_adminPass.value = "";
			_adminPass.label = "Password:";
			_body.addChild(_adminPass);
			_adminPass.getListOfExtras.add(_extraManager.createNotice("Enter a password that only you can remember it!"));
			
			// ------------------------------------------------------------------------------
			
			_adminPassConfirm = new InputText();
			_adminPassConfirm.displayAsPassword = true;
			_adminPassConfirm.base = _base;
			_adminPassConfirm.labelFormat = _formatLabel;
			_adminPassConfirm.inputFormat = _formatInput;
			_adminPassConfirm.inputWidth = _inputWidth;
			_adminPassConfirm.value = "";
			_adminPassConfirm.label = "Confirm Password:";
			_body.addChild(_adminPassConfirm);
			_adminPassConfirm.getListOfExtras.add(_extraManager.createNotice("Retype your password here"));
		}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Helpful Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_scroller)
			{
				_scroller.x = _margin;
				_scroller.y = _margin;
				_scroller.maskWidth = _width - (_margin * 2) - (_scroller.scrollBarWidth + _scroller.scrollSpace);
				_scroller.maskHeight = _height - (_margin * 2);
			}
			
			var w:Number = 510;
			var h:Number = 30;
			var y:Number = 0;
			
			if (_txt)
			{
				_txt.width = _scroller.maskWidth - 2;
				
				y += _txt.height + 15;
			}
			
			if (_adminFirstName)
			{
				_adminFirstName.x = 0;
				_adminFirstName.y = y;
				_adminFirstName.width = w;
				_adminFirstName.height = h;
				y += _adminFirstName.height + 15;
				
				_adminLastName.x = _adminFirstName.x;
				_adminLastName.y = y;
				_adminLastName.width = w;
				_adminLastName.height = h;
				y += _adminLastName.height + 15;
				
				_adminEmail.x = _adminFirstName.x;
				_adminEmail.y = y;
				_adminEmail.width = w;
				_adminEmail.height = h;
				y += _adminEmail.height + 15;
				
				_adminPass.x = _adminFirstName.x;
				_adminPass.y = y;
				_adminPass.width = w;
				_adminPass.height = h;
				y += _adminPass.height + 15;
				
				_adminPassConfirm.x = _adminFirstName.x;
				_adminPassConfirm.y = y;
				_adminPassConfirm.width = w;
				_adminPassConfirm.height = h;
				y += _adminPassConfirm.height + 15;
			}
			
			_body.width = w;
			_body.height = y;
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		public function retrieveValues():Object
		{
			_data = { };
			
			_data.firstName = _adminFirstName.value;
			_data.lastName = _adminLastName.value;
			_data.email = _adminEmail.value;
			_data.pass = _adminPass.value;
			_data.passConfirm = _adminPassConfirm.value;
			
			return _data;
		}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// Getter - Setter
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		
	}
	
}