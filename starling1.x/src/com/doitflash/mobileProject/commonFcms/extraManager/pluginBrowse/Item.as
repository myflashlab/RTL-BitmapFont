package com.doitflash.mobileProject.commonFcms.extraManager.pluginBrowse
{
	import com.doitflash.extendable.MySprite;
	import com.doitflash.text.TextArea;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 7/3/2012 1:42 PM
	 */
	public class Item extends MySprite 
	{
		private var _nameTxt:TextArea;
		private var _isPicked:Boolean;
		
		public function Item():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 1;
			//_bgColor = 0xFFbb77;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0x000000;
			//_bgStrokeThickness = 1;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeEventListener(MouseEvent.ROLL_OVER, onItemOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onItemOut);
			this.removeEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (!_nameTxt) initDetails();
			
			this.addEventListener(MouseEvent.ROLL_OVER, onItemOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onItemOut);
			this.addEventListener(MouseEvent.CLICK, onItemClick);
			
			buttonMode = true;
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initDetails():void
		{
			_nameTxt = new TextArea();
			_nameTxt.autoSize = TextFieldAutoSize.LEFT;
			_nameTxt.antiAliasType = AntiAliasType.ADVANCED;
			_nameTxt.embedFonts = true;
			_nameTxt.mouseEnabled = false;
			_nameTxt.htmlText = "<font face='Arimo' size='13' color='#333333'>" + name + "</font>";
			this.addChild(_nameTxt);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_nameTxt)
			{
				_nameTxt.x = 5;
				_nameTxt.y = _height - _nameTxt.height >> 1;
			}
			
			
		}
		
		private function onItemOver(e:MouseEvent):void
		{
			_bgAlpha = 1;
			_bgColor = 0xF5F5F5;
			drawBg();
		}
		
		private function onItemOut(e:MouseEvent):void
		{
			_bgAlpha = 0;
			_bgColor = 0xF5F5F5;
			drawBg();
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(PluginBrowser.ITEM_SELECTED))
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function pick($status:Boolean = true):void
		{
			_isPicked = $status;
			
			if (_isPicked)
			{
				this.removeEventListener(MouseEvent.ROLL_OVER, onItemOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, onItemOut);
				this.removeEventListener(MouseEvent.CLICK, onItemClick);
				
				buttonMode = false;
				
				_bgAlpha = 1;
				_bgColor = 0xCCCCCC;
				drawBg();
			}
			else
			{
				this.addEventListener(MouseEvent.ROLL_OVER, onItemOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onItemOut);
				this.addEventListener(MouseEvent.CLICK, onItemClick);
				
				buttonMode = true;
				
				_bgAlpha = 0;
				_bgColor = 0xEFF2F7;
				drawBg();
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		
		
	}
	
}