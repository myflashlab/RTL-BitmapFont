package com.doitflash.mobileProject.commonFcms.pages.plugins
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
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 7/8/2012 11:04 AM
	 */
	public class ConfirmBox extends MySprite 
	{
		private var _productType:String;
		
		private var _format:TextFormat;
		private var _paypalFieldHolder:MySprite;
		private var _paypalField:TextArea;
		private var _paypalFieldStr:String = "you paypal email address";
		
		private var _txt:TextArea;
		
		private var _paypalAddress:String = "";
		
		public function ConfirmBox($productType:String="plugin"):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_productType = $productType;
			
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0x000000;
			//_bgStrokeThickness = 1;
			//_bgAlpha = 1;
			//_bgColor = 0xFF9900;
			//drawBg();
			
			_format = new TextFormat();
			_format.color = 0x7578B3;
			_format.size = 12;
			_format.font = "Arimo";
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (_paypalAddress.length > 5) _paypalFieldStr = _paypalAddress;
			
			initTxt();
			initPayPalField();
			
			onResize();
		}
		
		private function initTxt():void
		{
			_txt = new TextArea();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.embedFonts = true;
			_txt.multiline = true;
			_txt.wordWrap = true;
			//_txt.border = true;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='13'>You are about to purchase the <b>" + _data.pluginName + "</b> " + _productType + " for <b>$" + _data.pluginPrice + "</b>.<br><br>We support paypal payments only at the moment. Please enter the PayPal email address which you want to use for the payment below so our purchase gateway system can track your payment process to deliver you the item...<br><br><font color='#990000'>**Please double check your paypal email address before hitting the \"Yes\" button</font></font>";
			this.addChild(_txt);
		}
		private function initPayPalField():void
		{
			_paypalFieldHolder = new MySprite();
			_paypalFieldHolder.bgAlpha = 1;
			_paypalFieldHolder.bgColor = 0xFFFFFF;
			_paypalFieldHolder.bgStrokeAlpha = 1;
			_paypalFieldHolder.bgStrokeThickness = 1;
			_paypalFieldHolder.bgStrokeColor = 0xBDC7D9;
			_paypalFieldHolder.drawBg();
			this.addChild(_paypalFieldHolder);
			
			
			_paypalField = new TextArea();
			_paypalField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_paypalField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_paypalField.embedFonts = true;
			_paypalField.antiAliasType = AntiAliasType.ADVANCED;
			_paypalField.defaultTextFormat = _format;
			_paypalField.type = TextFieldType.INPUT;
			_paypalField.data.def = _paypalFieldStr;
			_paypalField.text = _paypalField.data.def;
			
			_paypalFieldHolder.addChild(_paypalField);
		}
		
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_txt)
			{
				_txt.width = _width;
			}
			
			if (_paypalFieldHolder)
			{
				_paypalFieldHolder.width = _width - 100;
				_paypalFieldHolder.height = 25;
				
				_paypalField.width = _paypalFieldHolder.width - 10;
				_paypalField.height = 18;
				_paypalField.x = 5;
				_paypalField.y = _paypalFieldHolder.height / 2 - _paypalField.height / 2;
				
				_paypalFieldHolder.x = 50;
				_paypalFieldHolder.y = ((_height - _txt.height)/2 - _paypalFieldHolder.height/2) + _txt.height;
			}
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			var ta:TextArea = e.target as TextArea;
			if (ta.text == ta.data.def)
			{
				ta.text = "";
				ta.displayAsPassword = ta.data.displayAsPassword;
			}
		}
		
		private function onFocusOut(e:FocusEvent):void
		{
			var ta:TextArea = e.target as TextArea;
			if (ta.text == "")
			{
				ta.text = ta.data.def;
				ta.displayAsPassword = false;
			}
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		public function set paypalAddress(a:String):void
		{
			_paypalAddress = a;
		}
		
		public function get paypalAddress():String
		{
			if (_paypalField.text.length > 5)
			{
				return _paypalField.text;
			}
			
			return _paypalAddress;
		}
	}
	
}