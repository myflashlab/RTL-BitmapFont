package com.doitflash.mobileProject.commonFcms.loginArea
{
	import com.doitflash.text.modules.MyMovieClip;
	import com.doitflash.mobileProject.commonFcms.events.LoginEvent;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLVariables;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/9/2011 8:42 PM
	 */
	public class LoginArea extends MyMovieClip
	{
		private var _body:Body;
		
		public function LoginArea():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_body.removeEventListener(LoginEvent.LOGIN_ATTEMPT, onLogin);
			this.removeChild(_body);
			_body = null;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			// set the browser address bar
			pageAddressControler();
			
			_body = new Body();
			_body.addEventListener(LoginEvent.LOGIN_ATTEMPT, onLogin);
			_body.serverPath = _serverPath;
			_body.base = _base;
			this.addChild(_body);
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function onLogin(e:LoginEvent):void
		{
			_base.showPreloader(true);
			_base.gateway.call("AccessCheck.login", new Responder(onAccessResult, _base.onFault), e.param.$username, e.param.$password, _base.serverTime);
		}
		
		private function onAccessResult($result:String):void
		{
			_base.showPreloader(false);
			var vars:URLVariables = new URLVariables($result);
			
			switch (vars.backToFlash) 
			{
				case "true":
					
					// let Preloader.as know that login attempt has been successful
					this.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_SUCCEEDED, vars));
					
				break;
				default:
					
					// let _body know the login failure
					_body.fail(vars);
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*=null):void 
		{
			super.onResize(e);
			
			if (_body)
			{
				_body.width = 100; // will be overwritten by the _body itself in the onResize function
				_body.height = 100; // will be overwritten by the _body itself in the onResize function
				_body.x = _width / 2 - _body.width / 2;
				_body.y = _height / 2 - _body.height / 2;
			}
		}
		
		private function pageAddressControler():void
		{
			_base.setPageAddress("login", "Login Page");
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

	}
	
}