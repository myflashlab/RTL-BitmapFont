package com.doitflash.mobileProject.commonFcms.dll
{
	import com.doitflash.text.modules.MyMovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.doitflash.utils.tooltip.Tooltip;
	import com.doitflash.utils.tooltip.FloatStyle;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/21/2011 8:37 AM
	 */
	public class Tooltip extends MyMovieClip 
	{
		private var _dll:com.doitflash.utils.tooltip.Tooltip;
		
		public function Tooltip():void 
		{
			_dll = new com.doitflash.utils.tooltip.Tooltip();
		}
		
		public function init():void
		{
			_dll.name = "myTooltip";
			
			_dll.floatStyle = FloatStyle.STILL;
			_dll.bgAlpha = 1;
			_dll.indent = 1;
			_dll.embedFonts = false;
			_dll.mouseSpaceX = 0;
			_dll.mouseSpaceY = 0;
			_dll.delay = 0.5;
			_dll.fadeTime = 0.3;
			
			_dll.setBg("simpleColorBg", {simpleColor:0xffffe1, strokeThickness:1, strokeColor:0x000000});
			_dll.curve(0, 0, 0, 0);
			_dll.shadowFilter(0x000000, 0.1, 45, 5);
		}
		
		public function get getDll():*
		{
			return _dll;
		}
		
	}
	
}