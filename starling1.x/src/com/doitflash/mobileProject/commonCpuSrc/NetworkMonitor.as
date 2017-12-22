package com.doitflash.mobileProject.commonCpuSrc
{
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.events.StatusEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import air.net.URLMonitor;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/14/2012 11:10 AM
	 */
	public class NetworkMonitor extends EventDispatcher
	{
		private var _available:Boolean;
		private var _urlRequest:URLRequest;
		private var _monitor:URLMonitor;
		
		public function NetworkMonitor():void 
		{
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Privates
		
		private function handleStatus(e:StatusEvent):void
		{
			_available = _monitor.available;
			this.dispatchEvent(new AppEvent(AppEvent.NETWORK_STATUS, {available:_available}));
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		public function check($url:URLRequest):void
		{
			_urlRequest = $url;
			
			// stop any old monitoring processos
			stop();
			
			// start checking the new url
			_monitor = new URLMonitor(_urlRequest);
			_monitor.addEventListener(StatusEvent.STATUS, handleStatus);
			_monitor.start();
		}
		
		public function stop():void
		{
			if (_monitor)
			{
				_monitor.removeEventListener(StatusEvent.STATUS, handleStatus);
				_monitor.stop();
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Properties
		
		public function get available():Boolean
		{
			return _available;
		}
	}
	
}