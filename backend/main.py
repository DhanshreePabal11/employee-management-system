
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel, ConfigDict, EmailStr
from typing import Optional
from fastapi.middleware.cors import CORSMiddleware

from database import engine, Base, get_db
from employee_model import Employee

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Employee Management API")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


class EmployeeCreate(BaseModel):
    name: str
    email: EmailStr
    phone: Optional[str] = None
    department: Optional[str] = None
    salary: Optional[float] = None


class EmployeeResponse(EmployeeCreate):
    id: int
    model_config = ConfigDict(from_attributes=True)


@app.get("/")
def home():
    return {"message": "Employee Management API is running!"}


@app.post("/employees", response_model=EmployeeResponse)
def create_employee(employee: EmployeeCreate, db: Session = Depends(get_db)):
    existing = db.query(Employee).filter(Employee.email == employee.email).first()

    if existing:
        raise HTTPException(status_code=400, detail="Email already exists")

    new_employee = Employee(**employee.model_dump())
    db.add(new_employee)
    db.commit()
    db.refresh(new_employee)
    return new_employee


@app.get("/employees", response_model=list[EmployeeResponse])
def get_employees(db: Session = Depends(get_db)):
    return db.query(Employee).all()


@app.get("/employees/{employee_id}", response_model=EmployeeResponse)
def get_employee(employee_id: int, db: Session = Depends(get_db)):
    employee = db.query(Employee).filter(Employee.id == employee_id).first()

    if not employee:
        raise HTTPException(status_code=404, detail="Employee not found")

    return employee


@app.put("/employees/{employee_id}", response_model=EmployeeResponse)
def update_employee(
    employee_id: int,
    updated_data: EmployeeCreate,
    db: Session = Depends(get_db)
):
    employee = db.query(Employee).filter(Employee.id == employee_id).first()

    if not employee:
        raise HTTPException(status_code=404, detail="Employee not found")

    if updated_data.email != employee.email:
        existing = db.query(Employee).filter(
            Employee.email == updated_data.email
        ).first()

        if existing:
            raise HTTPException(status_code=400, detail="Email already exists")

    for key, value in updated_data.model_dump().items():
        setattr(employee, key, value)

    db.commit()
    db.refresh(employee)
    return employee


@app.delete("/employees/{employee_id}")
def delete_employee(employee_id: int, db: Session = Depends(get_db)):
    employee = db.query(Employee).filter(Employee.id == employee_id).first()

    if not employee:
        raise HTTPException(status_code=404, detail="Employee not found")

    db.delete(employee)
    db.commit()
    return {"message": "Employee deleted successfully"}
