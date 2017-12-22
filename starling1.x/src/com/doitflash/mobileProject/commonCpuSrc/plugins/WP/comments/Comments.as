package com.doitflash.mobileProject.commonCpuSrc.plugins.WP.comments
{
	import com.doitflash.text.TextArea;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.utils.scroll.TouchScroll;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.consts.ScrollConst;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/20/2012 2:20 PM
	 */
	public class Comments extends MySprite 
	{
		private var _commentPacks:Array;
		
		private var _list:*;
		private var _scroller:*;
		private var _altTxt:TextArea;
		private var _altStr:String = "There are no comments! You can be the first one to leave a comment on this post.";
		
		public function Comments():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			
			
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			this.removeChild(_scroller);
			_scroller.removeEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
			_base.touchScrollPool.returnObject(_scroller);
			
			_list.removeAll();
			_base.listPool.returnObject(_list);
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			_altStr = _configXml.noComment.str.text();
			
			_margin = 0;
			_bgAlpha = _configXml.bgAlpha.text();
			_bgColor = _configXml.bgColor.text();
			/*_bgStrokeAlpha = 1;
			_bgStrokeColor = 0x000000;
			_bgStrokeThickness = 1;*/
			drawBg();
			
			var arr:Array = [];
			_commentPacks = [];
			
			/*for (var i:int = 0; i < _data.comments.length; i++) 
			{
				var comment:Object = _data.comments[i];
				_commentPacks.push([comment]);
			}*/
			
			// split comments whose 'parent' attributes are '0' from others
			for (var i:int = 0; i < _data.comments.length; i++) 
			{
				var comment:Object = _data.comments[i];
				if (comment.parent == 0)
				{
					_commentPacks.push([comment]);
				}
				else
				{
					arr.push(comment);
				}
			}
			
			
			
			// loop through arr and categorize items in it into "_commentPacks.length" numbers
			var obj:Object;
			while (arr.length > 0) 
			{
				obj = arr.splice(0, 1)[0];
				
				for (var j:int = 0; j < _commentPacks.length; j++) 
				{
					var currCat:Array = _commentPacks[j];
					var foundResult:Boolean = false;
					for (var k:int = 0; k < currCat.length; k++) 
					{
						var currObj:Object = currCat[k];
						if (obj.parent == currObj.id)
						{
							// add the found obj into _commentPacks[j]
							_commentPacks[j].push(obj);
							foundResult = true;
							break;
						}
					}
					
					if (foundResult) break;
				}
			}
			
			initScroller();
			initList();
			if (_list.items.length < 1) initAlt();
			
			onResize();
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initScroller():void
		{
			//_scroller = new TouchScroll();
			_scroller = _base.touchScrollPool.borrowObject();
			_scroller.addEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
			//_scroller.addEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
			_scroller.orientation = Orientation.VERTICAL;
			_scroller.bitmapMode = ScrollConst.NORMAL;
			_scroller.easeType = "Strong.easeOut";
			_scroller.aniInterval = .5;
			_scroller.holdArea = 15;
			_scroller.isTouchScroll = true;
			_scroller.isMouseScroll = false;
			
			this.addChild(_scroller);
		}
		
		private function onScrollMove(e:*):void
		{
			_scroller._mask.smoothing = true;
		}
		
		private function initList():void
		{
			//_list = new List();
			_list = _base.listPool.borrowObject();
			//_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.table = false;
			_list.space = 0;
			_list.speed = 0;
			
			_scroller.maskContent = _list;
			
			for (var i:int = 0; i < _commentPacks.length; i++) 
			{
				var item:Item = new Item();
				item.base = _base;
				item.data = _commentPacks[i][0];
				item.subComments = _commentPacks[i].slice(1);
				item.configXml = new XML(_configXml.commentItem);
				
				//item.width = _width - (_margin * 2);
				
				_list.add(item);
			}
		}
		
		private function initAlt():void
		{
			_altTxt = new TextArea();
			_altTxt.autoSize = TextFieldAutoSize.LEFT;
			_altTxt.antiAliasType = AntiAliasType.ADVANCED;
			_altTxt.multiline = true;
			_altTxt.wordWrap = true;
			_altTxt.embedFonts = true;
			_altTxt.mouseEnabled = false;
			_altTxt.condenseWhite = true;
			
			//var str:String = _data.name;
			//str = str.replace("&hellip;", "... ");
			//str = str.replace("&rarr;", "");
			//str = str.replace("Continue reading", "<font color='#990000'>Continue reading</font>");
			
			_altTxt.htmlText = "<p align='center'><font face='" + _configXml.noComment.font.text() + "' size='" + _configXml.noComment.size.text() + "' color='" + _configXml.noComment.color.text() + "'>" + _altStr + "</font></p>";
			
			this.addChild(_altTxt);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_scroller)
			{
				_scroller.maskWidth = _width - (_margin * 2);
				_scroller.maskHeight = _height - (_margin * 2);
				
				for (var i:int = 0; i < _list.items.length; i++) 
				{
					var item:Item = _list.items[i].content as Item;
					item.width = _width - (_margin * 2);
					//item.height = _scroller.maskHeight;
				}
			}
			
			if (_altTxt && _width > 0 && _height > 0)
			{
				_altTxt.width = (_width - (_margin * 2) - 50);
				//_altTxt.scaleX = _altTxt.scaleY = _base.deviceInfo.dpiScaleMultiplier;
				_altTxt.x = _width / 2 - _altTxt.width / 2 ;
				_altTxt.y = _height / 2 - _altTxt.height / 2;
			}
			
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}