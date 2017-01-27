SELECT 
state, 
AVG(score / avg_mScore * 100) as Score_Index 
FROM 
procedure 
INNER JOIN 
(SELECT 
measureID, 
AVG(score) as Avg_mScore 
FROM 
procedure 
WHERE measureID <> "EDV" AND Score <> "Not Available" 
GROUP BY measureID) as average_table 
ON procedure.measureID = average_table.measureID 
INNER JOIN hospital ON procedure.providerID = hospital.providerID 
GROUP BY state 
ORDER BY Score_Index DESC 
LIMIT 10;
