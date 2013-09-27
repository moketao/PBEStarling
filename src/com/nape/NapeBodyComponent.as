package com.nape 
{
	import com.pblabs.engine.entity.EntityComponent;
	import flash.geom.Point;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.ShapeList;
	
	/**
	 * ...
	 * @author Zo
	 */
	public class NapeBodyComponent extends EntityComponent 
	{
		public static var STATIC:String = "STATIC";
		public static var DYNAMIC:String = "DYNAMIC";
		public static var KINEMATIC:String = "KINEMATIC";
		
		
		public function get bodyTypeName():String 
		{
			return _bodyTypeName;
		}
		
		public function set bodyTypeName(value:String):void
		{
			_bodyTypeName = value;
			
			bodyType = BodyType[value];//BodyType.STATIC
		}
		public function get bodyType():BodyType
		{
			return _bodyType;
		}
		
		public function set bodyType(value:BodyType):void
		{
			_bodyType = value;
		}
		
		
		public function get spaceComponent():NapeSpaceComponent
		{
			return _spaceComponent;
		}
		
		public function set spaceComponent(value:NapeSpaceComponent):void
		{
			_spaceComponent = value;
		}
		
		[TypeHint(type="nape.shape.Shape")]
		public function get shapes():Array
		{
			return _shapes;
		}
		public function set shapes(value:Array):void
		{
			_shapes = value;
		}
		public function get position():Point
		{
			if ( _body )
			{
				_position.x = _body.position.x;
				_position.y = _body.position.y;
			}
			return _position;
		}
		public function set position(value:Point):void
		{
			_position = value;
			if ( _body )
				_body.position.setxy(_position.x, _position.y);
		}
		
		public function get velocity():Point
		{
			if ( _body )
			{
				_velocity.x = _body.velocity.x;
				_velocity.y = _body.velocity.y;
			}
			return _velocity;
		}
		public function set velocity(value:Point):void
		{
			_velocity = value;
			if ( _body )
				_body.velocity.setxy(_velocity.x, _velocity.y);
		}
		
		public function get body():Body
		{
			return _body;
		}
		
		public function set body(value:Body):void
		{
			_body = value;
		}
		
		override protected function onAdd():void 
		{
			super.onAdd();
			
			if (!spaceComponent )
				throw new Error("must set the NapeSpaceComponent of a body");
			
			
			_body = new Body(bodyType);
			buildShapes();
			_body.position.setxy(_position.x, _position.y);
			_body.space = spaceComponent.space;
		}
		
		protected function buildShapes():void
		{
			for (var i:int = 0; i < shapes.length; i ++ )
			{
				_body.shapes.add( shapes[i].createShape() );
			}
		}
		
		protected var _spaceComponent:NapeSpaceComponent;
		protected var _bodyType:BodyType;
		protected var _bodyTypeName:String;
		protected var _body:Body;
		protected var _shapes:Array;
		protected var _position:Point = new Point();
		protected var _velocity:Point = new Point();
		
		
	}

}