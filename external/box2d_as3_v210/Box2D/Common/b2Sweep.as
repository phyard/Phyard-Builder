
package Box2D.Common
{
	/// This describes the motion of a body/shape for TOI computation.
	/// Shapes are defined with respect to the body origin, which may
	/// no coincide with the center of mass. However, to support dynamics
	/// we must interpolate the center of mass position.
	//struct b2Sweep
	public class b2Sweep
	{
		// this function doesn't exist in the c++ version
		public function Clone ():b2Sweep
		{
			var sweep:b2Sweep = new b2Sweep ();
			sweep.CopyFrom (this);
			return sweep;
		}
		
		// this function doesn't exist in the c++ version
		public function CopyFrom (another:b2Sweep):void
		{
			localCenter.x = another.localCenter.x;
			localCenter.y = another.localCenter.y;
			c0.x = another.c0.x;
			c0.y = another.c0.y;
			c.x = another.c.x;
			c.y = another.c.y;
			a0 = another.a0;
			a = another.a;
		}
		
		private static var mVec2:b2Vec2 = new b2Vec2 ();
		/// Get the interpolated transform at a specific time.
		/// @param alpha is a factor in [0,1], where 0 indicates t0.
		public function GetTransform(xf:b2Transform, alpha:Number):void
		{
			var _alpha:Number = 1.0 - alpha;
			xf.position.x = _alpha * c0.x + alpha * c.x;
			xf.position.y = _alpha * c0.y + alpha * c.y;
			var angle:Number = _alpha * a0 + alpha * a;
			xf.R.SetFromAngle(angle);

			// Shift to origin
			var vec2:b2Vec2 = mVec2;
			b2Math.b2Mul_Matrix22AndVector2_Output (xf.R, localCenter, vec2);
			xf.position.x -= vec2.x;
			xf.position.y -= vec2.y;
		}

		/// Advance the sweep forward, yielding a new initial state.
		/// @param t the new initial time.
		public function Advance(t:Number):void
		{
			var _t:Number = 1.0 - t;
			c0.x = _t * c0.x + t * c.x;
			c0.y = _t * c0.y + t * c.y;
			a0 = _t * a0 + t * a;
		}

		/// Normalize an angle in radians to be between -pi and pi
		public function Normalize():void
		{
			const twoPi:Number = 2.0 * Math.PI;
			var d:Number =  twoPi * Math.floor (a0 / twoPi);
			a0 -= d;
			a -= d;
		}

		public var localCenter:b2Vec2 = new b2Vec2 ();	///< local center of mass position
		public var c0:b2Vec2 = new b2Vec2 (), c:b2Vec2 = new b2Vec2 ();		///< center world positions
		public var a0:Number, a:Number;		///< world angles
		
	} // class
} // package
