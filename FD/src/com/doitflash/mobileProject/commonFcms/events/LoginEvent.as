package com.doitflash.mobileProject.commonFcms.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hadi Tavakoli
	 */
	public class LoginEvent extends Event 
	{
		public static const LOGIN_ATTEMPT:String = "onLoginAttempt";
		public static const LOGIN_SUCCEEDED:String = "onLoginAttemptSucceeded";
		
		public static const SIGNUP_ATTEMPT:String = "onSignupAttempt";
		public static const SIGNUP_SUCCEEDED:String = "onSignupAttemptSucceeded";
		
		public static const FORGOT_ATTEMPT:String = "onForgotAttempt";
		
		private var _param:*;
		
		public function LoginEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			_param = data;
			super(type, bubbles, cancelable);
		}
		
		public function get param():*
		{
			return _param;
		}
		
	}

}