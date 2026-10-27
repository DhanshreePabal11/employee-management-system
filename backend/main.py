
from datetime import date
from typing import Optional, Literal

from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict, EmailStr
from sqlalchemy.orm import Session

from database import engine, Base, get_db
from employee_model import Employee
from attendance_model import Attendance



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




AttendanceStatus = Literal["Present", "Absent", "On Leave"]


class AttendanceCreate(BaseModel):
    employee_id: int
    date: date
    status: AttendanceStatus


class AttendanceResponse(AttendanceCreate):
    id: int
    model_config = ConfigDict(from_attributes=True)


 

@app.get("/")
def home():
    return {"message": "Employee Management API is running!"}

 

# CREATE EMPLOYEE
@app.post("/employees", response_model=EmployeeResponse)
def create_employee(
    employee: EmployeeCreate,
    db: Session = Depends(get_db)
):
    existing = db.query(Employee).filter(
        Employee.email == employee.email
    ).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Email already exists"
        )

    new_employee = Employee(**employee.model_dump())

    db.add(new_employee)
    db.commit()
    db.refresh(new_employee)

    return new_employee


# GET ALL EMPLOYEES
@app.get("/employees", response_model=list[EmployeeResponse])
def get_employees(db: Session = Depends(get_db)):
    return db.query(Employee).all()


# GET EMPLOYEE BY ID
@app.get("/employees/{employee_id}", response_model=EmployeeResponse)
def get_employee(
    employee_id: int,
    db: Session = Depends(get_db)
):
    employee = db.query(Employee).filter(
        Employee.id == employee_id
    ).first()

    if not employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found"
        )

    return employee


# UPDATE EMPLOYEE
@app.put("/employees/{employee_id}", response_model=EmployeeResponse)
def update_employee(
    employee_id: int,
    updated_data: EmployeeCreate,
    db: Session = Depends(get_db)
):
    employee = db.query(Employee).filter(
        Employee.id == employee_id
    ).first()

    if not employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found"
        )

    if updated_data.email != employee.email:
        existing = db.query(Employee).filter(
            Employee.email == updated_data.email
        ).first()

        if existing:
            raise HTTPException(
                status_code=400,
                detail="Email already exists"
            )

    for key, value in updated_data.model_dump().items():
        setattr(employee, key, value)

    db.commit()
    db.refresh(employee)

    return employee


# DELETE EMPLOYEE
@app.delete("/employees/{employee_id}")
def delete_employee(
    employee_id: int,
    db: Session = Depends(get_db)
):
    employee = db.query(Employee).filter(
        Employee.id == employee_id
    ).first()

    if not employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found"
        )

   
    db.query(Attendance).filter(
        Attendance.employee_id == employee_id
    ).delete(synchronize_session=False)

    db.delete(employee)
    db.commit()

    return {"message": "Employee deleted successfully"}


 
 
@app.post("/attendance", response_model=AttendanceResponse)
def create_attendance(
    attendance_data: AttendanceCreate,
    db: Session = Depends(get_db)
): 
    
    employee = db.query(Employee).filter(
        Employee.id == attendance_data.employee_id
    ).first()

    if not employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found"
        )

  
    existing = db.query(Attendance).filter(
        Attendance.employee_id == attendance_data.employee_id,
        Attendance.date == attendance_data.date
    ).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Attendance already exists for this employee on this date"
        )

    new_attendance = Attendance(
        employee_id=attendance_data.employee_id,
        date=attendance_data.date,
        status=attendance_data.status
    )

    db.add(new_attendance)
    db.commit()
    db.refresh(new_attendance)

    return new_attendance


 
@app.get("/attendance", response_model=list[AttendanceResponse])
def get_attendance(
    attendance_date: date,
    db: Session = Depends(get_db)
):
    records = db.query(Attendance).filter(
        Attendance.date == attendance_date
    ).all()

    return records

 
@app.put("/attendance/{attendance_id}", response_model=AttendanceResponse)
def update_attendance(
    attendance_id: int,
    updated_data: AttendanceCreate,
    db: Session = Depends(get_db)
):
    attendance = db.query(Attendance).filter(
        Attendance.id == attendance_id
    ).first()

    if not attendance:
        raise HTTPException(
            status_code=404,
            detail="Attendance record not found"
        )

    
    employee = db.query(Employee).filter(
        Employee.id == updated_data.employee_id
    ).first()

    if not employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found"
        )

     
    duplicate = db.query(Attendance).filter(
        Attendance.employee_id == updated_data.employee_id,
        Attendance.date == updated_data.date,
        Attendance.id != attendance_id
    ).first()

    if duplicate:
        raise HTTPException(
            status_code=400,
            detail="Attendance already exists for this employee on this date"
        )

    attendance.employee_id = updated_data.employee_id
    attendance.date = updated_data.date
    attendance.status = updated_data.status

    db.commit()
    db.refresh(attendance)

    return attendance


 
@app.delete("/attendance/{attendance_id}")
def delete_attendance(
    attendance_id: int,
    db: Session = Depends(get_db)
):
    attendance = db.query(Attendance).filter(
        Attendance.id == attendance_id
    ).first()

    if not attendance:
        raise HTTPException(
            status_code=404,
            detail="Attendance record not found"
        )

    db.delete(attendance)
    db.commit()

    return {"message": "Attendance deleted successfully"}
