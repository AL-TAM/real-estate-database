SHOW TABLES;

SELECT 'Tenant' AS Relation, COUNT(*) AS Tuples FROM Tenant
UNION ALL SELECT 'Property', COUNT(*) FROM Property
UNION ALL SELECT 'Lease', COUNT(*) FROM Lease
UNION ALL SELECT 'Payment', COUNT(*) FROM Payment
UNION ALL SELECT 'Certificate', COUNT(*) FROM Certificate
UNION ALL SELECT 'Contractor', COUNT(*) FROM Contractor
UNION ALL SELECT 'Staff', COUNT(*) FROM Staff
UNION ALL SELECT 'Request', COUNT(*) FROM Request
UNION ALL SELECT 'Property_Staff', COUNT(*) FROM Property_Staff
UNION ALL SELECT 'Property_Contractor', COUNT(*) FROM Property_Contractor;
