package com.doitflash.mobileProject.commonCpuSrc.plugins.WP.comments
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.utils.setTimeout;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.remote.wp.WordPressParser;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.fl.motion.Color;
	
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.assets.CommentMc;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/20/2012 9:14 PM
	 */
	public class Item extends MySprite 
	{
		[Embed(source = "../assets/gravatar.jpg")]
		private var _avatarEmbed:Class;
		private var _defAvatar:Bitmap;
		
		private var _txt:TextField;
		private var _avatar:Loader;
		private var _replyBtn:CommentMc;
		
		private var _list:List;
		private var _subComments:Array;
		
		private var _line:Shape;
		
		public function Item():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_height = 50;
			
			_line = new Shape();
			this.addChild(_line);
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (_data.date is String) _data.date = WordPressParser.convertToDate(_data.date);
			
			_margin = _configXml.margin.text();
			_bgAlpha = _configXml.bgAlpha.text();
			_bgColor = _configXml.bgColor.text();
			//_bgStrokeAlpha = _configXml.bgStrokeAlpha.text();
			//_bgStrokeColor = _configXml.bgStrokeColor.text();
			//_bgStrokeThickness = _configXml.bgStrokeThickness.text();
			drawBg();
			
			if (!_defAvatar) _defAvatar = new _avatarEmbed();
			_defAvatar.smoothing = true;
			this.addChild(_defAvatar);
			
			_base.loadRemoteFile(new URLRequest(_data.gravatar), initAvatar);
			initTxt();
			initBtn();
			if(_subComments.length > 0) initSubs();
			
			
			onResize();
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initAvatar($bytes:*):void
		{
			_avatar = new Loader();
			_avatar.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			_avatar.loadBytes($bytes);
			//_avatar.bgAlpha = 1;
			//_avatar.bgColor = 0xFF9900;
			//_avatar.drawBg();
			//_avatar.width = 50;
			//_avatar.height = 50;
			
			this.addChild(_avatar);
			
			function onAvatarLoaded(e:Event):void
			{
				onResize();
			}
		}
		
		private function initTxt():void
		{
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = true;
			_txt.mouseEnabled = false;
			_txt.condenseWhite = true;
			
			//var str:String = _data.author;
			//str = str.replace("&hellip;", "... ");
			//str = str.replace("&rarr;", "");
			//str = str.replace("Continue reading", "<font color='#990000'>Continue reading</font>");
			
			_txt.htmlText = "<font face='Arimo' size='13' color='#999999'>" + _data.author + " - " + _data.date.toLocaleDateString() + "<br>" + _data.content + "</font>";
			
			this.addChild(_txt);
		}
		
		private function initBtn():void
		{
			_replyBtn = new CommentMc();
			_replyBtn.addEventListener(MouseEvent.CLICK, onReply);
			_replyBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_replyBtn.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_replyBtn.addEventListener(MouseEvent.MOUSE_OUT, onUp);
			_replyBtn.data = _data;
			_replyBtn.label_txt.text = "Re";
			_replyBtn.scaleX = _replyBtn.scaleY = 0.75;
			this.addChild(_replyBtn);
			
		}
		
		private function onReply(e:MouseEvent):void
		{
			this.dispatchEvent(new AppEvent(AppEvent.WP_REPLY, _data, true));
		}
		
		private function initSubs():void
		{
			_list = new List();
			_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.table = false;
			_list.space = 0;
			_list.speed = 0;
			
			this.addChild(_list);
			
			for (var i:int = 0; i < _subComments.length; i++) 
			{
				var item:ItemSub = new ItemSub();
				//item.addEventListener(AppEvent.WP_REPLY, goReplyMenu);
				item.base = _base;
				item.data = _subComments[i];
				
				//item.width = _width - (_margin * 2);
				
				_list.add(item);
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			var avatarW:Number = 0;
			var avatarH:Number = 0;
			
			if (_defAvatar)
			{
				_defAvatar.width = 75;
				_defAvatar.height = 75;
				_defAvatar.x = _margin;
				_defAvatar.y = _margin;
				
				avatarW = _defAvatar.x + _defAvatar.width;
				avatarH = _defAvatar.y + _defAvatar.height;
			}
			
			if (_avatar)
			{
				_avatar.width = 75;
				_avatar.height = 75;
				_avatar.x = _margin;
				_avatar.y = _margin;
				
				avatarW = _avatar.x + _avatar.width;
				avatarH = _avatar.y + _avatar.height;
			}
			
			if (_txt)
			{
				
				_txt.x = avatarW + 5;
				_txt.y = _margin;
				
				_txt.scaleX = _txt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
				_txt.width = (_width - (avatarW - _margin) - (_margin * 2)) * (1 / _base.deviceInfo.dpiScaleMultiplier);
				
				_height = Math.max(_txt.height, avatarH - _margin) + _margin * 2;
				
				_replyBtn.x = _width - (_replyBtn.width*0.75) - 0;
				_replyBtn.y = 0;
			}
			
			if (_list)
			{
				_list.x = _txt.x;
				_list.y = Math.max(_txt.y + _txt.height, avatarH) + 5;
				_height = _list.y + _list.height + _margin
				
				for (var i:int = 0; i < _list.items.length; i++) 
				{
					var item:ItemSub = _list.items[i].content as ItemSub;
					if (i % 2) item.bgColor = _configXml.subColorB.text();
					else item.bgColor = _configXml.subColorA.text();
					item.width = _width - (_margin * 2) - _txt.x;
					//item.height = _scroller.maskHeight;
				}
			}
			
			_line.graphics.clear();
			_line.graphics.lineStyle(1, _configXml.lineColor.text());
			_line.graphics.moveTo(0, 0);
			_line.graphics.lineTo(_width, 0);
			
			_line.y = _height;
			
			super.onResize(e);
		}
		
		private function onDown(e:MouseEvent):void
		{
			var item:* = e.currentTarget;
			
			var color:Color = new Color();
			color.setTint(0xFFFFFF, 1);
			
			try
			{
				item.icon_mc.transform.colorTransform = color;
				item.label_txt.htmlText = "<font color='#000000' >" + item.label_txt.text;
			}
			catch (err:Error)
			{
				item.transform.colorTransform = color;
			}
		}
		
		private function onUp(e:MouseEvent):void
		{
			var item:* = e.currentTarget;
			
			setTimeout(go, 100);
			function go():void
			{
				var color:Color = new Color();
				color.setTint(0xFFFFFF, 0);
				
				try
				{
					item.icon_mc.transform.colorTransform = color;
					item.label_txt.htmlText = "<font color='#FFFFFF' >" + item.label_txt.text;
				}
				catch (err:Error)
				{
					item.transform.colorTransform = color;
				}
			}
			
			
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		public function set subComments(a:Array):void
		{
			_subComments = a;
		}
		
	}
	
}