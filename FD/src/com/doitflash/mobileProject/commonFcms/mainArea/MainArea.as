package com.doitflash.mobileProject.commonFcms.mainArea
{
	import com.doitflash.mobileProject.commonFcms.events.MainEvent;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import com.doitflash.text.TextArea;
	
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.mobileProject.commonFcms.mainArea.header.Header;
	import com.doitflash.mobileProject.commonFcms.mainArea.navigation.Navigation;
	import com.doitflash.mobileProject.commonFcms.mainArea.content.Content;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/9/2011 8:42 PM
	 */
	public class MainArea extends MyMovieClip
	{
		private var _headerMc:Header;
		private var _navMc:Navigation;
		private var _contentMc:Content;
		
		public function MainArea():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 0.05;
			//_bgColor = 0x000000;
			//drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			// remove all listeners
			_headerMc.removeEventListener(MainEvent.LOGOUT, onLogout);
			_headerMc.removeEventListener(MainEvent.CONNECT, toConnect);
			_headerMc.removeEventListener(MainEvent.DISCONNECT, toDisconnect);
			
			// remove all children from the stage
			this.removeChild(_headerMc);
			this.removeChild(_navMc);
			this.removeChild(_contentMc);
			
			// destroy all children
			_headerMc = null;
			_navMc = null;
			_contentMc = null;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			// set the browser address bar
			pageAddressControler();
			
			initHeader();
			initContent();
			initNav();
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initHeader():void
		{
			_headerMc = new Header();
			_headerMc.addEventListener(MainEvent.LOGOUT, onLogout);
			_headerMc.addEventListener(MainEvent.CONNECT, toConnect);
			_headerMc.addEventListener(MainEvent.DISCONNECT, toDisconnect);
			_headerMc.base = _base;
			_headerMc.serverPath = _serverPath;
			this.addChild(_headerMc);
		}
		
		private function initContent():void
		{
			_contentMc = new Content();
			_contentMc.base = _base;
			_contentMc.serverPath = _serverPath;
			this.addChild(_contentMc);
		}
		
		private function initNav():void
		{
			_navMc = new Navigation();
			_navMc.addEventListener(MainEvent.PAGING, onPageChange);
			_navMc.base = _base;
			_navMc.serverPath = _serverPath;
			this.addChild(_navMc);
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function onLogout(e:MainEvent):void
		{
			_base.showPreloader(true);
			_base.gateway.call("AccessCheck.logout", new Responder(onResult, _base.onFault));
			
			function onResult($result:String):void
			{
				_base.showPreloader(false);
				var vars:URLVariables = new URLVariables($result);
				
				switch (vars.backToFlash) 
				{
					case "true":
						
						// let Preloader.as know that logout attempt has been successful
						dispatchEvent(new MainEvent(MainEvent.LOGOUT_SUCCEEDED, vars));
						
					break;
					default:
						
						// it seems that server-side code can't log you out!!!
				}
			}
		}
		
		private function toConnect(e:MainEvent):void
		{
			// manually go to plugins page
			
			var item:*;
			var lng:int = _navMc.nav.list.items.length;
			var i:int;
			for (i = 0; i < lng; i++) 
			{
				item = _navMc.nav.list.getItemByIndex(i).content;
				if (item.data.value.indexOf("page_plugins.swf") > 0)
				{
					_navMc.nav.pick(i);
					return;
				}
			}
		}
		
		private function toDisconnect(e:MainEvent):void
		{
			_base.logoutMyappera();
		}
		
		private function onPageChange(e:MainEvent):void
		{
			// load the page inside Content.as
			_contentMc.load(e.param);
		}
		
		override protected function onResize(e:*=null):void 
		{
			super.onResize(e);
			
			if (_headerMc)
			{
				_headerMc.width = _width;
				_headerMc.height = 40;
			}
			
			if (_navMc)
			{
				_navMc.y = _headerMc.y + _headerMc.height;
				_navMc.width = 200;
				_navMc.height = _height - _headerMc.height;
			}
			
			if (_contentMc)
			{
				_contentMc.x = _navMc.x + _navMc.width;
				_contentMc.y = _headerMc.y + _headerMc.height;
				_contentMc.width = _width - _navMc.width;
				_contentMc.height = _height - _headerMc.height;
			}
		}
		
		private function pageAddressControler():void
		{
			_base.setPageAddress("Main", "Main Page");
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function refreshHeader():void
		{
			_headerMc.setWelcomeMsg();
		}
		
		public function myapperaLogStatus($status:Boolean):void
		{
			_headerMc.connectionIcon($status);
		}
		
		public function gotoWelcomePage():void
		{
			// manually go to admin setting
			
			var item:*;
			var lng:int = _navMc.nav.list.items.length;
			var i:int;
			for (i = 0; i < lng; i++) 
			{
				item = _navMc.nav.list.getItemByIndex(i).content;
				if (item.data.value.indexOf("page_adminSetting.swf") > 0)
				{
					_navMc.nav.pick(i);
					return;
				}
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

	}
	
}