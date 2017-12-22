package com.doitflash.mobileProject.commonFcms.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/12/2011 10:36 AM
	 */
	public class PageEvent extends Event 
	{
		public static const SAVE_UPDATE:String = "saveUpdate";
		public static const SAVE_NEW:String = "saveNew";
		
		public static const NEW_ITEM_MODULE_ACTIVATION:String = "onNewItemModuleActivation";
		public static const SAVE_REQUEST_SUCCEEDED:String = "onSaveRequestSuccedded";
		public static const UPDATE_REQUEST_SUCCEEDED:String = "onUpdateRequestSuccedded";
		
		public static const ADD_QUESTION:String = "onAddQuestion";
		public static const SHOW_BOOKS:String = "onShowBooks";
		
		public static const LAUNCH_EXAM:String = "onLaunchExam";
		public static const RESULT_EXAM:String = "onResultExam";
		public static const START_EXAM:String = "onStartExam";
		public static const CANCEL_EXAM:String = "onCancelExam";
		public static const FINISH_EXAM:String = "onFinishExam";
		
		public static const ITEM_MOVE_UP:String = "onItemMoveUp";
		public static const ITEM_MOVE_DOWN:String = "onItemMoveDown";
		public static const ITEM_SWAP:String = "onItemSwap";
		public static const ITEM_DROP:String = "onItemDrop";
		public static const ITEM_EDIT:String = "onItemEdit";
		public static const ITEM_CONTENT_EDIT:String = "onItemContentEdit";
		
		public static const ALERT_RESULT:String = "onAlertResult";
		
		private var _param:*;
		
		public function PageEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
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