package com.doitflash.mobileProject.commonFcms.myapperaLogin
{
	import com.doitflash.text.modules.MyMovieClip;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.system.Security;
	import flash.events.NetStatusEvent;
	import flash.net.Responder;
	
	import com.doitflash.events.AlertEvent;
	import com.doitflash.tools.RemotingConnection;
	import com.doitflash.mobileProject.commonFcms.events.LoginEvent;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 7/31/2012 2:43 PM
	 */
	public class Starter extends MyMovieClip 
	{
		private var _gateway:RemotingConnection;
		
		protected var _body:*;
		private var _loginMc:Login;
		private var _signupMc:Signup;
		private var _forgotMc:Forgot;
		
		public function Starter():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 0;
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			drawBg();
		}
		
//--------------------------------------------------------------------------------------------------------------------- Private
		
		protected function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (_signupMc)
			{
				_signupMc.removeEventListener(LoginEvent.SIGNUP_ATTEMPT, onSignup);
				this.removeChild(_signupMc);
				_signupMc = null;
			}
			
			if (_forgotMc)
			{
				_forgotMc.removeEventListener(LoginEvent.FORGOT_ATTEMPT, onForgot);
				this.removeChild(_forgotMc);
				_forgotMc = null;
			}
		}
		
		protected function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			Security.loadPolicyFile(_base.xml.pluginDirectory.policy.text());
			_gateway = new RemotingConnection(_base.xml.pluginDirectory.amfphp.text());
			
			// first check if the user is logged in to our servers?
			checkUserLoginStatus();
			
			onResize();
		}
		
		private function checkUserLoginStatus():void
		{
			this.visible = false;
			_base.showPreloader(true);
			_gateway.call("users.CheckLogStatus.check", new Responder(onCheckLogResult, _base.onFault), _base.getServerTime(), _base.version);
		}
		
		private function onCheckLogResult($result:Object):void
		{
			this.visible = true;
			_base.showPreloader(false);
			
			if ($result.status == "true")
			{
				_base.myapperaUserInfo = $result;
				if (!_body) initBody($result);
				onResize();
			}
			else
			{
				// initialize the login page
				initLogin();
			}
			
			_base.myapperaLogStatus(toBoolean($result.status));
		}
		
		private function initLogin():void
		{
			if (_loginMc) 
			{
				_loginMc.visible = true;
				return;
			}
			
			_loginMc = new Login();
			_loginMc.addEventListener(LoginEvent.LOGIN_ATTEMPT, onLogin);
			_loginMc.addEventListener(LoginEvent.SIGNUP_ATTEMPT, initSignup);
			_loginMc.addEventListener(LoginEvent.FORGOT_ATTEMPT, initForgot);
			_loginMc.base = _base;
			_loginMc.holder = this;
			
			this.addChild(_loginMc);
			
			onResize();
		}
		
		private function initSignup(e:LoginEvent):void
		{
			_loginMc.visible = false;
			
			_signupMc = new Signup();
			_signupMc.addEventListener(LoginEvent.SIGNUP_ATTEMPT, onSignup);
			_signupMc.base = _base;
			_signupMc.holder = this;
			
			this.addChild(_signupMc);
			
			onResize();
		}
		
		private function initForgot(e:LoginEvent):void
		{
			_loginMc.visible = false;
			
			_forgotMc = new Forgot();
			_forgotMc.addEventListener(LoginEvent.FORGOT_ATTEMPT, onForgot);
			_forgotMc.base = _base;
			_forgotMc.holder = this;
			
			this.addChild(_forgotMc);
			
			onResize();
		}
		
		private function onLogin(e:LoginEvent):void
		{
			_base.showPreloader(true);
			_gateway.call("users.CheckLogStatus.login", new Responder(onLoginResult, _base.onFault), e.param.$username, e.param.$password, _base.getServerTime());
		}
		
		private function onSignup(e:LoginEvent):void
		{
			var obj:Object = { };
			obj.firstname = e.param.firstname;
			obj.lastname = e.param.lastname;
			obj.email = e.param.email;
			obj.password = e.param.password;
			obj.description = e.param.description;
			
			_base.showPreloader(true);
			_gateway.call("users.Register.newRegister", new Responder(onRegisterResult, _base.onFault), obj, _base.getServerTime());
		}
		
		private function onForgot(e:LoginEvent):void
		{
			var obj:Object = { };
			obj.email = e.param.email;
			
			_base.showPreloader(true);
			_gateway.call("users.Forgot.forgotPassword", new Responder(onForgotResult, _base.onFault), obj, _base.getServerTime());
		}
		
		private function onLoginResult($result:Object):void
		{
			_base.showPreloader(false);
			if ($result.status == "true")
			{
				_loginMc.removeEventListener(LoginEvent.LOGIN_ATTEMPT, onLogin);
				_loginMc.removeEventListener(LoginEvent.SIGNUP_ATTEMPT, initSignup);
				_loginMc.removeEventListener(LoginEvent.FORGOT_ATTEMPT, initForgot);
				this.removeChild(_loginMc);
				_loginMc = null;
				
				// build flash cookies
				_base.getSharedObject = SharedObject.getLocal("fcmsSharedObjects", "/");
				_base.getSharedObject.data.serverTime = _base.serverTime;
				_base.getSharedObject.flush();
				
				_base.myapperaUserInfo = $result;
				if (!_body) initBody($result);
				onResize();
			}
			else
			{
				_loginMc.fail($result.msg);
			}
			
			_base.myapperaLogStatus(toBoolean($result.status));
		}
		
		private function onRegisterResult($result:Object):void 
		{
			_base.showPreloader(false);
			if ($result.status == "true")
			{
				_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
				_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onAlertClose);
			}
			
			_base.showAlert(decodeURI($result.msg), $result.msgTitle, 550, 250);
		}
		
		private function onForgotResult($result:Object):void 
		{
			_base.showPreloader(false);
			if ($result.status == "true")
			{
				_base.getAlert.getDll.addEventListener(AlertEvent.CLOSE, onAlertClose);
				_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onAlertClose);
			}
			
			_base.showAlert(decodeURI($result.msg), $result.msgTitle, 400, 200);
		}
		
		private function onAlertClose(e:*):void
		{
			_base.getAlert.getDll.clearEvents();
			
			if (_signupMc)
			{
				_signupMc.removeEventListener(LoginEvent.SIGNUP_ATTEMPT, onSignup);
				this.removeChild(_signupMc);
				_signupMc = null;
			}
			
			if (_forgotMc)
			{
				_forgotMc.removeEventListener(LoginEvent.FORGOT_ATTEMPT, onForgot);
				this.removeChild(_forgotMc);
				_forgotMc = null;
			}
			
			_loginMc.visible = true;
		}
		
		protected function initBody($userInfo:Object):void
		{
			
		}
		
//--------------------------------------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_loginMc)
			{
				_loginMc.x = _width - _loginMc.width >> 1;
				_loginMc.y = _height - _loginMc.height >> 1;
			}
			
			if (_signupMc)
			{
				_signupMc.x = _width - _signupMc.width >> 1;
				_signupMc.y = _height - _signupMc.height >> 1;
			}
			
			if (_forgotMc)
			{
				_forgotMc.x = _width - _forgotMc.width >> 1;
				_forgotMc.y = _height - _forgotMc.height >> 1;
			}
			
			if (_body)
			{
				_body.x = _body.y = _margin;
				_body.width = _width - _margin * 2;
				_body.height = _height - _margin * 2;
			}
		}

//--------------------------------------------------------------------------------------------------------------------- Methods

		

//--------------------------------------------------------------------------------------------------------------------- Properties

		
	}
	
}