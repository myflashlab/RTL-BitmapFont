package com.doitflash.mobileProject.commonFcms.mainArea.content
{
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.text.modules.MyMovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import br.com.stimuli.loading.BulkLoader;
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/12/2011 11:03 AM
	 */
	public class Content extends MySprite
	{
		private var _body:Sprite; // All content will be droped into this layer
		private var _currPage:MyMovieClip;
		private var _currPageData:Object;
		
		public function Content():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			//_bgAlpha = 0.08;
			//_bgColor = 0x00FF00;
			//drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_body = new Sprite();
			this.addChild(_body);
			
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function onPageLoaded(e:Event = null):void
		{
			_base.showPreloader(false);
			_base.bulkLoader.removeEventListener(BulkLoader.COMPLETE, onPageLoaded);
			_base.bulkLoader.removeEventListener(BulkLoader.PROGRESS, _base.onProgress);
			
			_currPage = _base.bulkLoader.getMovieClip(_currPageData.xml.@name) as MyMovieClip;
			_currPage.base = _base;
			_currPage.serverPath = _serverPath;
			_body.addChild(_currPage);
			
			onResize();
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*=null):void 
		{
			super.onResize(e);
			
			if (_currPage)
			{
				_currPage.width = _width;
				_currPage.height = _height;
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function load($data:Object):void
		{
			_currPageData = $data;
			//C.log(_currPageData.value)
			//C.log(_currPageData.xml)
			
			cleanUp(_body);
			
			if (_base.bulkLoader.getMovieClip(_currPageData.xml.@name))
			{
				onPageLoaded();
			}
			else
			{
				_base.bulkLoader.addEventListener(BulkLoader.COMPLETE, onPageLoaded);
				_base.bulkLoader.addEventListener(BulkLoader.PROGRESS, _base.onProgress);
				
				_base.bulkLoader.add(new URLRequest(_currPageData.value), { id:_currPageData.xml.@name, type:BulkLoader.TYPE_MOVIECLIP } );
				
				// strat loading everything
				_base.bulkLoader.start(15);
				_base.showPreloader(true);
			}
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		

	}
	
}