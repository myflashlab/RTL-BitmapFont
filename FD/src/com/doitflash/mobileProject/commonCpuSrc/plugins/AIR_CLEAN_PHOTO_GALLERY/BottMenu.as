package com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY
{
	import com.doitflash.text.TextArea;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/20/2012 12:06 PM
	 */
	public class BottMenu extends MySprite 
	{
		private var _addressTxt:TextArea;
		
		public function BottMenu():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 0;
			_bgAlpha = 0.8;
			_bgColor = 0x444444;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xFFFFFF;
			//_bgStrokeThickness = 1;
			drawBg();
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			initTxt();
			
			onResize();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initTxt():void
		{
			var format:TextFormat = new TextFormat();
			format.font = "Arimo";
			format.size = 14;
			format.color = 0xCCCCCC;
			
			_addressTxt = new TextArea();
			_addressTxt.autoSize = TextFieldAutoSize.LEFT;
			_addressTxt.antiAliasType = AntiAliasType.ADVANCED;
			_addressTxt.mouseEnabled = false;
			_addressTxt.embedFonts = true;
			//_addressTxt.border = true;
			_addressTxt.defaultTextFormat = format;
			//_addressTxt.htmlText = ".";
			this.addChild(_addressTxt);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_addressTxt)
			{
				_addressTxt.scaleX = _addressTxt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
				_addressTxt.x = 5;
				_addressTxt.y = _height - _addressTxt.height >> 1;
			}
		}
		
		
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		public function updateAddress($str:String):void
		{
			_addressTxt.htmlText = $str;
			
			onResize();
		}

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}