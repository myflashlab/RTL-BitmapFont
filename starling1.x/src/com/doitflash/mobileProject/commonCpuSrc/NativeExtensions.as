package com.doitflash.mobileProject.commonCpuSrc
{
	import com.adobe.nativeExtensions.Vibration;
	
	//import 	com.adobe.ep.notifications.Notification;
	//import 	com.adobe.ep.notifications.NotificationAlertPolicy;
	//import 	com.adobe.ep.notifications.NotificationEvent;
	//import 	com.adobe.ep.notifications.NotificationIconType;
	//import 	com.adobe.ep.notifications.NotificationManager;
	
	import com.doitflash.mobile.NativeText;
	import com.doitflash.air.extensions.toast.Toast;
	
	//import com.ssd.ane.AndroidExtensions;
	
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialog;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextField;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
	import pl.mateuszmackowiak.nativeANE.NativeDialogListEvent;
	import pl.mateuszmackowiak.nativeANE.notification.NativeNotifiction;
	import pl.mateuszmackowiak.nativeANE.progress.NativeProgress;
	import pl.mateuszmackowiak.nativeANE.properties.SystemProperties;
	//import pl.mateuszmackowiak.nativeANE.toast.Toast;
	
	import milkmidi.air3.demo.extensions.AIR3Extension;
	
	import com.doitflash.air.extensions.MyExtensions;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/24/2012 11:17 AM
	 */
	public class NativeExtensions
	{
		
		
		public function NativeExtensions():void 
		{
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Privates
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Methods
		
		
		
// ----------------------------------------------------------------------------------------------------------------------- Properties
		
		public static function get toast():Class
		{
			return Toast;
		}
		
		public static function get systemProperties():Class
		{
			return SystemProperties;
		}
		
		public static function get nativeProgress():Class
		{
			return NativeProgress;
		}
		
		public static function get nativeNotifiction():Class
		{
			return NativeNotifiction;
		}
		
		public static function get nativeDialogListEvent():Class
		{
			return NativeDialogListEvent;
		}
		
		public static function get nativeTextInputDialog():Class
		{
			return NativeTextInputDialog;
		}
		
		public static function get nativeTextField():Class
		{
			return NativeTextField;
		}
		
		public static function get nativeListDialog():Class
		{
			return NativeListDialog;
		}
		
		public static function get nativeDialogEvent():Class
		{
			return NativeDialogEvent;
		}
		
		public static function get nativeAlert():Class
		{
			return NativeAlert;
		}
		
		public static function get vibration():Class
		{
			return Vibration;
		}
		
		/*public static function get notification():*
		{
			return Notification;
		}
		
		public static function get notificationAlertPolicy():*
		{
			return NotificationAlertPolicy;
		}
		
		public static function get notificationEvent():*
		{
			return NotificationEvent;
		}
		
		public static function get notificationIconType():*
		{
			return NotificationIconType;
		}
		
		public static function get notificationManager():*
		{
			return NotificationManager;
		}*/
		
		public static function get nativeText():*
		{
			return NativeText;
		}
		
		/*public static function get smsShareToast():*
		{
			return AndroidExtensions;
		}*/
		
		public static function get air3Extension():*
		{
			return AIR3Extension;
		}
		
		public static function get myExtensions():*
		{
			return MyExtensions;
		}
	}
	
}