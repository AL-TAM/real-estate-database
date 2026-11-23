SELECT First_name, Last_name
FROM Staff
WHERE StaffID NOT IN (SELECT StaffID FROM Request);
