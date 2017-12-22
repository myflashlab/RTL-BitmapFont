package com.doitflash.mobileProject.commonFcms.extraManager.fontBrowse
{
	import flash.events.Event;
	import flash.net.Responder;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.events.AlertEvent;
	import com.doitflash.events.RemoteEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 8/11/2012 12:41 PM
	 */
	public class FontBrowser extends MySprite 
	{
		
		
		public function FontBrowser():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_bgAlpha = 1;
			_bgColor = 0xFF9900;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			//this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
			
			onResize();
		}
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			
		}
		
	}

}