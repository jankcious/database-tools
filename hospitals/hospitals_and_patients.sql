
SELECT ((psum - (sum1 * sum2 / n)) / sqrt((sum1sq - pow(sum1, 2.0) / n) * (sum2sq - pow(sum2, 2.0) / n))) AS r,
pow(((psum - (sum1 * sum2 / n)) / sqrt((sum1sq - pow(sum1, 2.0) / n) * (sum2sq - pow(sum2, 2.0) / n))), 2.0) AS rsq,
n
FROM
(SELECT 
SUM(hcahpsbase) AS sum1,
SUM(Score_index) AS sum2,
SUM(hcahpsbase * hcahpsbase) AS sum1sq,
SUM(Score_index * Score_index) AS sum2sq,
SUM(Score_index * hcahpsbase) AS psum,
COUNT(*) AS n
FROM hospital
INNER JOIN
(SELECT 
hospitalname, 
AVG(score / avg_mScore * 100) as Score_Index 
FROM procedure 
INNER JOIN 
(SELECT measureID, 
AVG(score) as Avg_mScore 
FROM procedure 
WHERE measureID <> "EDV" AND Score <> "Not Available" GROUP BY measureID) as average_table 
ON procedure.measureID = average_table.measureID 
GROUP BY hospitalname ) as index_table
ON hospital.hospitalname = index_table.hospitalname) as scores_table
UNION ALL
SELECT ((psum - (sum1 * sum2 / n)) / sqrt((sum1sq - pow(sum1, 2.0) / n) * (sum2sq - pow(sum2, 2.0) / n))) AS r,
pow(((psum - (sum1 * sum2 / n)) / sqrt((sum1sq - pow(sum1, 2.0) / n) * (sum2sq - pow(sum2, 2.0) / n))), 2.0) AS rsq,
n
FROM
(SELECT
SUM(hcahpsconsistency) AS sum1,
SUM(Std_Dev) AS sum2,
SUM(hcahpsconsistency * hcahpsconsistency) AS sum1sq,
SUM(Std_Dev * Std_Dev) AS sum2sq,
SUM(hcahpsconsistency * Std_Dev) AS psum,
COUNT(*) AS n
FROM
(SELECT hospitalname, HCAHPSConsistency FROM hospital) as hSurvey_table
INNER JOIN
(SELECT hm_table.hospitalname,
SQRT(sum((score_index - Avg_hScore) * (score_index - Avg_hScore)) / COUNT(hm_table.measureID)) as Std_Dev
FROM
(SELECT hospitalname,
procedure.measureID,
score / avg_mScore * 100 as Score_Index
FROM
procedure
INNER JOIN 
(SELECT measureID, 
AVG(score) as avg_mScore
FROM procedure 
WHERE measureID <> "EDV" AND score <> "Not Available" GROUP BY measureID) as average_table
on procedure.measureID = average_table.measureID) as hm_table
INNER JOIN
(SELECT hospitalname,
AVG(Score_Index) as Avg_hScore
FROM 
(SELECT hospitalname,
procedure.measureID,
score / avg_mScore * 100 as Score_Index
FROM
procedure
INNER JOIN 
(SELECT measureID, 
AVG(score) as avg_mScore
FROM procedure 
WHERE measureID <> "EDV" AND score <> "Not Available" GROUP BY measureID) as average_table
on procedure.measureID = average_table.measureID) as hm_table
GROUP BY hospitalname) as havg_table
ON hm_table.hospitalname = havg_table.hospitalname
GROUP BY hm_table.hospitalname) as score_table
ON score_table.hospitalname = hSurvey_table.hospitalname) as final_table;
