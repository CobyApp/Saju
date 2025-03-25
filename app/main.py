@app.post("/start")
async def start_session(request: Request):
    try:
        data = await request.json()  # await 추가
        session_id = data.get('session_id')
        
        if not session_id:
            raise HTTPException(status_code=400, detail="세션 ID가 필요합니다")
            
        # 세션 초기화
        sessions[session_id] = {
            'step': 0,
            'user_info': {},
            'saju': None
        }
        
        return {
            "reply": "🐱 안녕냥~ 나는 사주를 보는 운세냥이야!\n먼저 이름을 알려줘냥!"
        }
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"세션 시작 실패: {str(e)}") 