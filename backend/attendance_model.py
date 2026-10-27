
from sqlalchemy import Column, Integer, String, Date, ForeignKey, UniqueConstraint
from database import Base


class Attendance(Base):
    __tablename__ = "attendance"

    __table_args__ = (
        UniqueConstraint(
            "employee_id",
            "date",
            name="unique_employee_attendance_per_day"
        ),
    )

    id = Column(Integer, primary_key=True, index=True)

    employee_id = Column(
        Integer,
        ForeignKey("employees.id"),
        nullable=False,
        index=True
    )

    date = Column(Date, nullable=False)

    status = Column(String(20), nullable=False)
