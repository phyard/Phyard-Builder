/*
* Copyright (c) 2006-2009 Erin Catto http://www.gphysics.com
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

//#ifndef B2_POLYGON_CONTACT_H
//#define B2_POLYGON_CONTACT_H

package Box2D.Dynamics.Contacts
{
	//#include <Box2D/Dynamics/Contacts/b2Contact.h>

	//class b2BlockAllocator;
	
	import Box2D.Common.b2BlockAllocator;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Collision.b2Collision;
	import Box2D.Collision.Shapes.b2PolygonShape;

	public class b2PolygonContact extends b2Contact
	{
		include "b2PolygonContact.cpp";
		
	//public:
		//static b2Contact* Create(b2Fixture* fixtureA, b2Fixture* fixtureB, b2BlockAllocator* allocator);
		//static void Destroy(b2Contact* contact, b2BlockAllocator* allocator);

		//b2PolygonContact(b2Fixture* fixtureA, b2Fixture* fixtureB);
		//~b2PolygonContact() {}
		public function _b2PolygonContact ():void {}

		//void Evaluate();
	} // class
} // package
//#endif