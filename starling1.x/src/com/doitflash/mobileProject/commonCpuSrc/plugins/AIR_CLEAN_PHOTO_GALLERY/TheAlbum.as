package com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY
{
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.ScrollConst;
	import com.doitflash.events.ListEvent;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.text.modules.MySprite;
	import com.greensock.TweenMax;
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY.assets.Album;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY.events.GalleryEvent;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/20/2012 12:06 PM
	 */
	public class TheAlbum extends MySprite 
	{
		public static const ALBUM_MODE:String = "albumMode";
		public static const IMAGE_MODE:String = "imageMode";
		private var _currMode:String = TheAlbum.ALBUM_MODE;
		
		private var _currXml:XML; // current xml to show albums and images...
		
		private var _body:*;
		private var _list:*;
		private var _scroller:*;
		private var _itemWidth:Number;
		private var _itemHeight:Number;
		private var _rows:int;
		
		private var _cover:Shape;
		
		private var _vibe:*;
		
		private var _imgHolder:TheImage;
		
		private var _address:String;
		
		public function TheAlbum():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_cover = new Shape();
			_cover.visible = true;
			_cover.alpha = 1;
			this.addChild(_cover);
			
			_margin = 0;
			//_bgAlpha = 1;
			//_bgColor = 0x333333;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xFFFFFF;
			//_bgStrokeThickness = 1;
			drawBg();
		}
		
		private function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			//this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			if (_scroller)
			{
				_scroller.removeEventListener(ScrollEvent.MOUSE_DOWN, onScrollDown);
				_scroller.removeEventListener(ScrollEvent.MOUSE_UP, onScrollUp);
				_scroller.removeEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
				_scroller.removeEventListener(ScrollEvent.TOUCH_TWEEN_UPDATE, detectSwipe);
				_scroller.removeEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
				this.removeChild(_scroller);
				_base.touchScrollPool.returnObject(_scroller);
				
				_list.removeEventListener(ListEvent.RESIZE, onResize);
				for each (var item:* in _list.items) 
				{
					if (item.content is Album)
					{
						item.content.removeEventListener(MouseEvent.CLICK, onAlbumClick);
						_holder.albumPool.returnObject(item.content);
					}
				}
				_list.removeAll();
				_base.listPool.returnObject(_list);
				
				_body.clearEvents();
				_base.mySpritePool.returnObject(_body);
			}
			
			if (_vibe) _vibe = null;
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			var album:Album = _holder.albumPool.borrowObject();
			_itemWidth = album.width;
			_itemHeight = album.height;
			_holder.albumPool.returnObject(album);
			
			_currXml = _xml;
			_address = _currXml.@name;
			
			onResize();
		}
		
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initList():void
		{
			TweenMax.to(_cover, 1, { autoAlpha:0, delay:1 } );
			
			//_body = new MySprite();
			_body = _base.mySpritePool.borrowObject();
			_body.margin = 15;
			_body.bgAlpha = 0.01;
			_body.bgColor = 0xCCCCCC;
			_body.drawBg();
			
			_list = _base.listPool.borrowObject();
			_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.table = true;
			_list.space = 40;
			
			_rows = Math.floor(_height / (_itemHeight + _list.space));
			
			_list.numRowsOrColumns = _rows;
			_list.speed = 0;
			
			_body.addChild(_list);
		}
		
		private function initScroller():void
		{
			_scroller = _base.touchScrollPool.borrowObject();
			_scroller.addEventListener(ScrollEvent.MOUSE_DOWN, onScrollDown);
			_scroller.addEventListener(ScrollEvent.MOUSE_UP, onScrollUp);
			_scroller.addEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
			//_scroller.addEventListener(ScrollEvent.TOUCH_TWEEN_UPDATE, detectSwipe);
			_scroller.addEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
			_scroller.orientation = Orientation.HORIZONTAL;
			_scroller.bitmapMode = ScrollConst.NORMAL;
			_scroller.easeType = "Strong.easeOut";
			_scroller.aniInterval = .5;
			_scroller.holdArea = 15;
			_scroller.isTouchScroll = true;
			_scroller.isMouseScroll = false;
			_scroller.maskContent = _body;
			this.addChildAt(_scroller, 0);
		}
		
		private function onScrollDown(e:*):void
		{
			stage.frameRate = 8;
		}
		
		private function onScrollUp(e:*):void
		{
			stage.frameRate = _base.frameRate;
		}
		
		private function onScrollMove(e:*):void
		{
			_scroller._mask.smoothing = true;
		}
		
		private function detectSwipe(e:*):void
		{
			if (_currMode == TheAlbum.IMAGE_MODE)
			{
				if ((_scroller.maskWidth - (Math.sqrt(Math.pow(_scroller.maskContentHolder.x, 2)))) < _scroller.maskWidth / 2)
				{
					var newId:int;
					if (_scroller.maskContentHolder.x < 0)
					{
						trace("right to left")
						newId = _imgHolder.data.id + 1;
						
						// check if the newId is available
						if (_imgHolder.data.dirXml.item.length() - 1 >= newId)
						{
							_currXml = new XML(_imgHolder.data.dirXml.item[newId]);
							_address = _address.substring(0, _address.lastIndexOf("\\"));
							_address = _address.concat("\\" + _currXml.@name);
							initItems(_currXml, {dirXml:_imgHolder.data.dirXml, id:newId});
						}
					}
					else
					{
						trace("left to right")
						newId = _imgHolder.data.id - 1;
						
						// check if the newId is available
						if (newId >= 0)
						{
							_currXml = new XML(_imgHolder.data.dirXml.item[newId]);
							_address = _address.substring(0, _address.lastIndexOf("\\"));
							_address = _address.concat("\\" + _currXml.@name);
							initItems(_currXml, {dirXml:_imgHolder.data.dirXml, id:newId});
						}
					}
					
				}
				
				_scroller.removeEventListener(ScrollEvent.TOUCH_TWEEN_UPDATE, detectSwipe);
			}
		}
		
		private function onScrollDone(e:*):void
		{
			_scroller._mask.smoothing = false;
			//_scroller.addEventListener(ScrollEvent.TOUCH_TWEEN_UPDATE, detectSwipe);
		}
		
		private function initItems($xml:XML, $data:Object=null):void
		{
			var itemList:XMLList = $xml.item;
			if (itemList.length() > 0)
			{
				if (_currMode != TheAlbum.ALBUM_MODE)
				{
					_currMode = TheAlbum.ALBUM_MODE;
					dispatchEvent(new GalleryEvent(GalleryEvent.MODE_CHANGE, {mode:_currMode}));
				}
				
				for (var i:int = 0; i < itemList.length(); i++) 
				{
					var album:Album = _holder.albumPool.borrowObject();
					album.addEventListener(MouseEvent.CLICK, onAlbumClick, false, 0, true);
					album.base = _base;
					album.xml =  new XML($xml.item[i]);
					album.data = { dirXml:new XML($xml), id:i };
					_list.add(album);
				}
			}
			else
			{
				if (_currMode != TheAlbum.IMAGE_MODE)
				{
					_currMode = TheAlbum.IMAGE_MODE;
					dispatchEvent(new GalleryEvent(GalleryEvent.MODE_CHANGE, {mode:_currMode}));
				}
				
				if (!_imgHolder) 
				{
					_imgHolder = new TheImage();
					_imgHolder.base = _base;
				}
				
				if (!_imgHolder.stage) _list.add(_imgHolder);
				_address = _address.concat(" " + Number($data.id+1) + "/" + $data.dirXml.item.length());
				_imgHolder.update($xml, $data);
				dispatchEvent(new GalleryEvent(GalleryEvent.ADDRESS_CHANGE, {address:_address}));
			}
			
			switch (_currMode) 
			{
				case TheAlbum.ALBUM_MODE:
					
					_scroller.orientation = Orientation.HORIZONTAL;
					_scroller.xPerc = 0;
					_scroller.yPerc = 0;
					_body.margin = 15;
					
				break;
				case TheAlbum.IMAGE_MODE:
					
					_scroller.orientation = Orientation.AUTO;
					_scroller.xPerc = 50;
					_scroller.yPerc = 50;
					_body.margin = 0;
					
				break;
			}
		}
		
		private function onAlbumClick(e:MouseEvent):void
		{
			e.currentTarget["onOver"]();
			setTimeout(fade, 100, e.currentTarget);
			
			function fade($target:*):void
			{
				$target["onOut"](doSthWhenAlbumIsClicked);
				
			}
			
			if (_base.nativeExtensions.vibration.isSupported) 
			{ 
				if(!_vibe) _vibe = new _base.nativeExtensions["vibration"](); 
				_vibe.vibrate(25);
			}
			
			function doSthWhenAlbumIsClicked($xml:XML, $data:Object):void
			{
				// Engage the back btn
				dispatchEvent(new AppEvent(AppEvent.BACK_BUTTON_ENGAGED, true, true));
				_holder.navHistory.push( { id:"navigateThroughAlbums", func:goAlbumUpOneLevel, params:[new XML(_currXml)] } );
				
				_currXml = $xml;
				_address = _address.concat("\\" + _currXml.@name);
				dispatchEvent(new GalleryEvent(GalleryEvent.ADDRESS_CHANGE, {address:_address}));
				for each (var item:* in _list.items) 
				{
					if (item.content is Album)
					{
						item.content.removeEventListener(MouseEvent.CLICK, onAlbumClick);
						_holder.albumPool.returnObject(item.content);
					}
				}
				_list.removeAll();
				
				_cover.visible = true;
				_cover.alpha = 1;
				TweenMax.to(_cover, 1, { autoAlpha:0, delay:1 } );
				
				initItems(_currXml, $data);
			}
		}
		
		private function goAlbumUpOneLevel($xml:XML):void
		{
			_currXml = $xml;
			
			_address = _address.substring(0, _address.lastIndexOf("\\"));
			dispatchEvent(new GalleryEvent(GalleryEvent.ADDRESS_CHANGE, {address:_address}));
			
			for each (var item:* in _list.items) 
			{
				if (item.content is Album)
				{
					item.content.removeEventListener(MouseEvent.CLICK, onAlbumClick);
					_holder.albumPool.returnObject(item.content);
				}
				else
				{
					item.content.stageRemoved();
				}
			}
			_list.removeAll();
			
			_cover.visible = true;
			_cover.alpha = 1;
			TweenMax.to(_cover, 1, { autoAlpha:0, delay:1 } );
			
			initItems(_currXml);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_cover)
			{
				_cover.graphics.clear();
				_cover.graphics.beginFill(_bgColor);
				_cover.graphics.drawRect(0, 0, _width, _height);
				_cover.graphics.endFill();
			}
			
			if (_scroller)
			{
				_body.width = _list.width + _body.margin * 2;
				
				switch (_currMode) 
				{
					case TheAlbum.ALBUM_MODE:
						
						_body.height = _height - (_margin * 2);
						
					break;
					case TheAlbum.IMAGE_MODE:
						
						_body.height = _list.height + _body.margin * 2;
						
					break;
				}
				
				_scroller.y = _margin;
				_scroller.x = _margin;
				
				_scroller.maskWidth = _width - (_margin * 2);
				_scroller.maskHeight = _height - (_margin * 2);
				
				_list.x = _body.margin;
				_list.y = _body.height / 2 - _list.height / 2;
				
				if (_list.width < _scroller.maskWidth)
				{
					_body.width = _width - (_margin * 2);
					_list.x = _body.width / 2 - _list.width / 2;
				}
			}
			
			if (_width > 0 && _height > 0 && !_list)
			{
				initList();
				initScroller();
				initItems(_currXml);
			}
			
			if (_list && _currMode == TheAlbum.ALBUM_MODE)
			{
				if (_rows != Math.floor(_height / (_itemHeight + _list.space)))
				{
					_scroller.removeEventListener(ScrollEvent.MOUSE_DOWN, onScrollDown);
					_scroller.removeEventListener(ScrollEvent.MOUSE_UP, onScrollUp);
					_scroller.removeEventListener(ScrollEvent.MOUSE_MOVE, onScrollMove);
					_scroller.removeEventListener(ScrollEvent.TOUCH_TWEEN_UPDATE, detectSwipe);
					_scroller.removeEventListener(ScrollEvent.TOUCH_TWEEN_COMPLETE, onScrollDone);
					this.removeChild(_scroller);
					_base.touchScrollPool.returnObject(_scroller);
					
					_list.removeEventListener(ListEvent.RESIZE, onResize);
					for each (var item:* in _list.items) 
					{
						if (item.content is Album)
						{
							item.content.removeEventListener(MouseEvent.CLICK, onAlbumClick);
							_holder.albumPool.returnObject(item.content);
						}
					}
					_list.removeAll();
					_base.listPool.returnObject(_list);
					
					_body.clearEvents();
					_base.mySpritePool.returnObject(_body);
					
					initList();
					initScroller();
					initItems(_currXml);
					
					_cover.visible = true;
					_cover.alpha = 1;
				}
			}
			
			/*if (_imgHolder)
			{
				_imgHolder.width = _width;
				_imgHolder.height = _height;
			}*/
		}
		
		
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}