use CasinoDB

/*
	QUERY ONE - tested on separate database
*/

select * from SHIFT
inner join EMPLOYEE
on EMPLOYEE.EMP_ID=SHIFT.EMP_ID
WHERE SHIFT.emp_ID=5;

select *, DATEPART(week, SCHEDULE.sch_date) as week
from schedule
where sch_id = 9 or sch_id = 10;

SELECT DATEPART(week, SCHEDULE.sch_date) as Week, EMPLOYEE.EMP_ID as Employee, sum( DATEPART(hour, SHIFT.shift_end) - DATEPART(hour, SHIFT.shift_start) ) as Hours
FROM SCHEDULE
INNER JOIN SHIFT 
ON SCHEDULE.sch_id = SHIFT.sch_id
INNER JOIN EMPLOYEE
ON EMPLOYEE.emp_id = SHIFT.emp_id
GROUP BY DATEPART(week, SCHEDULE.sch_date), EMPLOYEE.EMP_ID
ORDER BY DATEPART(week, SCHEDULE.sch_date);

( DATEPART(week, CAST(GETDATE() as date)) - 1 )



/*
	QUERY TWO - tested on separate database
*/


select * from shift order by sch_id;
select DATEPART(week, SCHEDULE.sch_date) as Week, * from schedule;

SELECT DATEPART(week, SCHEDULE.sch_date) as Week, sum( DATEPART(hour, SHIFT.shift_end) - DATEPART(hour, SHIFT.shift_start) ) as Hours
FROM SCHEDULE
INNER JOIN SHIFT
ON SHIFT.sch_id = SCHEDULE.sch_id
GROUP BY DATEPART(week, SCHEDULE.sch_date);



/*
	QUERY THREE
*/


SELECT SHIFT_ID, SHIFT_TYPE, SHIFT.EMP_ID
FROM SHIFT
INNER JOIN SCHEDULE
ON SHIFT.SCH_ID = SCHEDULE.SCH_ID
WHERE DATEPART(month, SCHEDULE.SCH_DATE) = (DATEPART(month, CAST(GETDATE() as date)) - 1);


SELECT DISTINCT EMPLOYEE.EMP_ID as "Employee ID", EMPLOYEE.EMP_NAME as "Employee Name"
FROM EMPLOYEE
INNER JOIN 
	( SELECT SHIFT_ID, SHIFT_TYPE, SHIFT.EMP_ID
	FROM SHIFT
	INNER JOIN SCHEDULE
	ON SHIFT.SCH_ID = SCHEDULE.SCH_ID
	WHERE DATEPART(month, SCHEDULE.SCH_DATE) = (DATEPART(month, CAST(GETDATE() as date)) - 1) ) AS SHIFTS_LAST_MO
ON EMPLOYEE.EMP_ID = SHIFTS_LAST_MO.EMP_ID
WHERE SHIFTS_LAST_MO.SHIFT_TYPE = 'B';


