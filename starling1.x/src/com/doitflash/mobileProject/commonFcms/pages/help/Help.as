package com.doitflash.mobileProject.commonFcms.pages.help
{
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 8/1/2012 8:46 AM
	 */
	public class Help extends MySprite 
	{
		private var _txt:TextArea;
		
		public function Help():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
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
			
			initTxt();
			
			onResize();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private

		private function initTxt():void
		{
			_txt = new TextArea();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.embedFonts = true;
			_txt.wordWrap = true;
			_txt.multiline = true;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='13'>Before opening a new ticket, you may consider searching for your question on our online help documentation <font color='#990000'><a href='http://www.myappera.com/' target='_blank'>here</a></font></font>";
			this.addChild(_txt);
		}
	
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_txt)
			{
				_txt.x = _txt.y = _margin;
				_txt.width = _width - _margin * 2;
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			_base.getTooltip.mouseSpaceX = 20;
			_base.getTooltip.mouseSpaceY = -20;
			_base.getTooltip.delay = 0.5;
			_base.getTooltip.showText("<font face='Tahoma' size='11' color='#000000'>" + e.target.data.alt +"</font>", "ltr");
		}
		
		private function onOut(e:MouseEvent):void
		{
			_base.getTooltip.hide();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}