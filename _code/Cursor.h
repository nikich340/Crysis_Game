#ifndef _MOD_CURSOR
#define _MOD_CURSOR

#include <windows.h>
#include "resource.h"

class CCursor : public ISystemEventListener
{
public:
	CCursor();
	~CCursor();
private:
	virtual void OnSystemEvent( ESystemEvent event,UINT_PTR wparam,UINT_PTR lparam );
	HCURSOR m_cursor;
};

#endif