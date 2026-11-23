CREATE VIEW Contractor_Count (PropertyID, Num_contractors) AS
SELECT PropertyID, COUNT(*)
FROM Property_Contractor
GROUP BY PropertyID;

SELECT P.Name
FROM Property P, Contractor_Count CC
WHERE P.PropertyID = CC.PropertyID
AND CC.Num_contractors >= ALL (SELECT Num_contractors FROM Contractor_Count);
