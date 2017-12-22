package com.doitflash.mobileProject.commonCpuSrc.plugins.WP.posts
{
	import com.doitflash.events.WpEvent;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.WordPress;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/10/2012 12:48 PM
	 */
	public class Excerpt extends MySprite 
	{
		private var _header:ExcerptHeader;
		private var _txt:TextField;
		
		public function Excerpt():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			this.clearEvents();
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_margin = _configXml.excerpt.body.margin.text();
			_bgAlpha = _configXml.excerpt.body.bgAlpha.text();
			_bgColor = _configXml.excerpt.body.bgColor.text();
			_bgStrokeAlpha = _configXml.excerpt.body.bgStrokeAlpha.text();
			_bgStrokeColor = _configXml.excerpt.body.bgStrokeColor.text();
			_bgStrokeThickness = _configXml.excerpt.body.bgStrokeThickness.text();
			drawBg();
			
			initHeader();
			initBody();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onUp);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			onResize();
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initHeader():void
		{
			_header = new ExcerptHeader();
			_header.margin = _margin;
			_header.base = _base;
			_header.data = _data;
			_header.configXml = new XML(_configXml.excerpt.head);
			
			this.addChild(_header);
		}
		
		private function initBody():void
		{
			_txt = new TextField();
			//_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.condenseWhite = true;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = true;
			_txt.mouseEnabled = false;
			
			var str:String = _data.excerpt;
			str = str.replace("&hellip;", "... ");
			str = str.replace("&rarr;", "");
			str = str.replace("Continue reading", _configXml.excerpt.body.more.text());
			
			_txt.htmlText = "<font face='" + _configXml.excerpt.body.textStyle.font.text() + "' size='" + _configXml.excerpt.body.textStyle.size.text() + "' color='" + _configXml.excerpt.body.textStyle.color.text() + "'>" + str + "</font>";
			this.addChild(_txt);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			
			if (_header)
			{
				_header.x = _margin;
				_header.width = _width - _margin * 2;
				_header.height = 70;
			}
			
			if (_txt)
			{
				_txt.scaleX = _txt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
				
				_txt.x = _margin;
				_txt.y = _header.y + _header.height;
				_txt.width = (_width - _margin * 2) * (1/_base.deviceInfo.dpiScaleMultiplier);
				_txt.height = (_height - _txt.y) * (1/_base.deviceInfo.dpiScaleMultiplier);
			}
		}
		
		public function onDown(e:MouseEvent=null):void
		{
			_bgColor = _configXml.excerpt.body.touch.down.color.text();
			drawBg();
			
			if(_header) _header.toCoverTitle(_bgColor);
		}
		
		public function onUp(e:MouseEvent=null):void
		{
			_bgColor = _configXml.excerpt.body.touch.up.color.text();
			drawBg();
			
			if(_header) _header.toCoverTitle(_bgColor);
		}
		
		private function onClick(e:MouseEvent):void
		{
			/*if (_currItem && e) unselect();
			
			if(e) _currItem = e.currentTarget as Item;
			select();
			
			this.dispatchEvent(new WpEvent(WpEvent.REQUEST_DATA, _currItem.data));*/
			
			this.dispatchEvent(new AppEvent(AppEvent.REQUEST_POST, _data, true));
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}