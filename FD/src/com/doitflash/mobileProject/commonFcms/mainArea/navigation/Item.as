package com.doitflash.mobileProject.commonFcms.mainArea.navigation
{
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import com.doitflash.mobileProject.commonFcms.events.MainEvent;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/29/2011 11:13 AM
	 */
	public class Item extends MySprite 
	{
		private var _label:String = "menu item";
		private var _nameTxt:TextArea;
		private var _iconMc:Sprite;
		
		public function Item():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 0.08;
			//_bgColor = 0xFF9900;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0x000000;
			//_bgStrokeThickness = 1;
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
			
			if (!_iconMc) initIcon();
			if (!_nameTxt) initDetails();
			
			this.addEventListener(MouseEvent.ROLL_OVER, onOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.buttonMode = true;
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initIcon():void
		{
			_iconMc = new Sprite()
			this.addChild(_iconMc);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onResize);
			loader.load(new URLRequest(_serverPath + _data.xml.config.icon.text()));
			
			_iconMc.addChild(loader);
		}
		
		private function initDetails():void
		{
			_nameTxt = new TextArea();
			_nameTxt.autoSize = TextFieldAutoSize.LEFT;
			_nameTxt.antiAliasType = AntiAliasType.ADVANCED;
			_nameTxt.embedFonts = true;
			_nameTxt.mouseEnabled = false;
			_nameTxt.htmlText = "<font face='Arimo' size='13' color='#333333'>" + _label + "</font>";
			
			this.addChild(_nameTxt);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_iconMc)
			{
				_iconMc.x = 5;
				_iconMc.y = _height / 2 - _iconMc.height / 2;
			}
			
			if (_nameTxt)
			{
				_nameTxt.x = _iconMc.x + _iconMc.width + 5;
				_nameTxt.y = _height / 2 - _nameTxt.height / 2;
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			_bgAlpha = 1;
			_bgColor = 0xF5F5F5;
			drawBg();
		}
		
		private function onOut(e:MouseEvent):void
		{
			_bgAlpha = 0;
			_bgColor = 0xF5F5F5;
			drawBg();
		}
		
		private function onClick(e:MouseEvent):void
		{
			this.dispatchEvent(new MainEvent(MainEvent.NAV_SELECT));
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function pick():void
		{
			_bgAlpha = 1;
			_bgColor = 0xE6E6E6;
			drawBg();
			
			this.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.buttonMode = false;
		}
		
		public function unPick():void
		{
			_bgAlpha = 0;
			_bgColor = 0xFFFFFF;
			drawBg();
			
			this.addEventListener(MouseEvent.ROLL_OVER, onOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.buttonMode = true;
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function set label(a:String):void
		{
			_label = a;
		}
		
		public function get label():String
		{
			return _label;
		}
		
	}
	
}