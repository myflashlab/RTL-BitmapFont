package com.doitflash.mobileProject.commonFcms.pages.adminSetting
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	import com.doitflash.mobileProject.commonFcms.extraManager.TabButton;
	import com.doitflash.mobileProject.commonFcms.extraManager.InputText;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli
	 */
	public class PageAdminSetting extends MyMovieClip 
	{
		private var _formatInput:TextFormat;
		private var _formatLabel:TextFormat;
		
		private var _firstNameStr:String = "Hadii";
		private var _lastNameStr:String = "Tavakolii";
		private var _emailStr:String = "email@site.com";
		private var _firstNameTxt:InputText;
		private var _lastNameTxt:InputText;
		private var _emailTxt:InputText;
		private var _oldPassTxt:InputText;
		private var _newPassTxt:InputText;
		private var _newPassConfirmTxt:InputText;
		
		private var _inputWidth:Number = 400;
		
		protected var _saveBtn:TabButton;
		
		private var _scroller:*;
		protected var _body:MySprite = new MySprite();
		
		public function PageAdminSetting():void 
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
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_base.showPreloader(true);
			_base.gateway.call("AccessCheck.toGetAdminInfo", new Responder(init, _base.onFault), _base.serverTime);
			
		}
		
		private function init($result:Object):void
		{
			_base.showPreloader(false);
			
			switch ($result["backToFlash"]) 
			{
				case "true":
					
					_emailStr = $result["username"];
					_firstNameStr = $result["firstname"];
					_lastNameStr = $result["lastname"];
					
				break;
				default:
					
					_base.showAlert("<font color='#333333' size='13'>" + $result["msg"] + "</font>", "", 350, 150);
					setTimeout(_base.sizeRefresh, 20);
					return;
			}
			
			initScroller();
			if (!_formatInput) initFormat();
			if (!_emailTxt) initFields();
			if (!_saveBtn) initButtons();
			
			onResize();
			setTimeout(onResize, 20);
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

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
			_firstNameTxt = new InputText();
			_firstNameTxt.base = _base;
			_firstNameTxt.labelFormat = _formatLabel;
			_firstNameTxt.inputFormat = _formatInput;
			_firstNameTxt.inputWidth = _inputWidth;
			_firstNameTxt.value = _firstNameStr;
			_firstNameTxt.label = "First Name:";
			_body.addChild(_firstNameTxt);
			
			_lastNameTxt = new InputText();
			_lastNameTxt.base = _base;
			_lastNameTxt.labelFormat = _formatLabel;
			_lastNameTxt.inputFormat = _formatInput;
			_lastNameTxt.inputWidth = _inputWidth;
			_lastNameTxt.value = _lastNameStr;
			_lastNameTxt.label = "Last Name:";
			_body.addChild(_lastNameTxt);
			
			_emailTxt = new InputText();
			_emailTxt.base = _base;
			_emailTxt.labelFormat = _formatLabel;
			_emailTxt.inputFormat = _formatInput;
			_emailTxt.inputWidth = _inputWidth;
			_emailTxt.value = _emailStr;
			_emailTxt.label = "Username:";
			_body.addChild(_emailTxt);
			
			_oldPassTxt = new InputText();
			_oldPassTxt.base = _base;
			_oldPassTxt.labelFormat = _formatLabel;
			_oldPassTxt.inputFormat = _formatInput;
			_oldPassTxt.inputWidth = _inputWidth;
			_oldPassTxt.value = "00000000";
			_oldPassTxt.displayAsPassword = true;
			_oldPassTxt.label = "Old password:";
			_body.addChild(_oldPassTxt);
			
			_newPassTxt = new InputText();
			_newPassTxt.base = _base;
			_newPassTxt.labelFormat = _formatLabel;
			_newPassTxt.inputFormat = _formatInput;
			_newPassTxt.inputWidth = _inputWidth;
			_newPassTxt.value = "00000000";
			_newPassTxt.displayAsPassword = true;
			_newPassTxt.label = "New password:";
			_body.addChild(_newPassTxt);
			
			_newPassConfirmTxt = new InputText();
			_newPassConfirmTxt.base = _base;
			_newPassConfirmTxt.labelFormat = _formatLabel;
			_newPassConfirmTxt.inputFormat = _formatInput;
			_newPassConfirmTxt.inputWidth = _inputWidth;
			_newPassConfirmTxt.value = "00000000";
			_newPassConfirmTxt.displayAsPassword = true;
			_newPassConfirmTxt.label = "Password confirm:";
			_body.addChild(_newPassConfirmTxt);
		}
		
		private function initButtons():void
		{
			_saveBtn = new TabButton();
			_saveBtn.addEventListener(MouseEvent.CLICK, onSave);
			_saveBtn.buttonMode = true;
			_saveBtn.label = "<font face='Arimo' size='13' color='#333333'>Save</font>";
			_saveBtn.icon = new _base.getGraphic.tickBtn();
			this.addChild(_saveBtn);
		}
		
		private function onSave(e:MouseEvent):void
		{
			_data = { };
			_data.firstname = _firstNameTxt.value;
			_data.lastname = _lastNameTxt.value;
			_data.email = _emailTxt.value;
			_data.oldPass = _oldPassTxt.value;
			_data.newPass = _newPassTxt.value;
			_data.newPassConfirm = _newPassConfirmTxt.value;
			
			_base.showPreloader(true);
			_base.gateway.call("AccessCheck.toSaveAdminInfo", new Responder(onAdminSettingSaveResult, _base.onFault), _base.serverTime, _data);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

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
			
			var w:Number = 555;
			var h:Number = 30;
			var y:Number = 0;
			
			if (_emailTxt)
			{
				_firstNameTxt.x = y;
				_firstNameTxt.y = y;
				_firstNameTxt.width = w;
				_firstNameTxt.height = h;
				y += _firstNameTxt.height + 15;
				
				_lastNameTxt.x = _firstNameTxt.x;
				_lastNameTxt.y = y;
				_lastNameTxt.width = w;
				_lastNameTxt.height = h;
				y += _lastNameTxt.height + 15;
				
				_emailTxt.x = _firstNameTxt.x;
				_emailTxt.y = y;
				_emailTxt.width = w;
				_emailTxt.height = h;
				y += _emailTxt.height + 15;
				
				_oldPassTxt.x = _firstNameTxt.x;
				_oldPassTxt.y = y;
				_oldPassTxt.width = w;
				_oldPassTxt.height = h;
				y +=_oldPassTxt.height + 15;
				
				_newPassTxt.x = _firstNameTxt.x;
				_newPassTxt.y = y;
				_newPassTxt.width = w;
				_newPassTxt.height = h;
				y +=_newPassTxt.height + 15;
				
				_newPassConfirmTxt.x = _firstNameTxt.x;
				_newPassConfirmTxt.y = y;
				_newPassConfirmTxt.width = w;
				_newPassConfirmTxt.height = h;
				y +=_newPassConfirmTxt.height + 2;
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
		
		private function onAdminSettingSaveResult($result:*):void
		{
			_base.showPreloader(false);
			var vars:URLVariables = new URLVariables($result);
			
			_base.showAlert("<font color='#333333' size='13'>" + vars.msg + "</font>", "", 420, 190);
			setTimeout(_base.sizeRefresh, 20);
			
			
			
			switch (vars.backToFlash) 
			{
				case "true":
					
					// save the new saved userInfo data
					_base.userInfo.firstName = _firstNameTxt.value;
					_base.userInfo.lastName = _lastNameTxt.value;
					_base.mainArea.refreshHeader();
					_base.showAlert("<font color='#333333' size='13'>" + vars.msg + "</font>", "", 350, 150);
					
				break;
				default:
					
					
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		
		
	}
	
}