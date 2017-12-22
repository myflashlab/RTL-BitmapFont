package com.doitflash.mobileProject.commonPluginFcms.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ali Tavakoli - 9/3/2012 4:16 PM
	 */
	public class NavEvent extends Event 
	{
		public static const SORT_DATE:String = "onSortDate";
		public static const SORT_CAT:String = "onSortCat";
		
		public static const ADDED:String = "onAdded";
		public static const EDIT:String = "onEdit";
		public static const HELP:String = "onHelp";
		public static const PRINT:String = "onPrint";
		public static const BACK:String = "onBack";
		
		private var _param:*;
		
		public function NavEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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