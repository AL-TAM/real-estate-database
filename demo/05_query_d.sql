SELECT LeaseID, Category, SUM(Amount)
FROM Payment
GROUP BY LeaseID, Category
ORDER BY LeaseID, Category;
