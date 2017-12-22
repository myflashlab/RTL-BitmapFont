package com.doitflash.mobileProject.commonFcms.pages.plugins
{
	import com.doitflash.mobileProject.commonFcms.myapperaLogin.Starter;
	import flash.events.Event;
	
	
	import com.luaye.console.C;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/13/2012 9:37 AM
	 */
	public class PagePlugins extends Starter 
	{
		public function PagePlugins():void 
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