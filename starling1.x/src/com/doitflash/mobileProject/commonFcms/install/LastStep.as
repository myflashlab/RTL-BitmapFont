package com.doitflash.mobileProject.commonFcms.install
{
	import com.doitflash.text.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.doitflash.text.modules.MySprite;
	
	//import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 1/8/2012 10:35 AM
	 */
	public class LastStep extends MySprite 
	{
		private var _scroller:*;
		private var _format:TextFormat;
		private var _txt:TextArea;
		
		public function LastStep():void 
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
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			initFormat();
			initTxt();
			initScroller();
			
			onResize();
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function initFormat():void
		{
			if(!_format) _format = new TextFormat();
			_format.size = 12;
			_format.font = "Verdana";
			_format.color = 0x333333;
		}
		
		private function initTxt():void
		{
			if(!_txt) _txt = new TextArea();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = true;
			_txt.selectable = false;
			_txt.defaultTextFormat = _format;
		}
		
		private function initScroller():void
		{
			_scroller = new _base.getScroller.getClass();
			_scroller.importProp = _base.getScroller.getDll.exportProp;
			_scroller.maskContent = _txt;
			this.addChild(_scroller);
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
				
				_txt.width = _scroller.maskWidth;
			}
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////// Methods
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		
		

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////// Getter - Setter
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

		public function get txt():TextArea
		{
			return _txt;
		}
	}
	
}