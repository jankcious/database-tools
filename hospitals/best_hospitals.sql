SELECT 
hospitalname, 
AVG(score / avg_mScore * 100) as Score_Index 
FROM procedure 
INNER JOIN (
SELECT measureID, 
AVG(score) as Avg_mScore 
FROM procedure 
WHERE measureID <> "EDV" AND Score <> "Not Available" GROUP BY measureID) as average_table 
ON procedure.measureID = average_table.measureID 
GROUP BY hospitalname 
ORDER BY Score_Index DESC 
LIMIT 10;