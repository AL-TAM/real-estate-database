SELECT C.Name
FROM Contractor C, Property_Contractor PC
WHERE C.ContractorID = PC.ContractorID
GROUP BY C.ContractorID, C.Name
HAVING COUNT(*) >= 2;
