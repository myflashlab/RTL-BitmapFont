package com.doitflash.mobileProject.commonFcms.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 1/8/2012 12:31 PM
	 */
	public class InstallEvent extends Event 
	{
		public static const NEXT_STEP:String = "onNextStep";
		public static const PREV_STEP:String = "onPrevStep";
		public static const START:String = "onInstallStart";
		
		private var _param:*;
		
		public function InstallEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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