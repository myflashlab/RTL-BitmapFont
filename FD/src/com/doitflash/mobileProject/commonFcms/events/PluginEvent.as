package com.doitflash.mobileProject.commonFcms.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/17/2012 2:36 PM
	 */
	public class PluginEvent extends Event 
	{
		public static const INSTALL:String = "onInstall";
		public static const UPDATE:String = "onUpdate";
		public static const UNINSTALL:String = "onUninstall";
		public static const PURCHASE:String = "onPurchase";
		
		private var _param:*;
		
		public function PluginEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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