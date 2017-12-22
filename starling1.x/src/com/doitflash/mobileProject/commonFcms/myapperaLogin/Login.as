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
	 * @author Hadi Tavakoli - 6/2/2012 1:43 PM
	 */
	public class Login extends MySprite 
	{
		private var _format:TextFormat;
		private var _titleField:TextArea;
		
		private var _userFieldHolder:MySprite;
		private var _userField:TextArea;
		
		private var _passFieldHolder:MySprite;
		private var _passField:TextArea;
		
		private var _forgotField:TextArea;
		
		private var _errorField:TextArea;
		
		private var _loginBtn:*;
		private var _signupBtn:*;
		
		public function Login():void 
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
			
			if(!_titleField) initTitle();
			if(!_userFieldHolder) init();
			if(!_errorField) initError();
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
			_titleField.htmlText = "<font color='#595A59' size='13'><b>You are not connected to myappera.com please login or register for a new account.</b></font>";
			
			this.addChild(_titleField);
		}
		
		private function init():void
		{
			_userFieldHolder = new MySprite();
			_userFieldHolder.bgAlpha = 1;
			_userFieldHolder.bgColor = 0xFFFFFF;
			_userFieldHolder.bgTopLeftRadius = 3;
			_userFieldHolder.bgTopRightRadius = 3;
			_userFieldHolder.bgBottomLeftRadius = 3;
			_userFieldHolder.bgBottomRightRadius = 3;
			_userFieldHolder.bgStrokeAlpha = 1;
			_userFieldHolder.bgStrokeThickness = 1;
			_userFieldHolder.bgStrokeColor = 0xCCCCCC;
			_userFieldHolder.drawBg();
			this.addChild(_userFieldHolder);
			
			
			_userField = new TextArea();
			_userField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_userField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_userField.embedFonts = true;
			_userField.antiAliasType = AntiAliasType.ADVANCED;
			_userField.defaultTextFormat = _format;
			_userField.type = TextFieldType.INPUT;
			_userField.data.def = "username / email";
			_userField.data.holder = _userFieldHolder;
			_userField.text = _userField.data.def;
			_userFieldHolder.addChild(_userField);
			
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
			//_passField.displayAsPassword = true;
			_passField.antiAliasType = AntiAliasType.ADVANCED;
			_passField.defaultTextFormat = _format;
			_passField.type = TextFieldType.INPUT;
			_passField.data.def = "password";
			_passField.data.holder = _passFieldHolder;
			_passField.data.displayAsPassword = true;
			_passField.text = _passField.data.def;
			_passFieldHolder.addChild(_passField);
			
			//////////////////////////////////////////////
			
			_loginBtn = new _base.getGraphic.fbBtn();
			_loginBtn.addEventListener(MouseEvent.CLICK, onLogin);
			_loginBtn.label = "Login";
			this.addChild(_loginBtn);
			
			_signupBtn = new _base.getGraphic.fbBtn();
			_signupBtn.addEventListener(MouseEvent.CLICK, onSignup);
			_signupBtn.label = "Sign up";
			this.addChild(_signupBtn);
			
			/////////////////////////////////////////////
			
			_forgotField = new TextArea();
			_forgotField.autoSize = TextFieldAutoSize.LEFT;
			_forgotField.antiAliasType = AntiAliasType.ADVANCED;
			_forgotField.embedFonts = true;
			_forgotField.selectable = false;
			_forgotField.defaultTextFormat = _format;
			_forgotField.funcSecurity = false;
			_forgotField.client = this;
			_forgotField.fmlText = "<a href=\"event:onForgot()\">Forgot your password?</a>";
			this.addChild(_forgotField);
		}
		
		private function initError():void
		{
			_errorField = new TextArea();
			_errorField.embedFonts = true;
			_errorField.selectable = false;
			_errorField.mouseEnabled = false;
			_errorField.autoSize = TextFieldAutoSize.LEFT;
			_errorField.antiAliasType = AntiAliasType.ADVANCED;
			_errorField.defaultTextFormat = _format;
			
			this.addChild(_errorField);
		}
		
		private function onKeyboardHit(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				onLogin();
			}
		}
		
		private function onLogin(e:MouseEvent=null):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
			
			_errorField.htmlText = "";
			this.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_ATTEMPT, {$username:_userField.text, $password:_passField.text}))
		}
		
		private function onSignup(e:MouseEvent):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
			
			_errorField.htmlText = "";
			this.dispatchEvent(new LoginEvent(LoginEvent.SIGNUP_ATTEMPT));
		}
		
		public function onForgot():void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
			
			_errorField.htmlText = "";
			this.dispatchEvent(new LoginEvent(LoginEvent.FORGOT_ATTEMPT));
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
			
			if (_userFieldHolder)
			{
				_userFieldHolder.width = _titleField.width;
				_userFieldHolder.height = 30;
				
				_userField.width = _userFieldHolder.width - 10;
				_userField.height = 18;
				_userField.x = 5;
				_userField.y = _userFieldHolder.height / 2 - _userField.height / 2;
				
				_userFieldHolder.x = _titleField.x;
				_userFieldHolder.y = _titleField.y + _titleField.height + 10;
			}
			
			if (_passFieldHolder)
			{
				_passFieldHolder.width = _userFieldHolder.width;
				_passFieldHolder.height = _userFieldHolder.height;
				
				_passField.width = _userField.width;
				_passField.height = _userField.height;
				_passField.x = _userField.x;
				_passField.y =_userField.y;
				
				_passFieldHolder.x = _titleField.x;
				_passFieldHolder.y = _userFieldHolder.y + _userFieldHolder.height + 10;
			}
			
			if (_loginBtn)
			{
				_loginBtn.x = _titleField.x;
				_loginBtn.y = _passFieldHolder.y + _passFieldHolder.height + 10;
				
				_signupBtn.x = _loginBtn.x + _loginBtn.width + 5;
				_signupBtn.y = _loginBtn.y;
			}
			
			if (_forgotField)
			{
				_forgotField.x = _titleField.x;
				_forgotField.y = _loginBtn.y + _loginBtn.height + 10;
			}
			
			if (_errorField)
			{
				_errorField.x = _signupBtn.x + _signupBtn.width + 5;
				_errorField.y = _signupBtn.y + (_signupBtn.height / 2 - _errorField.height / 2)
			}
			
			this.width = _titleField.width + (_titleField.x * 2);
			this.height = _forgotField.y + _forgotField.height + _titleField.y;
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

		public function fail($msg:String):void
		{
			_errorField.htmlText = "<font color='#B94A48' size='13'>" + $msg + "</font>";
			onResize();
			
			this.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
		}

//--------------------------------------------------------------------------------------------------------------------- Properties

		
	}
	
}