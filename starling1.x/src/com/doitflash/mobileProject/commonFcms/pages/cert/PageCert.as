package com.doitflash.mobileProject.commonFcms.pages.cert
{
	import com.doitflash.mobileProject.commonFcms.myapperaLogin.Starter;
	import flash.events.Event;
	
	
	import com.luaye.console.C;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/13/2012 9:37 AM
	 */
	public class PageCert extends Starter 
	{
		public function PageCert():void 
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
			_body = new Certificator();
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