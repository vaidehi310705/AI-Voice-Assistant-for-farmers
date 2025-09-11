from fastapi import FastAPI
from app.routes import solution

app = FastAPI(title="AI Voice Assistant for Farmers")

app.include_router(solution.router, prefix="/solution", tags=["Solution"])

@app.get("/")
def root():
    return {"message": "Backend is running"}
