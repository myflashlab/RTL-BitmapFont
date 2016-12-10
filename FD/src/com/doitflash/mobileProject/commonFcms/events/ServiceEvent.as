package com.doitflash.mobileProject.commonFcms.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 5/17/2012 2:36 PM
	 */
	public class ServiceEvent extends Event 
	{
		public static const INSTALL:String = "onInstall";
		public static const UPDATE:String = "onUpdate";
		public static const UNINSTALL:String = "onUninstall";
		public static const PURCHASE:String = "onPurchase";
		public static const ACTIVATE:String = "onActivate";
		public static const INACTIVATE:String = "onInactivate";
		public static const SETTING:String = "onServiceSetting";
		
		public static const AVAILABLE_SERVICES:String = "onAvailableServices";
		public static const INSTALLED_SERVICES:String = "onInstalledServices";
		
		private var _param:*;
		
		public function ServiceEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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