package com.doitflash.mobileProject.commonFcms.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/12/2011 10:36 AM
	 */
	public class MainEvent extends Event 
	{
		public static const LOGOUT:String = "onLogout";
		public static const LOGOUT_SUCCEEDED:String = "onLogoutSucceeded";
		public static const PAGING:String = "onPaging";
		public static const NAV_SELECT:String = "onNavSelect";
		
		public static const CONNECT:String = "onConnect";
		public static const DISCONNECT:String = "onDisconnect";
		public static const CHECK_CONNECTION:String = "onCheckConnection";
		
		private var _param:*;
		
		public function MainEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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