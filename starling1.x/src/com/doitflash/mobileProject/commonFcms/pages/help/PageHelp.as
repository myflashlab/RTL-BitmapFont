package com.doitflash.mobileProject.commonFcms.pages.help
{
	import com.doitflash.mobileProject.commonFcms.myapperaLogin.Starter;
	import flash.events.Event;
	
	
	import com.luaye.console.C;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 8/5/2012 11:44 AM
	 */
	public class PageHelp extends Starter 
	{
		public function PageHelp():void 
		{
			super();
			
			_margin = 0;
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
			_body = new Help();
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