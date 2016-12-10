package com.doitflash.mobileProject.commonCpuSrc.plugins
{
	import flash.events.Event;
	
	import com.doitflash.text.modules.MyMovieClip;
	
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/20/2012 4:16 PM
	 */
	public class Plugin extends MyMovieClip 
	{
		//dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, true)); // to engage the back btn
		//navHistory.push( { id:"historyId", func:closeTheHistory } ); // add a new history
		//if(checkHistory("historyId")) backBtnHit("historyId"); // close the history id
		private var _navHistory:Array = [];
		
		public function Plugin():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			_bgAlpha = 1;
			_bgColor = 0xFF9900;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0x990000;
			_bgStrokeThickness = 5;
			drawBg();
			
		}
		
		protected function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_base.removeEventListener(AppEvent.BACK_BUTTON_CLICK, onDeviceBackButtClick);
			_base.networkMonitor.removeEventListener(AppEvent.NETWORK_STATUS, onNetStatus);
			
			_navHistory = null;
		}
		
		protected function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_base.networkMonitor.addEventListener(AppEvent.NETWORK_STATUS, onNetStatus);
			_base.addEventListener(AppEvent.BACK_BUTTON_CLICK, onDeviceBackButtClick);
			
			_navHistory = [];
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			
		}
		
		protected function onNetStatus(e:AppEvent):void
		{
			
		}
		
		protected function onDeviceBackButtClick(e:AppEvent=null):void
		{
			if (_base.preloaderMc.visible)
			{
				_base.showPreloader(false);
			}
			
			backBtnHit();
		}
		
		public function backBtnHit($historyId:String=null):void
		{
			if (_navHistory.length > 0)
			{
				var obj:Object;
				var id:String;
				var func:Function;
				var params:Array = null;
				
				if ($historyId)
				{
					var foundIndexes:Array = []; // save the index of all the found history objects
					
					for (var i:int = 0; i < _navHistory.length; i++) 
					{
						obj = _navHistory[i];
						if (obj.id == $historyId)
						{
							foundIndexes.push(i);
						}
					}
					
					// remove all the found history objects and call its function
					for (var j:int = foundIndexes.length-1; j >= 0; j--) 
					{
						obj = _navHistory.splice(foundIndexes[j], 1)[0];
						id = obj.id;
						func = obj.func;
						params = obj.params;
					}
					
					if (foundIndexes.length > 0)
					{
						if (params) func.apply(null, params);
						else func.call(null);
					}
				}
				else
				{
					obj = _navHistory.pop();
					id = obj.id;
					func = obj.func;
					params = obj.params;
					
					if (params) func.apply(null, params);
					else func.call(null);
				}
			}
			
			if (_navHistory.length == 0)
			{
				this.dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, false));
			}
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		public function checkHistory($historyId:String):Boolean
		{
			var currHistory:Object;
			
			for (var i:int = 0; i < _navHistory.length; i++) 
			{
				currHistory = _navHistory[i];
				if (currHistory.id == $historyId)
				{
					return true;
				}
			}
			
			return false
		}

// ----------------------------------------------------------------------------------------------------------------------- Properties

		public function get navHistory():Array
		{
			return _navHistory;
		}
		
	}
	
}