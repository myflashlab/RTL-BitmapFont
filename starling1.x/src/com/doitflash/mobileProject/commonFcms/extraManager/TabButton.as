package com.doitflash.mobileProject.commonFcms.extraManager
{
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.consts.Position;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 1/3/2012 1:04 PM
	 */
	public class TabButton extends MySprite 
	{
		private var _labelTxt:TextArea;
		private var _label:String = "button";
		private var _icon:*;
		private var _iconPosition:String = Position.LEFT;
		
		public function TabButton():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_bgAlpha = 1;
			_bgColor = 0xF2F2F2;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			init();
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function init():void
		{
			if(!_labelTxt) _labelTxt = new TextArea();
			_labelTxt.autoSize = TextFieldAutoSize.LEFT;
			_labelTxt.antiAliasType = AntiAliasType.ADVANCED;
			_labelTxt.embedFonts = true;
			_labelTxt.mouseEnabled = false;
			setLabel();
			
			this.addChild(_labelTxt);
		}
		
		private function setLabel():void
		{
			if(_labelTxt) _labelTxt.htmlText = _label;
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_icon)
			{
				if (_iconPosition == Position.LEFT) _icon.x = 15;
				else if (_iconPosition == Position.RIGHT) _icon.x = _width - _icon.width - 15;
				
				_icon.y = _height / 2 - _icon.height / 2;
			}
			
			if (_labelTxt)
			{
				if (_iconPosition == Position.LEFT) _labelTxt.x = _icon.x + _icon.width + 5;
				else if (_iconPosition == Position.RIGHT) _labelTxt.x = _icon.x - _labelTxt.width - 5;
				
				_labelTxt.y = _height / 2 - _labelTxt.height / 2;
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function get label():String
		{
			return _label;
		}
		
		public function set label(a:String):void
		{
			_label = a;
			setLabel();
		}
		
		public function set icon(a:*):void
		{
			if (_icon) 
			{
				this.removeChild(_icon);
				_icon = null;
			}
			
			_icon = a;
			this.addChild(_icon);
			
			onResize();
		}
		
		public function set iconPosition(a:String):void
		{
			_iconPosition = a;
		}
		
	}
	
}