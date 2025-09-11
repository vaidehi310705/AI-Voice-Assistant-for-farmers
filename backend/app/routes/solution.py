from fastapi import APIRouter
from app.services.solution_services import get_solution

router = APIRouter()

@router.post("/")
def fetch_solution(prompt: str):
    return {"solution": get_solution(prompt)}
