package com.doitflash.mobileProject.commonFcms.extraManager
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.events.FocusEvent;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.events.TextEvent;	
	import flash.events.MouseEvent;
	
	import com.doitflash.extendable.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.utils.scroll.MouseScroll;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 1/3/2012 3:55 PM
	 */
	public class InputText extends MySprite 
	{
		private var _labelFormat:TextFormat;
		private var _inputFormat:TextFormat;
		
		private var _labelTxt:TextArea;
		private var _labelStr:String;
		
		private var _inputBg:Shape;
		private var _inputWidth:Number = 0;
		private var _inputHeight:Number = 0;
		protected var _inputTxt:TextArea;
		private var _value:String;
		
		private var _listExtras:List;
		private var _extraOrientation:String = Orientation.HORIZONTAL;
		private var _mouseScroller:MouseScroll;
		
		private var _body:Sprite = new Sprite();
		private var _scroller:*;
		
		private var _displayAsPassword:Boolean;
		
		public function InputText() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeChild(_mouseScroller);
			_mouseScroller = null;
		}
		
		protected function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			initLabel();
			initList();
			initMouseScroller();
			initBg();
			initInput();
			
			if (_inputHeight > 0) initScroller();
			else this.addChild(_body);
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initLabel():void
		{
			if(!_labelTxt) _labelTxt = new TextArea();
			_labelTxt.autoSize = TextFieldAutoSize.LEFT;
			_labelTxt.antiAliasType = AntiAliasType.ADVANCED;
			_labelTxt.embedFonts = true;
			_labelTxt.mouseEnabled = false;
			_labelTxt.defaultTextFormat = _labelFormat;
			_labelTxt.text = _labelStr;
			this.addChild(_labelTxt);
		}
		
		private function initList():void
		{
			if (!_listExtras) _listExtras = new List();
			//_listExtras.addEventListener(ListEvent.RESIZE, onResize);
			_listExtras.direction = Direction.LEFT_TO_RIGHT;
			_listExtras.orientation = _extraOrientation;
			_listExtras.space = 5;
			_listExtras.speed = 0;
		}
		
		private function initMouseScroller():void
		{
			_mouseScroller = new MouseScroll();
			_mouseScroller.orientation = _extraOrientation; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_mouseScroller.easeType = "Expo.easeOut";
			_mouseScroller.scrollSpace = 5;
			_mouseScroller.aniInterval = .5;
			_mouseScroller.blurEffect = false;
			_mouseScroller.lessBlurSpeed = 7;
			_mouseScroller.yPerc = 0; // min value is 0, max value is 100
			_mouseScroller.xPerc = 0; // min value is 0, max value is 100
			_mouseScroller.mouseWheelSpeed = 2;
			_mouseScroller.isMouseScroll = true;
			_mouseScroller.maskContent = _listExtras;
			this.addChild(_mouseScroller);
		}
		
		private function initBg():void
		{
			if(!_inputBg) _inputBg = new Shape();
			this.addChild(_inputBg);
		}
		
		protected function initInput():void
		{
			if (!_inputTxt) _inputTxt = new TextArea();
			_inputTxt.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_inputTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_inputTxt.antiAliasType = AntiAliasType.ADVANCED;
			_inputTxt.embedFonts = true;
			_inputTxt.displayAsPassword = _displayAsPassword;
			
			if (_inputHeight > 0) 
			{
				//_inputTxt.autoSize = TextFieldAutoSize.LEFT;
				_inputTxt.multiline = true;
				_inputTxt.wordWrap = true;
				//_inputTxt.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			}
			
			_inputTxt.type = TextFieldType.INPUT;
			_inputTxt.defaultTextFormat = _inputFormat;
			_inputTxt.text = _value;
			_body.addChild(_inputTxt);
		}
		
		private function initScroller():void
		{
			_scroller = new _base.getScroller.getClass();
			_scroller.importProp = _base.getScroller.getDll.exportProp;
			_scroller.maskContent = _body;
			//_scroller.scrollManualY = 100;
			if (_inputHeight > 0) _scroller.addEventListener("myEnterFrame", textInputHandler, false, 0, true);
			this.addChild(_scroller);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_labelTxt)
			{
				_labelTxt.x = 0;
				_labelTxt.y = _height / 2 - _labelTxt.height / 2;
			}
			
			if (_mouseScroller)
			{
				_mouseScroller.x = _width - 16;
				_mouseScroller.y = _height / 2 - (16 / 2);
				if (_extraOrientation == Orientation.HORIZONTAL) 
				{
					//_mouseScroller.maskWidth = 32 + ((_listExtras.items.length-1) * _listExtras.space);
					_mouseScroller.maskWidth = 32 + _listExtras.space;
					_mouseScroller.maskHeight = 16;
				}
				else 
				{
					_mouseScroller.maskWidth = 16;
					_mouseScroller.maskHeight = _inputBg.height - _mouseScroller.y;
				}
			}
			
			/*if (_listExtras)
			{
				for each (var itemHolder:* in _listExtras.items) 
				{
					var item:Item = itemHolder.content;
					item.width = _scroller.maskWidth - 2;
					item.height = 20;
				}
			}*/
			
			if (_inputBg)
			{
				_inputBg.graphics.clear();
				_inputBg.graphics.beginFill(0xFFFFFF);
				_inputBg.graphics.lineStyle(1, 0xCCCCCC, 1, true, "normal", CapsStyle.ROUND, JointStyle.ROUND);
				_inputBg.graphics.drawRoundRect(0, 0, _inputWidth, Math.max(_height, _inputHeight), 5, 5);
				_inputBg.graphics.endFill();
				
				_inputBg.x = _width - _inputWidth - 25;
			}
			
			if (_inputTxt)
			{
				
				if (_inputHeight > 0)
				{
					_scroller.x = _inputBg.x + 5;
					_scroller.y = _labelTxt.y;
					_scroller.maskWidth = _inputBg.width - 10 - (_scroller.scrollBarWidth + _scroller.scrollSpace);
					_scroller.maskHeight = _inputHeight - (_scroller.y * 2);
					
					_inputTxt.width = _scroller.maskWidth;
					textInputHandler();
				}
				else 
				{
					_inputTxt.y = _height / 2 - _inputTxt.height / 2;
					_inputTxt.height = _labelTxt.height;
					_inputTxt.width = _inputBg.width - 10;
					_inputTxt.x = _inputBg.x + 5;
				}
				
				
			}
		}
		
		private function textInputHandler(e:*=null):void
		{
			if (_inputTxt.textHeight + 50 > _inputHeight)
			{
				_inputTxt.autoSize = TextFieldAutoSize.LEFT;
			}
			else
			{
				_inputTxt.autoSize = TextFieldAutoSize.NONE;
				_inputTxt.height = _inputHeight - 10;
			}
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			_inputBg.graphics.clear();
			_inputBg.graphics.beginFill(0xFFFFFF);
			_inputBg.graphics.lineStyle(1, 0x74B9F0, 1, true, "normal", CapsStyle.ROUND, JointStyle.ROUND);
			_inputBg.graphics.drawRoundRect(0, 0, _inputWidth, Math.max(_height, _inputHeight), 5, 5);
			_inputBg.graphics.endFill();
			
			TweenMax.to(_inputBg, 0.3, {glowFilter:{color:0x74B9F0, alpha:1, blurX:8, blurY:8, strength:1, quality:2}});
		}
		
		private function onFocusOut(e:FocusEvent):void
		{
			_inputBg.graphics.clear();
			_inputBg.graphics.beginFill(0xFFFFFF);
			_inputBg.graphics.lineStyle(1, 0xCCCCCC, 1, true, "normal", CapsStyle.ROUND, JointStyle.ROUND);
			_inputBg.graphics.drawRoundRect(0, 0, _inputWidth, Math.max(_height, _inputHeight), 5, 5);
			_inputBg.graphics.endFill();
			
			TweenMax.to(_inputBg, 0.3, {glowFilter:{color:0x74B9F0, alpha:0, blurX:8, blurY:8, strength:1, quality:2, remove:true}});
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override public function get height():Number
		{
			return Math.max(_height, _inputHeight);
		}
		
		public function set labelFormat(a:TextFormat):void
		{
			_labelFormat = a;
		}
		
		public function set inputFormat(a:TextFormat):void
		{
			_inputFormat = a;
		}
		
		public function set label(a:String):void
		{
			_labelStr = a;
		}
		
		public function get value():String
		{
			_value = _inputTxt.text;
			return _value;
		}
		
		public function set value(a:String):void
		{
			_value = a;
			if (_inputTxt) _inputTxt.text = _value;
		}
		
		public function get inputWidth():Number
		{
			return _inputWidth;
		}
		
		public function set inputWidth(a:Number):void
		{
			_inputWidth = a;
		}
		
		public function get inputHeight():Number
		{
			return _inputHeight;
		}
		
		public function set inputHeight(a:Number):void
		{
			_inputHeight = a;
		}
		
		public function set displayAsPassword(a:Boolean):void
		{
			_displayAsPassword = a;
		}
		
		public function set extraOrientation(a:String):void
		{
			_extraOrientation = a;
		}
		
		public function get getListOfExtras():List
		{
			return _listExtras;
		}
		
		public function get getInputTxt():TextArea
		{
			return _inputTxt;
		}
	}

}