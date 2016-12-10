package com.doitflash.mobileProject.commonFcms.dll
{
	import com.doitflash.text.modules.MyMovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.doitflash.mobileProject.commonFcms.assets.alert.FacebookAlert;
	import com.doitflash.events.AlertEvent;
	import com.doitflash.utils.scroll.RegSimpleScroll;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/9/2011 1:23 PM
	 */
	public class Alert extends MyMovieClip 
	{
		private var _dll:FacebookAlert;
		private var _scrollbar:RegSimpleScroll = new RegSimpleScroll();
		
		public function Alert():void 
		{
			_dll = new FacebookAlert();
		}
		
		public function init():void
		{
			_dll.name = "myAlert";
			
			// add listeners
			//_dll.addEventListener(AlertEvent.CLOSE, onClose);
			//_dll.addEventListener(AlertEvent.CANCEL, onCancel);
			//_dll.addEventListener(AlertEvent.REJECT, onReject);
			//_dll.addEventListener(AlertEvent.APPROVE, onApprove);
			
			// set _dll window properties
			_dll.w = _configXml.width.text();
			_dll.h = _configXml.height.text();
			//_dll.autoSize = true;
			_dll.titleHeight = _configXml.titleHeight.text();
			_dll.indent = _configXml.indent.text();
			_dll.footerHeight = 50; // not working right now
			
			//_dll.resizerSkinPath = "assets/img/resize.png";
			//_dll.defaultBgColor = 0x888888;
			_dll.bgAlpha = _configXml.bgAlpha.text();
			
			setCancelSkin("CANCEL");
			setRejectSkin("NO");
			setApproveSkin("OK");
			
			_dll.setBg("simpleColorBg", {simpleColor:_configXml.bgColor.text(), strokeThickness:1, strokeColor:_configXml.titleStrokeColor.text()});
			//_dll.setBg("imageBg", {path:"img/bg.png", repeat:"repeat"});
			//_dll.setBg("glassyBg", {holder:_dll, glassColor:0x000000, glassAlpha:0.3, glassBlurQuality:2, glassBlur:10});
			
			_dll.showFreezer = true;
			_dll.setFreezer("simpleColorBg", { simpleColor:0x000000, strokeThickness:0, strokeColor:0x000000 } );
			//_dll.setFreezer("imageBg", { path:"img/bg.png", repeat:"repeat" } );
			//_dll.setFreezer("glassyBg", {holder:_dll.freezer, glassColor:0x000000, glassAlpha:0.3, glassBlurQuality:2, glassBlur:10});
			_dll.freezerAlpha = _configXml.freezerAlpha.text();
			
			_dll.buttSkin(_serverPath + _configXml.button.up.text(), _serverPath + _configXml.button.over.text());
			_dll.titleAlpha = _configXml.titleAlpha.text();
			_dll.title("", "Verdana", 0x333333, 18);
			_dll.loadingStyle("Loading... ", "Verdana", 0x333333, 18);
			_dll.defaultTitleColor = _configXml.titleColor.text();
			_dll.titleStaticBgColor = _configXml.titleColor.text();
			
			_dll.titleStrokeColor = _configXml.titleStrokeColor.text();
			_dll.titleStrokeThickness = _configXml.titleStrokeThickness.text();
			
			_dll.importScroll(_scrollbar, "com.doitflash.utils.scroll.RegSimpleScroll");
			
			_dll.embedFonts = true;
			_dll.resizable = false;
			_dll.dragable = true;
			_dll.glowFilter(_configXml.glowColor.text(), _configXml.glowAlpha.text(), _configXml.glowBlur.text(), _configXml.glowStrength.text());
			_dll.curve(0, 0, 0, 0);
		}
		
		public function get getDll():*
		{
			return _dll;
		}
		
		public function get getClass():Class
		{
			return FacebookAlert;
		}
		
		public function set setScroller($scroller:*):void
		{
			_scrollbar.importProp = $scroller.exportProp;
		}
		
		public function setApproveSkin($label:String):void
		{
			_dll.approveSkin = $label;
		}
		
		public function setRejectSkin($label:String):void
		{
			_dll.rejectSkin = $label;
		}
		
		public function setCancelSkin($label:String):void
		{
			_dll.cancelSkin = $label;
		}
		
	}
	
}