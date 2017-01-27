SELECT 
procedure.measureID, 
SQRT(sum((score - Avg_mScore) * (score - Avg_mScore)) / measureCount) as Std_Dev 
FROM procedure 
INNER JOIN 
(SELECT 
measureID, 
Count(*) as measureCount 
FROM 
procedure 
WHERE score <> "Not Available" 
GROUP BY measureID) as countTable 
ON procedure.measureID = countTable.measureID 
INNER JOIN 
(SELECT measureID, AVG(score) as Avg_mScore 
FROM procedure 
WHERE measureID <> "EDV" AND Score <> "Not Available" 
GROUP BY measureID) as average_table 
ON procedure.measureID = average_table.measureID 
GROUP BY procedure.measureID, measureCount 
ORDER BY Std_Dev DESC 
LIMIT 10;