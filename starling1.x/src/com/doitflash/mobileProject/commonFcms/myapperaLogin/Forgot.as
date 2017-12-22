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
	 * @author Hadi Tavakoli - 7/8/2012 11:04 AM
	 */
	public class Forgot extends MySprite 
	{
		private var _format:TextFormat;
		private var _titleField:TextArea;
		
		private var _emailFieldHolder:MySprite;
		private var _emailField:TextArea;
		
		private var _errorField:TextArea;
		
		private var _submitBtn:*;
		
		public function Forgot():void 
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
			_titleField.htmlText = "<font color='#595A59' size='13'><b>Please enter your email address below to receive a new password</b></font>";
			
			this.addChild(_titleField);
		}
		
		private function init():void
		{
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
			_emailField.antiAliasType = AntiAliasType.ADVANCED;
			_emailField.defaultTextFormat = _format;
			_emailField.type = TextFieldType.INPUT;
			_emailField.data.def = "Enter your email address";
			_emailField.data.holder = _emailFieldHolder;
			_emailField.text = _emailField.data.def;
			
			_emailFieldHolder.addChild(_emailField);
			
			//////////////////////////////////////////////
			
			_submitBtn = new _base.getGraphic.fbBtn();
			_submitBtn.addEventListener(MouseEvent.CLICK, onSignup);
			_submitBtn.label = "Renew";
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
			
			if (_emailField.text == "Firstname" || _emailField.text.length < 1) 
			{
				_errorField.htmlText = "<font color='#B55757' size='13'>Please enter your firstname!</font>"; 
				onResize(); 
				return;
			}
			
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardHit);
			this.dispatchEvent(new LoginEvent(LoginEvent.FORGOT_ATTEMPT, {email:_emailField.text}))
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
			
			if (_emailFieldHolder)
			{
				_emailFieldHolder.width = _titleField.width;
				_emailFieldHolder.height = 30;
				
				_emailField.width = _emailFieldHolder.width - 10;
				_emailField.height = 18;
				_emailField.x = 5;
				_emailField.y = _emailFieldHolder.height / 2 - _emailField.height / 2;
				
				_emailFieldHolder.x = _titleField.x;
				_emailFieldHolder.y = _titleField.y + _titleField.height + 10;
			}
			
			if (_submitBtn)
			{
				_submitBtn.x = _titleField.x;
				_submitBtn.y = _emailFieldHolder.y + _emailFieldHolder.height + 10;
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