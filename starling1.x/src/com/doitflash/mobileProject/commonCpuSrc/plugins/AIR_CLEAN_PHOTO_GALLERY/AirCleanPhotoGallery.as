package com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY
{
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.setTimeout;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.Plugin;
	
	import com.doitflash.mobileProject.commonCpuSrc.events.AppEvent;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY.events.GalleryEvent;
	import org.kissmyas.utils.loanshark.LoanShark;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY.assets.Album;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/20/2012 12:06 PM
	 */
	public class AirCleanPhotoGallery extends Plugin 
	{
		private var _albumMc:TheAlbum;
		private var _bottMc:BottMenu;
		private var _albumOffset:Number = 0;
		
		public var albumPool:LoanShark;
		
		public function AirCleanPhotoGallery():void 
		{
			_margin = 0;
			_bgAlpha = 1;
			_bgColor = 0x000000;
			_bgStrokeAlpha = 0;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			drawBg();
		}
		
		override protected function stageRemoved(e:Event = null):void 
		{
			super.stageRemoved(e);
			
			// dispose xml objects
			System.disposeXML(_xml);
			if(_albumMc) System.disposeXML(_albumMc.xml);
			
			_albumMc.removeEventListener(GalleryEvent.MODE_CHANGE, onGalleryModeChange);
			this.removeChild(_albumMc);
			this.removeChild(_bottMc);
			_albumMc = null;
			_bottMc = null;
			
			albumPool.dispose();
		}
		
		override protected function stageAdded(e:Event = null):void 
		{
			super.stageAdded(e);
			
			// Create a pool of Albums
			albumPool = new LoanShark(Album, true, 10);
			
			_xml = new XML(unescape(_data.content)); // save the xml object
			
			initBottMenu();
			initTheGallery();
			
			onResize();
			
			setTimeout(dispatch, 50);
			function dispatch():void
			{
				dispatchEvent(new AppEvent(AppEvent.MODULE_READY));
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function initBottMenu():void
		{
			_bottMc = new BottMenu();
			_bottMc.base = _base;
			_bottMc.holder = this;
			
			this.addChild(_bottMc);
		}
		
		private function initTheGallery():void
		{
			_albumMc = new TheAlbum();
			_albumMc.addEventListener(GalleryEvent.MODE_CHANGE, onGalleryModeChange);
			_albumMc.addEventListener(GalleryEvent.SHOW_TOOLS, onShowTools);
			_albumMc.addEventListener(GalleryEvent.ADDRESS_CHANGE, onAddressChange);
			_albumMc.bgColor = _bgColor;
			_albumMc.base = _base;
			_albumMc.holder = this;
			_albumMc.xml = new XML(_xml.gallery);
			
			this.addChildAt(_albumMc, 1);
			
			_bottMc.updateAddress(_xml.gallery.@name);
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		private function onGalleryModeChange(e:GalleryEvent):void
		{
			switch (e.param.mode) 
			{
				case TheAlbum.ALBUM_MODE:
					
					_albumOffset = 0;
					
				break;
				case TheAlbum.IMAGE_MODE:
					
					_albumOffset = _bottMc.height;
					
				break;
			}
			
			onResize();
		}
		
		private function onShowTools(e:GalleryEvent):void
		{
			if (e.param.showTools) _bottMc.visible = true;
			else _bottMc.visible = false;
		}
		
		private function onAddressChange(e:GalleryEvent):void
		{
			_bottMc.updateAddress(e.param.address);
		}
		
		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_bottMc)
			{
				_bottMc.width = _width;
				_bottMc.height = 50;
				_bottMc.y = _height - _bottMc.height;
				
				_albumMc.width = _width;
				_albumMc.height = _height - (_bottMc.height) + _albumOffset;
			}
		}
		
		override protected function onNetStatus(e:AppEvent):void
		{
			
		}
		
		
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}