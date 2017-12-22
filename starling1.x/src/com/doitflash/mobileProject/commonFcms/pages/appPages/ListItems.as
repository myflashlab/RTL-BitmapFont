package com.doitflash.mobileProject.commonFcms.pages.appPages
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.Responder;
	import flash.net.URLVariables;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.utils.lists.List;
	import com.doitflash.events.ListEvent;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.events.AlertEvent;
	import pages.*;
	import com.doitflash.mobileProject.commonFcms.events.PageEvent;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 12/14/2011 10:23 AM
	 */
	public class ListItems extends MySprite 
	{
		private var _list:List;
		private var _scroller:*;
		
		private var _theTarget:Item;
		private var _theObject:Item;
		
		public function ListItems():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			
			_margin = 10;
			
			_bgAlpha = 1;
			_bgColor = 0xFFFFFF;
			_bgStrokeAlpha = 1;
			_bgStrokeColor = 0xCCCCCC;
			_bgStrokeThickness = 1;
			drawBg();
		}
		
		private function stageRemoved(e:Event=null):void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			this.removeChild(_scroller);
			_scroller = null;
		}
		
		private function stageAdded(e:Event=null):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, stageRemoved);
			
			if (!_list)
			{
				initList();
				update();
			}
			
			initScroller();
			
			onResize();
		}
		
//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Private Funcs			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		private function initList():void
		{
			_list = new List();
			//_list.addEventListener(ListEvent.RESIZE, onResize);
			_list.direction = Direction.LEFT_TO_RIGHT;
			_list.orientation = Orientation.VERTICAL;
			_list.space = 2;
			_list.speed = 0;
		}
		
		private function initScroller():void
		{
			_scroller = new _base.getScroller.getClass();
			_scroller.importProp = _base.getScroller.getDll.exportProp;
			_scroller.maskContent = _list;
			this.addChild(_scroller);
		}
		
		private function onItemMoveUp(e:PageEvent):void
		{
			_theTarget = e.currentTarget as Item;
			_theObject = _list.getItemByIndex(_theTarget.parent.parent["index"] - 1).content as Item;
			
			_list.mouseChildren = false;
			
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.swapItems", new Responder(onSwapResult, _base.onFault), [_theTarget.data.id, _theTarget.data.itemOrder, _theObject.data.id, _theObject.data.itemOrder], _base.serverTime);
		}
		
		private function onItemMoveDown(e:PageEvent):void
		{
			_theTarget = e.currentTarget as Item;
			_theObject = _list.getItemByIndex(_theTarget.parent.parent["index"] + 1).content as Item;
			
			_list.mouseChildren = false;
			
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.swapItems", new Responder(onSwapResult, _base.onFault), [_theTarget.data.id, _theTarget.data.itemOrder, _theObject.data.id, _theObject.data.itemOrder], _base.serverTime);
		}
		
		private function onItemDrop(e:PageEvent):void
		{
			_base.getAlert.getDll.clearEvents();
			_base.getAlert.getDll.w = 400;
			_base.getAlert.getDll.h = 250;
			_base.getAlert.getDll.title("Please confirm!", "Verdana", 0x333333, 16);
			_base.getAlert.setApproveSkin("yes");
			_base.getAlert.getDll.openAlert("Are you sure you want to delete this item?", "Verdana", "reject", "approve");
			setTimeout(_base.sizeRefresh, 20);
			
			_base.getAlert.data = e.currentTarget as Item;
			_base.getAlert.getDll.addEventListener(AlertEvent.APPROVE, onItemDropConfirmed);
		}
		
		private function onItemDropConfirmed(e:*):void
		{
			_base.getAlert.getDll.clearEvents();
			
			var theTarget:Item = _base.getAlert.data;
			
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.dropItems", new Responder(onDropResult, _base.onFault), [theTarget.data.id], _base.serverTime);
		}
		
		private function onItemEdit(e:PageEvent):void
		{
			var theTarget:Item = e.currentTarget as Item;
			
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.selectItem", new Responder(gotoGeneralEdit, _base.onFault), [theTarget.data.id], _base.serverTime);
		}
		
		private function onItemContentEdit(e:PageEvent):void
		{
			var theTarget:Item = e.currentTarget as Item;
			
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.selectItem", new Responder(gotoContentEdit, _base.onFault), [theTarget.data.id], _base.serverTime);
		}
		
		private function onSwapResult($result:String):void
		{
			_base.showPreloader(false);
			var vars:URLVariables = new URLVariables($result);
			
			switch (vars.backToFlash) 
			{
				case "true":
					
					// animate the swap
					
						// take a shot from the object
						var objectBmd:BitmapData = new BitmapData(_theObject.width, _theObject.height);
						objectBmd.draw(_theObject);
						
						var objectBm:Bitmap = new Bitmap(objectBmd, "auto", true);
						objectBm.y = _theObject.parent.parent.y + _scroller.y;
						objectBm.x = _scroller.x;
						this.addChild(objectBm);
						
						// take a shot from the target
						var targetBmd:BitmapData = new BitmapData(_theTarget.width, _theTarget.height);
						targetBmd.draw(_theTarget);
						
						var targetBm:Bitmap = new Bitmap(targetBmd, "auto", true);
						targetBm.y = _theTarget.parent.parent.y + _scroller.y;
						targetBm.x = _scroller.x;
						this.addChild(targetBm);
					
					// hide the real items
					_theObject.visible = false;
					_theTarget.visible = false;
					
					var swapTime:Number = 0.5;
					
					var swapTween:TweenMax = TweenMax.to(targetBm, swapTime, {y:_theObject.parent.parent.y + _scroller.y, onComplete:onSwapAnimationDone, onUpdate:onSwapping/*, ease:Expo.easeOut*/})
					TweenMax.to(objectBm, swapTime, { y:_theTarget.parent.parent.y + _scroller.y/*, ease:Expo.easeOut*/} );
					
					TweenMax.to(targetBm, swapTime/2, {dropShadowFilter:{color:0x000000, alpha:0.3, strength:0.5, blurX:8, blurY:8, angle:90, distance:0}});
					TweenMax.to(targetBm, swapTime/2, {dropShadowFilter:{color:0x000000, alpha:0, strength:0.5, blurX:8, blurY:8, angle:90, distance:0, remove:true}, delay:swapTime/2});
					
					
					
					// actually move the items now!
					_list.swapItems(_list.getItemIndex(_theTarget), _list.getItemIndex(_theObject));
					
					if(_list.getItemIndex(_theTarget) == 0)_theTarget.goUp = false;
					else _theTarget.goUp = true;
					
					if (_list.getItemIndex(_theTarget) == _list.items.length - 1) _theTarget.goDown = false;
					else _theTarget.goDown = true;
					
					_theTarget.data.itemOrder = _list.getItemIndex(_theTarget) + 1;
					_theTarget.update();
					
					if(_list.getItemIndex(_theObject) == 0)_theObject.goUp = false;
					else _theObject.goUp = true;
					
					if (_list.getItemIndex(_theObject) == _list.items.length - 1) _theObject.goDown = false;
					else _theObject.goDown = true;
					
					_theObject.data.itemOrder = _list.getItemIndex(_theObject) + 1;
					_theObject.update();
					
					//this.dispatchEvent(new PageEvent(PageEvent.ITEM_SWAP));
					
				break;
				default:
					
					_list.mouseChildren = true;
					_base.showAlert("<font color='#333333' size='13'>" + vars.msg + "</font>", "", 450, 250);
					setTimeout(_base.sizeRefresh, 20);
			}
			
			function onSwapping():void
			{
				var z:Number = 1;
				var multipier:Number = 0.05;
				
				if (swapTween.currentProgress < 0.5)
				{
					z = 1 + swapTween.currentProgress * multipier;
					targetBm.scaleX = targetBm.scaleY = z;
				}
				else
				{
					z = (z + multipier) - (swapTween.currentProgress * multipier);
					targetBm.scaleX = targetBm.scaleY = z;
				}
				
				
				//C.log(swapTween.currentProgress)
				targetBm.x = (_width - targetBm.width >> 1) - _scroller.x;
			}
			
			function onSwapAnimationDone():void
			{
				// show the real items
				_theObject.visible = true;
				_theTarget.visible = true;
				
				_list.mouseChildren = true;
				
				TweenMax.allTo([targetBm, objectBm], 0.25, { autoAlpha:0 }, 0, onSwapFadeDone);
			}
			
			function onSwapFadeDone():void
			{
				removeChild(targetBm);
				removeChild(objectBm);
				
				targetBm = null;
				objectBm = null;
				
				targetBmd.dispose();
				objectBmd.dispose();
			}
		}
		
		private function onDropResult($result:String):void
		{
			_base.showPreloader(false);
			var vars:URLVariables = new URLVariables($result);
			
			switch (vars.backToFlash) 
			{
				case "true":
					
					this.dispatchEvent(new PageEvent(PageEvent.ITEM_DROP));
					
				break;
				default:
					
					_base.showAlert("<font color='#333333' size='13'>" + vars.msg + "</font>", "", 450, 250);
					setTimeout(_base.sizeRefresh, 20);
			}
		}
		
		private function gotoGeneralEdit($result:Array):void
		{
			_base.showPreloader(false);
			this.dispatchEvent(new PageEvent(PageEvent.ITEM_EDIT, $result[0]));
		}
		
		private function gotoContentEdit($result:Array):void
		{
			_base.showPreloader(false);
			this.dispatchEvent(new PageEvent(PageEvent.ITEM_CONTENT_EDIT, $result[0]));
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Helpful Private Funcs	---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		override protected function onResize(e:*= null):void
		{
			super.onResize(e);
			
			if (_scroller)
			{
				_scroller.x = _margin;
				_scroller.y = _margin;
				_scroller.maskWidth = _width - (_margin * 2) - (_scroller.scrollBarWidth + _scroller.scrollSpace);
				_scroller.maskHeight = _height - (_margin * 2);
			}
			
			if (_list)
			{
				for each (var itemHolder:* in _list.items) 
				{
					var item:Item = itemHolder.content;
					item.width = _scroller.maskWidth - 2;
					item.height = 30;
				}
			}
			
		}
		
		private function onSelectItemsResult($result:Array):void
		{
			_base.showPreloader(false);
			for (var i:int = 0; i < $result.length; i++) 
			{
				var item:Item = new Item();
				item.addEventListener(PageEvent.ITEM_MOVE_UP, onItemMoveUp, false, 0, true);
				item.addEventListener(PageEvent.ITEM_MOVE_DOWN, onItemMoveDown, false, 0, true);
				item.addEventListener(PageEvent.ITEM_DROP, onItemDrop, false, 0, true);
				item.addEventListener(PageEvent.ITEM_EDIT, onItemEdit, false, 0, true);
				item.addEventListener(PageEvent.ITEM_CONTENT_EDIT, onItemContentEdit, false, 0, true);
				item.base = _base;
				item.id = $result[i].id;
				item.data = $result[i];
				
				if (i == 0) item.goUp = false;
				else item.goUp = true;
				
				if (i == $result.length - 1) item.goDown = false;
				else item.goDown = true;
				
				_list.add(item);
			}
			
			onResize();
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//	Methods					---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		public function update():void
		{
			_list.visible = false;
			_list.alpha = 0;
			TweenMax.to(_list, 0.6, { autoAlpha:1, delay:0.2 } );
			
			// remove all current items in the list
			_list.removeAll();
			
			_base.showPreloader(true);
			_base.gateway.call("pages.PageManage.getPages", new Responder(onSelectItemsResult, _base.onFault), _base.serverTime);
			onResize();
		}

//-----------------------------------------------------------------------------------------------------------------------------------------------
// 	Getter - Setter			---------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

		
		
	}
	
}