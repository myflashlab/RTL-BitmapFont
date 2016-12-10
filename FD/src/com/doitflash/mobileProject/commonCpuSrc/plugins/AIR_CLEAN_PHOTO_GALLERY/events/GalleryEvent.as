package com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/25/2012 4:11 PM
	 */
	public class GalleryEvent extends Event 
	{
		public static const MODE_CHANGE:String = "onModeChange";
		public static const SHOW_TOOLS:String = "onShowTools";
		public static const ADDRESS_CHANGE:String = "onAddressChange";
		
		private var _param:*;
		
		public function GalleryEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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