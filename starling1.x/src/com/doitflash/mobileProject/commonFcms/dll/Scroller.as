package com.doitflash.mobileProject.commonFcms.dll
{
	import com.doitflash.text.modules.MyMovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.doitflash.utils.scroll.RegSimpleScroll;
	import com.doitflash.consts.Orientation;
	import com.doitflash.utils.scroll.EffectConst;
	import com.doitflash.utils.scroll.RegSimpleConst;
	import com.doitflash.consts.Ease;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/7/2011 11:02 AM
	 */
	public class Scroller extends MyMovieClip 
	{
		private var _dll:RegSimpleScroll;
		
		public function Scroller():void 
		{
			_dll = new RegSimpleScroll();
		}
		
		public function init():void
		{
			_dll.orientation = Orientation.VERTICAL;
			_dll.scrollBlurEffect = toBoolean(_configXml.blur.text());
			_dll.scrollEaseType = _configXml.ease.text();
			_dll.drawDisabledScroll = toBoolean(_configXml.drawDisabledScroll.text());
			_dll.scrollAniInterval = _configXml.time.text();
			_dll.mouseWheelSpeed = _configXml.mouseWheelSpeed.text();
			_dll.scrollManualAniInterval = 0;
			
			_dll.bgEffectColor = _configXml.bgEffectColor.text();
			_dll.bgCurve = _configXml.bgCurve.text();
			_dll.bgW = _configXml.bgW.text();
			_dll.bgColor = _configXml.bgColor.text();
			_dll.bgAlpha = _configXml.bgAlpha.text();
			
			_dll.sliderEffectType = _configXml.btnEffectType.text(); // accepted values: EffectConst.COLOR, EffectConst.GLOW, EffectConst.COLOR_GLOW
			_dll.sliderEffectColor = _configXml.btnEffectColor.text();
			_dll.sliderGlowBlur = _configXml.btnGlowBlur.text();
			_dll.sliderGlowStrength = _configXml.btnGlowStrength.text();
			_dll.sliderCurve = _configXml.bgCurve.text();
			_dll.sliderW = _configXml.bgW.text();
			_dll.sliderColor = _configXml.btnColor.text();
			
			_dll.btnEffectType = _configXml.btnEffectType.text(); // accepted values: EffectConst.COLOR, EffectConst.GLOW, EffectConst.COLOR_GLOW
			_dll.btnEffectColor = _configXml.btnEffectColor.text();
			_dll.btnGlowBlur = _configXml.btnGlowBlur.text();
			_dll.btnGlowStrength = _configXml.btnGlowStrength.text();
			_dll.btnLayout = _configXml.btnLayout.text(); // accepted values: RegSimpleConst.TRIANGLE, RegSimpleConst.CIRCLE
			_dll.btnColor = _configXml.btnColor.text();
			_dll.btnSize = _configXml.btnSize.text();
		}
		
		public function get getDll():*
		{
			return _dll;
		}
		
		public function get getClass():Class
		{
			return RegSimpleScroll;
		}
		
	}
	
}