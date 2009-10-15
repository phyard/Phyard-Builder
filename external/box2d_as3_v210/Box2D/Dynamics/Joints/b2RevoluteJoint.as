/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

//#ifndef B2_REVOLUTE_JOINT_H
//#define B2_REVOLUTE_JOINT_H

package Box2D.Dynamics.Joints
{

	//#include <Box2D/Dynamics/Joints/b2Joint.h>
	
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2Math;
	import Box2D.Common.b2Vec2;
	import Box2D.Common.b2Vec3;
	import Box2D.Common.b2Transform;
	import Box2D.Common.b2Mat22;
	import Box2D.Common.b2Mat33;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2Body;

	/// A revolute joint constrains to bodies to share a common point while they
	/// are free to rotate about the point. The relative rotation about the shared
	/// point is the joint angle. You can limit the relative rotation with
	/// a joint limit that specifies a lower and upper angle. You can use a motor
	/// to drive the relative rotation about the shared point. A maximum motor torque
	/// is provided so that infinite forces are not generated.
	public class b2RevoluteJoint extends b2Joint
	{
		include "b2RevoluteJoint.cpp";
		
	//public:
		//b2Vec2 GetAnchor1() const;
		//b2Vec2 GetAnchor2() const;

		//b2Vec2 GetReactionForce(float32 inv_dt) const;
		//float32 GetReactionTorque(float32 inv_dt) const;

		/// Get the current joint angle in radians.
		//float32 GetJointAngle() const;

		/// Get the current joint angle speed in radians per second.
		//float32 GetJointSpeed() const;

		/// Is the joint limit enabled?
		//bool IsLimitEnabled() const;

		/// Enable/disable the joint limit.
		//void EnableLimit(bool flag);

		/// Get the lower joint limit in radians.
		//float32 GetLowerLimit() const;

		/// Get the upper joint limit in radians.
		//float32 GetUpperLimit() const;

		/// Set the joint limits in radians.
		//void SetLimits(float32 lower, float32 upper);

		/// Is the joint motor enabled?
		//bool IsMotorEnabled() const;

		/// Enable/disable the joint motor.
		//void EnableMotor(bool flag);

		/// Set the motor speed in radians per second.
		//void SetMotorSpeed(float32 speed);

		/// Get the motor speed in radians per second.
		//float32 GetMotorSpeed() const;

		/// Set the maximum motor torque, usually in N-m.
		//void SetMaxMotorTorque(float32 torque);

		/// Get the current motor torque, usually in N-m.
		//float32 GetMotorTorque() const;

		//--------------- Internals Below -------------------
		//b2RevoluteJoint(const b2RevoluteJointDef* def);

		//void InitVelocityConstraints(const b2TimeStep& step);
		//void SolveVelocityConstraints(const b2TimeStep& step);

		//bool SolvePositionConstraints(float32 baumgarte);

		public var m_localAnchor1:b2Vec2 = new b2Vec2 ();	// relative
		public var m_localAnchor2:b2Vec2 = new b2Vec2 ();
		public var m_impulse:b2Vec3 = new b2Vec3 ();
		public var m_motorImpulse:Number;

		public var m_mass:b2Mat33 = new b2Mat33 ();			// effective mass for point-to-point constraint.
		public var m_motorMass:Number;	// effective mass for motor/limit angular constraint.
		
		public var m_enableMotor:Boolean;
		public var m_maxMotorTorque:Number;
		public var m_motorSpeed:Number;

		public var m_enableLimit:Boolean;
		public var m_referenceAngle:Number;
		public var m_lowerAngle:Number;
		public var m_upperAngle:Number;
		//b2LimitState m_limitState;
		public var m_limitState:int;
	//};

		public function GetMotorSpeed():Number
		{
			return m_motorSpeed;
		}
	} // class
} // package
//#endif