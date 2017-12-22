package com.doitflash.mobileProject.commonCpuSrc.plugins.WP.posts
{
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import com.doitflash.text.modules.MySprite;
	
	import com.doitflash.mobileProject.commonCpuSrc.plugins.WP.assets.CommentMc;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/11/2012 12:26 PM
	 */
	public class ExcerptHeader extends MySprite 
	{
		private var _titleCover:Shape;
		
		private var _leftMc:Sprite;
		private var _midMc:Sprite;
		private var _rightMc:Sprite;
		private var _seperator:Shape;
		
		private var _title:TextField;
		private var _title2:TextField;
		private var _comments:TextField;
		
		public function ExcerptHeader():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_bgAlpha = 1;
			//_bgColor = 0x00FF0F;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xE1E1E1;
			//_bgStrokeThickness = 1;
			//drawBg();
			
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
			
			_leftMc = new Sprite();
			this.addChild(_leftMc);
			
			_midMc = new Sprite();
			this.addChild(_midMc);
			
			_rightMc = new Sprite();
			this.addChild(_rightMc);
			
			_seperator = new Shape();
			_seperator.visible = false;
			this.addChild(_seperator);
			
			initTitle();
			initDate();
			
			if (_data.comment_status == "open") initComments();
			
			onResize();
			
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initTitle():void
		{
			_title = new TextField();
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.antiAliasType = AntiAliasType.ADVANCED;
			_title.embedFonts = true;
			_title.mouseEnabled = false;
			_title.htmlText = "<font face='" + _configXml.textStyle.title1.font.text() + "' size='" + _configXml.textStyle.title1.size.text() + "' color='" + _configXml.textStyle.title1.color.text() + "'>"+ _data.title_plain +"</font>";
			//_title.scaleX = _title.scaleY = _base.deviceInfo.dpiScaleMultiplier;
			
			_leftMc.addChild(_title);
		}
		
		private function initDate():void
		{
			_title2 = new TextField();
			_title2.autoSize = TextFieldAutoSize.LEFT;
			_title2.antiAliasType = AntiAliasType.ADVANCED;
			_title2.embedFonts = true;
			_title2.mouseEnabled = false;
			_title2.htmlText = "<font face='" + _configXml.textStyle.title2.font.text() + "' size='" + _configXml.textStyle.title2.size.text() + "' color='" + _configXml.textStyle.title2.color.text() + "'>"+ _data.author[0].first_name + " " + _data.author[0].last_name + " - " + _data.date.toDateString() + "</font>";
			_title2.scaleX = _title2.scaleY = _base.deviceInfo.dpiScaleMultiplier;
			
			_leftMc.addChild(_title2);
		}
		
		private function initComments():void
		{
			var gr:CommentMc = new CommentMc();
			gr.label_txt.text = _data.comment_count;
			_rightMc.addChild(gr);
			
			/*_comments = new TextField();
			_comments.autoSize = TextFieldAutoSize.LEFT;
			_comments.antiAliasType = AntiAliasType.ADVANCED;
			_comments.embedFonts = true;
			_comments.mouseEnabled = false;
			
			var str:String = " Comment";
			if (_data.comment_count > 1) str = " Comments";
			
			_comments.htmlText = "<font face='PT Sans Narrow' size='15' color='#999999'>" + _data.comment_count + str + "</font>";
			_comments.scaleX = _comments.scaleY = _base.deviceInfo.dpiScaleMultiplier;
			
			_comments.x = gr.x + gr.width - 10;
			_comments.y = gr.height / 2 - _comments.height / 2;
			
			_rightMc.addChild(_comments);*/
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_rightMc)
			{
				_rightMc.x = _width - _rightMc.width - 5;
				_rightMc.y = _height / 2 - _rightMc.height / 2;
			}
			
			if (_seperator)
			{
				_seperator.graphics.clear();
				_seperator.graphics.lineStyle(1, 0xE1E1E1, 1);
				_seperator.graphics.moveTo(0, _height / 6);
				_seperator.graphics.lineTo(0, _height - (_height / 6));
				_seperator.graphics.endFill();
				
				_seperator.x = _rightMc.x - 5;
			}
			
			if (_data.comment_status != "open" && _rightMc && _seperator)
			{
				_seperator.x = _width;
			}
			
			if (_leftMc)
			{
				_title.autoSize = TextFieldAutoSize.LEFT;
				if (_title.width > _width && _width > 0)
				{
					var h:Number = _title.height;
					_title.autoSize = TextFieldAutoSize.NONE;
					
					_title.width = _width;
					_title.height = h;
				}
				
				_title2.y = _title.y + _title.height - 5;
				
				var point:Number = _seperator.x - 100;
				if(_titleCover)_titleCover.graphics.clear();
				
				if (point > 0 && _leftMc.width > point)
				{
					_titleCover = new Shape();
					_leftMc.addChild(_titleCover);
					
					toCoverTitle(0xFFFFFF);
				}
			}
		}
		
		public function toCoverTitle($color:uint):void
		{
			if (!_titleCover) return;
			
			var point:Number = _seperator.x - 100;
			
			_titleCover.graphics.clear();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_seperator.x - point + _margin, _leftMc.height, toRad(0), point, 0);
			_titleCover.graphics.beginGradientFill(GradientType.LINEAR, [$color, $color], [0, 1], [0, 235], matr);
			_titleCover.graphics.drawRect(point, 1, _seperator.x - point + _margin, _leftMc.height);
			
			_titleCover.graphics.beginFill($color, 1);
			_titleCover.graphics.drawRect(_seperator.x, 1, _width - _seperator.x + _margin, _leftMc.height);
			
			_titleCover.graphics.endFill();
		}
		
		private function toRad(a:Number):Number 
		{
			return a*Math.PI/180;
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		override public function get height():Number
		{
			if (_title2.y + _title2.height > _height)
			{
				return _title2.y + _title2.height;
			}
			else
			{
				return _height;
			}
		}
		
	}
	
}