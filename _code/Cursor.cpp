#include "StdAfx.h"
#include "Cursor.h"

CCursor::CCursor()
{
	gEnv->pSystem->GetISystemEventDispatcher()->RegisterListener(this);
	m_cursor = LoadCursor((HINSTANCE)g_hInst, MAKEINTRESOURCE(IDC_CURSOR1));
	SetCursor(m_cursor);
}

CCursor::~CCursor()
{
	gEnv->pSystem->GetISystemEventDispatcher()->RemoveListener(this);
}


void CCursor::OnSystemEvent( ESystemEvent event,UINT_PTR wparam,UINT_PTR lparam )
{
	if(event == ESYSTEM_EVENT_TOGGLE_FULLSCREEN || event == ESYSTEM_EVENT_RESIZE || event == ESYSTEM_EVENT_CHANGE_FOCUS)
	{
		if (m_cursor != GetCursor()) 
			SetCursor(m_cursor);
	}
}