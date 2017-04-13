package feathers.extensions.progress
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	import starling.events.Event;
	import starling.display.BlendMode;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.display.Image;
	import starling.textures.RenderTexture;
	import starling.display.Shape;
	import starling.display.Graphics;
	import starling.extensions.TextureMaskStyle;
	
	import feathers.utils.math.clamp;
	import feathers.core.FeathersControl;
 
	/**
	 * The Canvas supports basic vector drawing functionality.
	 *
	 * @see feathers.extensions.canvas.CanvasDisplayObject
	 */
	public class CircleProgress extends FeathersControl
	{
		private var field:TextField;
		private var format:TextFormat = new TextFormat();
		private var child:Shape;
		private var backCircle:Image;
		private var percentage:Number = 0;
		
		public function CircleProgress()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		/**
		 * @private
		 */
		protected var _value:Number = 0;

		/**
		 * The value of the progress bar, between the minimum and maximum.
		 *
		 * <p>In the following example, the value is set to 12:</p>
		 *
		 * <listing version="3.0">
		 * progress.minimum = 0;
		 * progress.maximum = 100;</listing>
		 *
		 * @default 0
		 *
		 * @see #minimum
		 * @see #maximum
		 */
		public function get value():Number
		{
			return this._value;
		}

		/**
		 * @private
		 */
		public function set value(newValue:Number):void
		{
			newValue = clamp(newValue, this._minimum, this._maximum);
			if(this._value == newValue)
			{
				return;
			}
			this._value = newValue;
			change();
		}

		/**
		 * @private
		 */
		protected var _minimum:Number = 0;

		/**
		 * The progress bar's value will not go lower than the minimum.
		 *
		 * <p>In the following example, the minimum is set to 0:</p>
		 *
		 * <listing version="3.0">
		 * progress.minimum = 0;
		 * progress.maximum = 100;</listing>
		 *
		 * @default 0
		 *
		 * @see #value
		 * @see #maximum
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}

		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			if(this._minimum == value)
			{
				return;
			}
			this._minimum = value;
		}

		/**
		 * @private
		 */
		protected var _maximum:Number = 1;

		/**
		 * The progress bar's value will not go higher than the maximum.
		 *
		 * <p>In the following example, the maximum is set to 100:</p>
		 *
		 * <listing version="3.0">
		 * progress.minimum = 0;
		 * progress.maximum = 100;</listing>
		 *
		 * @default 1
		 *
		 * @see #value
		 * @see #minimum
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}

		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			if(this._maximum == value)
			{
				return;
			}
			this._maximum = value;
		}
		
		private var _color:uint = 0x000000;

		/**
		 * Indicates the color of the circle.
		 *
		 * @default 0x000000
		 */
		public function get color():uint
		{
			return this._color;
		}
		
		public function set color(value:uint):void
		{
			if(this._color == value)
			{
				return;
			}
			this._color = value;
		}
		
		private var _backCircleColor:uint = 0x000000;

		/**
		 * Indicates the color of the back circle.
		 *
		 * @default 0x000000
		 */
		public function get backCircleColor():uint
		{
			return this._backCircleColor;
		}
		
		public function set backCircleColor(value:uint):void
		{
			if(this._backCircleColor == value)
			{
				return;
			}
			this._backCircleColor = value;
		}		
		
		private var _backCircleAlpha:Number = 0.2;

		/**
		 * Indicates the alpha transparency value of the back circle.
		 *
		 * @default 0.2
		 */
		public function get backCircleAlpha():Number
		{
			return this._backCircleAlpha;
		}
		
		public function set backCircleAlpha(value:Number):void
		{
			if(this._backCircleAlpha == value)
			{
				return;
			}
			this._backCircleAlpha = value;
		}
		
		private var _textColor:uint = 0x000000;

		/**
		 * Indicates the color of the text.
		 *
		 * @default 0x000000
		 */
		public function get textColor():uint
		{
			return this._textColor;
		}
		
		public function set textColor(value:uint):void
		{
			if(this._textColor == value)
			{
				return;
			}
			this._textColor = value;
		}
		
		private var _textFont:String = "Verdana";

		/**
		 * Indicates the font of the text.
		 *
		 * @default Verdana
		 */
		public function get textFont():String
		{
			return this._textFont;
		}
		
		public function set textFont(value:String):void
		{
			if(this._textFont == value)
			{
				return;
			}
			this._textFont = value;
		}
		
		private var _textSize:Number = 12;

		/**
		 * The size of the text.
		 *
		 * @default 12
		 */
		public function get textSize():Number
		{
			return this._textSize;
		}
		
		public function set textSize(value:Number):void
		{
			if(this._textSize == value)
			{
				return;
			}
			this._textSize = value;
		}
		
		private var _textVisible:Boolean = true;

		/**
		 * The visibility of the text.
		 *
		 * @default true
		 */
		public function get textVisible():Boolean
		{
			return this._textVisible;
		}
		
		public function set textVisible(value:Boolean):void
		{
			if(this._textVisible == value)
			{
				return;
			}
			this._textVisible = value;
			if(field)
			{
				field.visible = this.textVisible;
			}
		}
		
		private var _backCircleVisible:Boolean = true;

		/**
		 * The visibility of the back circle.
		 *
		 * @default true
		 */
		public function get backCircleVisible():Boolean
		{
			return this._backCircleVisible;
		}
		
		public function set backCircleVisible(value:Boolean):void
		{
			if(this._backCircleVisible == value)
			{
				return;
			}
			this._backCircleVisible = value;
			if(backCircle)
			{
				backCircle.visible = this.backCircleVisible;
			}
		}
		
		private function addedToStageHandler(event:Event):void
		{
			if( isNaN(this.explicitWidth) ) this.width = 100;
			if( isNaN(this.explicitHeight) ) this.height = 100;
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			format.font = textFont;
			format.color = textColor;
			format.size = textSize;
			field = new TextField(100, 100, "100%", format);
			field.autoSize = "right";
			var fieldWidth:Number = field.width;
			var fieldHeight:Number = field.height;
			field.autoSize = "none";
			field.width = fieldWidth;
			field.height = fieldHeight;
			field.text = percentage+"%";
			field.x=this.width/2-field.width/2;
			field.y=this.height/2-field.height/2;
			addChild(field);
			if(!this.textVisible) field.visible = false;
			
			createBackCircle();
			
			child = new Shape();
			child.graphics.beginFill(0x000000);
			drawPieMask(child.graphics, percentage);
			child.graphics.endFill();
			addChild(child);
			child.x=this.width/2;
			child.y=this.height/2;
			
			var _renderTexture:RenderTexture = new RenderTexture(this.width, this.height);
			var _canvas:Image = new Image(_renderTexture);
			addChild(_canvas);
			
			var child2:Shape = new Shape();
			child2.graphics.beginFill(color);
			child2.graphics.drawCircle(0,0, this.height/2);
			child2.graphics.endFill();
			child2.x=this.width/2;
			child2.y=this.height/2;
			
			var child3:Shape = new Shape();
			child3.graphics.beginFill(0x000000);
			child3.graphics.drawCircle(0,0, this.height/2 - 5);
			child3.graphics.endFill();
			child3.x=this.width/2;
			child3.y=this.height/2;
			
			child3.blendMode = BlendMode.ERASE;

			_renderTexture.draw(child2);
			_renderTexture.draw(child3);
			
			var style:TextureMaskStyle = new TextureMaskStyle();
			_canvas.style = style;
			child.mask = _canvas;
		}
		
		private function drawPieMask(graphics:Graphics, percentage:Number, radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0, sides:int = 6):void
		{
			rotation = -Math.PI/2;
			// graphics should have its beginFill function already called by now
			graphics.moveTo(x, y);
			if (sides < 3) sides = 3; // 3 sides minimum
			// Increase the length of the radius to cover the whole target
			radius /= Math.cos(1/sides * Math.PI);
			// Find how many sides we have to draw
			var sidesToDraw:int = Math.floor(percentage/100 * sides);
			for (var i:int = 0; i <= sidesToDraw; i++)
			lineToRadians((i / sides) * (Math.PI * 2) + rotation, graphics, radius);
			// Draw the last fractioned side
			if (percentage/100 * sides != sidesToDraw)
			lineToRadians(percentage/100 * (Math.PI * 2) + rotation, graphics, radius);
		}
		// Shortcut function
		private function lineToRadians(rads:Number, graphics:Graphics, radius:Number):void
		{
			graphics.lineTo(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
		}
		
		private function change():void
		{			
			percentage = Math.round( ((this._value - this._minimum) / (this._maximum - this._minimum)) * 100 );
			
			field.text = percentage+"%";
			child.graphics.clear();
			child.graphics.beginFill(0x000000);
			drawPieMask(child.graphics, percentage, 100);
			child.graphics.endFill();
		}
		 
		private function createBackCircle():void
		{	  
			var _renderTexture:RenderTexture = new RenderTexture(this.width, this.height);
			backCircle = new Image(_renderTexture);
			addChild(backCircle);
			if(!this.backCircleVisible) backCircle.visible = false;
			
			var child:Shape = new Shape();
			child.graphics.beginFill(backCircleColor, backCircleAlpha);
			child.graphics.drawCircle(0,0, this.height/2);
			child.graphics.endFill();
			child.x=this.width/2;
			child.y=this.height/2;
			
			var child2:Shape = new Shape();
			child2.graphics.beginFill(0x000000);
			child2.graphics.drawCircle(0,0, this.height/2 - 5);
			child2.graphics.endFill();
			child2.x=this.width/2;
			child2.y=this.height/2;
			
			child2.blendMode = BlendMode.ERASE;

			_renderTexture.draw(child);
			_renderTexture.draw(child2);
		}
	}
}