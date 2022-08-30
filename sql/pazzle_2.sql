-- 一度コード値0に変換するというが、サブクエリに対してやらないと実業務ではだめでは？
UPDATE 
  absenteeism as A1
SET
  severity_points = 0,
  reason_code = 'long term illness'
WHERE EXISTS
  (
    SELECT
      *
    FROM
      absenteeism as A2
    WHERE
      A1.emp_id = A2.emp_id
    AND
      (A2.absent_date + INTERVAL '1' DAY) = A1.absent_date
  )
;

DELETE FROM Personnel
  WHERE emp_id = (
    SELECT A1.emp_id
      FROM absenteeism as A1
    WHERE A1.emp_id = Personnel.emp_id
    AND absent_date 
      BETWEEN CURRENT_TIMESTAMP - INTERVAL '365' DAY
        AND CURRENT_TIMESTAMP
    GROUP BY A1.emp_id
    HAVING SUM(severity_points) >= 40
  )
;