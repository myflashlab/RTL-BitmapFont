package com.doitflash.mobileProject.commonFcms.myapperaLogin
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	
	import com.doitflash.events.ButtonEvent;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	
	import com.doitflash.mobileProject.commonFcms.events.LoginEvent;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/2/2012 2:13 PM
	 */
	public class Signup extends MySprite 
	{
		private var _format:TextFormat;
		private var _titleField:TextArea;
		
		private var _firstNameFieldHolder:MySprite;
		private var _firstNameField:TextArea;
		
		private var _lastNameFieldHolder:MySprite;
		private var _lastNameField:TextArea;
		
		private var _emailFieldHolder:MySprite;
		private var _emailField:TextArea;
		
		private var _passFieldHolder:MySprite;
		private var _passField:TextArea;
		
		private var _passConfirmFieldHolder:MySprite;
		private var _passConfirmField:TextArea;
		
		private var _hearFieldHolder:MySprite;
		private var _hearField:TextArea;
		
		private var _errorField:TextArea;
		
		private var _submitBtn:*;
		
		public function Signup():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			_bgAlpha = 1;
			_bgColor = 0xF7F7F7;
			drawBg();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_format = new TextFormat();
			_format.color = 0x333333;
			_format.size = 12;
			_format.font = "Arimo";
			
			initTitle();
			init();
			initError();
			onResize(); // all position setting must happen in this func
			
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
		}
		
		private function initTitle():void
		{
			_titleField = new TextArea();
			_titleField.embedFonts = true;
			_titleField.selectable = false;
			_titleField.mouseEnabled = false;
			_titleField.autoSize = TextFieldAutoSize.LEFT;
			_titleField.antiAliasType = AntiAliasType.ADVANCED;
			_titleField.defaultTextFormat = _format;
			_titleField.htmlText = "<font color='#595A59' size='13'><b>Please fill in the following information and click the \"register\" button</b></font>";
			
			this.addChild(_titleField);
		}
		
		private function init():void
		{
			_firstNameFieldHolder = new MySprite();
			_firstNameFieldHolder.bgAlpha = 1;
			_firstNameFieldHolder.bgColor = 0xFFFFFF;
			_firstNameFieldHolder.bgTopLeftRadius = 3;
			_firstNameFieldHolder.bgTopRightRadius = 3;
			_firstNameFieldHolder.bgBottomLeftRadius = 3;
			_firstNameFieldHolder.bgBottomRightRadius = 3;
			_firstNameFieldHolder.bgStrokeAlpha = 1;
			_firstNameFieldHolder.bgStrokeThickness = 1;
			_firstNameFieldHolder.bgStrokeColor = 0xCCCCCC;
			_firstNameFieldHolder.drawBg();
			this.addChild(_firstNameFieldHolder);
			
			
			_firstNameField = new TextArea();
			_firstNameField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_firstNameField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_firstNameField.embedFonts = true;
			_firstNameField.antiAliasType = AntiAliasType.ADVANCED;
			_firstNameField.defaultTextFormat = _format;
			_firstNameField.type = TextFieldType.INPUT;
			_firstNameField.data.def = "Firstname";
			_firstNameField.data.holder = _firstNameFieldHolder;
			_firstNameField.text = _firstNameField.data.def;
			_firstNameFieldHolder.addChild(_firstNameField);
			
			//////////////////////////////////////////////
			
			_lastNameFieldHolder = new MySprite();
			_lastNameFieldHolder.bgAlpha = 1;
			_lastNameFieldHolder.bgColor = 0xFFFFFF;
			_lastNameFieldHolder.bgTopLeftRadius = 3;
			_lastNameFieldHolder.bgTopRightRadius = 3;
			_lastNameFieldHolder.bgBottomLeftRadius = 3;
			_lastNameFieldHolder.bgBottomRightRadius = 3;
			_lastNameFieldHolder.bgStrokeAlpha = 1;
			_lastNameFieldHolder.bgStrokeThickness = 1;
			_lastNameFieldHolder.bgStrokeColor = 0xCCCCCC;
			_lastNameFieldHolder.drawBg();
			this.addChild(_lastNameFieldHolder);
			
			_lastNameField = new TextArea();
			_lastNameField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_lastNameField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_lastNameField.embedFonts = true;
			_lastNameField.displayAsPassword = false;
			_lastNameField.antiAliasType = AntiAliasType.ADVANCED;
			_lastNameField.defaultTextFormat = _format;
			_lastNameField.type = TextFieldType.INPUT;
			_lastNameField.data.def = "Lastname";
			_lastNameField.data.holder = _lastNameFieldHolder;
			_lastNameField.text = _lastNameField.data.def;
			_lastNameFieldHolder.addChild(_lastNameField);
			
			//////////////////////////////////////////////
			
			_emailFieldHolder = new MySprite();
			_emailFieldHolder.bgAlpha = 1;
			_emailFieldHolder.bgColor = 0xFFFFFF;
			_emailFieldHolder.bgTopLeftRadius = 3;
			_emailFieldHolder.bgTopRightRadius = 3;
			_emailFieldHolder.bgBottomLeftRadius = 3;
			_emailFieldHolder.bgBottomRightRadius = 3;
			_emailFieldHolder.bgStrokeAlpha = 1;
			_emailFieldHolder.bgStrokeThickness = 1;
			_emailFieldHolder.bgStrokeColor = 0xCCCCCC;
			_emailFieldHolder.drawBg();
			this.addChild(_emailFieldHolder);
			
			_emailField = new TextArea();
			_emailField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_emailField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_emailField.embedFonts = true;
			_emailField.displayAsPassword = false;
			_emailField.antiAliasType = AntiAliasType.ADVANCED;
			_emailField.defaultTextFormat = _format;
			_emailField.type = TextFieldType.INPUT;
			_emailField.data.def = "Email address";
			_emailField.data.holder = _emailFieldHolder;
			_emailField.text = _emailField.data.def;
			
			_emailFieldHolder.addChild(_emailField);
			
			//////////////////////////////////////////////
			
			_passFieldHolder = new MySprite();
			_passFieldHolder.bgAlpha = 1;
			_passFieldHolder.bgColor = 0xFFFFFF;
			_passFieldHolder.bgTopLeftRadius = 3;
			_passFieldHolder.bgTopRightRadius = 3;
			_passFieldHolder.bgBottomLeftRadius = 3;
			_passFieldHolder.bgBottomRightRadius = 3;
			_passFieldHolder.bgStrokeAlpha = 1;
			_passFieldHolder.bgStrokeThickness = 1;
			_passFieldHolder.bgStrokeColor = 0xCCCCCC;
			_passFieldHolder.drawBg();
			this.addChild(_passFieldHolder);
			
			_passField = new TextArea();
			_passField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_passField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_passField.embedFonts = true;
			//_passField.displayAsPassword = false;
			_passField.antiAliasType = AntiAliasType.ADVANCED;
			_passField.defaultTextFormat = _format;
			_passField.type = TextFieldType.INPUT;
			_passField.data.def = "password";
			_passField.data.holder = _passFieldHolder;
			_passField.data.displayAsPassword = true;
			_passField.text = _passField.data.def;
			
			_passFieldHolder.addChild(_passField);
			
			//////////////////////////////////////////////
			
			_passConfirmFieldHolder = new MySprite();
			_passConfirmFieldHolder.bgAlpha = 1;
			_passConfirmFieldHolder.bgColor = 0xFFFFFF;
			_passConfirmFieldHolder.bgTopLeftRadius = 3;
			_passConfirmFieldHolder.bgTopRightRadius = 3;
			_passConfirmFieldHolder.bgBottomLeftRadius = 3;
			_passConfirmFieldHolder.bgBottomRightRadius = 3;
			_passConfirmFieldHolder.bgStrokeAlpha = 1;
			_passConfirmFieldHolder.bgStrokeThickness = 1;
			_passConfirmFieldHolder.bgStrokeColor = 0xCCCCCC;
			_passConfirmFieldHolder.drawBg();
			this.addChild(_passConfirmFieldHolder);
			
			_passConfirmField = new TextArea();
			_passConfirmField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_passConfirmField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_passConfirmField.embedFonts = true;
			//_passConfirmField.displayAsPassword = false;
			_passConfirmField.antiAliasType = AntiAliasType.ADVANCED;
			_passConfirmField.defaultTextFormat = _format;
			_passConfirmField.type = TextFieldType.INPUT;
			_passConfirmField.data.def = "Retype password";
			_passConfirmField.data.holder = _passConfirmFieldHolder;
			_passConfirmField.data.displayAsPassword = true;
			_passConfirmField.text = _passConfirmField.data.def;
			
			_passConfirmFieldHolder.addChild(_passConfirmField);
			
			//////////////////////////////////////////////
			
			_hearFieldHolder = new MySprite();
			_hearFieldHolder.bgAlpha = 1;
			_hearFieldHolder.bgColor = 0xFFFFFF;
			_hearFieldHolder.bgTopLeftRadius = 3;
			_hearFieldHolder.bgTopRightRadius = 3;
			_hearFieldHolder.bgBottomLeftRadius = 3;
			_hearFieldHolder.bgBottomRightRadius = 3;
			_hearFieldHolder.bgStrokeAlpha = 1;
			_hearFieldHolder.bgStrokeThickness = 1;
			_hearFieldHolder.bgStrokeColor = 0xCCCCCC;
			_hearFieldHolder.drawBg();
			this.addChild(_hearFieldHolder);
			
			_hearField = new TextArea();
			_hearField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_hearField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_hearField.embedFonts = true;
			_hearField.displayAsPassword = false;
			_hearField.antiAliasType = AntiAliasType.ADVANCED;
			_hearField.defaultTextFormat = _format;
			_hearField.type = TextFieldType.INPUT;
			_hearField.data.def = "How did you hear about us?";
			_hearField.data.holder = _hearFieldHolder;
			_hearField.text = _hearField.data.def;
			
			_hearFieldHolder.addChild(_hearField);
			
			//////////////////////////////////////////////
			
			_submitBtn = new _base.getGraphic.fbBtn();
			_submitBtn.addEventListener(MouseEvent.CLICK, onSignup);
			_submitBtn.label = "Register";
			this.addChild(_submitBtn);
			
		}
		
		private function initError():void
		{
			_errorField = new TextArea();
			_errorField.embedFonts = true;
			_errorField.selectable = false;
			_errorField.mouseEnabled = false;
			//_errorField.border = true;
			_errorField.autoSize = TextFieldAutoSize.LEFT;
			_errorField.antiAliasType = AntiAliasType.ADVANCED;
			_errorField.defaultTextFormat = _format;
			
			this.addChild(_errorField);
		}
		
		private function onKeyboardHit(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				onSignup();
			}
		}
		
		private function onSignup(e:MouseEvent=null):void
		{
			_errorField.htmlText = "";
			//_errorField.htmlText = "<font color='#B55757' size='13'>Cannot login, try again!</font>";
			
			if (_firstNameField.text == "Firstname" || _firstNameField.text.length < 1) 
			{
				_errorField.htmlText = "<font color='#B55757' size='13'>Please enter your firstname!</font>"; 
				onResize(); 
				return;
			}
			
			if (_lastNameField.text == "Lastname" || _lastNameField.text.length < 1) 
			{
				_errorField.htmlText = "<font color='#B55757' size='13'>Please enter your lastname!</font>"; 
				onResize(); 
				return;
			}
			
			if (_emailField.text == "Email address" || _emailField.text.length < 1) 
			{
				_errorField.htmlText = "<font color='#B55757' size='13'>Enter your email address!</font>"; 
				onResize(); 
				return;
			}
			
			if (_passField.text == "Password" || _passField.text.length < 1) 
			{
				_errorField.htmlText = "<font color='#B55757' size='13'>Please enter a password!</font>"; 
				onResize(); 
				return;
			}
			
			if (_passConfirmField.text != _passField.text) 
			{
				_errorField.htmlText = "<font color='#B55757' size='13'>Please retype password!</font>"; 
				onResize(); 
				return;
			}
			
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
			this.dispatchEvent(new LoginEvent(LoginEvent.SIGNUP_ATTEMPT, {firstname:_firstNameField.text, lastname:_lastNameField.text, email:_emailField.text, password:_passField.text, description:_hearField.text}))
		}
		
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_titleField)
			{
				_titleField.x = 15;
				_titleField.y = 15;
			}
			
			if (_firstNameFieldHolder)
			{
				_firstNameFieldHolder.width = _titleField.width;
				_firstNameFieldHolder.height = 30;
				
				_firstNameField.width = _firstNameFieldHolder.width - 10;
				_firstNameField.height = 18;
				_firstNameField.x = 5;
				_firstNameField.y = _firstNameFieldHolder.height / 2 - _firstNameField.height / 2;
				
				_firstNameFieldHolder.x = _titleField.x;
				_firstNameFieldHolder.y = _titleField.y + _titleField.height + 10;
			}
			
			if (_lastNameFieldHolder)
			{
				_lastNameFieldHolder.width = _firstNameFieldHolder.width;
				_lastNameFieldHolder.height = _firstNameFieldHolder.height;
				
				_lastNameField.width = _firstNameField.width;
				_lastNameField.height = _firstNameField.height;
				_lastNameField.x = _firstNameField.x;
				_lastNameField.y =_firstNameField.y;
				
				_lastNameFieldHolder.x = _titleField.x;
				_lastNameFieldHolder.y = _firstNameFieldHolder.y + _firstNameFieldHolder.height + 10;
			}
			
			if (_emailFieldHolder)
			{
				_emailFieldHolder.width = _firstNameFieldHolder.width;
				_emailFieldHolder.height = _firstNameFieldHolder.height;
				
				_emailField.width = _firstNameField.width;
				_emailField.height = _firstNameField.height;
				_emailField.x = _firstNameField.x;
				_emailField.y =_firstNameField.y;
				
				_emailFieldHolder.x = _titleField.x;
				_emailFieldHolder.y = _lastNameFieldHolder.y + _lastNameFieldHolder.height + 10;
			}
			
			if (_passFieldHolder)
			{
				_passFieldHolder.width = _firstNameFieldHolder.width;
				_passFieldHolder.height = _firstNameFieldHolder.height;
				
				_passField.width = _firstNameField.width;
				_passField.height = _firstNameField.height;
				_passField.x = _firstNameField.x;
				_passField.y =_firstNameField.y;
				
				_passFieldHolder.x = _titleField.x;
				_passFieldHolder.y = _emailFieldHolder.y + _emailFieldHolder.height + 10;
			}
			
			if (_passConfirmFieldHolder)
			{
				_passConfirmFieldHolder.width = _firstNameFieldHolder.width;
				_passConfirmFieldHolder.height = _firstNameFieldHolder.height;
				
				_passConfirmField.width = _firstNameField.width;
				_passConfirmField.height = _firstNameField.height;
				_passConfirmField.x = _firstNameField.x;
				_passConfirmField.y =_firstNameField.y;
				
				_passConfirmFieldHolder.x = _titleField.x;
				_passConfirmFieldHolder.y = _passFieldHolder.y + _passFieldHolder.height + 10;
			}
			
			if (_hearFieldHolder)
			{
				_hearFieldHolder.width = _firstNameFieldHolder.width;
				_hearFieldHolder.height = _firstNameFieldHolder.height;
				
				_hearField.width = _firstNameField.width;
				_hearField.height = _firstNameField.height;
				_hearField.x = _firstNameField.x;
				_hearField.y =_firstNameField.y;
				
				_hearFieldHolder.x = _titleField.x;
				_hearFieldHolder.y = _passConfirmFieldHolder.y + _passConfirmFieldHolder.height + 10;
			}
			
			if (_submitBtn)
			{
				_submitBtn.x = _titleField.x;
				_submitBtn.y = _hearFieldHolder.y + _hearFieldHolder.height + 10;
			}
			
			if (_errorField)
			{
				_errorField.x = _submitBtn.x + _submitBtn.width + 5;
				_errorField.y = _submitBtn.y + (_submitBtn.height / 2 - _errorField.height / 2)
			}
			
			this.width = _titleField.width + (_titleField.x * 2);
			this.height = _submitBtn.y + _submitBtn.height + _titleField.y;
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			var ta:TextArea = e.target as TextArea;
			if (ta.text == ta.data.def)
			{
				ta.text = "";
				ta.displayAsPassword = ta.data.displayAsPassword;
			}
			
			ta.data.holder.bgStrokeColor = 0x74B9F0;
			ta.data.holder.drawBg();
			TweenMax.to(ta.parent, 0.3, {glowFilter:{color:0x74B9F0, alpha:1, blurX:8, blurY:8, strength:1, quality:2}});
		}
		
		private function onFocusOut(e:FocusEvent):void
		{
			var ta:TextArea = e.target as TextArea;
			if (ta.text == "")
			{
				ta.text = ta.data.def;
				ta.displayAsPassword = false;
			}
			
			ta.data.holder.bgStrokeColor = 0xCCCCCC;
			ta.data.holder.drawBg();
			TweenMax.to(ta.parent, 0.3, {glowFilter:{color:0x74B9F0, alpha:0, blurX:8, blurY:8, strength:1, quality:2, remove:true}});
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		public function fail($result:URLVariables):void
		{
			_errorField.htmlText = "<font color='#B55757' size='13'>Cannot login, try again!</font>";
			onResize();
			
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
		}

//--------------------------------------------------------------------------------------------------------------------- Properties

		
	}
	
}