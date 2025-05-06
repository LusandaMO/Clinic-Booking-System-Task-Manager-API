from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Optional
from sqlalchemy import create_engine, Column, Integer, String, Text, Enum, ForeignKey, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session

# Database Configuration
DATABASE_URL = "mysql+pymysql://root:password@localhost/task_manager"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# FastAPI App
app = FastAPI()

# =====================
# Database Models
# =====================

class User(Base):
    __tablename__ = "Users"
    UserID = Column(Integer, primary_key=True, index=True)
    Name = Column(String(100), nullable=False)
    Email = Column(String(100), unique=True, nullable=False)
    PasswordHash = Column(String(255), nullable=False)
    tasks = relationship("Task", back_populates="owner", cascade="all, delete")

class Task(Base):
    __tablename__ = "Tasks"
    TaskID = Column(Integer, primary_key=True, index=True)
    UserID = Column(Integer, ForeignKey("Users.UserID"), nullable=False)
    Title = Column(String(255), nullable=False)
    Description = Column(Text, nullable=True)
    Status = Column(Enum("Pending", "In Progress", "Completed"), default="Pending", nullable=False)
    DueDate = Column(DateTime, nullable=True)
    owner = relationship("User", back_populates="tasks")

# Create tables in the database
Base.metadata.create_all(bind=engine)

# =====================
# Pydantic Models
# =====================

class UserCreate(BaseModel):
    Name: str
    Email: str
    PasswordHash: str

class TaskCreate(BaseModel):
    UserID: int
    Title: str
    Description: Optional[str] = None
    Status: Optional[str] = "Pending"
    DueDate: Optional[str] = None

class TaskUpdate(BaseModel):
    Title: Optional[str] = None
    Description: Optional[str] = None
    Status: Optional[str] = None
    DueDate: Optional[str] = None

class TaskResponse(BaseModel):
    TaskID: int
    UserID: int
    Title: str
    Description: Optional[str]
    Status: str
    DueDate: Optional[str]

    class Config:
        orm_mode = True

class UserResponse(BaseModel):
    UserID: int
    Name: str
    Email: str

    class Config:
        orm_mode = True

# =====================
# Dependency
# =====================

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# =====================
# CRUD Operations
# =====================

# 1. User Operations
@app.post("/users/", response_model=UserResponse)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.Email == user.Email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    new_user = User(**user.dict())
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.get("/users/{user_id}", response_model=UserResponse)
def read_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.UserID == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# 2. Task Operations
@app.post("/tasks/", response_model=TaskResponse)
def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.UserID == task.UserID).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    new_task = Task(**task.dict())
    db.add(new_task)
    db.commit()
    db.refresh(new_task)
    return new_task

@app.get("/tasks/{task_id}", response_model=TaskResponse)
def read_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.TaskID == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task

@app.put("/tasks/{task_id}", response_model=TaskResponse)
def update_task(task_id: int, updated_task: TaskUpdate, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.TaskID == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    for key, value in updated_task.dict(exclude_unset=True).items():
        setattr(task, key, value)
    db.commit()
    db.refresh(task)
    return task

@app.delete("/tasks/{task_id}")
def delete_task(task_id: int, db: Session = Depends(get_db)):
    task = db.query(Task).filter(Task.TaskID == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    db.delete(task)
    db.commit()
    return {"message": "Task deleted successfully"}