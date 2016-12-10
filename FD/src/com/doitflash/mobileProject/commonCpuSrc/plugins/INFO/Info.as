package com.doitflash.mobileProject.commonCpuSrc.plugins.INFO
{
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.consts.ScrollConst;
	import com.doitflash.utils.scroll.TouchScroll;
	import com.doitflash.utils.scroll.RegSimpleScroll;
	import com.doitflash.utils.scroll.MouseScroll;
	import com.doitflash.text.TextArea;
	import com.doitflash.consts.Orientation;
	import com.doitflash.events.ScrollEvent;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/5/2012 4:03 PM
	 */
	public class Info extends MyMovieClip 
	{
		private var _txt:TextArea;
		private var _scroller:*;
		
		public function Info():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			/*_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			drawBg();*/
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			if (_scroller)
			{
				this.removeChild(_scroller);
				_scroller.removeEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
				_scroller.removeEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
				//_scroller = null;
				_base.touchScrollPool.returnObject(_scroller);
				_txt = null;
			}
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			//_base.c.log(">> ", _data.type, " - ", _data.id, " - ", _data.content)
			//_base.c.log(escape("<font face='Arimo' color='#999999' size='13'><font face='PT Sans Narrow' color='#8BB060' size='40'>Who we are?</font><br>lorem ipsum dolor sit amet, consectetuer adipiscing elit. nam cursus. morbi ut mi. nullam enim leo, egestas id, condimentum at, laoreet mattis, massa. sed eleifend nonummy diam. praesent mauris ante, elementum et, bibendum at, posuere sit amet, nibh. duis tincidunt lectus quis dui viverra vestibulum.<br><br>lorem ipsum dolor sit amet, consectetuer adipiscing elit. nam cursus. morbi ut mi. nullam enim leo, egestas id, condimentum at, laoreet mattis, massa. sed eleifend nonummy diam. praesent mauris ante, elementum et, bibendum at, posuere sit amet, nibh. duis tincidunt lectus quis dui viverra vestibulum.<br><br>lorem ipsum dolor sit amet, consectetuer adipiscing elit. nam cursus. morbi ut mi. nullam enim leo, egestas id, condimentum at, laoreet mattis, massa. sed eleifend nonummy diam. praesent mauris ante, elementum et, bibendum at, posuere sit amet, nibh. duis tincidunt lectus quis dui viverra vestibulum.<br><br>lorem ipsum dolor sit amet, consectetuer adipiscing elit. nam cursus. morbi ut mi. nullam enim leo, egestas id, condimentum at, laoreet mattis, massa. sed eleifend nonummy diam. praesent mauris ante, elementum et, bibendum at, posuere sit amet, nibh. duis tincidunt lectus quis dui viverra vestibulum.<br><br>lorem ipsum dolor sit amet, consectetuer adipiscing elit. nam cursus. morbi ut mi. nullam enim leo, egestas id, condimentum at, laoreet mattis, massa. sed eleifend nonummy diam. praesent mauris ante, elementum et, bibendum at, posuere sit amet, nibh. duis tincidunt lectus quis dui viverra vestibulum.<br><br>lorem ipsum dolor sit amet, consectetuer adipiscing elit. nam cursus. morbi ut mi. nullam enim leo, egestas id, condimentum at, laoreet mattis, massa. sed eleifend nonummy diam. praesent mauris ante, elementum et, bibendum at, posuere sit amet, nibh. duis tincidunt lectus quis dui viverra vestibulum.<br><br>lorem ipsum dolor sit amet, consectetuer adipiscing elit. nam cursus. morbi ut mi. nullam enim leo, egestas id, condimentum at, laoreet mattis, massa. sed eleifend nonummy diam. praesent mauris ante, elementum et, bibendum at, posuere sit amet, nibh. duis tincidunt lectus quis dui viverra vestibulum.<br><br></font>"));
			initTxt();
			initScroller();
			
			onResize();
			
			setTimeout(dispatch, 50);
			function dispatch():void
			{
				dispatchEvent(new AppEvent(AppEvent.MODULE_READY));
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initTxt():void
		{
			_txt = new TextArea();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.condenseWhite = true;
			_txt.mouseEnabled = false;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = true;
			_txt.htmlText = unescape(_data.content);
			//this.addChild(_txt);
		}
		
		private function initScroller():void
		{
			//_scroller = new TouchScroll();
			_scroller = _base.touchScrollPool.borrowObject();
			_scroller.addEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
			_scroller.addEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
			_scroller.orientation = Orientation.VERTICAL; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_scroller.easeType = "Strong.easeOut";
			_scroller.bitmapMode = ScrollConst.NORMAL;
			_scroller.aniInterval = .5;
			_scroller.isTouchScroll = true;
			_scroller.isMouseScroll = false;
			_scroller.maskContent = _txt;
			this.addChild(_scroller);
			
			//_base.c.log(_base.deviceInfo.dpiCategory)
			//_base.c.log(_base.deviceInfo.dpiScaleMultiplier)
		}
		
		private function onScrollMove(e:*):void
		{
			_scroller._mask.smoothing = true;
		}
		
		private function onScrollDone(e:*):void
		{
			_scroller._mask.smoothing = false;
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			if (_width == 0 || _height == 0) return;
			super.onResize(e);
			
			if (_txt)
			{
				_scroller.x = _margin;
				_scroller.maskWidth = _width - _margin * 2;
				_scroller.maskHeight = _height;
				
				_txt.scaleX = _txt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
				_txt.width = (_scroller.maskWidth - 2) * (1/_base.deviceInfo.dpiScaleMultiplier);
			}
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}