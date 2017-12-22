package com.doitflash.mobileProject.commonFcms.pages.services
{
	import flash.events.Event;
	
	import com.doitflash.mobileProject.commonFcms.myapperaLogin.Starter;
	
	import com.luaye.console.C;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/13/2012 9:37 AM
	 */
	public class PageServices extends Starter 
	{
		public static const SERVICE_INSTALLED:String = "serviceIsInstalled";
		public static const SERVICE_NOT_INSTALLED:String = "serviceIsNotInstalled";
		public static const SERVICE_NEEDS_UPDATE:String = "serviceNeedsUpdate";
		public static const SERVICE_NOT_PURCHASED:String = "serviceNotPurchased";
		
		public function PageServices():void 
		{
			super();
			
			_margin = 10;
		}
		
		override protected function stageRemoved(e:Event=null):void 
		{
			super.stageRemoved(e);
			
			if (_body)
			{
				this.removeChild(_body);
				_body = null;
			}
		}
		
		override protected function initBody($userInfo:Object):void
		{
			_body = new Directory();
			_body.data = $userInfo;
			_body.base = _base;
			_body.holder = this;
			
			this.addChild(_body);
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private

		

//--------------------------------------------------------------------------------------------------------------------- Helpful

		
		
//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}