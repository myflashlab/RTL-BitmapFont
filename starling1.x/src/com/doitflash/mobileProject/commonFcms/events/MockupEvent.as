package com.doitflash.mobileProject.commonFcms.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/13/2012 12:08 PM
	 */
	public class MockupEvent extends Event 
	{
		public static const HIT_AREA_SELECT:String = "onHitAreaSelect";
		
		private var _param:*;
		
		public function MockupEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			_param = data;
			super(type, bubbles, cancelable);
		}
		
		public function get param():*
		{
			return _param;
		}
		
	}

}