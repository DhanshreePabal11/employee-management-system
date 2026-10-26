
from database import engine

try:
    with engine.connect() as connection:
        print("MySQL connected successfully!")

except Exception as error:
    print("MySQL connection failed:")
    print(error)
