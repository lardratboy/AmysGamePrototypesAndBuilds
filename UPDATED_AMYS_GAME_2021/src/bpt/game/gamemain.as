// yes this code is super duper gross - it was originally AS2 scripting :/

package bpt.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.flash_proxy;
	import flash.utils.getTimer;
	
	import bpt.Helpers;
	import bpt.game.ActionGrid;
	import bpt.game.GameDynamicText;
	import bpt.game.GameSprite_Ref;
	import bpt.game.SFX_Ref;
	import bpt.game._global;
	import bpt.game.game_state;
	import bpt.game.group_ref;
	import bpt.game.meta_ref;
	import bpt.game.onEnterFrame_Ref;
	import bpt.game.piece_ref;
	import bpt.util.Allocator;
	
	import starling.core.starling_internal;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;

	// -------------------------------------------------------------------------
	
	public final class gamemain extends Sprite
	{
		private var CONTAINER:GameSprite_Ref;
		
		private var LAST_MOUSE_DOWN_FRAMES:int = 0;
		private var MOUSE_DOWN_FRAMES:int = 0;
		
		private var _MOUSEBUTTONDOWN_LAST_MSG_STATE:Boolean;
		private var _LAST_MOUSEBUTTONDOWN:Boolean;
		private var _MOUSEBUTTONDOWN:Boolean;
		
		// these positions are in 'global' coordinate space
		
		private var _XMOUSE:Number;
		private var _YMOUSE:Number;
		private var _XMOUSE_DOWN:Number;
		private var _YMOUSE_DOWN:Number;
		private var _XMOUSE_UP:Number;
		private var _YMOUSE_UP:Number;
		private var _XMOUSE_AS_OF_LAST_MOVE:Number;
		private var _YMOUSE_AS_OF_LAST_MOVE:Number;
		
		protected function OLD_30_FPS_TO_N_FPS( n:int ):int
		{
			if ( _global.purgatory_demo_mode && _global.purgatory_demo_mode_increase_speed ) return n/3+1;
			return n*3/2; // *2
		}
		
		public function gamemain()
		{
			//if (stage) kickstart();
			//else 
			addEventListener(Event.ADDED_TO_STAGE, kickstart);
		}
		
		private function kickstart( e:Event = null ):void
		{
			Core.starlingRoot.ShowContent( true );
			
			this.mouseEnabled = true;
			
//			if ( null != e ) removeEventListener(Event.ADDED_TO_STAGE, kickstart);
			
			addEventListener( Event.REMOVED_FROM_STAGE, MAIN_OnRemovedFromStage, false, 0, true );
			
			addEventListener( Event.ENTER_FRAME, MAIN_OnEnterFrame, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, MAIN_OnMouseMove, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, MAIN_OnMouseDown, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_UP, MAIN_OnMouseUp, false, 0, true );
	
//			BOOTSTRAP_GAME_SESSION();
		}

		// --------------------------------------------------------------------
		
		private static var zoom_manage_tracking_position_helper:Point = new Point();
		private static var zoom_manage_position_helper_point_a:Point = new Point();
		private static var zoom_manage_position_helper_point_b:Point = new Point();
		private static var zoom_manage_position_helper_point_c:Point = new Point();
		private static var zoom_manage_position_helper_point_d:Point = new Point();
		
		private function ZOOM_ManageZoomArea():void
		{
			if ( _global.bpt2014_tap_zoom_mode )
			{
				var xpt:Number, ypt:Number;
				var xst:Number, yst:Number;
				var coefficient:Number;
				
				var trackingItem:piece_ref = ((null != selected_item) ? selected_item : ((null != src_swap_item) ? src_swap_item : null) );
				
				if ( null != trackingItem )
				{
					coefficient = 0.125;
					
					xst = 200;
					yst = 200;
					
					/*
					private var _MOUSEBUTTONDOWN_LAST_MSG_STATE:Boolean;
					private var _LAST_MOUSEBUTTONDOWN:Boolean;
					private var _MOUSEBUTTONDOWN:Boolean;
					private var _XMOUSE:Number;
					private var _YMOUSE:Number;
					private var _XMOUSE_DOWN:Number;
					private var _YMOUSE_DOWN:Number;
					private var _XMOUSE_UP:Number;
					private var _YMOUSE_UP:Number;
					private var _XMOUSE_AS_OF_LAST_MOVE:Number;
					private var _YMOUSE_AS_OF_LAST_MOVE:Number;
					*/
					
					xpt = _global.purgatory_stage_cx/2 - board_positions_array[ trackingItem.row ][ trackingItem.col ].x;
					ypt = _global.purgatory_stage_cy/2 - board_positions_array[ trackingItem.row ][ trackingItem.col ].y;
					
					if ( null != action_mc )
					{
						// 'live' touch postion (in global)
						
						action_mc.SetMousePositionFromGlobalCoordinates( _XMOUSE_AS_OF_LAST_MOVE, _YMOUSE_AS_OF_LAST_MOVE );
						
					}
					
					if ( 60 <= MOUSE_DOWN_FRAMES )
					{
						// 'live' touch postion
						
						zoom_manage_position_helper_point_a.x = _XMOUSE_AS_OF_LAST_MOVE;
						zoom_manage_position_helper_point_a.y = _YMOUSE_AS_OF_LAST_MOVE;
						CONTAINER.globalToLocal( zoom_manage_position_helper_point_a );
						
						// down position
						
						zoom_manage_position_helper_point_b.x = _XMOUSE_DOWN;
						zoom_manage_position_helper_point_b.y = _YMOUSE_DOWN;
						CONTAINER.globalToLocal( zoom_manage_position_helper_point_b );
						
						// delta from the down position
						
						zoom_manage_tracking_position_helper.x = zoom_manage_position_helper_point_a.x - zoom_manage_position_helper_point_b.x;
						zoom_manage_tracking_position_helper.y = zoom_manage_position_helper_point_a.y - zoom_manage_position_helper_point_b.y;
						
						var dS:Number = zoom_manage_tracking_position_helper.x*zoom_manage_tracking_position_helper.x +
							zoom_manage_tracking_position_helper.y*zoom_manage_tracking_position_helper.y;
						
						var pS:Number = (Math.max(item_cx,item_cy) * 2.5);
						pS *= pS;
						
						//trace( zoom_manage_tracking_position_helper );
						
						// if outside the legal move area...
						
						if ( dS > pS )
						{
							if ( true )
							{
								// zoom backout
								
								coefficient = (moving_items_count) ? 0.0 : 0.125 * 0.5;
								
								xst = 100;
								yst = 100;
								
								xpt = _global.purgatory_stage_cx/2;
								ypt = _global.purgatory_stage_cy/2;
							}
							else
							{
								// drag around logic (don't like this much)
								
								coefficient = 1.0;
								xpt += zoom_manage_tracking_position_helper.x;
								ypt += zoom_manage_tracking_position_helper.y;
							}
						}
							
					}
					
				}
				else
				{
					coefficient = (moving_items_count) ? 0.0 : 0.125 * 0.5;
					
					xst = 100;
					yst = 100;
					
					xpt = _global.purgatory_stage_cx/2;
					ypt = _global.purgatory_stage_cy/2;
				}
				
				// ------------------------------------------------------------------------------
				
				CONTAINER._xscale += (xst - CONTAINER._xscale) * coefficient;
				CONTAINER._yscale += (yst - CONTAINER._yscale) * coefficient;
				
				// ------------------------------------------------------------------------------
				
				zoom_manage_position_helper_point_a.x = xpt;
				zoom_manage_position_helper_point_a.y = ypt;
				var viewPoint:Point = zoom_manage_position_helper_point_a;
				
				zoom_manage_position_helper_point_b.x = _global.purgatory_stage_cx/2;
				zoom_manage_position_helper_point_b.y = _global.purgatory_stage_cy/2;
				var viewCenter:Point = zoom_manage_position_helper_point_b;
				
				CONTAINER.localToGlobal( viewPoint );
				CONTAINER.localToGlobal( viewCenter );
				
				var dc:Point = zoom_manage_position_helper_point_c;
				dc.x = (viewPoint.x - viewCenter.x);
				dc.y = (viewPoint.y - viewCenter.y);
				
				zoom_manage_position_helper_point_d.x = (_global.purgatory_stage_cx/2 - xpt); 
				zoom_manage_position_helper_point_d.y = (_global.purgatory_stage_cy/2 - ypt); 
				var centerAdjustment:Point = zoom_manage_position_helper_point_d;
				CONTAINER.localToGlobal( centerAdjustment );
				
//				dc.x = (dc.x + viewCenter.x - (centerAdjustment.x - viewCenter.x));
//				dc.y = (dc.y + viewCenter.y - (centerAdjustment.y - viewCenter.y));
				
				// ------------------------------------------------------------------------------
				
				var positionCoefficient:Number = 1.0 * coefficient;
				CONTAINER._x += (dc.x - CONTAINER._x) * positionCoefficient;
				CONTAINER._y += (dc.y - CONTAINER._y) * positionCoefficient;
				
			}
			
		}
		
		// --------------------------------------------------------------------
		
		private function MAIN_OnEnterFrame( e:Event ):void
		{
			_LAST_MOUSEBUTTONDOWN = _MOUSEBUTTONDOWN;
			
			_MOUSEBUTTONDOWN = _MOUSEBUTTONDOWN_LAST_MSG_STATE;
			
			LAST_MOUSE_DOWN_FRAMES = MOUSE_DOWN_FRAMES;
			
			if ( _MOUSEBUTTONDOWN )
			{
				++MOUSE_DOWN_FRAMES;
			}
			else
			{
				MOUSE_DOWN_FRAMES = 0;
			}
			
			if ( _MOUSEBUTTONDOWN_LAST_MSG_STATE )
			{
				_XMOUSE = _XMOUSE_DOWN;
				_YMOUSE = _YMOUSE_DOWN;
			}
			else
			{
				_XMOUSE = _XMOUSE_UP;
				_YMOUSE = _YMOUSE_UP;
			}
			
			// ================================================================
			
			// FUTURE.FUTURE. this almost zooms in correctly to allow playing on huge boards...
			
			/*
			if ( _global.bpt2014_tap_zoom_mode )
			{
				var xpt:Number, ypt:Number;
				var xst:Number, yst:Number;
				var coefficient:Number;

				if ( _MOUSEBUTTONDOWN ) // _MOUSEBUTTONDOWN  )
				{
					coefficient = 0.125;
					
					xst = 200;
					yst = 200;

					xpt = _XMOUSE_DOWN;
					ypt = _YMOUSE_DOWN;
					
				}
				else
				{
					coefficient = 0.125;
					
					xst = 100;
					yst = 100;
					
					xpt = _global.purgatory_stage_cx/2;
					ypt = _global.purgatory_stage_cy/2;
				}
				
				// ------------------------------------------------------------------------------
				
				CONTAINER._xscale += (xst - CONTAINER._xscale) * coefficient;
				CONTAINER._yscale += (yst - CONTAINER._yscale) * coefficient;
				
				// ------------------------------------------------------------------------------
				
				var cc:Point = new Point( xpt, ypt );
				cc = CONTAINER.localToGlobal( cc );
				var dc:Point = new Point( -((cc.x - xpt)), -((cc.y - ypt)) );
				dc = CONTAINER.localToGlobal( dc );
			
				// ------------------------------------------------------------------------------
				
				if ( false ) {
					
					var positionCoefficient:Number = 1.0 * coefficient;
					CONTAINER._x += (dc.x - CONTAINER._x) * positionCoefficient;
					CONTAINER._y += (dc.y - CONTAINER._y) * positionCoefficient;
					
				} else {
					
					CONTAINER._x = dc.x; // (dc.x - CONTAINER._x) * coefficient;
					CONTAINER._y = dc.y; // (dc.y - CONTAINER._y) * coefficient;
					
				}
				
			} */
			
			// ================================================================
			
		}
		
		private var mousePostionConversionHelper:Point = new Point();
		
		private function ConvertMouseToGlobalCoordinates():void
		{
			mousePostionConversionHelper.x = stage.mouseX;
			mousePostionConversionHelper.y = stage.mouseY;

			/*
			if (_global.bpt2014_tap_zoom_mode)
			{
				stage.localToGlobal( mousePostionConversionHelper );
			}
			*/
			
		}

		private function MAIN_OnMouseMove( e:Event ):void
		{
			if ( _MOUSEBUTTONDOWN_LAST_MSG_STATE )
			{
				e.stopPropagation();
			}
			
			ConvertMouseToGlobalCoordinates();
			
			_XMOUSE_AS_OF_LAST_MOVE = mousePostionConversionHelper.x;
			_YMOUSE_AS_OF_LAST_MOVE = mousePostionConversionHelper.y;
		}
		
		private function MAIN_OnMouseDown( e:Event ):void
		{
			e.stopPropagation();
			
			ConvertMouseToGlobalCoordinates();
			
			_XMOUSE_DOWN = mousePostionConversionHelper.x;
			_YMOUSE_DOWN = mousePostionConversionHelper.y;
			
			_MOUSEBUTTONDOWN_LAST_MSG_STATE = true;
		}
		
		private function MAIN_OnMouseUp( e:Event ):void
		{
			if ( _MOUSEBUTTONDOWN_LAST_MSG_STATE )
			{
				e.stopPropagation();
			}
			
			ConvertMouseToGlobalCoordinates();
			
			_XMOUSE_UP = mousePostionConversionHelper.x;
			_YMOUSE_UP = mousePostionConversionHelper.y;
			
			_MOUSEBUTTONDOWN_LAST_MSG_STATE = false;
		}
		
		private function MAIN_OnRemovedFromStage( e:Event ):void
		{
			Core.starlingRoot.ShowContent( false );
			//this.ShutdownDynamicElements();
			stage.removeEventListener( MouseEvent.MOUSE_UP, MAIN_OnMouseUp );
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, MAIN_OnMouseDown );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, MAIN_OnMouseMove );
			removeEventListener( Event.ENTER_FRAME, MAIN_OnEnterFrame );
		}
		
		// --------------------------------------------------------------------
		
		private var game_in_progress_:Boolean = false;
		public function get game_in_progress():Boolean { return game_in_progress_; }
		public function set game_in_progress( value:Boolean ):void { game_in_progress_ = value; }
		
		// --------------------------------------------------------------------
		
		private var dynamic_moves_display:DynamicTextHolder/*GameDynamicText*/;
		private var dynamic_score_display:DynamicTextHolder/*GameDynamicText*/;
		private var display_score:int;
			
		// --------------------------------------------------------------------
		
		private var next_active_group_id:int = 1;
		private var active_groups_head:group_ref = null; // active_groups_array:Vector.<group_ref>; / / active_groups_array_t

		private var item_cx:int;
		private var item_cy:int;

		private var board_rows:int;
		private var board_row_first:int;
		private var board_row_last:int;

		private var board_cols:int;
		private var board_col_first:int;
		private var board_col_last:int;
		
		private var board_array:Vector.< Vector.<piece_ref> >; // board_rows_t;
		private var meta_board:Vector.< Vector.<meta_ref> >; // meta_rows_t;
		
		private var board_positions_array:Vector.< Vector.< Point > >; // board_positions_t;
		private var count_array:Vector.<int>;

		private var selected_item:piece_ref;
		private var src_swap_item:piece_ref;
		private var dst_swap_item:piece_ref;

		private var dst_row_item:int;
		private var dst_col_item:int;

		private var src_row_item:int;
		private var src_col_item:int;

		private var moving_items_count:int;
		private var bCheckForMatch:Boolean;

		private var meta_items_count:int;
		private var animating_item_count:int;
		private var dropping_star_count:int;

		private var bCheckForEmptyColumns:Boolean;
		private var bPendingCollectMetaItems:Boolean;
		private var bPendingPackRequest:Boolean;

		private var bCheckForNoMoves:Boolean;
		private var nNoMovesCountDown:int;
		private var bFinalNoMoreMoves:Boolean;

		private var bBoardChanged:Boolean;

		private var nFramesSinceLastMove:int;
		private var nShowHintsAfterNFrames:int;

		private var bSwapCursorActive:Boolean;

		private var nRemovalsInARow:int;

		private var bFirstRemoval:Boolean;
		
		private var bpt2021_PendingOCDMode:Boolean;

		private var nNextStarRemovedID:int;
		private var nNextStarRemovedIndicatorXPos:int;
		private var nNextStarRemovedIndicatorYPos:int;
		private var nNextStarRemovedIndicatorXDelta:int;

		private var hint_item_a:piece_ref ;
		private var hint_item_b:piece_ref ;

		private var nRowMovesSearch:int;
		private var nColMovesSearch:int;
		private var bFoundMoveAtSearchLocation:Boolean;
		private var bMovesSearchDone:Boolean;
		
		private var bPendingRemovalsModeActive:Boolean;
		private var nPendingRemovalAnimationSpeed:Number;		

		private var sfx_meta_remove:SFX_Ref;
		private var sfx_pack_noise:SFX_Ref;
		private var sfx_remove_column:SFX_Ref;
		private var sfx_remove_noise:SFX_Ref;
		private var sfx_select_item:SFX_Ref;
		private var sfx_swap_noise:SFX_Ref;
		private var sfx_unswap_noise:SFX_Ref;
		private var sfx_no_moves:SFX_Ref;
		private var sfx_board_cleared:SFX_Ref;
		private var sfx_lucky_spin:SFX_Ref;
		private var sfx_slot_stop:SFX_Ref;
		private var sfx_super_jackpot:SFX_Ref;
		private var sfx_jackpot:SFX_Ref;
		private var sfx_winner:SFX_Ref;
		private var sfx_board_over:SFX_Ref;
		private var sfx_bonus_mode:SFX_Ref;
		
		private var playfield_mc:GameSprite_Ref;
		private var collected_stars_mc:GameSprite_Ref;
		private var mainboard_mc:GameSprite_Ref;
		private var metaboard_mc:GameSprite_Ref;

		private var hints_mc_front:GameSprite_Ref;
		private var hint_a_mc_front:game_asset_based_visual;//GameSprite_Ref;
		private var hint_b_mc_front:game_asset_based_visual;//GameSprite_Ref;

		private var hints_mc_back:GameSprite_Ref;
		private var hint_a_mc_back:game_asset_based_visual;//GameSprite_Ref;
		private var hint_b_mc_back:game_asset_based_visual;//GameSprite_Ref;
		
		private var active_boundaries_indicator_mc:game_asset_based_visual;
		private var selection_mc:GameSprite_Ref;
		private var action_mc:ActionGrid; // MovieClip_Ref;
		private var particles_mc:GameSprite_Ref;
		private var messages_mc:GameSprite_Ref;
		
		private var hud_mc:Sprite;//GameSprite_Ref;
		
		private var nopickcandidateshelpercache:Vector.<Boolean>;
		private var bpt2021_active_pieces_histogram:Vector.<int>;

		// not sure these are correct any more
		
		private var rising_point_duration:int = 35;
		private var rising_point_release_duration:int = 15;
		private static var combo_text_color:uint = 0xfff4dcae; // static so the bonus text cache function can be called during the 'loading'
		private var combo_rising_point_duration:int = 35;
		private var combo_rising_point_release_duration:int = 15;
		
		// ---------------------------------------------------------
		
		private function assert( b:Boolean ):void
		{
			if ( !b )
			{
				if ( true ) // Capabilities.isDebugger() )
				{
					var t:Error = new Error();
					
					trace( "assert failed " + t.getStackTrace() );
				}
			}
		}
		
		// ---------------------------------------------------------

		private function HELPER_MakeDyanmicID( s:String, i:int ):String
		{
			return s + i;
		}

		// ---------------------------------------------------------

		private function SetBoardAsChanged():void
		{
			bBoardChanged = true;
			nFramesSinceLastMove = 0;
		}

		private function START_SFX( sfx:SFX_Ref ):void
		{
			if ( !_global.purgatory_demo_mode )
			{
				sfx.Start();
			}
		}

		// ---------------------------------------------------------

		private function EaseToOnEnterFrameClosure( xPos:int, yPos:int, fCoefficient:Number, props:Array = null, durationCoeff:Number = 1.0 ):onEnterFrame_Ref
		{
			++moving_items_count;
			
			var nFrames:int = OLD_30_FPS_TO_N_FPS(10*durationCoeff);
			var t:Number = 0;
			var td:Number = 1.0/(nFrames - 2);
			var bBeenHere:Boolean = false;
			var ix:int, iy:int;

			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();

			closure.code = function():void {
				
				if ( !bBeenHere )
				{
					bBeenHere = true;
					ix = closure.mc._x;
					iy = closure.mc._y;			
				}
				
				var useT:Number = Math.sin( (Math.PI/2.0) * t );
				t += td;
				
				if ( null != props ) for each ( var o:Object in props ) {
					
					closure.mc[ o.property ] += ((o.start + (useT * (o.end - o.start))) - closure.mc[ o.property ]) * o.blend;
					
				}
			
//trace( closure.mc._name + " moving from " + closure.mc._x + ", " + closure.mc._y + " to " + xPos + ", " + yPos + " has " + nFrames + " more to go" );				

				closure.mc._x = ix + (useT * (xPos - ix));
				closure.mc._y = iy + (useT * (yPos - iy));
			
				if ( 0 >= --nFrames )
				{
					if ( null != props ) for each ( var o:Object in props ) {
						
						closure.mc[ o.property ] = o.end;
						
					}
					
					closure.mc._x = xPos;
					closure.mc._y = yPos;
				
					--moving_items_count;
			
//trace( closure.mc._name + " moved from " + ix + ", " + iy + " to " + xPos + ", " + yPos );				

					closure.mc.onEnterFrame = null; // onEnterFrame_Ref(); // unlink the frame handler
				}
			};
			
			return closure;
		}

		// ---------------------------------------------------------
		
		private function DispatchRisingObject(
			o:DisplayObject,
			adoptionName:String,
			x:int,
			y:int,
			dy:int, // = 1,
			color:uint, // = 0xFFFFFF,
			nFrames:int, // = 45,
			nReleaseFrame:int, // = 35,
			fadeCoefficient:Number, // = 0.85,
			scaleCoefficient:Number, // = 0.125
			affectedByNumbersOfRemovals:Boolean
		):GameSprite_Ref
		{
			var nextHighestDepthForMessage:int = messages_mc.getNextHighestDepth();
			
			var display:GameSprite_Ref = messages_mc.createEmptyMovieClip( "", nextHighestDepthForMessage );
			
			display._name = "rising_text_" + nextHighestDepthForMessage; // can flash have two movieclips with the same name active?
			
//trace( display._name + " @ depth " + nextHighestDepthForMessage );
			
			if ( null == adoptionName )
			{
				display.addChild( o );
			}
			else
			{
				display.AdoptAsResourceAttachment( o, adoptionName );
			}
			
			display._x = x;
			display._y = y;
			display._alpha = 100;
			
			++animating_item_count;
			
			//var dy:int = 1;
			
			var scale:Number = 100;
			
			if ( affectedByNumbersOfRemovals )
			{
				scale = Math.max( 100, Math.min( 500, (100 + (5 * (nRemovalsInARow + 1))) * 2 )); // this is probably not the best place for this
			}
			
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			if ( nReleaseFrame > nFrames )
			{
				nReleaseFrame = nFrames;
			}
			
// trace( adoptionName + " ******************************************************************** BORN" );
				
			closure.code = function():void {
				
				closure.mc._xscale += (scale - closure.mc._xscale) * scaleCoefficient; // 0.125;
				closure.mc._yscale = closure.mc._xscale;
				closure.mc._y -= dy;
				
				//closure.mc._alpha *= fadeCoefficient;
				closure.mc._alpha += (0.0 - closure.mc._alpha) * fadeCoefficient;
				
				if ( nReleaseFrame == nFrames )
				{
					--animating_item_count;
				}
					
//trace(
//	closure.mc._name + ", nframes:" + nFrames + " ->" + 
//	adoptionName + " alpha " + display._alpha + " scale " + display._xscale + " live" + " @ " + display._x + "," + display._y );

				if ( 0 >= --nFrames )
				{
					
//trace(
//	closure.mc._name + ", nframes:" + nFrames + " -> " + 
//	adoptionName + " alpha " + display._alpha + " scale " + display._xscale + " DEAD" + " @ " + display._x + "," + display._y + "!!!!!!!!!!!!!" );


					closure.mc.removeMovieClip();
				}
			};
			
			display.onEnterFrame = closure;
			
//			if ( 1 < display.parent.numChildren )
//			{
//				trace("numChildren (upto) " + display.parent.numChildren );
//			}
			
			return display;
		}
		
		private function DispatchRisingMessage(
			text:String,
			x:int,
			y:int,
			dy:int, // = 1,
			color:uint, // = 0xFFFFFFFF,
			nFrames:int, // = 45,
			nReleaseFrame:int, // = 35,
			fadeCoefficient:Number, // = 0.85,
			scaleCoefficient:Number, // = 0.125
			affectedByNumbersOfRemovals:Boolean
		):GameSprite_Ref
		{
			return DispatchRisingObject(
				assets.starling_GetReusableTextObject( text, color ),
				assets.GetStaticTextID( text, color ),
				x,
				y,
				dy,
				color,
				OLD_30_FPS_TO_N_FPS(nFrames),
				OLD_30_FPS_TO_N_FPS(nReleaseFrame),
				fadeCoefficient,
				scaleCoefficient,
				affectedByNumbersOfRemovals
			);
		}
		
		// ---------------------------------------------------------
		
		private static function GetComboMultiplierColor( multiplier:int ):uint
		{
			return combo_text_color;
				// (0xF00000 + ((int)(Math.min( multiplier, 15 )) << 16)) |	(0x00F000 + ((int)(Math.min( multiplier, 15 )) << 8)) ;
		}
		
		private function DispatchRisingPoints( points:int, x:int, y:int ):void
		{
			board_state.score += points;
			
			if ( _global.bDisableRisingTextEffects ) return;
			
			DispatchRisingMessage( "+" + points, x, y, 1, 0xFFFFFFFF, rising_point_duration, rising_point_release_duration, 0.125, 0.125, true );
		}
		
		private function DispatchComboMessage( multiplier:int, group:group_ref ):void
		{
			if ( _global.bDisableRisingTextEffects ) return;
			
			var x:int = 0;// _global.purgatory_stage_cx / 2;
			var y:int = 0;
			
			var groupCentroid = FindGroupCentroid( group );
			
			// does this point need to be transformed???
			
			mainboard_mc.localToGlobal( groupCentroid );
			messages_mc.globalToLocal( groupCentroid ); // ??????????
			
			x = groupCentroid.x;
			y = groupCentroid.y;
			
			var yBonusMovementDelta:int = 0;
			
			var combo:GameSprite_Ref = DispatchRisingMessage(
				"combo",
				x,
				y, // + _global.purgatory_piece_cy / 2,
				yBonusMovementDelta,
				combo_text_color,
				combo_rising_point_duration, // was /*OLD_30_FPS_TO_N_FPS*/(35),
				combo_rising_point_release_duration,
				0.125,
				0.25,
				true
			);
				
			DispatchRisingMessage(
				multiplier.toString() + "x",
				combo._x,
				combo._y + combo._height,
				yBonusMovementDelta,
				GetComboMultiplierColor( multiplier ), // hmm
				combo_rising_point_duration, ///*OLD_30_FPS_TO_N_FPS*/(60), 
				combo_rising_point_release_duration, ///*OLD_30_FPS_TO_N_FPS*/(45),
				0.125,
				0.125,
				true
			);
		}
		
		static public function RegisterCommonPopupTextMessages():void
		{
			assets.GenerateStaticTextBitmap( "combo", combo_text_color );
			
			var i:int;
			
			for ( i = 2; i <= 10; ++i )
			{
				assets.GenerateStaticTextBitmap( i.toString() + "x", GetComboMultiplierColor( i ) );
			}
			
			for ( i = 1; i <= 10; ++i )
			{
				assets.GenerateStaticTextBitmap( "+" + (10 * i), GetComboMultiplierColor( i ) );
				assets.GenerateStaticTextBitmap( "+" + (100 * i), GetComboMultiplierColor( i ) );
			}
		}

		// ---------------------------------------------------------
		
		private function RemoveElementClosure_ORIGINAL( nFrames:int, angleDelta:Number, removalCounter:int, posTarget:Point = null, nFinalDelay:int = 0, pointValue:int = 0, bTriggerRemoveSound:Boolean = false ):onEnterFrame_Ref
		{
			++moving_items_count;
			
			var fScale:Number = 120.0;
			var fScaleDelta:Number = 1.05;
			var removalScaleIncrease:Number = (1.0 + ((removalCounter - 1) / 3.0));
			
			var markStopHoldingMovingCountAfterNFrames:int = nFrames / 3;
			var releasedMovingCountHold:Boolean = false;
			
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			// another idea -
			// all the pieces involved in a match could collapse towards the src & dst swap positions
			// basically the 'value' of the match could be calculated during this animation
			// and the size of the resulting multiplier could also be shown here
			
			var bFallingTest:Boolean = true;
			var fallingDeltaDelta:Number = 1.5;
			var fallingDelta:Number = -(fallingDeltaDelta*4)*removalScaleIncrease;
			var fallingRemoveScale:Number = fScale * Math.min( 4.0, removalScaleIncrease );
			
			if ( false && bFallingTest )
			{
				releasedMovingCountHold = true;
				--moving_items_count;
			}
			
			var bFirstFrame:Boolean = true;
			
			closure.code = function():void {
				
				if ( bFallingTest )
				{
					if ( bFirstFrame )
					{
						if ( 0 != pointValue )
						{
							DispatchRisingPoints( pointValue, closure.mc._x, closure.mc._y );
						}
						
						bFirstFrame = false;
						closure.mc.GetDisplayObject().removeFromParent(false);
						particles_mc.addChild(closure.mc.GetDisplayObject());
					}

					if ( fallingRemoveScale != closure.mc._xscale )
					{
						var fallingScaleDetla:Number = (fallingRemoveScale - closure.mc._xscale) * 0.125
							
						closure.mc._xscale += fallingScaleDetla;
						closure.mc._yscale += fallingScaleDetla;
					}
					
					closure.mc._y += fallingDelta;
					fallingDelta += fallingDeltaDelta;
					fallingDeltaDelta *= 1.01;					
					
				}
				else
				{
					closure.mc._rotation += angleDelta;
					closure.mc._xscale = Math.min( 200.0, fScale * removalScaleIncrease );
					closure.mc._yscale = Math.min( 200.0, fScale * removalScaleIncrease );
				}
				
				fScale *= fScaleDelta;
				fScaleDelta *= 0.98;
				
				if ( (!releasedMovingCountHold) && (nFrames < markStopHoldingMovingCountAfterNFrames) )
				{
					releasedMovingCountHold = true;
					
					--moving_items_count;
				}
				
				if ( 0 >= --nFrames ) {
					
					if ( !releasedMovingCountHold )
					{
						releasedMovingCountHold = true;
						--moving_items_count;
					}
					
					closure.mc.removeMovieClip();
				}
				
			};
			
			return closure;
		}
		
		// ---------------------------------------------------------

		private function DelayedThenClosure( nDelay:int, then:onEnterFrame_Ref ):onEnterFrame_Ref
		{
			if ( 0 >= nDelay ) return then;
			
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
				
				if ( 0 <= --nDelay ) return;
				
				closure.mc.onEnterFrame = then;
			};
			
			return closure;
		}
		
		
		private function AcceleratedFallClosure( nFrames:int, yDelta:Number, yDeltaDelta:Number ):onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			var movementCoefficient:Number = (_global.purgatory_going_down) ? 1.0 : -1.0;
			var deltaDeltaCoefficient:Number = (_global.purgatory_going_down) ? 1.1 : 1.05;
			
			closure.code = function():void {
				
				closure.mc._y += (yDelta * movementCoefficient);
				yDelta += yDeltaDelta;
				yDeltaDelta *= deltaDeltaCoefficient; // hmm
					
				if ( 0 >= --nFrames ) {
						
					closure.mc.removeMovieClip();
					
				}
			};
			
			return closure;
		}
		
		private function RemoveElementClosure_ONCEUPONATIME(
			nFrames:int, angleDelta:Number, removalCounter:int, posTarget:Point = null,
			nFinalDelay:int = 0, pointValue:int = 0, bTriggerRemoveSound:Boolean = false ):onEnterFrame_Ref
		{
			++moving_items_count;
			++animating_item_count;
			
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			var scaleDelta:Number = 12.5;
			scaleDelta += (scaleDelta * 0.25) * Math.min( removalCounter, 4 );
			
			var releasedMovingCountHold:Boolean = false;
			var smoothCoefficient:Number = 0.66;
			var base_scale:Number = 0;
			var targetScale:Number;
			var nReleaseHold:int = 1+nFrames/2;
			var alphaTarget:Number = 100.0 / nFinalDelay;
			
			closure.code = function():void {
				
				if ( 0 == base_scale )
				{
					closure.mc.GetDisplayObject().removeFromParent(false);
					particles_mc.addChild(closure.mc.GetDisplayObject());
					base_scale = closure.mc._xscale;
				}
				
				targetScale = base_scale + scaleDelta * Math.sin( getTimer() * 0.0125 );
				
				if ( releasedMovingCountHold && (null != posTarget) )
				{
					smoothCoefficient = 0.125;
					closure.mc._x += (posTarget.x - closure.mc._x) * smoothCoefficient;
					closure.mc._y += (posTarget.y - closure.mc._y) * smoothCoefficient;
					targetScale = base_scale + scaleDelta * 2;
					//closure.mc._alpha += (alphaTarget - closure.mc._alpha) * smoothCoefficient * 3.0; // looks better IMHO without this
				}
				
				closure.mc._xscale += (targetScale - closure.mc._xscale) * smoothCoefficient;
				closure.mc._yscale = closure.mc._xscale;
				
				if ( 0 >= --nFrames ) {
					
					if ( null != posTarget )
					{
						closure.mc._xscale = targetScale;
						closure.mc._yscale = targetScale;
						closure.mc._x = posTarget.x;
						closure.mc._y = posTarget.y;
					}
					
					--animating_item_count;
					
					if ( !releasedMovingCountHold )
					{
						releasedMovingCountHold = true;
						--moving_items_count;
					}
					
					if ( bTriggerRemoveSound )
					{
						START_SFX( sfx_remove_noise );
					}
					
					if ( 0 != pointValue )
					{
						DispatchRisingPoints( pointValue, closure.mc._x, closure.mc._y );
					}
					
					closure.mc._alpha = alphaTarget;
					
					closure.mc.onEnterFrame = DelayedThenClosure(
						nFinalDelay, AcceleratedFallClosure( OLD_30_FPS_TO_N_FPS(45), -10, +2.5 ) );
					
					return;
				}
				
				if ( !releasedMovingCountHold )
				{
					if ( nReleaseHold >= nFrames )
					{
						releasedMovingCountHold = true;
						--moving_items_count;
					}
				}
				
			}
			
			return closure
		}
		
		// ---------------------------------------------------------
		
//		private var RemoveElementClosure:Function = RemoveElementClosure_ORIGINAL;		
		private var RemoveElementClosure:Function = RemoveElementClosure_ONCEUPONATIME;		
		
		// ---------------------------------------------------------

		private function CollectMetaItemClosure( delta:Number, nFrames:int, yDelta:Number, yDeltaDelta:Number ):onEnterFrame_Ref
		{
			++dropping_star_count;
			++animating_item_count;
			
			var movementCoefficient:Number = (_global.purgatory_going_down) ? 1.0 : -1.0;
			
			var nDrawAttentionFrames:int = Math.max( 1, nFrames/2 ); // was slower at 15;
			
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			var releaseHoldOnStarCountAfterNFrames:int = Math.max( 1, nFrames * 3 / 4 );
			var haveReleaseStarHold:Boolean = false;
			
			// if this is the last meta item the animation hold should
			// probably stay until the very end...
			
			delta /= 100.0;
			
			var collected_indicator_cc_mc:game_asset_based_visual = null;

			closure.code = function():void {
				
				if ( null == collected_indicator_cc_mc )
				{
					var collectedStarName:String = HELPER_MakeDyanmicID ("precollected_", nNextStarRemovedID++ );
					
					if ( null != collected_stars_mc )
					{
						var cc_do:DisplayObject = collected_stars_mc.getChildByName( collectedStarName );
						
						collected_indicator_cc_mc = cc_do as game_asset_based_visual;
						
						collected_indicator_cc_mc.onEnterFrame = MakeThrobClosure(20);
					}
				}
				
				if ( 0 < nDrawAttentionFrames ) {
				
					closure.mc._rotation += delta *= 1.125;
				
					var fScale:Number = 150 + (Math.sin( (Math.PI * 2.0) * nDrawAttentionFrames / OLD_30_FPS_TO_N_FPS(15) ) * 25 * 2);
				
					closure.mc._xscale = fScale;
					closure.mc._yscale = fScale;
				
					if ( 0 == --nDrawAttentionFrames ) {
						
						DispatchRisingPoints( GetMetaPointsValue(), closure.mc._x, closure.mc._y );
					
						--animating_item_count;
						
						// BPT.2014
						closure.mc.GetDisplayObject().removeFromParent(false);
						particles_mc.addChild(closure.mc.GetDisplayObject());
						
						delta /= -50.0;
					
					}
				
				} else {
					
					closure.mc._rotation = 0; //+= delta *= 1.01;
					closure.mc._xscale += (250.0 - closure.mc._xscale) * 0.8;
					closure.mc._yscale += (250.0 - closure.mc._yscale) * 0.8;
					
					/*
					closure.mc._xscale = Math.min( closure.mc._xscale * 1.5, 400 ); //1.025f;
					closure.mc._yscale = Math.min( closure.mc._yscale * 1.5, 400 ); //1.025f;
					*/
				
					closure.mc._y += (yDelta * movementCoefficient);
					yDelta += yDeltaDelta;
					
					yDeltaDelta *= 1.1; // hmm
					
					if ( (!haveReleaseStarHold) && (nFrames < releaseHoldOnStarCountAfterNFrames) )
					{
						--dropping_star_count;
						haveReleaseStarHold = true;
					}
				
					if ( 0 >= --nFrames ) {
					
						if ( !haveReleaseStarHold )
						{
							--dropping_star_count;
							haveReleaseStarHold = true;
						}
					
						if ( null != collected_indicator_cc_mc )
						{
							collected_indicator_cc_mc.onEnterFrame = null;
							collected_indicator_cc_mc._alpha = 100;
							collected_indicator_cc_mc._xscale = 100;
							collected_indicator_cc_mc._yscale = 100;
							
							// could add these to a collection to make the win summary panel 
							// have an animation of these in the background ?
							
						}
						/* else
						{
							
							// show a new star in the collected area over the old one (this is sloppy)
						
							var cc_mc:MovieClip_Ref = collected_stars_mc.attachMovie(
									"gfx_star"
								,	HELPER_MakeDyanmicID ("collected_",nNextStarRemovedID++ )
								,	collected_stars_mc.getNextHighestDepth()
								);

							cc_mc._x = nNextStarRemovedIndicatorXPos;
							cc_mc._y = nNextStarRemovedIndicatorYPos;
				
							nNextStarRemovedIndicatorXPos += nNextStarRemovedIndicatorXDelta;
						} */
					
						// finally get rid of the falling thing
					
						closure.mc.removeMovieClip();
					}
				
				}
			};

			return closure;
		}

		// ---------------------------------------------------------
		
		private function HintFrontClosure( otherHint_mc:game_asset_based_visual ):onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
				
				if ( closure.mc.GetDisplayObject().parent.visible )
				{
					var t:Number = flash.utils.getTimer() * 0.005;
					var scale:Number = 100.0 + 15.0 * (1 + Math.sin( t ));
					var targetRotation:Number = ((Math.atan2( closure.mc._x - otherHint_mc._x, closure.mc._y - otherHint_mc._y ) * -180 / Math.PI)+(90));
					
					closure.mc._rotation = targetRotation;
					closure.mc._xscale = scale;
					closure.mc._yscale = scale;
				}
				
			};
			
			return closure;
		}
		
		private function HintBackClosure( rotation:Number ):onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
				
				var t:Number = flash.utils.getTimer() * 0.001;
				
				var scale:Number = 100.0 + 15.0 * Math.sin( t * 0.33 );
				var alphaTarget:Number = closure.mc.GetDisplayObject().parent.visible ? (100.0 - 40.0* (1.0 + Math.sin( t * 0.66 ))*0.5) : 0.0;
				
				closure.mc._rotation += rotation;
				closure.mc._alpha += (alphaTarget - closure.mc._alpha) * 0.8;
				closure.mc._xscale = scale;
				closure.mc._yscale = scale;
				
			};
			
			return closure;
		}
		
		// ---------------------------------------------------------
		
		private function DBUG_CenterOnMouseClosure():onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
				
				closure.mc._x = _XMOUSE;
				closure.mc._y = _YMOUSE;
				closure.mc._visible = true;
				
				trace("where is it at (" + closure.mc._x + "," + closure.mc._y + ")" );
			};
			
			return closure;
		}
		
		// ---------------------------------------------------------

		private function ShowHints( bShow:Boolean ):void
		{
			//hint_a_mc_front._visible = bShow;
			//hint_b_mc_front._visible = bShow;
			hints_mc_front._visible = bShow && (!game_state.setting_disable_hints);
			
			//hint_a_mc_back._visible = bShow; // 'visibility' now controlled by HintBackClosure
			//hint_b_mc_back._visible = bShow;
			hints_mc_back._visible = bShow && (!game_state.setting_disable_hints);
		}

		private function HideHints():void
		{
			ShowHints( false );
		}

		// ---------------------------------------------------------

		private function PositionOccupied( item:piece_ref ):Boolean
		{
			return item.occupied;
		}

		// ---------------------------------------------------------

		private function SwapItems( a:piece_ref, b:piece_ref, bMoveVisualsWithClosure:Boolean ):void
		{
			var src_row:int = a.row;
			var src_col:int = a.col;

			var dst_row:int = b.row;
			var dst_col:int = b.col;
			
			board_array[ src_row ][ src_col ] = b;
			board_array[ dst_row ][ dst_col ] = a;
			
			a.row = dst_row;
			a.col = dst_col;

			b.row = src_row;
			b.col = src_col;
			
			if ( a.occupied ) {
				
				--count_array[ b.col ];
				++count_array[ a.col ];
				
				if ( bMoveVisualsWithClosure ) {
				
					a.clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
						board_positions_array[ a.row ][ a.col ].x
					,	board_positions_array[ a.row ][ a.col ].y
					,	0.33
					);
					
				} else {
					
					a.clip_mc._x = board_positions_array[ a.row ][ a.col ].x;
					a.clip_mc._y = board_positions_array[ a.row ][ a.col ].y;
					
				}
				
			}
			
			if ( b.occupied ) {
				
				--count_array[ a.col ];
				++count_array[ b.col ];
				
				if ( bMoveVisualsWithClosure ) {
				
					b.clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
						board_positions_array[ b.row ][ b.col ].x
					,	board_positions_array[ b.row ][ b.col ].y
					,	0.33
					);
					
				} else {
					
					b.clip_mc._x = board_positions_array[ b.row ][ b.col ].x;
					b.clip_mc._y = board_positions_array[ b.row ][ b.col ].y;
					
				}
				
			}
		}

		private function IsMoveValidRowOrColOnly( from:piece_ref, to:piece_ref ):Boolean
		{
			var rows:int = from.row - to.row;
			var cols:int = from.col - to.col;
			
			if (0 == rows) {
				
				return (1 == Math.abs( cols ));
				
			}
			
			return (0 == cols) && (1 == Math.abs( rows ));
		}

		private function IsMoveValid( from:piece_ref, to:piece_ref ):Boolean
		{
			if ( !(from.occupied || to.occupied) ) return false;
			
			if ( !_global.bpt2014_allow_diagonal_moves ) return IsMoveValidRowOrColOnly( from, to );			
			
			return (1 >= Math.abs( from.col - to.col )) && (1 >= Math.abs( from.row - to.row ));
		}

		private function IsValidBoardLocation( row:int, col:int ):Boolean
		{
			return (0 <= row) && (board_rows > row) && (0 <= col) && (board_cols > col);
		}
		
		// ----------------------------------------------------------------------------
		
		private function IsLocationInsideMainBoard( row:int, col:int ):Boolean
		{
			return (row >= board_row_first) && 
				(row < board_row_last) &&
				(col >= board_col_first) &&
				(col < board_col_last); 
		}

		private function IsItemInsideMainBoard( item:piece_ref ):Boolean
		{
			if ( null != item ) return IsLocationInsideMainBoard( item.row, item.col );
			
			return false;
		}
		
		// ----------------------------------------------------------------------------
		
		private var _xy_conversion_helper_1:Point = new Point();
		private var _xy_conversion_helper_2:Point = new Point();

		private function ManageSwapCursor( bPress:Boolean, nLastDownFrames:int ):void
		{
			if ( moving_items_count || animating_item_count
				|| bPendingPackRequest || bPendingCollectMetaItems || bCheckForEmptyColumns || bCheckForMatch )
			{
				if ( bSwapCursorActive )
				{
					selected_item = null;
					bSwapCursorActive = false;
					
					if ( null != action_mc )
					{
						action_mc._visible = false;
					}
				}
				
				return;
			}
			
			// ------------------------------------------------------------------------------------

			var xy:Point = _xy_conversion_helper_1;
			
			xy.x = _XMOUSE;
			xy.y = _YMOUSE;

			xy = playfield_mc.globalToLocal( xy );
			
			// ------------------------------------------------------------------------------------

			var dxy:Point = _xy_conversion_helper_2;
			
			dxy.x = _XMOUSE_DOWN;
			dxy.y = _YMOUSE_DOWN;

			dxy = playfield_mc.globalToLocal( dxy );
			
			// ------------------------------------------------------------------------------------
			
			var row:int, col:int;
			
			if ( selected_item && (0 < nLastDownFrames) )
			{
				var p:Point = board_positions_array[ row = selected_item.row ][ col = selected_item.col ];
				
				// ------------------
				
				var hx:Number = (xy.x - dxy.x);
				var hy:Number = (xy.y - dxy.y);
				
				if ( (Math.abs( hx ) * 0.3) > (Math.abs( hy )) )
				{
					hy = 0;
				}
				else if ( (Math.abs( hy ) * 0.3) > (Math.abs( hx )) )
				{
					hx = 0;
				}
				
				// ------------------
				
				var dx:int = hx / (item_cx/3);
				var dy:int = hy / (item_cy/3);
				
				if ( 0 > dy ) { --row; } else if ( 0 < dy ) { ++row; }
				if ( 0 > dx ) { --col; } else if ( 0 < dx ) { ++col; }
			}
			else
			{
				row = Math.floor( (xy.y - board_positions_array[ 0 ][ 0 ].y + (item_cy/2)) / item_cy );
				col = Math.floor( (xy.x - board_positions_array[ 0 ][ 0 ].x + (item_cx/2)) / item_cx );
			}
			
			if ( !IsValidBoardLocation( row, col ) )
			{
				selected_item = null;
				bSwapCursorActive = false;
					
				if ( null != action_mc )
				{
					action_mc._visible = false;
				}

				return;
			}

			var oldSelectedItem:piece_ref = selected_item;
			
			selected_item = board_array[ row ][ col ];

			// ------------------------------------------------------------------------------------

			HideHints();
			
			var bFallbackToNormalSelection:Boolean = false;

			if ( oldSelectedItem )
			{
				if ( oldSelectedItem == selected_item )
				{
					if ( !bPress )
					{
						return ;
					}

					START_SFX( sfx_select_item ); // TODO this should be an unselect sound?
					
// ---------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------
					if ( null != selected_item.clip_mc )
					{
						// BUGBUG - this is for debugging :-)
					}
// ---------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------
					
				}
				else
				{
					var src_row:int = oldSelectedItem.row;
					var src_col:int = oldSelectedItem.col;
			
					var dst_row:int = selected_item.row;
					var dst_col:int = selected_item.col;

					src_swap_item = board_array[ src_row ][ src_col ];
					src_row_item = src_row;
					src_col_item = src_col;
					
					dst_swap_item = board_array[ dst_row ][ dst_col ];
					dst_row_item = dst_row;
					dst_col_item = dst_col;

					if ( IsMoveValid( src_swap_item, dst_swap_item ) )
					{
						SetBoardAsChanged();
						
						++game_state.last_board_moves;
						++game_state.total_moves;

						SwapItems( dst_swap_item, src_swap_item, true );
					
						bCheckForMatch = true;
					
						START_SFX( sfx_swap_noise );
					}
					else
					{
						bFallbackToNormalSelection = dst_swap_item.occupied;
						
						src_swap_item = null;
						dst_swap_item = null;
					}
				}
				
				if ( !bFallbackToNormalSelection )
				{
					selected_item = null;
					bSwapCursorActive = false;
					
					if ( null != action_mc )
					{
						action_mc._visible = false;
					}
				}
			}
			else
			{
				bFallbackToNormalSelection = true;
			}
			
			if ( bFallbackToNormalSelection )
			{
				START_SFX( sfx_select_item );
				
				action_mc._visible = true;
				action_mc._x = board_positions_array[ row ][ col ].x;
				action_mc._y = board_positions_array[ row ][ col ].y;
				
				bSwapCursorActive = true;
				nRemovalsInARow = 0; // clear out removal counter...
			}
		}

		private function ManageSwapCursorOnPress():void
		{
			ManageSwapCursor( true, LAST_MOUSE_DOWN_FRAMES );
		}

		private function ManageSwapCursorOnRelease():void
		{
			if ( moving_items_count || animating_item_count || (!bSwapCursorActive) ) return;

			ManageSwapCursor( false, LAST_MOUSE_DOWN_FRAMES );
		}

		// ---------------------------------------------------------

		private function HorizontalCenterPlayfield():void
		{
			var dim:int = (int)((playfield_mc._xscale * (CountCols(false) * item_cx)) / 100.0);
			playfield_mc._x = (_global.purgatory_stage_cx - dim) / 2;
		}

		private function VerticalCenterPlayfield():void
		{
			var dim:int = (int)((playfield_mc._yscale * (CountRows(false) * item_cy)) / 100.0);
			playfield_mc._y = (_global.purgatory_stage_cy - dim) / 2;
		}

		private function CenterPlayfield():void
		{
			HorizontalCenterPlayfield();
			VerticalCenterPlayfield();
		}

		// ---------------------------------------------------------

		private function CheckForMatch( dst:piece_ref, src:piece_ref ):Boolean
		{
			return (0 != src.match_id) && (dst.match_id == src.match_id);
		}

		// ---------------------------------------------------------
		// group management
		// TODO - probably should manage these as lists instead of vectors?...
		// ---------------------------------------------------------

		private function MoveSmallerGroupItemsToLarger( larger:group_ref, smaller:group_ref ):void
		{
			// adopt the smaller group members into the larger group
			
			while ( 0 != smaller.length )
			{
				var obj:piece_ref = smaller.pop();
				
				obj.pGroupHead = larger;

				larger.push( obj );
			}
			
			// recycle the smaller group
			
			if ( smaller != active_groups_head )
			{
				if ( null != smaller.pNextGroup )
				{
					smaller.pNextGroup.pPrevGroup = smaller.pPrevGroup;
				}
				
				smaller.pPrevGroup.pNextGroup = smaller.pNextGroup;
			}
			else
			{
				active_groups_head = smaller.pNextGroup;
			}
			
			smaller.reset()
			
			Allocator.Release( smaller );
		}

		private function MergeConnectivityGroups( dst:piece_ref, src:piece_ref  ):void
		{
			if ( (null == dst.pGroupHead) && (null == src.pGroupHead) )
			{
				var newGroup:group_ref = group_ref.Alloc();

				newGroup.group_id = next_active_group_id++;
				
				newGroup.push( dst );
				newGroup.push( src );
					
				dst.pGroupHead = newGroup;
				src.pGroupHead = newGroup;
				
				newGroup.pNextGroup = active_groups_head;
				
				if ( null != active_groups_head )
				{
					active_groups_head.pPrevGroup = newGroup;
				}
				
				active_groups_head = newGroup;
			}
			else
			{
				if ( null == dst.pGroupHead )
				{
					// add ungrouped item to the existing group
					
					src.pGroupHead.push( dst );
					dst.pGroupHead = src.pGroupHead;
				}
				else if ( null == src.pGroupHead )
				{
					// add ungrouped item to the existing group
					
					dst.pGroupHead.push( src );
					src.pGroupHead = dst.pGroupHead;
				}
				else if ( dst.pGroupHead != src.pGroupHead )
				{
					assert( dst.pGroupHead.group_id != src.pGroupHead.group_id );

					// move the smaller group items to the larger group
					
					if ( dst.pGroupHead.length >= src.pGroupHead.length )
					{
						MoveSmallerGroupItemsToLarger( dst.pGroupHead, src.pGroupHead );
					}
					else
					{
						MoveSmallerGroupItemsToLarger( src.pGroupHead, dst.pGroupHead );
					}
				}
				else
				{
					assert( dst.pGroupHead.group_id == src.pGroupHead.group_id );
				}
			}
		}
		
		private function ResetConnectivityGroups():void
		{
			// clear out the references to all grouping info in the board
			
			var row_array:Vector.<piece_ref>;
			
			var row:int, col:int;
			
			var o:piece_ref;
			
			for ( row = board_rows; 0 <= --row; )
			{
				row_array = board_array[ row ];
				
				/*
				for each ( var piece:piece_ref in row_array )
				{
					piece.pGroupHead = null;
					piece.pGroupNext = null;
				}
				*/
				
				for ( col = board_cols; 0 <= --col; )
				{
					o = row_array[ col ];
					o.pGroupHead = null;
					o.pGroupNext = null;
				}
			}
			
			// recycle the groups
			
			var group:group_ref;
				
			while ( null != active_groups_head )
			{
				group = active_groups_head;
				
				active_groups_head = active_groups_head.pNextGroup;
					
				group.reset();
					
				Allocator.Release( group );
			}

			active_groups_head = null;
			next_active_group_id = 1;
		}

		// --------------------------------------------------------------------
		
		private function OnePassBuildConnectivity( bCheckDiagnols:Boolean ):void
		{
			var item:piece_ref, A:piece_ref, B:piece_ref;
			var id:int;
			
			var col:int, row:int, rows:int, cols:int;
			
			cols = board_cols;
			rows = board_rows;
			
			var rm2_array:Vector.<piece_ref>;
			var rm1_array:Vector.<piece_ref>;
			var row_array:Vector.<piece_ref>;
			
			for ( row = 0; row < rows; ++row )
			{
				if (2 <= row)
				{
					rm2_array = board_array[ row - 2 ];
					rm1_array = board_array[ row - 1 ];
				}
				else
				{
					rm2_array = null;
					rm1_array = null;
				}
				
				row_array = board_array[ row ];
				
				for ( col = 0; col < cols; ++col )
				{
					item = row_array[ col ];
					
					if ( !item.occupied ) continue;
					
					id = item.match_id;
					
					if ( (rm2_array && rm1_array) && (id == (A = rm1_array[ col ]).match_id) && (id == (B = rm2_array[ col ]).match_id) )
					{
						if ( A.occupied && B.occupied )
						{
							MergeConnectivityGroups( item, A );
							MergeConnectivityGroups( item, B );
						}
					}
					
					// check left sides
					
					if ( 0 <= (col - 2) )
					{
						if ( (id == (A = row_array[ col - 1 ]).match_id) && (id == (B = row_array[ col - 2 ]).match_id) )
						{
							if ( A.occupied && B.occupied )
							{
								MergeConnectivityGroups( item, A );
								MergeConnectivityGroups( item, B );
							}
						}
						
						if ( bCheckDiagnols && rm2_array && rm1_array )
						{
							if ( (id == (A = rm1_array[ col - 1 ]).match_id) && (id == (B = rm2_array[ col - 2 ]).match_id) )
							{
								if ( A.occupied && B.occupied )
								{
									MergeConnectivityGroups( item, A );
									MergeConnectivityGroups( item, B );
								}
							}
						}
					}
					
					// check right sides
					
					if ( board_col_last >= (col + 2) )
					{
						if ( (id == (A = row_array[ col + 1 ]).match_id) && (id == (B = row_array[ col + 2 ]).match_id) )
						{
							if ( A.occupied && B.occupied )
							{
								MergeConnectivityGroups( item, A );
								MergeConnectivityGroups( item, B );
							}
						}
						
						if ( bCheckDiagnols && rm2_array && rm1_array )
						{
							if ( (id == (A = rm1_array[ col + 1 ]).match_id) && (id == (B = rm2_array[ col + 2 ]).match_id) )
							{
								if ( A.occupied && B.occupied )
								{
									MergeConnectivityGroups( item, A );
									MergeConnectivityGroups( item, B );
								}
							}
						}
					}
					
				}
			}
		}

		private function OnePassCheckConnectivity( bCheckDiagnols:Boolean ):Boolean
		{
			var item:piece_ref, A:piece_ref, B:piece_ref;
			var id:int;
			
			var col:int, row:int, rows:int, cols:int;
			
			cols = board_cols;
			rows = board_rows;
			
			var rm2_array:Vector.<piece_ref>;
			var rm1_array:Vector.<piece_ref>;
			var row_array:Vector.<piece_ref>;
			
			for ( row = 0; row < rows; ++row )
			{
				if (2 <= row)
				{
					rm2_array = board_array[ row - 2 ];
					rm1_array = board_array[ row - 1 ];
				}
				else
				{
					rm2_array = null;
					rm1_array = null;
				}
				
				row_array = board_array[ row ];
				
				for ( col = 0; col < cols; ++col )
				{
					item = row_array[ col ];
					
					if ( !item.occupied ) continue;
					
					id = item.match_id;
					
					if ( (rm2_array && rm1_array) && (id == (A = rm1_array[ col ]).match_id) && (id == (B = rm2_array[ col ]).match_id) )
					{
						if ( A.occupied && B.occupied ) return true;
					}
					
					// check left sides
					
					if ( 0 <= (col - 2) )
					{
						if ( (id == (A = row_array[ col - 1 ]).match_id) && (id == (B = row_array[ col - 2 ]).match_id) )
						{
							if ( A.occupied && B.occupied ) return true;
						}
						
						if ( bCheckDiagnols && rm2_array && rm1_array )
						{
							if ( (id == (A = rm1_array[ col - 1 ]).match_id) && (id == (B = rm2_array[ col - 2 ]).match_id) )
							{
								if ( A.occupied && B.occupied ) return true;
							}
						}
					}
					
					// check right sides
					
					if ( board_col_last >= (col + 2) )
					{
						if ( (id == (A = row_array[ col + 1 ]).match_id) && (id == (B = row_array[ col + 2 ]).match_id) )
						{
							if ( A.occupied && B.occupied ) return true;
						}
						
						if ( bCheckDiagnols && rm2_array && rm1_array )
						{
							if ( (id == (A = rm1_array[ col + 1 ]).match_id) && (id == (B = rm2_array[ col + 2 ]).match_id) )
							{
								if ( A.occupied && B.occupied ) return true;
							}
						}
					}
					
				}
			}
			
			return false;
		}

		// --------------------------------------------------------------------

		private function RebuildThreeOrMoreConnectivity():void
		{
			ResetConnectivityGroups();
			
			OnePassBuildConnectivity( _global.purgatory_bIncludeDiagonalsInConnectivity );
		}

		// ---------------------------------------------------------
		
		private var findCentroidHelperPoint_:Point = new Point(); 
		
		private function FindGroupCentroid_( centroid:Point, group:group_ref):Point
		{
			//var normalizeCount:Number = 1;
			
			centroid.x = 0; //board_positions_array[ group.pHead.row ][ group.pHead.col ].x;
			centroid.y = 0; //board_positions_array[ group.pHead.row ][ group.pHead.col ].y;
			
			for ( var who:piece_ref = group.pHead; null != who; who = who.pGroupNext )
			{
				centroid.x += board_positions_array[ who.row ][ who.col ].x;
				centroid.y += board_positions_array[ who.row ][ who.col ].y;
				
				//++normalizeCount;
			}
			
			var oo:Number = 1.0 / group.length /*normalizeCount*/;
			
			centroid.x *= oo; 
			centroid.y *= oo; 
			
			return centroid;
		}
		
		private function FindGroupCentroid( group:group_ref):Point
		{
			return FindGroupCentroid_( findCentroidHelperPoint_, group );
		}
		
		private function GetPointForPiece( who:piece_ref ):Point
		{
			return  board_positions_array[ who.row ][ who.col ];
		}
		
		private function FindGroupPieceClosestToPoint( p:Point, group:group_ref):piece_ref
		{
			var closestDistanceSquared:Number = Number.MAX_VALUE;
			var closest:piece_ref = group.pHead;
			var distanceSquared:Number;
			var cx:Number = p.x;
			var cy:Number = p.y;
			var dx:Number;
			var dy:Number;
			var wp:Point;
			
			for ( var who:piece_ref = group.pHead; null != who; who = who.pGroupNext ) {
				
				wp = board_positions_array[ who.row ][ who.col ];
				
				dx = cx - wp.x;
				dy = cy - wp.y;
				
				distanceSquared = dx*dx + dy*dy;
				
				if ( distanceSquared < closestDistanceSquared )
				{
					closestDistanceSquared = distanceSquared;
					closest = who;
				}
			}
			
			return closest;
		}
		// ---------------------------------------------------------
		
		private function FindGroupCollapseCandidate(group:group_ref):piece_ref
		{
			// prioritize group members involved in the last swap 
			
			for ( var p:piece_ref = group.pHead; null != p; p = p.pGroupNext ) {
				
				if ( ((p == dst_swap_item) || (p == src_swap_item)) )
				{
					if ( _global.bpt2021_replace_removed_groups_with_next_match_id && !IsItemInsideMainBoard(p) )
					{
						continue; // if candidate isn't in the main board skip
					}
					
					return p;
				}
				
			}
			
			// fallback to searching for the piece closest to the group centroid
			
			var piece:piece_ref = FindGroupPieceClosestToPoint( FindGroupCentroid( group ), group );
			
			// if the closest piece isn't in the main board pick the first member that is inside
			
			if ( _global.bpt2021_replace_removed_groups_with_next_match_id && !IsItemInsideMainBoard(piece))
			{
				for ( var p:piece_ref = group.pHead; null != p; p = p.pGroupNext ) {
						
					if ( IsItemInsideMainBoard(p) )
					{
						return p;
					}
				}
			}
			
			return piece;
		}
		
		private function CalcGroupPointsTotal(group:group_ref):int
		{
			var total:int = 0;
			
			for ( var item:piece_ref = group.pHead; null != item; item = item.pGroupNext )
			{
				total += GetPointsValue( item );				
			}
			
			return total;
		}
		
		// =================================================================================================
		
		// TODO - this really should be a dictionary - which would allow for new items to be introduced
		
		private function FindReplacementForPieceType( match_id:int ):int
		{
			var len:int = _global.purgatory_active_pieces.length;
			
			for ( var i:int = 0; i < len; i++ )
			{
				if ( match_id == _global.purgatory_active_pieces[i] )
				{
					return _global.purgatory_active_pieces[ (i + 1) % len ];
				}
			}
			
			return match_id;
		}
		
		private function GetReplacementPieceForGroup( group:group_ref ):int
		{
			// DESIGN - should the length of the group affect the replacement match id?????
			
			return FindReplacementForPieceType( group.pHead.match_id );
		}

		// =================================================================================================
		
		private function RemoveGroup( group:group_ref ):void
		{
			SetBoardAsChanged();
			
			var item:piece_ref = null;
			var last:piece_ref = null;
			
			var replacementPiece:int = GetReplacementPieceForGroup( group );

			var collapseCandidate:piece_ref = FindGroupCollapseCandidate( group );
			var targetPos:Point = GetPointForPiece( collapseCandidate );
			
			var removeDuration:int = _global.bpt2014_remove_base_duration; //OLD_30_FPS_TO_N_FPS(20); 
			removeDuration = Math.max( 10, removeDuration * nPendingRemovalAnimationSpeed ); // bpt.2014
			
			var displayPoints:int = 0;
			var removeDelay:int = 1;
			var groupTotalPointValue:int = 0;
			var bTriggerRemovalSound:Boolean;
			
			if ( _global.bpt2014_collect_points_once_per_group )
			{
				groupTotalPointValue = CalcGroupPointsTotal( group );
			}
			
			while ( 0 != group.length )
			{
				last = item;
				item = group.pop();

				//assert( null != item );
				
				item.pGroupNext = null;
				item.pGroupHead = null;
				
				/*
				if ( 0 < item.match_id )
				{
					++_global.purgatory_played_types_removed_counter[ item.match_id - 1 ];
				}
				*/
				
				bTriggerRemovalSound = false;
				
				if ( _global.bpt2014_collect_points_once_per_group )
				{
					if ( item != collapseCandidate )
					{
						displayPoints = 0;
					}
					else
					{
						bTriggerRemovalSound = _global.bpt2014_play_removal_sound_per_item;
						
						displayPoints = groupTotalPointValue;
					}
				}
				else
				{
					displayPoints = GetPointsValue( item );
				}
				
				item.clip_mc.onEnterFrame = RemoveElementClosure( removeDuration, 10, nRemovalsInARow, targetPos, removeDelay, displayPoints, bTriggerRemovalSound );
				board_array[ item.row ][ item.col ] = new piece_ref( item.row, item.col );
				--count_array[ item.col ];
				
				++game_state.total_pieces_removed;
				++removeDelay;
			}
			
			if ( _global.bpt2021_replace_removed_groups_with_next_match_id )
			{
				CreateAndSetupItemForBoardAtLocation(
					collapseCandidate.row, collapseCandidate.col, false, replacementPiece, 1000, true );
			}
			
		}
		
		private function RemoveGroupsLargerThan( size:int, stopAfterNRemovals:int = -1 ):Boolean
		{
			var bRemovedSomething:Boolean = false;
			
			var nRemovedSoFar:int = 0;
			
			for ( var group:group_ref = active_groups_head; null != group; group = group.pNextGroup )
			{
				if ( group.length <= size ) continue;
				
				if ( !bRemovedSomething )
				{
					if ( -1 == stopAfterNRemovals )
					{
						++nRemovalsInARow;
						
						if ( 1 != nRemovalsInARow )
						{
							DispatchComboMessage( nRemovalsInARow, group );
						}
					}
					
					bRemovedSomething = true;
				}
				
				++nRemovedSoFar;
				
				RemoveGroup( group );
				
				if ( (-1 != stopAfterNRemovals) && (nRemovedSoFar == stopAfterNRemovals) )
				{
					return true; 
				}
				
			}
			
 			return bRemovedSomething;
		}

		private function CountGroupsLargerThan( size:int ):int
		{
			var nCount:int = 0;

			for ( var group:group_ref = active_groups_head; null != group; group = group.pNextGroup )
			{
				if ( group.length <= size ) continue;
				
				++nCount;
			}
			
			return nCount;
		}

		// ---------------------------------------------------------

		private function MoveItemTo( item:piece_ref, row:int, col:int, bMoveMovieClip:Boolean ):void
		{
			SetBoardAsChanged();
			
			board_array[ row ][ col ] = item;

			board_array[ item.row ][ item.col ] = new piece_ref( item.row, item.col );
			
			++count_array[ col ];
			--count_array[ item.col ];
			
			item.row = row;
			item.col = col;

			if ( bMoveMovieClip )
			{
				item.clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
					board_positions_array[ row ][ col ].x
				,	board_positions_array[ row ][ col ].y
				,	0.33
				);
			}
		}

		private function PackBoardDownwards():void
		{
			SetBoardAsChanged();
			
			var item:piece_ref;
			
			var bSomethingMoved = false;
			
			var col:int, row:int, search_row:int;
			
			for ( col = board_col_first; col <= board_col_last; ++col )
			{
				for ( row = board_row_last; board_row_first < --row; )
				{
					if ( board_array[ row ][ col ].occupied ) continue;
					
					for ( search_row = row; board_row_first <= --search_row; )
					{
						item = board_array[ search_row ][ col ];
						
						if ( !item.occupied ) continue;
						
						bSomethingMoved = true;
						
						MoveItemTo( item, row, col, true );
						break;
					}
				}
			}
			
			if ( bSomethingMoved )
			{
				START_SFX( sfx_pack_noise );
			}
			
		}

		private function PackBoardUpwards():void
		{
			SetBoardAsChanged();
			
			var item:piece_ref;
			
			var bSomethingMoved = false;

			var col:int, row:int, search_row:int;
			
			for ( col = board_col_first; col <= board_col_last; ++col )
			{
				for ( row = board_row_first; row <= board_row_last; ++row )
				{
					if ( board_array[ row ][ col ].occupied ) continue;
					
					for ( search_row = row + 1; search_row <= board_row_last; ++search_row )
					{
						item = board_array[ search_row ][ col ];

						if ( !item.occupied ) continue;
						
						bSomethingMoved = true;
						
						MoveItemTo( item, row, col, true );
						break;
					}
				}
			}
			
			if ( bSomethingMoved )
			{
				START_SFX( sfx_pack_noise );
			}
			
		}

		// ---------------------------------------------------------
		
		private function DoNotPickFor( rowa:int, cola:int, rowb:int, colb:int ) {
			
			var a:piece_ref = board_array[ rowa ][ cola ];
			var b:piece_ref = board_array[ rowb ][ colb ];
			
			if ( a.occupied && a.occupied && (a.match_id == b.match_id) ) {
				
				return a.match_id;
				
			}
			
			return -1;
		}
		
		private function PickRandomPieceForLocationThatWillNotCauseAMatch( row:int, col:int, nPieces:int ) {
			
			var candidates:Vector.<Boolean> = nopickcandidateshelpercache;
			for ( var i:int = candidates.length; --i >= 0; ) {
				candidates[i] = (-1 != _global.purgatory_active_pieces.indexOf(i));
			}
			
			var id:int, idx:int;
			
			bDownRowChecksOK = (board_row_first <= (row - 2));
			bUpRowChecksOK = (board_row_last >= (row + 2));
			
			if ( bDownRowChecksOK && (-1 != (id = DoNotPickFor( row - 1, col, row - 2, col ))) ) candidates[ id ] = false;
			if ( bUpRowChecksOK && (-1 != (id = DoNotPickFor( row + 1, col, row + 2, col ))) ) candidates[ id ] = false;
			
			// check left sides
			
			if ( board_col_first <= (col - 2) )
			{
				if ( -1 != (id = DoNotPickFor( row, col - 1, row, col - 2 )) ) candidates[ id ] = false;
				
				if ( _global.purgatory_bIncludeDiagonalsInConnectivity )
				{
					if (bDownRowChecksOK && ( -1 != (id = DoNotPickFor( row - 1, col - 1, row - 2, col - 2 )) )) candidates[ id ] = false;
					if (bUpRowChecksOK && ( -1 != (id = DoNotPickFor( row + 1, col - 1, row + 2, col - 2 )) )) candidates[ id ] = false;
				}
			}
			
			// check right sides
			
			if ( board_col_last >= (col + 2) )
			{
				if ( -1 != (id = DoNotPickFor( row, col + 1, row, col + 2 )) ) candidates[ id ] = false;
				
				if ( _global.purgatory_bIncludeDiagonalsInConnectivity )
				{
					if (bDownRowChecksOK && ( -1 != (id = DoNotPickFor( row - 1, col + 1, row - 2, col + 2 )) )) candidates[ id ] = false;
					if (bUpRowChecksOK && ( -1 != (id = DoNotPickFor( row + 1, col + 1, row + 2, col + 2 )) )) candidates[ id ] = false;
				}
			}
			
			for ( var retries:int = _global.purgatory_nPieces * 2; 0 <= retries; --retries ) { // bpt.2021.04.04 oops was ++ (bug fix??)
				
				id = GenerateRandomPieceMatchID(_global.purgatory_nPieces);
				
				if ( candidates[id] )
				{
					return id;
				}
				
			}
			
			return GenerateRandomPieceMatchID(_global.purgatory_nPieces);
		}
		
		// ----------------------------------------------------------------------------------------------
		
		private function CreateAndSetupItemForBoardAtLocation( row:int, col:int, bCreateFalling:Boolean, createPieceType:int, creationID:int, bBloomIntoPosition:Boolean ):piece_ref
		{
			++moving_items_count;
			
			var item:piece_ref = new piece_ref( row, col, true );
			
			board_array[ row ][ col ] = item;
			
			++count_array[ col ];
			
			var id_str:String = HELPER_MakeDyanmicID( "id_", creationID ); // THINK.THINK. about what happens when creationID gets huge is that a problem?
			
			var piece:int = createPieceType; // PickRandomPieceForLocationThatWillNotCauseAMatch( row, col, _global.purgatory_nPieces );
			
			item.clip_mc = piece_visual.Alloc( piece );
			
			item.clip_mc._name = id_str;
			
			mainboard_mc.addChild( item.clip_mc );
			
			item.clip_mc._x = board_positions_array[ row ][ col ].x;
			item.clip_mc._y = board_positions_array[ row ][ col ].y;
			
			if ( bCreateFalling )
			{
				if ( _global.purgatory_going_down ) {
					
					item.clip_mc._y = board_positions_array[ row ][ col ].y - 1000;
					
				} else {
					
					item.clip_mc._y = board_positions_array[ row ][ col ].y + 1000;
					
				}
				
			}
			
			SetupItemType( item, piece );
			
			if ( bBloomIntoPosition )
			{
				item.clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
					board_positions_array[ row ][ col ].x
				,	board_positions_array[ row ][ col ].y
				,	0.33
				,	[
						{ property:"_xscale", start:250.0, end:100.0, blend:0.125 },
						{ property:"_yscale", start:250.0, end:100.0, blend:0.125 },
					]
				,	3
				);
			}
			else
			{
					
				item.clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
					board_positions_array[ row ][ col ].x
				,	board_positions_array[ row ][ col ].y
				,	0.33
				);
				
			}
			
			--moving_items_count;
			
			return item;

		}
		
		// ----------------------------------------------------------------------------------------------
		
		private function FillBoardHoles() { // BPT.2014.09.03 - keeping the board full test
			
			++moving_items_count;
			
			var idNumber:int = 1000;

			for ( col = board_col_first; col < board_col_last; ++col )
			{
				for ( row = board_row_first; row < board_row_last; ++row )
				{
					var item:piece_ref = board_array[ row ][ col ];
					
					if ( item.occupied ) continue;
					
					var piece:int = PickRandomPieceForLocationThatWillNotCauseAMatch( row, col, _global.purgatory_nPieces );
						
					item = CreateAndSetupItemForBoardAtLocation( row, col, true, piece, idNumber++, false );
				}
			}
			
			--moving_items_count;
			
		}
		
		// ---------------------------------------------------------

		private function SyncBoardObjectsToNewPositions():void
		{
			// NOW FIX UP THE COORDINATES! -- this could do some sort of fun lag for the tops.. to make it look like something about to fall?
			
			var item:piece_ref;
			
			var col:int, row:int;

			for ( row = 0; row < board_rows; ++row )
			{
				for ( col = 0; col < board_cols; ++col )
				{
					item = board_array[ row ][ col ];

					if ( item.occupied )
					{
						item.clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
							board_positions_array[ row ][ col ].x
						,	board_positions_array[ row ][ col ].y
						,	0.33
						);
					}

					if ( null != meta_board[ row ][ col ] ) // ( meta_ref() != meta_board[ row ][ col ] )
					{
						meta_board[ row ][ col ].clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
							board_positions_array[ row ][ col ].x
						,	board_positions_array[ row ][ col ].y
						,	0.33
						);
					}
				}
			}

		}

		private function RemoveColumn( remove_col:int ):void
		{

		//CONSOLE << "RemoveColumn " << remove_col << " START" << std::endl;

			SetBoardAsChanged();
			
			var item:piece_ref;

			// What about triggering an animation for column removal...

			// manipulate the coordinates for where the board will be

			var xDelta:int = item_cx / 2;

			var col:int, row:int, pack_col:int;
			
			for ( row = 0; row < board_rows; ++row )
			{
				for ( col = 0; col < board_cols; ++col )
				{
					board_positions_array[ row ][ col ].x += xDelta;
				}
			}

			// pack all the logical information 

			for ( row = board_rows; 0 <= --row; )
			{
				pack_col = remove_col;

				for ( col = remove_col; ++col < board_cols; )
				{
					item = board_array[ row ][ col ];

					if ( item.occupied )
					{
						MoveItemTo( item, row, pack_col, false );
					}
					
					if ( null != meta_board[ row ][ col ] )
					{
						meta_board[ row ][ pack_col ] = meta_board[ row ][ col ];
						meta_board[ row ][ col ] = null;
					}
					
					++pack_col;		
				}
			}

			--board_cols;
			--board_col_last;

		//CONSOLE << "RemoveColumn " << remove_col << " FINISH" << std::endl;

		}

		private function RemoveEmptyColumns():Boolean
		{
			var bRemovedSomething:Boolean = false;

			for ( var col:int = board_col_first; col < board_col_last; ++col )
			{
				if ( 0 != count_array[ col ] ) continue;
				
				RemoveColumn( col );

				bRemovedSomething = true;

				--col; // search again for a removed column in the same place...

				if ( !_global.purgatory_pack_all_columns_at_once ) break;
			}

			if ( bRemovedSomething )
			{
				START_SFX( sfx_remove_column );
				SyncBoardObjectsToNewPositions();
			}

			return bRemovedSomething;
		}

		// ---------------------------------------------------------

		private function CollectMetaItems():void
		{
			var nRemoveCounter:int = 0;
			
			var col:int, row:int;
			
			for ( row = board_row_first; row <= board_row_last; ++row )
			{
				for ( col = board_col_first; col <= board_col_last; ++col )
				{
					//if ( (meta_ref() != meta_board[ row ][ col ]) && (!board_array[ row ][ col ].occupied) )
					if ( (null != meta_board[ row ][ col ]) && (!board_array[ row ][ col ].occupied) )
					{
						--meta_items_count;
						
						++nRemoveCounter;

						//meta_board[ row ][ col ].clip_mc.play();
						
						if ( _global.purgatory_going_down )
						{
							meta_board[ row ][ col ].clip_mc.onEnterFrame =
								CollectMetaItemClosure( 2, OLD_30_FPS_TO_N_FPS(45), -10, +2.5 );
								
						}
						else
						{
							meta_board[ row ][ col ].clip_mc.onEnterFrame =
								CollectMetaItemClosure( 2, OLD_30_FPS_TO_N_FPS(45), +10, -2.5 );
						}
						
						meta_board[ row ][ col ] = null; // meta_ref();
					}
				}
			}
			
			if ( nRemoveCounter ) {
				
				START_SFX( sfx_meta_remove );
				
			}
		}

		// ---------------------------------------------------------

		private function CheckForRemovals_ORIGINAL():Boolean
		{
			//if ( !OnePassCheckConnectivity( _global.purgatory_bIncludeDiagonalsInConnectivity ) ) return false;
			
			RebuildThreeOrMoreConnectivity();
			
			if ( !RemoveGroupsLargerThan( _global.bpt2021_remove_when_groups_larger_than ) ) return false;
			
			if ( bFirstRemoval )
			{
				bFirstRemoval = false;
				
				// could do something on first removal (like a tutorial...)
			}
			
			START_SFX( sfx_remove_noise );
			
			bPendingPackRequest = true;
			bPendingCollectMetaItems = true;
			bCheckForEmptyColumns = true;
			
			bCheckForMatch = true;
			src_swap_item = null; // piece_ref();
			dst_swap_item = null; // piece_ref();
			
			return true;
		}
		
		private function ContinuePendingRemovals_ORIGINAL():Boolean
		{
			return false;
		}
		
		// ---------------------------------------------------------
		
		private function ConfirmMoveValidByResetActiveSwapItems():void
		{
			bCheckForMatch = true;
			src_swap_item = null; // piece_ref();
			dst_swap_item = null; // piece_ref();
		}
		
		private function CheckForRemovals_ONCEUPONATIME():Boolean
		{
			RebuildThreeOrMoreConnectivity();
			
			if (0 == CountGroupsLargerThan( _global.bpt2021_remove_when_groups_larger_than ))
			{
				if ( _global.bpt2014_experiment_allow_move_and_hold_test )
				{
					ConfirmMoveValidByResetActiveSwapItems();
				}
				return false;
			}
			
			bPendingRemovalsModeActive = true;
			nPendingRemovalAnimationSpeed = _global.bpt2014_remove_animation_speed_coefficient_start;		
			
			++nRemovalsInARow;
			
			return true;
		}
		
		private function ContinuePendingRemovals_ONCEUPONATIME():Boolean
		{
			if ( !bPendingRemovalsModeActive ) return false;
			//if ( 0 != nActivePreRemovals) return true;
			
			if ( (0 != moving_items_count) ) return true;
			
			//if ( !OnePassCheckConnectivity( _global.purgatory_bIncludeDiagonalsInConnectivity ) ) return false;
			
			if ( !RemoveGroupsLargerThan( _global.bpt2021_remove_when_groups_larger_than, 1 ) )
			{
				bPendingRemovalsModeActive = false;
				
				return (0 != animating_item_count);
			}
			
			nPendingRemovalAnimationSpeed = Math.max(
				_global.bpt2014_remove_animation_speed_coefficient_min,
				Math.min( nPendingRemovalAnimationSpeed + _global.bpt2014_remove_animation_speed_delta,
					_global.bpt2014_remove_animation_speed_coefficient_max ) );
			
			ConfirmMoveValidByResetActiveSwapItems();
			
			if ( bFirstRemoval )
			{
				bFirstRemoval = false;
				
				// could do something on first removal (like a tutorial...)
			}
			
			// BUGBUG - this sound triggering logic is suspect (does the same thing regardless of condition...
			
			if ( !_global.bpt2014_collect_points_once_per_group )
			{
				START_SFX( sfx_remove_noise );
			}
			else
			{
				START_SFX( sfx_remove_noise );
			}
			
			bPendingPackRequest = true;
			bPendingCollectMetaItems = true;
			bCheckForEmptyColumns = true;
			
			return true;
		}
		
		// ---------------------------------------------------------

		private var CheckForRemovals:Function = CheckForRemovals_ORIGINAL;
		private var ContinuePendingRemovals:Function = ContinuePendingRemovals_ORIGINAL; 
		
		// this creates a nice effect to allow people to notice what matches happened 
		// BUGBUG (currently doesn't make sounds correctly)
		
//		private var CheckForRemovals:Function = CheckForRemovals_ONCEUPONATIME;
//		private var ContinuePendingRemovals:Function = ContinuePendingRemovals_ONCEUPONATIME;
		
		
		private function SetupRemovalAndPendingRemovalStrategyFunctions()
		{
			if ( _global.bpt2021_use_original_removal_strategy )
			{
				CheckForRemovals = CheckForRemovals_ORIGINAL;
				ContinuePendingRemovals = ContinuePendingRemovals_ORIGINAL;
			}
			else
			{
				CheckForRemovals = CheckForRemovals_ONCEUPONATIME;
				ContinuePendingRemovals = ContinuePendingRemovals_ONCEUPONATIME;
			}
		}
		
		
		// ---------------------------------------------------------

		private function RestartMovesSearch():void
		{
			HideHints();
			hint_item_a = null; // piece_ref();
			hint_item_b = null; // piece_ref();
			
			nRowMovesSearch = 0;
			nColMovesSearch = 0;
			bMovesSearchDone = false;
			bFoundMoveAtSearchLocation = false;
		}

		// ---------------------------------------------------------

		private function CheckLocationForMoves( row:int, col:int ):Boolean
		{
			var start_row:int = Math.max( 0, Math.min( row - 1, board_rows - 1 ) );
			var end_row:int = Math.max( start_row, Math.min( row + 1, board_rows - 1 ) );
			
			var start_col:int = Math.max( 0, Math.min( col - 1, board_cols - 1 ) );
			var end_col:int = Math.max( start_col, Math.min( col + 1, board_cols - 1 ) );
			
			var check_row:int;
			var check_col:int;
			var item:piece_ref;
			var check_item:piece_ref;
			var bMatchMade:Boolean;
			
			item = board_array[ row ][ col ];
			
			for ( check_row = start_row; check_row <= end_row; ++check_row )
			{
				for ( check_col= start_col; check_col <= end_col; ++check_col )
				{
					if ( (col == check_col) && (row == check_row) ) continue;
					
//					item = board_array[ row ][ col ]; // moved outside the loop
					check_item = board_array[ check_row ][ check_col ];

					if ( (item.match_id == check_item.match_id) || (!(item.occupied || check_item.occupied)) )
					{
						// if both items are the same or empty then skip the swap & check since it doesn't change the board!!!!
						continue;
					}
					
					if ( (!_global.bpt2014_allow_diagonal_moves) && (!this.IsMoveValidRowOrColOnly( item, check_item )) ) continue;
					
					SwapItems( item, check_item, false );
						
					bMatchMade = OnePassCheckConnectivity( _global.purgatory_bIncludeDiagonalsInConnectivity );
						
					SwapItems( item, check_item, false );
						
					if ( bMatchMade )
					{
						hint_item_a = check_item;
						hint_item_b = item;
						
						// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
						
						ShowHints( nFramesSinceLastMove > nShowHintsAfterNFrames );
						
						hint_a_mc_front._x = board_positions_array[ hint_item_a.row ][ hint_item_a.col ].x;
						hint_a_mc_front._y = board_positions_array[ hint_item_a.row ][ hint_item_a.col ].y;
						hint_a_mc_back._x = board_positions_array[ hint_item_a.row ][ hint_item_a.col ].x;
						hint_a_mc_back._y = board_positions_array[ hint_item_a.row ][ hint_item_a.col ].y;
						
						hint_b_mc_front._x = board_positions_array[ hint_item_b.row ][ hint_item_b.col ].x;
						hint_b_mc_front._y = board_positions_array[ hint_item_b.row ][ hint_item_b.col ].y;
						hint_b_mc_back._x = board_positions_array[ hint_item_b.row ][ hint_item_b.col ].x;
						hint_b_mc_back._y = board_positions_array[ hint_item_b.row ][ hint_item_b.col ].y;

						// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
						
						return true;
					}
				}
			}
			
			return false;
		}
		
		private function CheckForAnyMoves_Step():Boolean
		{
			if ( bMovesSearchDone ) return false;
			
			bFoundMoveAtSearchLocation = CheckLocationForMoves( nRowMovesSearch, nColMovesSearch );

			if ( bFoundMoveAtSearchLocation )
			{
				return true;		
			}
			
			if ( board_cols > ++nColMovesSearch ) return true;
				
			nColMovesSearch = 0;
				
			if ( board_rows > ++nRowMovesSearch ) return true;
			
			bMovesSearchDone = true;
			
			return false;
		}
		
		private function BuildHistogramOfActiveBoard():void {
			
			var v:Vector.<piece_ref>;
			var p:piece_ref;
			
			for ( var i:int = 0; i < bpt2021_active_pieces_histogram.length; i++ )
			{
				bpt2021_active_pieces_histogram[ i ] = 0;
			}
			
			for ( var row:int = board_row_first; row < board_row_last; ++row ) {
				
				v = board_array[row];
				
				for ( var col:int = board_col_first; col < board_col_last; ++col ) {
					
					p = v[col];
				
					if ( p.occupied && (p.match_id != 0) ) {
						
						bpt2021_active_pieces_histogram[ p.match_id - 1 ]++;
						
					}
					
				}
				
			}
			
		}
		
		// -------------------------------------------------------------------------------------------------------
		
		private function CheckLocationForNonMatchingMoveTargets( row:int, col:int ):Boolean
		{
			var p:piece_ref;
			
			for ( var c:int = (col-1); c <= (col+1); c++ )
			{
				if ( 0 == c ) continue;
				
				p = board_array[row][c];
				
				if ( !p.occupied && (0 == p.match_id) ) {
					
					if ( (c >= board_col_first) && (c < board_col_last) )
					{
						return true;
					}
					
				}
			}
			
			return false;
		}
		
		private function CheckMetaBoardForPossibleNonMatchingRemoval():Boolean
		{
			if ( _global.bpt2014_allow_non_matching_moves_moves )
			{
				var p:piece_ref;
				var activePieces:int = 0;
				
				for ( var row:int = board_row_first; row < board_row_last; ++row ) {
					
					for ( var col:int = board_col_first; col < board_col_last; ++col ) {
						
						p = board_array[row][col];
					
						if ( p.occupied && (p.match_id != 0) ) {
							
							++activePieces;
							
							if ( null != meta_board[ row ][ col ] )
							{
								if ( CheckLocationForNonMatchingMoveTargets( row, col ) ) {
									
									return true;
									
								}
								
							}
							
						}
						
					}
					
				}
				
				var n:int = _global.bpt2021_remove_when_groups_larger_than * 2 + 1;
				
				if ( (n >= activePieces ) )
				{
					if ( 1 == (board_col_last - board_col_first) )
					{
						if ( _global.bpt2021_remove_when_groups_larger_than < activePieces )
						{
							trace( "BUGBUG - this is a stalemate or whatever to call it stops game progression " );
							return true;
						}
					}
					else
					{
						return true; // some movement is possible
					}
				}
				else
				{
					
					if ( 0 != meta_items_count )
					{
						return true;
					}
					else
					{
						trace( "BUGBUG Hello is this a stalemate (B)??" );
					}
					
				}
				
			}
			
			return false;
		}
		
		private function CheckActiveBoardElementsForPossibleMatches():Boolean
		{
			if ( _global.bpt2014_allow_non_matching_moves_moves )
			{
				BuildHistogramOfActiveBoard();
				
				for ( var i:int = 0; i < bpt2021_active_pieces_histogram.length; i++ )
				{
					var count:int = bpt2021_active_pieces_histogram[ i ];
					
					if ( (0 != count) && (count > _global.bpt2021_remove_when_groups_larger_than ) ) {
						
						return true;
						
					}
					
				}
				
				if ( 0 != meta_items_count )
				{
					var bResult = CheckMetaBoardForPossibleNonMatchingRemoval();
					
					if ( bResult )
					{
						return true;
					}
					else
					{
						trace( "why is there no possible moves being reported?" );
					}
				}
				else
				{
					trace("house wins :-) no meta items and no removal candidates");
				}
			}
			
			return false;
		}

		// -------------------------------------------------------------------------------------------------------
		
		private function CheckForAnyMoves():Boolean
		{
			if ( bBoardChanged )
			{
				RestartMovesSearch();
				bBoardChanged = false;
			}
			else
			{
				// if nothing has changed and we already found one simply manage the hints
			
				if ( bFoundMoveAtSearchLocation )
				{
					ShowHints( nFramesSinceLastMove > nShowHintsAfterNFrames );

					return true;
				}
			}
			
			for ( var i:int = 0; i < 2; ++i )
			{
				CheckForAnyMoves_Step();
				
				if ( bFoundMoveAtSearchLocation )
				{
					return true;
				}
			}
			
			if ( CheckForAnyMoves_Step() )
			{
				return true;
			}
			
			// ------------------------------------------------------------------------------------------

			if ( CheckActiveBoardElementsForPossibleMatches() )
			{
				return true;
			}
			else
			{
				// --------------------------------------------------------------------------------------
				
				trace( "BUGBUG - most likely this is a stalemate situation..." );
				
				return false; 
				
				// --------------------------------------------------------------------------------------
			}
			
			// ------------------------------------------------------------------------------------------
			
			return false;
		}

		// ---------------------------------------------------------
		
		private function DestroyBoardClips():void
		{
			var boardClip:piece_visual;
			var metaClip:game_asset_based_visual;
			var item:piece_ref;
			var meta:meta_ref;
			
			for ( var row:int = 0; row < board_rows; ++row )
			{
				var board_row:Vector.<piece_ref> = (null != board_array) ? (board_array[ row ]) : null;
				
				var meta_row:Vector.<meta_ref> = (null != meta_board) ? (meta_board[ row ]) : null;
				
				for ( var col:int = 0; col < board_cols; ++col )
				{
					if ( null != board_row )
					{
						item = board_row[ col ];
						
						if ( null != item )
						{
							if ( null != item.clip_mc ) {
								
								item.clip_mc.removeMovieClip();
								item.clip_mc = null;
								
							}
							
							item.pGroupHead = null;
							item.pGroupNext = null;
						}
					}
					
					if ( null != meta_row )
					{
						meta = meta_row[ col ];
						
						if ( null != meta )
						{
							metaClip = meta_row[ col ].clip_mc;
							
							if ( null != metaClip )
							{
								meta_row[ col ].clip_mc = null;
								
								metaClip.removeMovieClip();
							}
						}
					}
				}
				
			}
		}

		public function ShutdownDynamicElements():void
		{
			game_in_progress = false;
			
			//trace( "(!) START---Dumping remaining display list" );
			//DIAGNOSTIC_DumpDisplayList( Main.starlingRoot, "", "." );
			//trace( "(!) FINISH--Dumping remaining display list" );
			
			//CONSOLE << "BEGIN ShutdownDynamicElements()" << std::endl;

			selected_item = null; // piece_ref();
			src_swap_item = null; // piece_ref();
			dst_swap_item = null; // piece_ref();
			hint_item_a = null; // piece_ref();
			hint_item_b = null; // piece_ref();
			
			ResetConnectivityGroups();
			
			DestroyBoardClips();
			
			if ( null != board_array) board_array.length = 0; // clear();
			if ( null != meta_board) meta_board.length = 0; // clear();
			if ( null != board_positions_array ) board_positions_array.length = 0; // .clear();
			if ( null != count_array ) count_array.length = 0; // .clear();
			
			if ( null != hud_mc )
			{
				hud_mc.removeChild( dynamic_moves_display );
				hud_mc.removeChild( dynamic_score_display );
				hud_mc.parent.removeChild( hud_mc ); 
			}
			
			if ( null != action_mc )
			{
				action_mc.DisposeOfInternalClips();
				action_mc.removeMovieClip();
			}
			
			if ( null != active_boundaries_indicator_mc ) active_boundaries_indicator_mc.removeMovieClip();
			if ( null != mainboard_mc ) mainboard_mc.removeMovieClip();
			if ( null != metaboard_mc ) metaboard_mc.removeMovieClip();
			if ( null != particles_mc ) particles_mc.removeMovieClip();
			if ( null != selection_mc) selection_mc.removeMovieClip();
			if ( null != messages_mc ) messages_mc.removeMovieClip();
			if ( null != hint_a_mc_front ) hint_a_mc_front.removeMovieClip();
			if ( null != hint_b_mc_front ) hint_b_mc_front.removeMovieClip();
			if ( null != hints_mc_front ) hints_mc_front.removeMovieClip();
			if ( null != hint_a_mc_back ) hint_a_mc_back.removeMovieClip();
			if ( null != hint_b_mc_back ) hint_b_mc_back.removeMovieClip();
			if ( null != hints_mc_back ) hints_mc_back.removeMovieClip();
			if ( null != playfield_mc ) playfield_mc.removeMovieClip();
			if ( null != collected_stars_mc ) collected_stars_mc.removeMovieClip();
			if ( null != CONTAINER ) CONTAINER.removeMovieClip();

			active_boundaries_indicator_mc = null;
			mainboard_mc = null; // MovieClip_Ref();
			metaboard_mc = null; // MovieClip_Ref();
			particles_mc = null; // MovieClip_Ref();
			action_mc = null; // MovieClip_Ref();
			selection_mc = null; // MovieClip_Ref();
			messages_mc = null; // MovieClip_Ref();
			
			hints_mc_front = null; // MovieClip_Ref();
			hint_a_mc_front = null; // MovieClip_Ref();
			hint_b_mc_front = null; // MovieClip_Ref();
			
			hints_mc_back = null; // MovieClip_Ref();
			hint_a_mc_back = null; // MovieClip_Ref();
			hint_b_mc_back = null; // MovieClip_Ref();
			
			playfield_mc = null; // MovieClip_Ref();
			collected_stars_mc = null; // MovieClip_Ref();
			hud_mc = null; // MovieClip_Ref();
			CONTAINER = null; // MovieClip_Ref();
			
			board_cols = 0;
			board_rows = 0;
			board_row_first = 0;
			board_row_last = 0;
			board_col_first = 0;
			board_col_last = 0;
			
			nopickcandidateshelpercache = null;
			bpt2021_active_pieces_histogram = null;

			//CONSOLE << "DONE ShutdownDynamicElements()" << std::endl;
			
			//trace( "START---Dumping remaining display list" );
			//DIAGNOSTIC_DumpDisplayList( Main.starlingRoot, "", "." );
			//trace( "FINISH--Dumping remaining display list" );
		}
		
		/*
		private function DIAGNOSTIC_DumpDisplayList( d:DisplayObjectContainer, prefix:String, add:String ):void
		{
			var child:DisplayObject;
			
			for ( var i:int = d.numChildren; 0 <= --i; )
			{
				child = d.getChildAt( i );
				
				trace( prefix + child.name );
				
				try
				{
					var container:DisplayObjectContainer = child as DisplayObjectContainer;
					
					if ( null != container )
					{
						DIAGNOSTIC_DumpDisplayList( container, prefix + add, add );
					}
					
				}
				finally
				{
				}
				
			}
		}
		*/

		// ---------------------------------------------------------

		private function WaitForMovingThingsThenGotoAndStop( target:String, solved:Boolean ):onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
				
				if ( !(animating_item_count || moving_items_count || dropping_star_count) ) {
					
					if ( solved && (game_state.high_score < board_state.score) )
					{
						// trigger event???
						game_state.high_score = board_state.score;
					}
					
					//CONTAINER.gotoAndStop( target );
					
					// FIX.FIX.FIX.this probably should have a hide/show thing like the panels!!!!
					
					ShutdownDynamicElements();
					
					if ( solved && _global.bpt2014_increasing_difficulty_mode ) // this probably should be someplace else...
					{
						Core.instance.HandleIncreaseDifficulty();
						Core.instance.PrepareForNewBoard();
					}
					
					if ( _global.purgatory_demo_mode || (solved && _global.bpt2021_automatically_advance_to_next_round) )
					{
						_global.purgatory_use_last_board_layout = false;
						BOOTSTRAP_GAME_SESSION();
					}
					else
					{
						if ( solved )
						{
							Core.instance.GotoRoundClearPanel( target );
						}
						else
						{
							Core.instance.GotoNoMovesPanel( target );
						}
					}
				}
			};
			
			return closure;
		}

		// ---------------------------------------------------------
		
		private function MakeThrobClosure( scaleDelta:Number ):onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			var base_scale:Number = 0;
			
			closure.code = function():void {
				
				if ( 0 == base_scale )
				{
					base_scale = closure.mc._xscale;
				}
				
				closure.mc._xscale = base_scale + scaleDelta * Math.sin( getTimer() * 0.01 );
				closure.mc._yscale = closure.mc._xscale;
				
			}
			
			return closure
		}
		
		private function MakeScanClosure( delay:int ):onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			++animating_item_count;
			
			closure.code = function():void {
				
				if ( 0 >= delay )
				{
					--animating_item_count;
					
	//trace( "item " + closure.mc._name + " preparing for remove" );						
					
					closure.mc.onEnterFrame = RemoveElementClosure_ORIGINAL( OLD_30_FPS_TO_N_FPS(40), 0, 0 );
				}
				else
				{
					--delay;
				}
				
			}
			
			return closure
		}
		
		private function BoardOverAnimation():void
		{
			var c:Point = _xy_conversion_helper_1;
			c.x = _global.purgatory_stage_cx / 2;
			c.y = _global.purgatory_stage_cy / 2;
			c = messages_mc.globalToLocal( c );
			
			DispatchRisingObject(
				BaseGameSprite.CreateFromAsset( "board_over" ),
				"board_over",
				c.x, // _global.purgatory_stage_cx / 2,
				c.y, // _global.purgatory_stage_cy / 2,
				2,
				0xFFFFFFFF,
				120,
				30,
				1.0/120.0,
				0.125,
				false );
		}
		
		private function SuperJackpotAnimation():void
		{
			var c:Point = _xy_conversion_helper_1;
			c.x = _global.purgatory_stage_cx / 2;
			c.y = _global.purgatory_stage_cy / 2;
			c = messages_mc.globalToLocal( c );
			
			DispatchRisingObject(
				BaseGameSprite.CreateFromAsset( "super_jackpot" ),
				"super_jackpot",
				c.x, // _global.purgatory_stage_cx / 2,
				c.y, // _global.purgatory_stage_cy / 2,
				2,
				0xFFFFFFFF,
				120,
				30,
				1.0/120.0,
				0.125,
				false );
		}
		
		private function BonusModeAnimation():void
		{
			var c:Point = _xy_conversion_helper_1;
			c.x = _global.purgatory_stage_cx / 2;
			c.y = _global.purgatory_stage_cy / 2;
			c = messages_mc.globalToLocal( c );
			
			DispatchRisingObject(
				BaseGameSprite.CreateFromAsset( "bonus_mode" ),
				"bonus_mode",
				c.x, // _global.purgatory_stage_cx / 2,
				c.y, // _global.purgatory_stage_cy / 2,
				2,
				0xFFFFFFFF,
				120,
				30,
				1.0/120.0,
				0.125,
				false );
		}
		
		private function NoMoreMovesAnimation():void
		{
			var c:Point = _xy_conversion_helper_1;
			c.x = _global.purgatory_stage_cx / 2;
			c.y = _global.purgatory_stage_cy / 2;
			c = messages_mc.globalToLocal( c );
			
			DispatchRisingObject(
				BaseGameSprite.CreateFromAsset( "no_moves" ),
				"no_moves",
				c.x, // _global.purgatory_stage_cx / 2,
				c.y, // _global.purgatory_stage_cy / 2,
				2,
				0xFFFFFFFF,
				120,
				60, // was 30
				0.0625,
				0.125,
				false );
		}
		
		private function ScanAllRemainingItemsAnimation():void
		{
			NoMoreMovesAnimation();
			
			var item:piece_ref;
			var row_array:Vector.<piece_ref>
			
			var counter:int = 0;
			
			var bEven:Boolean = false
				
	//trace("**********************************************************");
			
			for ( var row:int = board_row_last; --row >= board_row_first; )
			{
				row_array = board_array[ row ];
				
				var cfirst:int = bEven ? board_col_first : board_col_last - 1;
				var clast:int = bEven ? board_col_last: (board_col_first - 1);
				var cdelta:int = bEven ? 1 : -1;
				bEven = !bEven;
				
				for ( var col:int = cfirst; col != clast; col += cdelta )
				{
					item = row_array[ col ];
					
					if ( item.occupied && (null != item.clip_mc) )
					{
						item.clip_mc.onEnterFrame = MakeScanClosure( counter );
						
						counter += OLD_30_FPS_TO_N_FPS( 2 );
						
						item.clip_mc = null; // detach...
						
						var meta:meta_ref = meta_board[ row ][ col ];
						
						if ( null != meta )
						{
							meta.clip_mc.onEnterFrame = MakeThrobClosure( 25 );
						}
						
					}
					
				}
				
			}
		}
		
		// ---------------------------------------------------------

		private function NoMovesDetection():void
		{
			if ( !(animating_item_count || moving_items_count || dropping_star_count) )
			{
				if ( bFinalNoMoreMoves )
				{
					--nNoMovesCountDown;
					
					if ( 1 == nNoMovesCountDown )
					{
						var pendingLossSound = !(bpt2021_PendingOCDMode && _global.bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode );

						if ( pendingLossSound )
						{
							START_SFX( sfx_no_moves );
						}
						else
						{
							if ( board_col_first == board_col_last )
							{
								START_SFX( sfx_super_jackpot );
								SuperJackpotAnimation();
							}
							else
							{
								if ( bpt2021_PendingOCDMode )
								{
									START_SFX( sfx_winner ); // 
								}
								
							}
						}
						
						ScanAllRemainingItemsAnimation();
					}
					else if ( 0 >= nNoMovesCountDown )
					{
						// -----------------------------------------------------------------------------------
						
						if ( bpt2021_PendingOCDMode && _global.bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode ) {
							
							/* need to detect and reward clearing the board during ocd mode... */

							playfield_mc.onEnterFrame = WaitForMovingThingsThenGotoAndStop( "board_cleared", true ); // since the meta board was cleared we still 'won'
							return;
							
						} 
						
						// -----------------------------------------------------------------------------------
						
						game_state.last_board_remaining_stars = meta_items_count;
						game_state.last_board_fewest_remaining_stars = Math.min( game_state.last_board_fewest_remaining_stars, meta_items_count );
						game_state.current_streak = 0;
						
						_global.purgatory_use_last_board_layout = _global.purgatory_replay_on_board_loss;
						playfield_mc.onEnterFrame = WaitForMovingThingsThenGotoAndStop( "no_moves", false );
						
					}
					
				}
				else if ( !CheckForAnyMoves() )
				{
					bFinalNoMoreMoves = true;
					nNoMovesCountDown = OLD_30_FPS_TO_N_FPS(45);
				}
			}
			
		}

		// ---------------------------------------------------------

		private function HandleAutoPlay():void
		{

		/// AUTOPLAY THEORY (USING HINTS)
			
			if ( !_global.purgatory_demo_mode ) return;
		
		///*
			if ( moving_items_count || animating_item_count
				|| bPendingPackRequest || bPendingCollectMetaItems || bCheckForEmptyColumns || bCheckForMatch )
			{
				return;
			}
			
			if ( bFoundMoveAtSearchLocation && (null != hint_item_a) && (null != hint_item_b) && hints_mc_front._visible )
			{
				if ( (OLD_30_FPS_TO_N_FPS(10) < nFramesSinceLastMove) && (!( moving_items_count || animating_item_count )) )
				{
					if ( IsMoveValid( hint_item_a, hint_item_b ) )
					{
						nRemovalsInARow = 0;
						nFramesSinceLastMove = 0;
						
						SetBoardAsChanged();
						
						++game_state.last_board_moves;
						++game_state.total_moves;
						
						SwapItems( hint_item_a, hint_item_b, true );
						
						bCheckForMatch = true;
						
						HideHints();
						
						nShowHintsAfterNFrames = OLD_30_FPS_TO_N_FPS(30*15);
							
						START_SFX( sfx_swap_noise );
					}
				}
			}
			
		//*/
			
		/// AUTOPLAY MODE

		}

		// ---------------------------------------------------------
		
		private var move_txt:String = " Swap";
		private var moves_txt:String = " Swaps";
		
		private function UpdateHUD():void
		{
			var border:int = 2;
			
			if ( (null != dynamic_moves_display) && ((0 < game_state.last_board_moves) || _global.bpt2014_increasing_difficulty_mode) )
			{
				if ( _global.bpt2014_increasing_difficulty_mode )
				{
					dynamic_moves_display.SetText(
						"board: " + _global.bpt2014_current_difficulty_progression +
						" [" + _global.purgatory_nPieces + "," + (_global.purgatory_board_rows - 2) + "x" + (_global.purgatory_board_cols - 2) + "]"
					);
				}
				else
				{
					dynamic_moves_display.SetText( game_state.last_board_moves + ((1 != game_state.last_board_moves ) ? moves_txt : move_txt) );
				}
				
				dynamic_moves_display.x = _global.purgatory_stage_cx - (dynamic_moves_display.width / 2) - border - 40;
				dynamic_moves_display.y = border + (dynamic_moves_display.height / 2);
				
				if ( 1 > dynamic_moves_display.alpha )
				{
					dynamic_moves_display.alpha += 0.125;
					
					if ( 1 < dynamic_moves_display.alpha ) dynamic_moves_display.alpha = 1;
				}
			}
			
			if ( null != dynamic_score_display )
			{
				if ( board_state.score != display_score )
				{
					var delta:int = (board_state.score - display_score) * 0.15;
					
					if ( 0 == delta ) delta = 1;
					
					display_score += delta;
					dynamic_score_display.SetText( "Score: " + display_score );
				}
				
				if ( 1 > dynamic_score_display.alpha )
				{
					dynamic_score_display.alpha += 0.125;
					
					if ( 1 < dynamic_score_display.alpha ) dynamic_score_display.alpha = 1;
				}
				
			}
			
		}
		
		// ---------------------------------------------------------
		
		private var indicatorActiveCounter:int = 0;
		
		private function HandleActionIndicators():void
		{
			var item:piece_ref;
			var col:int, row:int;
			
			//var phase:Number = Math.sin( getTimer() * 0.0025 );
			
			var bIndicatorActive:Boolean = (null != selected_item) && bSwapCursorActive && (!(animating_item_count || moving_items_count));
			
			if ( bIndicatorActive )
			{
				++indicatorActiveCounter;
			}
			else
			{
				indicatorActiveCounter = 0;
			}
			
			if ( 20 > indicatorActiveCounter )
			{
				bIndicatorActive = false; // only do the fade after a slight pause
			}
			
			var targetAlpha:Number = bIndicatorActive ? 25 : 100;
			var coeff:Number = bIndicatorActive ? 0.2 : 0.3;
			var sel_row:int, sel_col:int;
			
			var area_row_min:int, area_row_max:int, area_col_min:int, area_col_max:int;
			
			if ( bIndicatorActive )
			{
				sel_row = selected_item.row;
				sel_col = selected_item.col;
				area_row_min = sel_row - 2;
				area_row_max = sel_row + 2;
				area_col_min = sel_col - 2;
				area_col_max = sel_col + 2;
			}
			
			var bInArea:Boolean = false;
			
			var bInnerMostArea:Boolean = false;
			
			var v:Number = 100;
			
			var a:Number = targetAlpha;
			
			for ( row = board_row_first; row < board_row_last; ++row )
			{
				for ( col = board_col_first; col < board_col_last; ++col )
				{
					item = board_array[ row ][ col ];
					
					if ( bIndicatorActive )
					{
						bInArea = ( (area_row_min <= row) &&
							(area_row_max >= row) && (area_col_min <= col) && (area_col_max >= col) );
							
						if ( bInArea )
						{
							bInnerMostArea = (Math.abs( row - sel_row ) <= 1) && (Math.abs( col - sel_col ) <= 1);
							
							v = (bInnerMostArea) ? 100 : 50;
						}
							
						a = bInArea ? v : targetAlpha;
					}

					if ( item.occupied && (null != item.clip_mc) )
					{
						item.clip_mc._alpha += (a - item.clip_mc._alpha) * coeff;
						
						item.clip_mc._xscale += ((bInnerMostArea ? (100 + (5)) : 100) - item.clip_mc._xscale) * (coeff * 2);
						item.clip_mc._yscale = item.clip_mc._xscale;
						
					}

					if ( null != meta_board[ row ][ col ] )
					{
						if ( null != meta_board[ row ][ col ].clip_mc )
						{
							meta_board[ row ][ col ].clip_mc._alpha += (a - meta_board[ row ][ col ].clip_mc._alpha) * coeff;
						}
					}
				}
			}
		}
		
		// ---------------------------------------------------------

		private function CreateGameOnEnterFrameLogic():onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
				
				UpdateHUD();
				
				// ----------------------------------------------------------------
				
				if ( null != stage )
				{
					var delta:Number = 1 / stage.frameRate;
					game_state.last_board_seconds += delta;
					game_state.total_seconds_playing += delta;
				}
				
				// ----------------------------------------------------------------

				if ( _MOUSEBUTTONDOWN != _LAST_MOUSEBUTTONDOWN )
				{
					if ( _MOUSEBUTTONDOWN && (!_LAST_MOUSEBUTTONDOWN) )
					{
						// POSSIBLE PRESS EVENT
						ManageSwapCursorOnPress();
					}
					else if ( _LAST_MOUSEBUTTONDOWN  && (!_MOUSEBUTTONDOWN) )
					{
						// POSSIBLE RELEASE EVENT
						ManageSwapCursorOnRelease();
					}
				}
				else
				{
					if ( _MOUSEBUTTONDOWN )
					{
						// POSSIBLE DRAG EVENT
					}
				}

				// ----------------------------------------------------------------
				
				ZOOM_ManageZoomArea();
				
//				HandleActionIndicators();
				HandleAutoPlay();
				
				// ----------------------------------------------------------------
				
				if ( ContinuePendingRemovals() )
				{
				}
				else if ( !animating_item_count )
				{
					if ( bCheckForMatch && (!moving_items_count) )
					{
						if ( CheckForRemovals() )
						{
							// ???
						}
						else
						{
							bCheckForMatch = false;
					
							//if ( (piece_ref() != src_swap_item) && (piece_ref() != dst_swap_item) ) {
							if ( (null != src_swap_item) && (null != dst_swap_item) ) {
								
								// last move produced no match do something
					
								SetBoardAsChanged();
								
								do {
								
									if ( _global.bpt2014_allow_non_matching_moves_moves )
									{
										if ( IsItemInsideMainBoard( src_swap_item) && IsItemInsideMainBoard( dst_swap_item ) )
										{
											bCheckForEmptyColumns = true;
											bPendingCollectMetaItems = true;
											bPendingPackRequest = true;
											bCheckForMatch = true;
											break;
										}
										
										// if the piece is moved outside the normal board it should swap back
									}
									
									// undo the move
									
									SwapItems( src_swap_item, dst_swap_item, true );
									START_SFX( sfx_unswap_noise );
									
								} while ( false );
						
								src_swap_item = null; // piece_ref();
								dst_swap_item = null; // piece_ref();
							}
						}
					}
					
					if ( !moving_items_count )
					{
						if ( bPendingPackRequest )
						{
							bPendingPackRequest = false;
		
							if ( _global.purgatory_going_down )
							{
								PackBoardDownwards();
							}
							else
							{
								PackBoardUpwards();
							}
							
							if ( _global.bpt2014_keep_board_full ) {
								
								FillBoardHoles();
								
							}
					
						}
						else if ( bPendingCollectMetaItems )
						{
							bPendingCollectMetaItems = false;
							CollectMetaItems();
					
						}
						else if ( bCheckForEmptyColumns )
						{
							bCheckForEmptyColumns = RemoveEmptyColumns();
							bCheckForMatch = true;
						}
						
						if ( _global.bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode && bpt2021_PendingOCDMode )
						{
							/* gross NOP mode to let the player keep playing after meta board clearing */
						}
						else if ( (!meta_items_count) && (!animating_item_count) && (!moving_items_count) )
						{
							++game_state.current_streak;
							++game_state.total_boards_solved;
							
							if ( game_state.last_board_moves < game_state.min_moves_to_solve )
							{
								// trigger event?
								game_state.min_moves_to_solve = game_state.last_board_moves;
							}
							
							if ( game_state.current_streak > game_state.longest_winining_streak )
							{
								// trigger event?
								game_state.longest_winining_streak = game_state.current_streak;
							}

							
							// -----------------------------------------------------------------------------------
							
							trace( "TODO - decide if this is the right place for this" );
					
							_global.purgatory_use_last_board_layout = false;
							
							// -----------------------------------------------------------------------------------
							
							if ( _global.bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode ) {
								
								var bPossibleMatchesDetected:Boolean = CheckActiveBoardElementsForPossibleMatches();
								
								var bNoMetaItems:Boolean = (0 == meta_items_count);
								
								if ( bNoMetaItems && bPossibleMatchesDetected ) {
									
									trace("ENTERING PENDING OCD MODE!!!! ------------------------------------------------------------"); // reminder of what a gross hack this is to keep playing after
									
									START_SFX( sfx_bonus_mode ); // START_SFX( sfx_board_cleared );
									BonusModeAnimation();
									
									bpt2021_PendingOCDMode = true;
									return;
									
								}
								else if ( bPossibleMatchesDetected )
								{
									trace("Does this state make any sense???");
								}
								else
								{
									trace("BUGBUG - HMMM is this a stalemate (A) or a win condition?? I'm declaring it a win");
									
									BoardOverAnimation();
									
									if ( bNoMetaItems && (0 < game_state.last_board_retries) )
									{
										START_SFX( sfx_board_cleared );
									}
									else
									{
										START_SFX( sfx_board_over );
									}
									
								}
							}
							else
							{
								if ( board_col_first == board_col_last )
								{
									START_SFX( sfx_super_jackpot );
									SuperJackpotAnimation();
								}
								else
								{
									START_SFX( sfx_board_cleared );
								}
							}
							
							// -----------------------------------------------------------------------------------
							
							playfield_mc.onEnterFrame = WaitForMovingThingsThenGotoAndStop( "board_cleared", true ); // end of everything....
							return;
						}
					}
					else
					{
						// IDLE TIME??
					}
			
				}
		
				// ------------------------------------------------------------------------
		
				if ( !(bSwapCursorActive || animating_item_count || moving_items_count) )
				{
					NoMovesDetection();
				}
		
				++nFramesSinceLastMove;
		
				// -------------------------------------------------------------------------

			};
			
			return closure;
		}

		// ---------------------------------------------------------
		
		private function SlotMachineRotateClosure( nFrames:int, clip_mc:IActSomethingtLikeAMovieClipFromAS2, yPos:int, row:int, col:int ):onEnterFrame_Ref
		{
			//nFrames *= 2;
			
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			var h:Number = (board_positions_array[ board_row_last ][ col ].y -
				board_positions_array[ board_row_first ][ col ].y);
				
			++moving_items_count;
			
			var activeRows:int = board_row_last - board_row_first;
			
			var N:int = nFrames;
			
			closure.code = function():void {
				
				var t:Number = nFrames / (N - 1);
				
				var rr:int = ((row + (N * (1 - t))) % activeRows) + board_row_first;
				
				clip_mc._y = board_positions_array[ rr ][ col ].y;
				
				var phi:Number = ((col + 1) * t * t) * 0.01;
				
				clip_mc._xscale = clip_mc._yscale = 50 + ((200 - Math.sin( phi ) * 100) / 3) * Math.sin( rr * Math.PI / board_rows );
				
				if ( 0 >= --nFrames )
				{
					START_SFX( sfx_slot_stop );

					--moving_items_count;
					
					clip_mc._y = yPos;
					
					clip_mc._xscale = clip_mc._yscale = 100;
					
					clip_mc.onEnterFrame = null;
					
				}
			};
			
			return closure;
		}

		// ---------------------------------------------------------

		private function DelayedDropClosure( nDelay:int, clip_mc:IActSomethingtLikeAMovieClipFromAS2, pos:Point, onDropSetVisible:IActSomethingtLikeAMovieClipFromAS2 = null ):onEnterFrame_Ref
		{
			++moving_items_count; // mark item as moving  
			
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			clip_mc._visible = false;
			clip_mc._xscale = 50;
			clip_mc._yscale = 50;
			
			closure.code = function():void {
				
//trace( clip_mc._name + " has " + nDelay + " more frames to delay" );				
				
				if ( 0 <= --nDelay ) return;
				
				clip_mc._visible = true;
				
				if ( null != onDropSetVisible ) onDropSetVisible._visible = true;

				--moving_items_count; // release moving count
			
				clip_mc.onEnterFrame = EaseToOnEnterFrameClosure(
					pos.x
				,	pos.y
				,	0.33
				,	[
						{ property:"_rotation", start:360.0*(Math.random()-0.5)*2.0, end:0.0, blend:0.66 },
						{ property:"_xscale", start:150.0, end:100.0, blend:0.25 },
						{ property:"_yscale", start:150.0, end:100.0, blend:0.25 },
//						{ property:"_alpha", start:0.0, end:100.0, blend:0.66 }
					]
				,	2
				);
			};
			
			return closure;
		}

		// ---------------------------------------------------------

		private function GenerateRandomPieceMatchID( nPieces:int ):int
		{
			var idx:int = Math.round( (Math.random() * (nPieces - 1)));
			
			return _global.purgatory_active_pieces[ idx ];
			
//			return (Math.round( (Math.random() * (nPieces - 1))) + 1); // [1 to n]
		}

		private function SetupItemType( item:piece_ref, match_id:int ):void
		{
			item.match_id = match_id;
			
			//if ( null != item.clip_mc ) item.clip_mc.SetType( match_id );
		}

		private function SetupRandomItemType( item:piece_ref ):void
		{
			SetupItemType( item, GenerateRandomPieceMatchID(_global.purgatory_nPieces) );
		}

		private function CreateBoardArrays( target_mc:GameSprite_Ref, rows:int, cols:int, cx:int, cy:int ):void
		{
			var row:int, col:int;
			
			item_cx = cx;
			item_cy = cy;
			
			// never referenced???
			//_global.current_item_size_cx = item_cx;
			//_global.current_item_size_cy = item_cy;
			
			// create the board
			
			board_rows = rows;
			board_row_first = 1;
			board_row_last = rows - 1;
			
			board_cols = cols;
			board_col_first = 1;
			board_col_last = cols - 1;
			
			// fill in the counts for each col
			
			count_array.length = cols; // .resize( cols );
//			std::fill( count_array.begin(), count_array.end(), 0 ); // BPT.FIX
			
			// create the board array

			board_array.length = rows; // resize( rows );
			meta_board.length = rows; // resize( rows );
			board_positions_array.length = rows; // resize( rows );
			
			for ( var i:int = 0; i < rows; ++i )
			{
				board_array[ i ] = new Vector.<piece_ref>( cols ); // .length = cols; / / resize( cols );
 				meta_board[ i ] = new Vector.<meta_ref>( cols ); // .length = cols; // resize( cols );
				board_positions_array[ i ] = new Vector.<Point>( cols ); // .length = cols; // resize( cols );
			}
			
			// fill in the board and create the elements

			var xPos:int = 0;
			var yPos:int = cy/2;
			var nDepth:int = 1;
			
			for ( row = 0; row < rows; ++row ) {
				
				xPos = cx/2;
				
				for ( col = 0; col < cols; ++col ) {

					var bInsideBorderItem:Boolean = ((col >= board_col_first) && (col < board_col_last)) &&
						((row >= board_row_first) && (row < board_row_last));

					if ( bInsideBorderItem ) ++count_array[ col ];
					
					//piece_ref item = piece_ref( new piece_t( row, col, bInsideBorderItem ) ); // { row:row, col:col, occupied:true };
					var item:piece_ref = new piece_ref( row, col, bInsideBorderItem );
					
					board_array[ row ][ col ] = item;
					board_positions_array[ row ][ col ] = new Point( xPos, yPos ); // .set( xPos, yPos ); // = { x:xPos, y:yPos };
					
					//meta_board[ row ][ col ] = meta_ref(); // need to decide...
					
					xPos += cx;
					
				}
				
				yPos += cy;

			}
		}

		private function SetupMetaBoard( target_mc:GameSprite_Ref, metaColLayout:Vector.<int>, originPoint:Point ):void
		{
			var row:int, col:int;
			
			var count:int = 0;
			
			meta_items_count = 0;
			
			var nDepth:int = 1;
			
			for ( col = board_col_first; col < board_col_last; ++col )
			{
				++meta_items_count;
				
				// ------------------------------------------------------------------------
				
				// show a placeholder star in the collected area
				
				var ph_mc:game_asset_based_visual = game_asset_based_visual.Alloc( "meta_star" ); //"gfx_star" );
				ph_mc._name = HELPER_MakeDyanmicID( "precollected_", meta_items_count );
				collected_stars_mc.addChild( ph_mc );

				ph_mc._x = (nNextStarRemovedIndicatorXPos + nNextStarRemovedIndicatorXDelta * (meta_items_count - 1));
				ph_mc._y = nNextStarRemovedIndicatorYPos;
				ph_mc._xscale = 75.0;
				ph_mc._yscale = 75.0;
				ph_mc._visible = false;
				ph_mc._alpha = 50;
				
				if ( _global.bpt2014_keep_board_full ) { // BPT.2014.09.03.HACK - to make stars invisible ;)
					ph_mc._alpha = 0;
				}
				
				// probably should have a trigger animation as each one lands...
				
				// ------------------------------------------------------------------------
				
				row = metaColLayout[ col ];
				
				var meta_item:meta_ref = new meta_ref();
				
				// ------------------------------------------------------------------------
				
				/*
				meta_item.clip_mc = target_mc.attachMovie(
					"gfx_star"
				,	HELPER_MakeDyanmicID( "meta_", (row * board_cols) + col )
				,	nDepth++ // target_mc.getNextHighestDepth()
				);
				*/
				
				meta_item.clip_mc = game_asset_based_visual.Alloc( "meta_star" ); //"gfx_star" );
				meta_item.clip_mc._name = HELPER_MakeDyanmicID( "meta_", (row * board_cols) + col );
				target_mc.addChild( meta_item.clip_mc );
				
				if ( _global.bpt2014_keep_board_full )
				{	
					meta_item.clip_mc.alpha = 0; // BPT.2014.09.03.HACK - to make stars invisible ;)
				}
				else
				{
					meta_item.clip_mc.alpha = 1; // make sure the meta item is visible
				}
				
				// ------------------------------------------------------------------------
				
				if ( null != originPoint ) {
					
					meta_item.clip_mc._x = originPoint.x;
					meta_item.clip_mc._y = originPoint.y;
					
				} else {

					meta_item.clip_mc._x = board_positions_array[ row ][ col ].x;
					meta_item.clip_mc._y = (item_cy * -2);
					
				}
				
				meta_item.clip_mc.onEnterFrame = DelayedDropClosure(
					OLD_30_FPS_TO_N_FPS( 0 /*30*/ + (1 + col) * 2 * 2 )
				,	meta_item.clip_mc
				,	board_positions_array[ row ][ col ]
				,	ph_mc
				);
				
				meta_board[ row ][ col ] = meta_item;

			}
		}

		// ---------------------------------------------------------
		
		private function LargestActiveRowCount():int {
			
			var v:Vector.<piece_ref>;
			var p:piece_ref;
			var count:int = 0;
			
			for ( var row:int = board_row_first; row < board_row_last; ++row ) {
				
				v = board_array[row];
				
				for ( var col:int = board_col_first; col < board_col_last; ++col ) {
					
					p = v[col];
				
					if ( p.occupied && (p.match_id != 0) ) {
						++count;
						break;
					}
					
				}
				
			}
			
			return count;
		}
		
		
		private function CountRows( bActiveRowsAndColumns:Boolean ):int {
			return ((bActiveRowsAndColumns) ? LargestActiveRowCount() + 2 : board_rows);
		}
		
		private function CountCols( bActiveRowsAndColumns:Boolean ):int {
			return ((bActiveRowsAndColumns) ? (board_col_last - board_col_first) + 2 : board_cols);
		}
		
		// ---------------------------------------------------------
		
		private function FitBoardToFillMostOfStageArea( bActiveRowsAndColumns:Boolean ):void
		{
			var bh:Number = item_cy * CountRows( bActiveRowsAndColumns );
			var bw:Number = item_cx * CountCols( bActiveRowsAndColumns );
			
			var xfitscale:Number = ((Number)(_global.purgatory_stage_cx) * 100.0) / bw;
			var yfitscale:Number = ((Number)(_global.purgatory_stage_cy) * 100.0) / bh;
			
			var scale:Number = Math.min( xfitscale, yfitscale );
			
			playfield_mc._xscale = scale;
			playfield_mc._yscale = scale;
		}
		
		// ---------------------------------------------------------

		private function WaitForSetupThenStartPlayingClosure():onEnterFrame_Ref
		{

// ****************************************************************************
// ****************************************************************************

			if ( _global.purgatory_board_scaling_enabled )
			{
				FitBoardToFillMostOfStageArea( false );
			}

// ****************************************************************************
// ****************************************************************************

			CenterPlayfield(); // needs to be smarter...

			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
				
//trace( "animating_item_count = " + animating_item_count + ", moving_items_count = " + moving_items_count ); 
				
				if ( (!animating_item_count) && (!moving_items_count) ) {
			
					playfield_mc.onEnterFrame = CreateGameOnEnterFrameLogic();
					
//trace( "starting game???" );					
			
	//				mainboard_mc.onPress = ManageSwapCursorOnPress; // NEED TO FIGURE OUT!!!
			
				}
			};
			
			return closure;
		}

		// --------------------------------------------------------------------
		
		private function __OLD_30_FPS_TO_N_FPS__( x:int ):int
		{
			//if ( _global.purgatory_demo_mode ) return x;
			
			return OLD_30_FPS_TO_N_FPS(x);
		}
		
		private function CenteredPyramidDropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__( (int)(( Math.abs(col - board_cols/2) * 2.5) + ((_global.purgatory_going_down ? (board_rows - row) : (row) )* 5))+1 )
		}

		private function CenteredPyramid2DropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__( Math.abs(board_rows/2 - row) + Math.abs(board_cols/2 - col) + 1 );;
		}
		
		private function GroupedRowsDropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__( (board_rows - row) * 5 + 1 );
		}
		
		private function GroupedColsDropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__( col * 5 + 1 );
		}
		
		private function RowsPlusColsDropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__( row + col + 1 );
		}

		private function InverseRowsPlusColsDropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__( (board_rows - row) + (board_cols - col) + 1 );;
		}

		private function HmmmDropCalc():Function
		{
			var fn:Function = PickCalculateDelayFunctionForPieceForDropAnimationCore();
			
			var whoa:Number = (Math.random() * 4.0);
			
			return function( row:int, col:int, itemNumber:int ):int {
			
				row = Math.abs((1.0 - Math.sin( whoa * 3.141592 * row / (board_rows-1) )) * board_rows);
				col = Math.abs((1.0 - Math.sin( whoa * 3.141592 * col / (board_cols-1) )) * board_cols);
				
				return Math.min( __OLD_30_FPS_TO_N_FPS__(30), fn(row,col,itemNumber) );
			}
		}
		
		private function CheckersDropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__(( (row ^ col) & 1) + (row + col) );
		}
		
		private function CascadeNDropCalc( row:int, col:int, itemNumber:int ):int
		{
			return __OLD_30_FPS_TO_N_FPS__( (col+row) + ((col & 1) ? (board_cols - col) : (col)) + row );
		}
		
		// --------------------------------------------------------------------------------
		
		/*
		private function ZigZagFindXY( row:int, col:int, total:int ):int
		{
			var dr:int = 1;
			var dc:int = 0;
			var r:int = 0;
			var c:int = 0;
			
			for ( var i:int = 0; i < total; ++i )
			{
				if ( (r == row) && (c == col) ) return i;
				
				r += dr;
				c += dc;
				
				if ( 0 == r )
				{
					++dr;
					if ( 0 != dr ) dc = -dc;
				}
				
				if ( 0 == c )
				{
					++dc;
					if ( 0 != dc ) dr = -dr;
				}
				
			}
			
			return total;
		}
		*/
		
		private function ZigZagCalcRowMajor( row:int, col:int, itemNumber:int ):int
		{
			if ( 0 != (row & 1) ) return (row * board_cols)+col; 
			return (board_rows * board_cols) - ((board_rows - row) * board_cols)+(board_cols - col);
		}
		
		private function ZigZagCalcColMajor( row:int, col:int, itemNumber:int ):int
		{
			if ( 0 != (col & 1) ) return (col * board_rows)+row; 
			return (board_rows * board_cols) - ((board_cols - col) * board_rows)+(board_rows - row);
		}

		// --------------------------------------------------------------------------------
		
		private function RandRandDelayCalc():Function
		{
			var fn1:Function = PickCalculateDelayFunctionForPieceForDropAnimation(false);
			
			var fn2:Function = PickCalculateDelayFunctionForPieceForDropAnimation(false);
			
			return function( row:int, col:int, itemNumber:int ):int {
				
				var n:int = fn1( row, col, itemNumber );
				
				return fn2( n / board_rows, n % board_cols, itemNumber );
				
			}
			
		}
		
		// --------------------------------------------------------------------------------

		private function CrossBoardDelayCalcGenerator( modulo:int ):Function
		{
			return function( row:int, col:int, itemNumber:int ):int {
				
				return Math.min( modulo-(col%modulo), modulo-(row%modulo) ) * board_rows; 
				
			}
		}
		
		// --------------------------------------------------------------------------------
		
		private function TestCalc2( row:int, col:int, itemNumber:int ):int
		{
			return 1;
			//return CrossBoardDelayCalcGenerator( 1 + Math.floor( Math.random() * 5 ) ); 
		}
		
		// --------------------------------------------------------------------------------
		
		private function PickCalculateDelayFunctionForPieceForDropAnimationCore():Function
		{
			switch ( (int)(Math.random() * 9) ) {
				case 0: return CenteredPyramidDropCalc;
				case 1: return GroupedColsDropCalc;
				case 2: return RowsPlusColsDropCalc;
				case 3: return InverseRowsPlusColsDropCalc;
				case 4: return CenteredPyramid2DropCalc;
				case 5: return CascadeNDropCalc;
				case 6: return ZigZagCalcColMajor;
				case 7: return ZigZagCalcRowMajor;
				case 8: return CrossBoardDelayCalcGenerator( 1 + Math.floor( Math.random() * 8 + 0.5 ) );
			}
			
			return CheckersDropCalc; //CenteredPyramidDropCalc; 
		}
		
		private function PickCalculateDelayFunctionForPieceForDropAnimation( bAllowBizzare:Boolean = true ):Function
		{
			//if ( bAllowBizzare && (0.1 < Math.random()) ) return RandRandDelayCalc(); 
			return PickCalculateDelayFunctionForPieceForDropAnimationCore();
		}
		
		// --------------------------------------------------------------------
		
		private function UseSlotMachineDrop():Boolean
		{
			return false;
		}

		private function DynamicBoardFillClosure(
			fnAfterOnEnterFrame:onEnterFrame_Ref,
			boardLayout_array:Vector.< Vector.<int> >,
			metaBoardLayout_array:Vector.<int> ):onEnterFrame_Ref
		{
			var rowCounter:int = board_rows;
			var idNumber:int = 1;
			
			var startCol:int, endCol:int, deltaCol:int;
			
			var nStartFromYPostion:int = _global.purgatory_going_down ? (item_cy * -4) : (_global.purgatory_stage_cy + (item_cy * 2));

			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();

			START_SFX( sfx_lucky_spin );
			
			var fnDropDelay:Function = PickCalculateDelayFunctionForPieceForDropAnimation();
			
			var pieceOriginPoint:Point = null;
			var metaOriginPoint:Point = null;
			
			if ( 0.8 > Math.random() ) {
				
				var rr:int = (int)(Helpers.Rnd( 0, board_rows - 1 ));
				var rc:int = (int)(Helpers.Rnd( 0, board_cols - 1 ));
				pieceOriginPoint = board_positions_array[ rr ][ rc ];
				
				rr = (int)(Helpers.Rnd( 0, board_rows - 1 ));
				rc = (int)(Helpers.Rnd( 0, board_cols - 1 ));
				metaOriginPoint = board_positions_array[ rr ][ rc ];
				
			}

			closure.code = function():void {
				
				for ( var loops:int = (UseSlotMachineDrop() ? board_rows : 1); 0 <= --loops; )
				{
					--rowCounter;
				
					var nDelayCounter:int = 0;
				
					startCol = board_cols - 1;
					endCol = -1;
					deltaCol = -1;
					
					for ( var col:int = startCol; col != endCol; col += deltaCol, ++nDelayCounter )
					{
						var bInsideBorderItem:Boolean = ((col >= board_col_first) && (col < board_col_last)) &&
							((rowCounter >= board_row_first) && (rowCounter < board_row_last));
					
						var item:piece_ref = board_array[ rowCounter ][ col ];
					
						if ( bInsideBorderItem ) // bpt.2014
						{
							var id_str:String = HELPER_MakeDyanmicID( "id_", idNumber++ );
							
							// --------------------------------------------------------------------

							item.clip_mc = piece_visual.Alloc( boardLayout_array[ rowCounter ][ col ] );
							
							item.clip_mc._name = id_str;
							
							mainboard_mc.addChild( item.clip_mc ); //, mainboard_mc.getNextHighestDepth() ); //idNumber ); // adoptChildAtDepth( item.clip_mc, idNumber );
	
							// --------------------------------------------------------------------
							
							item.clip_mc._x = board_positions_array[ rowCounter ][ col ].x;
							
							if ( UseSlotMachineDrop() )
							{
								item.clip_mc._y = board_positions_array[ rowCounter ][ col ].y;
								
								if ( bInsideBorderItem )
								{
									item.clip_mc.onEnterFrame = SlotMachineRotateClosure(
										OLD_30_FPS_TO_N_FPS((col + 2) * 7)
									,	item.clip_mc
									,	board_positions_array[ rowCounter ][ col ].y
									,	rowCounter
									,	col
									);
								}
							}
							else
							{
								item.clip_mc._y = nStartFromYPostion;
								
								if ( null != pieceOriginPoint )
								{
									item.clip_mc._x = pieceOriginPoint.x;
									item.clip_mc._y = pieceOriginPoint.y;
								}
								
								item.clip_mc.onEnterFrame = DelayedDropClosure(
									fnDropDelay( rowCounter, col, idNumber )
								,	item.clip_mc
								,	board_positions_array[ rowCounter ][ col ]
								);
							}
						}
						
						SetupItemType( item, boardLayout_array[ rowCounter ][ col ] );
					}
				
					if ( 0 == rowCounter ) {
						
						// TODO.2014 - add support for multiple meta board layouts
				
						SetupMetaBoard( metaboard_mc, metaBoardLayout_array, metaOriginPoint );
					
						playfield_mc.onEnterFrame = fnAfterOnEnterFrame;
					
					}
				}
			};
			
			return closure;
		}

		// ---------------------------------------------------------

		private function CreateLayoutArray( layout:Vector.< Vector.<int> >, rows:int, cols:int ):void
		{
			layout.length = rows; // resize( rows );
			
			for ( var row:int = 0; row < rows; ++row ) {
				
				layout[ row ] = new Vector.<int>( cols ); // .length = cols; // resize( cols );
				
			}
		}

		// ---------------------------------------------------------

		// this same concept should be used to check for the quick matches....

		private function QuickMatch3CheckLayoutAreaForMatch( row:int, col:int, layout:Vector.< Vector.<int> >, bFarEnoughForRowChecks:Boolean ):Boolean
		{
			var id:int = layout[ row  ][ col ];
			
			if ( bFarEnoughForRowChecks && (id == layout[ row - 1 ][ col ]) && (id == layout[ row - 2 ][ col ]) ) return true;
			
			// check left sides
			
			if ( board_col_first <= (col - 2) )
			{
				if ( (id == layout[ row  ][ col - 1 ]) && (id == layout[ row ][ col - 2 ]) ) return true;
				
				if ( bFarEnoughForRowChecks && _global.purgatory_bIncludeDiagonalsInConnectivity )
				{
					if ( (id == layout[ row - 1 ][ col - 1 ]) && (id == layout[ row - 2 ][ col - 2 ]) ) return true;
				}
			}
			
			// check right sides
			
			if ( board_col_last >= (col + 2) )
			{
				if ( (id == layout[ row  ][ col + 1 ]) && (id == layout[ row ][ col + 2 ]) ) return true;
				
				if ( bFarEnoughForRowChecks && _global.purgatory_bIncludeDiagonalsInConnectivity )
				{
					if ( (id == layout[ row - 1 ][ col + 1 ]) && (id == layout[ row - 2 ][ col + 2 ]) ) return true;
				}
			}
			
			// any other rules to check???
			
			return false;
		}

		private function GenerateRandomBoardLayout( layout_array:Vector.< Vector.<int> >, nPieces:int, bLimitStartingMatches:Boolean ):Boolean
		{
			game_state.last_board_retries = 0;
			
			++game_state.total_unique_boards;
			
			CreateLayoutArray( layout_array, board_rows, board_cols );
			
			var bOkayToProceedToNextRow:Boolean = false;
			
			var bFarEnoughForRowChecks:Boolean;

			var bReturningValidBoard:Boolean = true;
			
			var row:int, col:int, retry:int;
			
			for ( row = board_row_first; row < board_row_last; ++row )
			{
				bFarEnoughForRowChecks = (row >= (board_row_first + 2));
				
				retry = 0;
				
				do {
				
					for ( col = board_col_first; col < board_col_last; ++col )
					{
						layout_array[ row ][ col ] = GenerateRandomPieceMatchID( nPieces );
					}
					
					bOkayToProceedToNextRow = true;
					
					if ( bLimitStartingMatches )
					{
						for ( col = board_col_first; col < board_col_last; ++col )
						{
							if ( QuickMatch3CheckLayoutAreaForMatch( row, col, layout_array, bFarEnoughForRowChecks ) )
							{
								bOkayToProceedToNextRow = false;
								break;
							}
						}
					}
					
					if ( bOkayToProceedToNextRow ) break;
					
					if ( 100 < ++retry )
					{
						bReturningValidBoard = false;
						break;
					}
					
				} while ( !bOkayToProceedToNextRow );
			}

			return bReturningValidBoard;
		}

		// ---------------------------------------------------------

		private function GenerateMetaBoardLayout( layout:Vector.<int> ):void
		{
			layout.length = board_cols; // resize( board_cols );
			
				// how far down/up determines difficulty...
			
			var target_low:int = (game_state.setting_tougher_stars || _global.bpt2014_increasing_difficulty_mode) ? ((board_row_first + board_row_last) / 2) : board_row_first;
			
			for ( var col:int = board_col_first; col < board_col_last; ++col )
			{
				if ( Math.random() <= 0.85 )
				{
					layout[ col ] = target_low + Math.floor( Math.random() * (board_row_last - target_low - 1) );
				}
				else
				{
					layout[ col ] = board_row_first + Math.floor( Math.random() * (board_row_last - board_row_first - 1) );
				}
			}

			if ( !_global.purgatory_going_down ) { // BPT.20140903 - fix for going up mode without tough stars
				for ( var col:int = board_col_first; col < board_col_last; ++col ) {
					layout[ col ] = (board_row_last - 1) - (layout[ col ] - board_row_first);
				}
			}
			
		}

		// ---------------------------------------------------------

		private function CopyActiveLayoutContents( src:Vector.< Vector.<int> >, dst:Vector.< Vector.<int> > ):void
		{
			for ( var row:int = board_row_first; row < board_row_last; ++row )
			{
				for ( var col:int = board_col_first; col < board_col_last; ++col )
				{
					dst[ row ][ col ] = src[ row ][ col ];
				}
			}
		}

		private function StoreLayoutForRestart( layout:Vector.< Vector.<int> >, metaLayout:Vector.<int> ):void
		{
			CreateLayoutArray( _global.purgatory_last_board_layout, board_rows, board_cols );
			
			_global.purgatory_last_board_rows = board_rows;
			
			_global.purgatory_last_board_cols = board_cols;
			
			CopyActiveLayoutContents( layout, _global.purgatory_last_board_layout );
			
			_global.purgatory_last_meta_cols_layout = metaLayout.concat(); // creates a copy
		}

		// ---------------------------------------------------------
		
		/*
		private function GenerateTypeHistograms( layout:Vector.< Vector.<int> > ):void
		{
			for ( var i:int = 0; i < _global.purgatory_nPieces; ++i )
			{
				_global.purgatory_played_types_removed_counter[ i ] = 0;
			}
			
			for ( var row:int = board_row_first; row < board_row_last; ++row )
			{
				for ( var col:int = board_col_first; col < board_col_last; ++col )
				{
					++_global.purgatory_played_types_original_counts[ layout[ row ][ col ] - 1 ];
				}
			}
		}
		*/

		private function BootstrapGameClosure():onEnterFrame_Ref
		{
			var closure:onEnterFrame_Ref = onEnterFrame_Ref.Alloc(); // new onEnterFrame_Ref();
			
			closure.code = function():void {
			
				var nPieces:int = _global.purgatory_nPieces;
		
				var boardLayout_array:Vector.< Vector.<int> > = new Vector.< Vector.<int> >();
				var metaBoardLayout_array:Vector.<int> = new Vector.<int>();
		
				if ( _global.purgatory_use_last_board_layout )
				{
					CreateBoardArrays(
						mainboard_mc
					,	_global.purgatory_last_board_rows
					,	_global.purgatory_last_board_cols
					,	_global.purgatory_piece_cx
					,	_global.purgatory_piece_cy
					);
					
					++game_state.last_board_retries;
					
					if ( game_state.last_board_retries > game_state.max_retries_for_any_round )
					{
						// trigger event?
						game_state.max_retries_for_any_round = game_state.last_board_retries;
					}
					
					CreateLayoutArray( boardLayout_array, board_rows, board_cols );
					CopyActiveLayoutContents( _global.purgatory_last_board_layout, boardLayout_array );
					metaBoardLayout_array = _global.purgatory_last_meta_cols_layout.concat();
				}
				else
				{
					game_state.last_board_remaining_stars = int.MAX_VALUE;
					game_state.last_board_fewest_remaining_stars = int.MAX_VALUE;
					
					CreateBoardArrays(
						mainboard_mc
					,	_global.purgatory_board_rows
					,	_global.purgatory_board_cols
					,	_global.purgatory_piece_cx
					,	_global.purgatory_piece_cy
					);
					
					// TODO.2014 - add support for more than one meta board (maybe this should just be a 2d board?)
					
					GenerateMetaBoardLayout( metaBoardLayout_array );
			
					if ( _global.purgatory_bAllowInitialMatches )
					{
						GenerateRandomBoardLayout( boardLayout_array, nPieces, false );
					}
					else
					{
						GenerateRandomBoardLayout( boardLayout_array, nPieces, true );
					}
					
					// save the this layout as the last board - really need a load/save system for levels
					
					StoreLayoutForRestart( boardLayout_array, metaBoardLayout_array );
					_global.SaveBoardLayout();
				}
		
				_global.purgatory_use_last_board_layout = false;
				++game_state.total_boards_played;
				game_state.last_board_moves = 0;
				game_state.last_board_seconds = 0;
				
				//GenerateTypeHistograms( boardLayout_array );

				playfield_mc.onEnterFrame = DynamicBoardFillClosure(
					WaitForSetupThenStartPlayingClosure(), boardLayout_array, metaBoardLayout_array );
			};

			return closure;
		}
		
		// --------------------------------

		public function BOOTSTRAP_GAME_SESSION():void
		{
			
			// ------------------------------------------------------------------------
			
			game_in_progress = true;
			
			if ( _global.purgatory_small_display_device )
			{
				_global.purgatory_board_scaling_enabled = true;
			}
			else
			{
				_global.purgatory_board_scaling_enabled = true || _global.purgatory_allow_board_scaling &&
					(((1 != assets.asset_runtime_scale_factor) &&
					((_global.purgatory_default_board_cols < _global.purgatory_board_cols) ||
					(_global.purgatory_default_board_cols < _global.purgatory_board_cols))) ||
					(((_global.purgatory_piece_cx * (_global.purgatory_board_cols - 2)) >= Core.canvas_width) || 
					((_global.purgatory_piece_cy * (_global.purgatory_board_rows - 2)) >= Core.canvas_height)))
					;
			}
			
			SetupRemovalAndPendingRemovalStrategyFunctions();
			
			// ------------------------------------------------------------------------
			// setup the global game instance variables for the game...

			_LAST_MOUSEBUTTONDOWN = false;
			_MOUSEBUTTONDOWN = false;
			_XMOUSE = 0.0;
			_YMOUSE = 0.0;

			CONTAINER = new GameSprite_Ref();
			CONTAINER._name = "CONTAINER";
			//CONTAINER._rotation = 180; // playing around
			
			Core.starlingRoot.SetContent( CONTAINER.GetDisplayObject() ); // addChild( CONTAINER.GetSprite() );
			
			item_cx = _global.purgatory_piece_cx; // 32;
			item_cy = _global.purgatory_piece_cy; // 32;

			board_rows = 0;
			board_row_first = 0;
			board_row_last = 0;

			board_cols = 0;
			board_col_first = 0;
			board_col_last = 0;
			
			board_array = new Vector.< Vector.<piece_ref> >(); //.length = 0; // clear();
 			meta_board = new Vector.< Vector.<meta_ref> >(); // .length = 0; // clear();
			board_positions_array = new Vector.< Vector.<Point> >(); // .length = 0; //clear();
			count_array = new Vector.<int>(); // length = 0; // clear();

			selected_item = null; // piece_ref();
			src_swap_item = null; // piece_ref();
			dst_swap_item = null; // piece_ref();

			dst_row_item = 0;
			dst_col_item = 0;

			src_row_item = 0;
			src_col_item = 0;

			moving_items_count = 0;
			bCheckForMatch = true;

			meta_items_count = 0;
			animating_item_count = 0;
			dropping_star_count = 0;

			bCheckForEmptyColumns = false;
			bPendingCollectMetaItems = false;
			bPendingPackRequest = false;

			bCheckForNoMoves = false;
			nNoMovesCountDown = 0;
			bFinalNoMoreMoves = false;

			bBoardChanged = true;

			nFramesSinceLastMove = 0;
			nShowHintsAfterNFrames = OLD_30_FPS_TO_N_FPS( 30 * 6 );

			bSwapCursorActive = false;

			nRemovalsInARow = 0;

			bFirstRemoval = true;
			bpt2021_PendingOCDMode = false;

			nNextStarRemovedID = 1;
			nNextStarRemovedIndicatorXPos = 15 * assets.asset_runtime_scale_factor;
			nNextStarRemovedIndicatorYPos = _global.purgatory_stage_cy - nNextStarRemovedIndicatorXPos; // 15;
			nNextStarRemovedIndicatorXDelta = _global.purgatory_piece_cx / 2;

			hint_item_a = null; // piece_ref();
			hint_item_b = null; // piece_ref();

			nRowMovesSearch = 0;
			nColMovesSearch = 0;
			bFoundMoveAtSearchLocation = false;
			bMovesSearchDone = false;
			
			bPendingRemovalsModeActive = false;
			nPendingRemovalAnimationSpeed = _global.bpt2014_remove_animation_speed_coefficient_start;		

			if ( null == sfx_slot_stop ) sfx_slot_stop = new SFX_Ref( "sfx_slot_stop" );
			if ( null == sfx_meta_remove ) sfx_meta_remove = new SFX_Ref( "sfx_meta_remove" );
			if ( null == sfx_pack_noise ) sfx_pack_noise = new SFX_Ref( "sfx_pack_noise" );
			if ( null == sfx_remove_column ) sfx_remove_column = new SFX_Ref( "sfx_remove_column" );
			if ( null == sfx_remove_noise ) sfx_remove_noise = new SFX_Ref( "sfx_remove_noise" );
			if ( null == sfx_select_item ) sfx_select_item = new SFX_Ref( "sfx_select_item" );
			if ( null == sfx_swap_noise ) sfx_swap_noise = new SFX_Ref( "sfx_swap_noise" );
			if ( null == sfx_unswap_noise ) sfx_unswap_noise = new SFX_Ref( "sfx_unswap_noise" );
			if ( null == sfx_no_moves ) sfx_no_moves = new SFX_Ref( "sfx_no_moves" );
			if ( null == sfx_board_cleared ) sfx_board_cleared = new SFX_Ref( "sfx_board_cleared" );
			if ( null == sfx_lucky_spin ) sfx_lucky_spin = new SFX_Ref( "sfx_lucky_spin" );
			if ( null == sfx_super_jackpot ) sfx_super_jackpot = new SFX_Ref( "sfx_super_jackpot" );
			if ( null == sfx_jackpot ) sfx_jackpot = new SFX_Ref( "sfx_jackpot" );
			if ( null == sfx_winner ) sfx_winner = new SFX_Ref( "sfx_winner" );
			if ( null == sfx_board_over ) sfx_board_over = new SFX_Ref( "sfx_board_over" );
			if ( null == sfx_bonus_mode ) sfx_bonus_mode = new SFX_Ref( "sfx_bonus_mode" );
			
			// ---------------------------------------------------------

			playfield_mc = CONTAINER.createEmptyMovieClip( "playfield", 1 );
			collected_stars_mc = CONTAINER.createEmptyMovieClip( "collected_stars", 2 );
			
			hud_mc = new Sprite(); //hud_mc = CONTAINER.createEmptyMovieClip( "hud", 3 );
			hud_mc.name = "hud";
			addChild(hud_mc);

			// -------------------------------
			
			hints_mc_back = playfield_mc.createEmptyMovieClip( "hints_back", 3 );
			hints_mc_back._visible = false;
			
			hint_a_mc_back = game_asset_based_visual.Alloc( "selector_bottom" );
			hint_a_mc_back._name = "hint_a_back";
			//hint_a_mc_back._visible = false;
			//hint_a_mc_back._alpha = 50.0;
			hint_a_mc_back.onEnterFrame = HintBackClosure( +0.0125 );
			hints_mc_back.addChild( hint_a_mc_back ); 
			
			hint_b_mc_back = game_asset_based_visual.Alloc( "selector_bottom" );
			hint_b_mc_back._name = "hint_b_back";
			//hint_b_mc_back._visible = false;
			//hint_b_mc_back._alpha = 50.0;
			hint_b_mc_back.onEnterFrame = HintBackClosure( -0.0125 );
			hints_mc_back.addChild( hint_b_mc_back ); 
			
			// -------------------------------
			
			active_boundaries_indicator_mc = game_asset_based_visual.Alloc( "selection_reach_indicator" );
			active_boundaries_indicator_mc._xscale = 100; // FIX.FIX.ME.ME
			active_boundaries_indicator_mc._yscale = 100; // FIX.FIX.ME.ME
			active_boundaries_indicator_mc._rotation = 0; // FIX.FIX.ME.ME
			active_boundaries_indicator_mc.visible = false; // FIX.FIX.ME.ME
			playfield_mc.addChild( active_boundaries_indicator_mc );
			
			// -------------------------------
			
			mainboard_mc = playfield_mc.createEmptyMovieClip( "mainboard", 1 );
//			metaboard_mc = playfield_mc.createEmptyMovieClip( "metaboard", 2 );  // above particles

			// -------------------------------
			
			// TODO.TODO - the hud elements do NOT use MovieClip_Ref's
			
			if ( null == dynamic_moves_display )
			{
				dynamic_moves_display = new DynamicTextHolder();//GameDynamicText();
			}
			
			dynamic_moves_display.alpha = 0;
			hud_mc.addChild( dynamic_moves_display );
			
			if ( null == dynamic_score_display )
			{
				dynamic_score_display = new DynamicTextHolder(false);//GameDynamicText( false );
			}
			
			dynamic_score_display.SetText( "Score:" );
			dynamic_score_display.alpha = 0;
			dynamic_score_display.x = 2;
			dynamic_score_display.y = 2;
			hud_mc.addChild( dynamic_score_display );
			
			display_score = 0;
			board_state.score = 0;
			
			// -------------------------------

			selection_mc = playfield_mc.createEmptyMovieClip( "selection", 4 );
			action_mc = new ActionGrid( active_boundaries_indicator_mc );
			action_mc._name = "action_grid";
			action_mc._visible = false;
			selection_mc.adoptChildAtDepth( action_mc, 1 );
			
			particles_mc = playfield_mc.createEmptyMovieClip( "particles", 5 );
			
			metaboard_mc = playfield_mc.createEmptyMovieClip( "metaboard", 6 );  // above particles
			
			// -------------------------------
			
			hints_mc_front = playfield_mc.createEmptyMovieClip( "hints_front", 3 );
			hints_mc_front._visible = false;
			
			hint_a_mc_front = game_asset_based_visual.Alloc( "hint_arrow" ); //hints_mc.attachMovie( "throbbing_arrow", "hint_a", 1 );
			hint_a_mc_front._name = "hint_a_front";
			//hint_a_mc_front._visible = false;
			//hint_a_mc_front._alpha = 50.0;
			hints_mc_front.addChild( hint_a_mc_front ); 
			
			hint_b_mc_front = game_asset_based_visual.Alloc( "hint_arrow" ); //hints_mc.attachMovie( "throbbing_arrow", "hint_a", 1 );
			hint_b_mc_front._name = "hint_b_front";
			//hint_b_mc_front._visible = false;
			//hint_b_mc_front._alpha = 50.0;
			hints_mc_front.addChild( hint_b_mc_front ); 
			
			hint_a_mc_front.onEnterFrame = HintFrontClosure( hint_b_mc_front );
			hint_b_mc_front.onEnterFrame = HintFrontClosure( hint_a_mc_front );
			
			// -------------------------------
			
			messages_mc = playfield_mc.createEmptyMovieClip( "messages", 7 );

			// -------------------------------
			
			trace( "TODO - fix this +1 hack" );
			nopickcandidateshelpercache = new Vector.<Boolean>( _global.purgatory_max_piece_types + 1 ); // hack to fix stupid bug (0 vs 1 indexing...)
			bpt2021_active_pieces_histogram = new Vector.<int>( _global.purgatory_max_piece_types + 1 );
			
			// -------------------------------

			playfield_mc.onEnterFrame = BootstrapGameClosure();
		}

		// ---------------------------------------------------------
		
		private function GetPointsMultiplier():Number
		{
			var bonus_multiplier = 1;
			
			if ( _global.bpt2021_keep_playing_after_meta_board_clear_aka_ocd_mode && bpt2021_PendingOCDMode )
			{
				bonus_multiplier = 2; // BUG.BUG.BUG should be a variable...
			}
			
			return Math.max( 1, nRemovalsInARow ) * bonus_multiplier;
		}
		
		private function GetMetaPointsValue():int
		{
			return (int)(100 * GetPointsMultiplier()); // BUG.BUG.BUG - need variable
		}
		
		private function GetPointsValue( item:piece_ref ):int
		{
			return (int)(10 * GetPointsMultiplier()); // BUG.BUG.BUG - need variable
		}

		// ---------------------------------------------------------
	}

} // package bpt.game

