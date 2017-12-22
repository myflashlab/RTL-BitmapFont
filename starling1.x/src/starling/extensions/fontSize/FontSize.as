package starling.extensions.fontSize 
{
	import starling.events.EventDispatcher;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	/**
	 * ...
	 * @author majid
	 */
	public class FontSize extends EventDispatcher
	{
		
		public function FontSize():void
		{
			
		}
		
		public static function calculate($fontSizeBase:int, $stageWidth:int, $stageHeight:int):int
		{
			var dpi:Number = DeviceInfo.dpi;
			var fontSize:int = 0;
			var multiPlier:Number = dpi / 240;
			var widthRatio:Number = $stageWidth / 480;
			var heightRatio:Number = $stageHeight / 762;
			var ratio:Number = Math.min(multiPlier, widthRatio, heightRatio);
			
			if (ratio < 1 && widthRatio >= 1 && heightRatio >= 1) ratio = 1;
			
			fontSize = ratio * $fontSizeBase;
			
			return fontSize;
		}
		
	}

}