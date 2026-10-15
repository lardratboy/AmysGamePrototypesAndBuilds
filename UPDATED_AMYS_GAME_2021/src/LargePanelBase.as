package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ContextBase;
	
	import ScaledAssetButton;
	
	import assets;
	
	import bpt.game.gamemain;
	import bpt.ui.panel.PanelSprite;
	
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Bounce;
	import org.libspark.betweenas3.easing.Elastic;
	import org.libspark.betweenas3.easing.Sine;
	import org.libspark.betweenas3.tweens.ITween;
	
	// ------------------------------------------------------------------------
	
	/**
	 * ...
	 * @author BPT
	 */
	public class LargePanelBase extends ContextBase
	{
		protected var background_panel_:Sprite = null;
		//protected var background_panel_:PanelSprite;
		
		protected var main_menu_button_bg_:Sprite;
		protected var main_menu_button_:ScaledAssetButton;
				
		public function LargePanelBase() 
		{
//			if ( 1 != assets.asset_runtime_scale_factor )
//			{
				scaleX = Core.panel_scale;
				scaleY = scaleX;
//			}
			
			super();
		}
		
		// --------------------------------------------------------------------
		
		protected override function XOriginOffset():int
		{
			return (Core.canvas_width - Core.canvas_width * scaleX) / 2;
		}
		
		protected override function YOriginOffset():int
		{
			return (Core.canvas_height - Core.canvas_height * scaleY) / 2;
		}
		
		// --------------------------------------------------------------------
		
		protected override function EnableButtons( b:Boolean ):void
		{
			super.EnableButtons( b );
			
			if ( null != main_menu_button_ )
			{
				main_menu_button_.Enable( b );
			}
		}
		
		protected override function Create():void
		{
			super.Create();
			
			background_panel_ = assets.SpriteWrapper( "large_panel" );
			background_panel_.x = Core.canvas_x_center;
			background_panel_.y = Core.canvas_y_center;
			
			addChild( background_panel_ );
		}
		
		// --------------------------------------------------------------------
		
		protected function CreateMainMenuButton( handler:Function = null ):void
		{
			if ( null == handler )
			{
				handler = OnMainMenuButton;
			}
			
			if ( false )
			{
				main_menu_button_bg_ = assets.SpriteWrapper( "panel_button_hole_bg" );
				main_menu_button_bg_.x = 0;
				main_menu_button_bg_.y = 0;
				main_menu_button_bg_.mouseEnabled = true;
				
				main_menu_button_ = new ScaledAssetButton( "home_icon" );
				main_menu_button_.x = background_panel_.x - background_panel_.width/2 + main_menu_button_bg_.width * 0.75;
				main_menu_button_.y = background_panel_.y - background_panel_.height/2 + main_menu_button_bg_.height * 0.75;
				main_menu_button_.addEventListener( MouseEvent.CLICK, handler );

				main_menu_button_.addChild( main_menu_button_bg_ );
				main_menu_button_.mouseChildren = true;
				
				addChild( main_menu_button_ );
			}
			else
			{
				main_menu_button_bg_ = assets.SpriteWrapper( "panel_button_hole_bg" );
				main_menu_button_bg_.x = background_panel_.x - background_panel_.width/2 + main_menu_button_bg_.width * 0.75;
				main_menu_button_bg_.y = background_panel_.y - background_panel_.height/2 + main_menu_button_bg_.height * 0.75;
				main_menu_button_bg_.mouseChildren = false;
				main_menu_button_bg_.mouseEnabled = false;
				addChild( main_menu_button_bg_ );
	
				main_menu_button_ = new ScaledAssetButton( "home_icon" );
				main_menu_button_.x = main_menu_button_bg_.x;
				main_menu_button_.y = main_menu_button_bg_.y;
				main_menu_button_.addEventListener( MouseEvent.CLICK, handler );
				main_menu_button_.hitArea =	main_menu_button_bg_;
				
				addChild( main_menu_button_ );
			}
		}
		
		protected function OnMainMenuButton( e:MouseEvent ):void
		{
			Core.instance.GotoMenu();
			
			Dismiss();
		}
		
	}

}


	


