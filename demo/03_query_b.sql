CREATE VIEW Commercial_Lease AS
SELECT * FROM Lease
WHERE Type = 'Commercial';

SELECT DISTINCT P.Name
FROM Property P, Commercial_Lease CL
WHERE P.PropertyID = CL.PropertyID
AND P.PropertyID NOT IN (SELECT PropertyID FROM Lease
WHERE Type = 'Residential');
