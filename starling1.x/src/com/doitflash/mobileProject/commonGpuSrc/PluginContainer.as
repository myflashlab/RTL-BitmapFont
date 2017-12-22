package com.doitflash.mobileProject.commonGpuSrc 
{
	import com.greensock.TweenMax;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import com.doitflash.starling.MyStarlingSprite;
	import com.doitflash.text.modules.MyMovieClip;
	
	import com.doitflash.mobileProject.commonGpuSrc.events.AppEventStarling;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 8/8/2012 12:47 PM
	 */
	public class PluginContainer extends MyStarlingSprite 
	{
		public static const CPU_PLUGIN:String = "cpu";
		public static const GPU_PLUGIN:String = "gpu";
		private var _currPluginType:String;
		
		private var _mc:*;
		private var _plugin:*;
		private var _backBtnEngaged:Boolean;
		
		private var _isWaitingForJavaPlugin:Boolean;
		
		public function PluginContainer() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//drawBg(1, 0xFFFFFF, 0, 0xFFFFFF, 1);
		}
		
		private function howsBackBtnStatus(e:*):void
		{
			_backBtnEngaged = e.param;
		}
		
		private function onPageReady(e:*=null):void
		{
			dispatchEventWith(AppEventStarling.MODULE_READY);
		}
		
		private function onPageClose(e:*=null):void
		{
			dispatchEventWith(AppEventStarling.FORCE_CLOSE);
		}
		
		public function javaApkResult($result:Object):void
		{
			_base.showPreloader(false);
			
			if ($result.status)
			{
				if ($result.isAppInstalled)
				{
					_isWaitingForJavaPlugin = true;
					_base.runJavaPlugin(_data);
				}
			}
			else
			{
				_base.showPreloader(true, $result.msg);
				setTimeout(_base.showPreloader, 2500, false);
			}
			
			_isWaitingForJavaPlugin = false;
		}
		
		private function onFrameRateChange(e:AppEvent):void
		{
			if (Starling.current.nativeStage.frameRate > 10 && _isWaitingForJavaPlugin)
			{
				_base.runJavaApk(javaApkResult);
				_isWaitingForJavaPlugin = false;
			}
		}
		
		public function update():void
		{
			// remove current content to save resources
			clear();
			
			// check if _data.type is a pointing to a java or html plugin?
			if (_data.type.substr(0, 4) == "JAVA" || _data.type.substr(0, 4) == "HTML")
			{
				_base.runJavaApk(javaApkResult);
				setTimeout(_base.showPreloader, 1000, false);
				_isWaitingForJavaPlugin = true;
				
				return;
			}
			
			// get on the external swf's hook
			_mc = _base.bulkLoader.getMovieClip(_data.type) as MyMovieClip;
			
			try
			{
				_currPluginType = PluginContainer.GPU_PLUGIN;
				
				// initialize the main class in the hook
				_plugin = new _mc.mainClass();
				_plugin.addEventListener(AppEventStarling.BACK_BUTTON_ENGAGED, howsBackBtnStatus);
				_plugin.addEventListener(AppEventStarling.MODULE_READY, onPageReady);
				_plugin.addEventListener(AppEventStarling.FORCE_CLOSE, onPageClose);
				_plugin.theBase = _base;
				_plugin.data = _data;
				_plugin.width = _width;
				_plugin.height = _height;
				this.addChild(_plugin);
				
				return;
			}
			catch (err:Error) 
			{
				_plugin = null;
			}
			
			_currPluginType = PluginContainer.CPU_PLUGIN;
			
			// initialize the required page .swf file according to _data.type
			//_mc = _base.bulkLoader.getMovieClip(_data.type) as MyMovieClip;
			_mc.addEventListener(AppEvent.BACK_BUTTON_ENGAGED, howsBackBtnStatus);
			_mc.addEventListener(AppEvent.MODULE_READY, onPageReady);
			_mc.addEventListener(AppEvent.FORCE_CLOSE, onPageClose);
			_mc.base = _base;
			_mc.data = _data;
			_mc.width = _width;
			_mc.height = _height;
			_base.cpuPluginContainer.addChild(_mc);
		}
		
		public function clear():void 
		{
			_backBtnEngaged = false;
			
			if (_mc)
			{
				switch (_currPluginType) 
				{
					case PluginContainer.CPU_PLUGIN:
						
						_mc.removeEventListener(AppEvent.BACK_BUTTON_ENGAGED, howsBackBtnStatus);
						_mc.removeEventListener(AppEvent.MODULE_READY, onPageReady);
						_mc.removeEventListener(AppEvent.FORCE_CLOSE, onPageClose);
						_base.cpuPluginContainer.removeChild(_mc);
						_mc = null;
						
					break;
					case PluginContainer.GPU_PLUGIN:
						
						_plugin.removeEventListener(AppEventStarling.BACK_BUTTON_ENGAGED, howsBackBtnStatus);
						_plugin.removeEventListener(AppEventStarling.MODULE_READY, onPageReady);
						_plugin.removeEventListener(AppEventStarling.FORCE_CLOSE, onPageClose);
						_plugin.disposeIt();
						removeChild(_plugin, true);
						_plugin = null;
						
					default:
				}
			}
		}
		
		public function get backBtnEngaged():Boolean
		{
			return _backBtnEngaged;
		}
		
		public function get currPluginType():String
		{
			return _currPluginType;
		}
		
	}

}