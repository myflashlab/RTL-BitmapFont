package com.doitflash.mobileProject.commonPluginFcms
{
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.TextArea;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 10/25/2012 11:06 AM
	 */
	public class Help extends MySprite
	{
		private var _textArea:TextArea;
		private var _format:TextFormat;
		private var _scroller:*;
		
		public function Help():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 0.5;
			//_bgColor = 0x000000;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xFF9900;
			//_bgStrokeThickness = 5;
			//drawBg();
		}
		
// ----------------------------------------------------------------------------------------- Private

		private function stageRemoved(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
		}
		
		private function stageAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			
			
			initTxt();
			onResize();
		}
		
		private function initTxt():void
		{
			if (!_format) 
			{
				_format = new TextFormat();
				_format.color = 0x333333;
				_format.size = 15;
				_format.font = "Arimo";
			}
			
			if (!_textArea) 
			{
				_textArea = new TextArea();
				_textArea.condenseWhite = true;
				_textArea.autoSize = TextFieldAutoSize.LEFT;
				_textArea.antiAliasType = AntiAliasType.ADVANCED;
				_textArea.embedFonts = true;
				_textArea.selectable = true;
				_textArea.border = false;
				_textArea.multiline = true;
				_textArea.wordWrap = true;
				
				_textArea.holder = this;
				_textArea.client = this; // must be where you have your 'allowed functions' saved
				_textArea.serverPath = _serverPath;
				_textArea.assetsPath = _serverPath + "assets/";
				_textArea.funcSecurity = false;
				//_textArea.allowedFunctions(func1, func2, funcOnOver, funcOnOut);
				_textArea.mouseRollOverEnabled = true;
			}	
			
			
			_textArea.defaultTextFormat = _format;
			_textArea.fmlText = _xml.info.textBlock.text();
			if(!_textArea.stage) this.addChild(_textArea);
			
			
		}

// ----------------------------------------------------------------------------------------- Helpful

		override protected function onResize(e:*=null):void
		{
			super.onResize(e);
			
			if (_textArea) 
			{
				_textArea.width = _width;
			}
		}

// ----------------------------------------------------------------------------------------- Methods

		public function talkAvatar($avatarId:String, $script:*):void
		{
			// find the target avatar
			var avatar:Object = _textArea.getModule($avatarId);
			
			// send the scripts into the avatar
			avatar.script($script);
		}
		
		public function videoPlayer($videoId:String, $vidPath:String, $youTube:String, $ratio:String="true", $thumb:String = null):void
		{
			// find the target video player
			var video:Object = _textArea.getModule($videoId);
			
			// send the scripts into the avatar
			video.playNewVideo($vidPath, toBoolean($youTube), toBoolean($ratio), $thumb);
		}
		
		public function textLink($url:String, $target:String="_self"):void
		{
			//C.log($url, $target);
			
			navigateToURL(new URLRequest($url), $target);
		}
		
		public function objectLink($obj:Object):void
		{
			/*for (var param:String in $obj)
			{
				C.log(param + " = " + $obj[param])
			}*/
		}
		
		public function arrayLink($arr:Array):void
		{
			/*for (var i:int = 0; i < $arr.length; i++ )
			{
				C.log(i, $arr[i]);
			}*/
		}
		
		public function arrayObjectStringLink($str:String, $obj:Object, $arr:Array):void
		{
			//C.log($str);
			
			/*for (var param:String in $obj)
			{
				C.log(param + " = " + $obj[param])
			}
			
			for (var i:int = 0; i < $arr.length; i++ )
			{
				C.log(i, $arr[i]);
			}*/
			
		}
		
		public function myCustomFunction($message:String):void
		{
			//C.log($message);
			
		}
		
		public function funcOnOver($value:String):void
		{
			//C.log(_textArea.rolledOverText, _textArea.rolledOverUrl);
			
			_base.getTooltip.mouseSpaceX = 0;
			_base.getTooltip.mouseSpaceY = -20;
			_base.getTooltip.delay = 0.1;
			//_base.getTooltip.showText("<font face='Tahoma' size='11'>" + _textArea.rolledOverText + " // " + $value + "</font>", "ltr");
			_base.getTooltip.showText("<font face='Tahoma' size='11'>" + $value + "</font>", "ltr");
		}
		
		public function funcOnOut(... rest):void
		{
			_base.getTooltip.hide();
		}
		
		public function anchor($name:String):void
		{
			// find the target anchor
			var anchor:Object = _textArea.getModule($name);
			var perc:Number = (anchor.getLocation().y * 100) / (_textArea.height - _scroller.maskHeight)
			
			_scroller.scrollManualY = Math.min(perc, 100);
		}
		
		public function onVideoModule($obj:Object=null):void
		{
			/*for (var param:String in $obj)
			{
				C.log(param + " = " + $obj[param]);
			}*/
		}
		
		public function onAvatarModule($obj:Object=null):void
		{
			/*for (var param:String in $obj)
			{
				C.log(param + " = " + $obj[param]);
			}*/
		}
		
		public function onSlideshowModule($obj:Object=null):void
		{
			/*for (var param:String in $obj)
			{
				C.log(param + " = " + $obj[param]);
			}*/
			
			/*for (var i:int = 0; i < $arr.length; i++ )
			{
				C.log(i, $arr[i]);
			}*/
		}
		
		public function onButtonModule($obj:Object=null):void
		{
			/*for (var param:String in $obj)
			{
				C.log(param + " = " + $obj[param]);
			}*/
		}
	
// ----------------------------------------------------------------------------------------- Getter - Setter
	
		public function set scroller(a:*):void
		{
			_scroller = a;
		}

	}
}