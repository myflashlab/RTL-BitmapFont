package com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY
{
	import com.doitflash.text.modules.MySprite;
	import com.greensock.layout.*;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import com.doitflash.mobileProject.commonCpuSrc.plugins.AIR_CLEAN_PHOTO_GALLERY.events.GalleryEvent;
	
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 6/20/2012 12:06 PM
	 */
	public class TheImage extends MySprite 
	{
		private var _dropZone:Sprite;
		private var _isToolsVisible:Boolean = true;
		
		public function TheImage():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			//_margin = 0;
			_bgAlpha = 0;
			_bgColor = 0x666666;
			//_bgStrokeAlpha = 1;
			//_bgStrokeColor = 0xFFFFFF;
			//_bgStrokeThickness = 1;
			drawBg();
			
			_dropZone = new Sprite();
			this.addChild(_dropZone);
		}
		
		public function stageRemoved(e:Event = null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			//this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			if (!_xml) return;
			
			_isToolsVisible = true;
			dispatchEvent(new GalleryEvent(GalleryEvent.SHOW_TOOLS, { showTools:_isToolsVisible }, true));
			
			_xml = null;
			_data = null;
		}
		
		private function stageAdded(e:Event = null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			this.addEventListener(MouseEvent.CLICK, onClick);
			
			dispatchEvent(new GalleryEvent(GalleryEvent.SHOW_TOOLS, {showTools:_isToolsVisible}, true));
			
			_width = stage.stageWidth;
			_height = stage.stageHeight;
			onResize();
			
			_base.showPreloader(true, "Loading photo...");
		}
		
// ----------------------------------------------------------------------------------------------------------------------- funcs
		
		private function loadImg($bytes:*):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			loader.loadBytes($bytes);
			
			function onLoaded(e:Event):void
			{
				e.currentTarget.removeEventListener(Event.COMPLETE, onLoaded);
				var bm:Bitmap = e.currentTarget.content as Bitmap;
				bm.smoothing = true;
				_dropZone.addChild(bm);
				
				onResize();
				
				_base.showPreloader(false);
			}
		}
		
// ----------------------------------------------------------------------------------------------------------------------- Helpful Funcs

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if(_dropZone.width > 0 && _dropZone.height > 0 && stage)
			{
				var area:AutoFitArea = new AutoFitArea(this, 0, 0, Math.max(stage.stageWidth, stage.stageHeight), Math.max(stage.stageWidth, stage.stageHeight));
				area.attach(_dropZone, {scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, hAlign:AlignMode.LEFT});
				
				_width = _dropZone.width;
				_height = _dropZone.height;
				
				//this.graphics.clear();
				//this.graphics.lineStyle(1, 0xFFFFFF);
				//this.graphics.drawRect( -0.5, -0.5, _width + 1, _height + 1);
				//this.graphics.endFill();
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			(_isToolsVisible) ? _isToolsVisible = false : _isToolsVisible = true;
			dispatchEvent(new GalleryEvent(GalleryEvent.SHOW_TOOLS, {showTools:_isToolsVisible}, true));
		}
	
// ----------------------------------------------------------------------------------------------------------------------- Methods

		public function update($xml:XML, $data:Object):void
		{
			// save the new info
			_xml = $xml;
			_data = $data;
			
			cleanUp(_dropZone);
			
			_base.showPreloader(true, "Loading photo...");
			
			// load the image:
			if(String(_xml.img.text()).indexOf("http://") != -1) _base.loadRemoteFile(new URLRequest(_xml.img.text()), loadImg);
			else _base.loadRemoteFile(new URLRequest(_base.proj + _xml.img.text()), loadImg);
			
			onResize();
		}

// ----------------------------------------------------------------------------------------------------------------------- Properties

		
		
	}
	
}