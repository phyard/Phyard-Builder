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

//#include <Box2D/Dynamics/Joints/b2Joint.h>
//#include <Box2D/Dynamics/Joints/b2DistanceJoint.h>
//#include <Box2D/Dynamics/Joints/b2LineJoint.h>
//#include <Box2D/Dynamics/Joints/b2MouseJoint.h>
//#include <Box2D/Dynamics/Joints/b2RevoluteJoint.h>
//#include <Box2D/Dynamics/Joints/b2PrismaticJoint.h>
//#include <Box2D/Dynamics/Joints/b2PulleyJoint.h>
//#include <Box2D/Dynamics/Joints/b2GearJoint.h>
//#include <Box2D/Dynamics/b2Body.h>
//#include <Box2D/Dynamics/b2World.h>
//#include <Box2D/Common/b2BlockAllocator.h>

//#include <new>

public static function Create(def:b2JointDef, allocator:b2BlockAllocator = null):b2Joint
{
	var joint:b2Joint = null;

	switch (def.type)
	{
	case e_distanceJoint:
		{
			//void* mem = allocator->Allocate(sizeof(b2DistanceJoint));
			//joint = new (mem) b2DistanceJoint((b2DistanceJointDef*)def);
			joint = new b2DistanceJoint (def as b2DistanceJointDef);
		}
		break;

	case e_mouseJoint:
		{
			//void* mem = allocator->Allocate(sizeof(b2MouseJoint));
			//joint = new (mem) b2MouseJoint((b2MouseJointDef*)def);
			joint = new b2MouseJoint (def as b2MouseJointDef);
		}
		break;

	case e_prismaticJoint:
		{
			//void* mem = allocator->Allocate(sizeof(b2PrismaticJoint));
			//joint = new (mem) b2PrismaticJoint((b2PrismaticJointDef*)def);
			joint = new b2PrismaticJoint (def as b2PrismaticJointDef);
		}
		break;

	case e_revoluteJoint:
		{
			//void* mem = allocator->Allocate(sizeof(b2RevoluteJoint));
			//joint = new (mem) b2RevoluteJoint((b2RevoluteJointDef*)def);
			joint = new b2RevoluteJoint (def as b2RevoluteJointDef);
		}
		break;

	case e_pulleyJoint:
		{
			//void* mem = allocator->Allocate(sizeof(b2PulleyJoint));
			//joint = new (mem) b2PulleyJoint((b2PulleyJointDef*)def);
			joint = new b2PulleyJoint (def as b2PulleyJointDef);
		}
		break;

	case e_gearJoint:
		{
			//void* mem = allocator->Allocate(sizeof(b2GearJoint));
			//joint = new (mem) b2GearJoint((b2GearJointDef*)def);
			joint = new b2GearJoint (def as b2GearJointDef);
		}
		break;

	case e_lineJoint:
		{
			//void* mem = allocator->Allocate(sizeof(b2LineJoint));
			//joint = new (mem) b2LineJoint((b2LineJointDef*)def);
			joint = new b2LineJoint (def as b2LineJointDef);
		}
		break;
        
	default:
		//b2Assert(false);
		break;
	}

	return joint;
}

public static function Destroy (joint:b2Joint, allocator:b2BlockAllocator = null):void
{
	//joint->~b2Joint();
	joint.Destructor ();
	switch (joint.m_type)
	{
	case e_distanceJoint:
		//allocator->Free(joint, sizeof(b2DistanceJoint));
		break;

	case e_mouseJoint:
		//allocator->Free(joint, sizeof(b2MouseJoint));
		break;

	case e_prismaticJoint:
		//allocator->Free(joint, sizeof(b2PrismaticJoint));
		break;

	case e_revoluteJoint:
		//allocator->Free(joint, sizeof(b2RevoluteJoint));
		break;

	case e_pulleyJoint:
		//allocator->Free(joint, sizeof(b2PulleyJoint));
		break;

	case e_gearJoint:
		//allocator->Free(joint, sizeof(b2GearJoint));
		break;

	case e_lineJoint:
		//allocator->Free(joint, sizeof(b2LineJoint));
		break;
    
	default:
		//b2Assert(false);
		break;
	}
}

public function b2Joint(def:b2JointDef)
{
	m_type = def.type;
	m_prev = null;
	m_next = null;
	m_bodyA = def.body1;
	m_bodyB = def.body2;
	m_collideConnected = def.collideConnected;
	m_islandFlag = false;
	m_userData = def.userData;

	m_edgeA.joint = null;
	m_edgeA.other = null;
	m_edgeA.prev = null;
	m_edgeA.next = null;

	m_edgeB.joint = null;
	m_edgeB.other = null;
	m_edgeB.prev = null;
	m_edgeB.next = null;
}