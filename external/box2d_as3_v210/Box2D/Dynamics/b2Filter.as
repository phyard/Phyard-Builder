
package Box2D.Dynamics
{
	/// This holds contact filtering data.
	public class b2Filter
	{
		/// The collision category bits. Normally you would just set one bit.
		public var categoryBits:int; //uint16

		/// The collision mask bits. This states the categories that this
		/// shape would accept for collision.
		public var maskBits:int; // uint16

		/// Collision groups allow a certain group of objects to never collide (negative)
		/// or always collide (positive). Zero means no collision group. Non-zero group
		/// filtering always wins against the mask bits.
		public var groupIndex:int; // int16
		
	} // class
} // package
