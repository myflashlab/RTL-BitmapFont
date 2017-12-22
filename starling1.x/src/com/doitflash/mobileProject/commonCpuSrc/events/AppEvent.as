package com.doitflash.mobileProject.commonCpuSrc.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/13/2012 1:28 PM
	 */
	public class AppEvent extends Event 
	{
		public static const ORIENTATION_CHANGE:String = "onOrientationChange";
		public static const FRAMERATE_CHANGE:String = "onFrameRateChange";
		
		public static const NAV_SELECT:String = "onNavSelect";
		public static const NETWORK_STATUS:String = "onNetworkStatus";
		
		public static const MODULE_READY:String = "onModuleReady";
		public static const FORCE_CLOSE:String = "onForceClose";
		
		public static const BACK_BUTTON_CLICK:String = "onBackButtonClicked";
		public static const BACK_BUTTON_ENGAGED:String = "onBackButtonEngaged";
		public static const MENU_BUTTON_CLICK:String = "onMenuButtonClicked";
		public static const ACTIVATED:String = "onAppActivated";
		public static const DEACTIVATED:String = "onAppDeactivated";
		
		public static const WP_CHANGE_NAV:String = "onWpNavChange";
		public static const WP_REPLY:String = "onWpReply";
		public static const REQUEST_DATA:String = "onRequestData";
		public static const REQUEST_RECENT_POSTS:String = "onRequestRecentPosts";
		public static const REQUEST_POST:String = "onRequestPost";
		public static const SUBMIT_COMMENT:String = "onSubmitComment";
		
		public static const APP_ACTIVE:String = "onAppActive";
		public static const APP_DEACTIVE:String = "onAppDeactive";
		public static const APP_INVOKE:String = "onAppInvoke";
		
		private var _param:*;
		
		public function AppEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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