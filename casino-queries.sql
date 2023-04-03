use CasinoDB

/*
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
	WHERE SCHEDULE.SCH_DATE BETWEEN DATEADD(month, -1, GETDATE() ) AND GETDATE() ) AS SHIFTS_LAST_MO
ON EMPLOYEE.EMP_ID = SHIFTS_LAST_MO.EMP_ID
WHERE SHIFTS_LAST_MO.SHIFT_TYPE = 'B';




/*
	QUERY FOUR
*/

SELECT COUNT(*) AS "Breaker Shifts this Week"
FROM SHIFT sh
INNER JOIN SCHEDULE s
ON sh.SCH_ID = s.SCH_ID
WHERE sh.SHIFT_TYPE = 'B'
AND DATEPART(week, s.SCH_DATE) = DATEPART(week, GETDATE());



/*
	QUERY FIVE
*/

SELECT COUNT(*) AS "Slot Attendants Today"
FROM EMPLOYEE e
INNER JOIN ROLE r
ON e.ROLE_ID = r.ROLE_ID
INNER JOIN SHIFT sh
ON e.EMP_ID = sh.EMP_ID
INNER JOIN SCHEDULE s
ON sh.SCH_ID = s.SCH_ID
WHERE r.ROLE_TITLE = 'Slot Attendant' AND s.SCH_DATE = CAST(GETDATE() as DATE);



/*
	QUERY SIX
*/

SELECT DISTINCT e.EMP_ID as "Employee ID", e.EMP_NAME as "Employee Name"
FROM EMPLOYEE e
INNER JOIN ROLE r
ON e.ROLE_ID = r.ROLE_ID
LEFT JOIN SHIFT sh
ON e.EMP_ID = sh.EMP_ID
WHERE r.ROLE_TITLE = 'Slot Attendant' AND e.EMP_ID NOT IN 
	( SELECT sh.EMP_ID
	FROM SHIFT sh
	INNER JOIN SECTION sec
	ON sh.SEC_ID = sec.SEC_ID
	INNER JOIN SCHEDULE s
	ON sh.SCH_ID = s.SCH_ID
	WHERE sec.SEC_NAME = 'North' AND s.SCH_DATE BETWEEN DATEADD(month, -1, GETDATE() ) AND GETDATE() );

SELECT *
FROM SHIFT sh
INNER JOIN SECTION sec
ON sh.SEC_ID = sec.SEC_ID
INNER JOIN SCHEDULE s
ON sh.SCH_ID = s.SCH_ID
WHERE sec.SEC_NAME = 'North' AND s.SCH_DATE BETWEEN DATEADD(month, -1, GETDATE() ) AND GETDATE();


/*
	QUERY SEVEN - considering employee A as employee #3
*/

SELECT EMP_ID as "Employee ID", COUNT(*) AS "Active Warnings"
FROM WRITTEN_WARNING
WHERE EMP_ID = 3 AND WW_STATUS = 1
GROUP BY EMP_ID;



/*
	QUERY EIGHT - assuming date sorted from oldest to newest
*/

SELECT *
FROM WRITTEN_WARNING
WHERE WW_STATUS = 1
ORDER BY WW_DATE, EMP_ID;



/*
	QUERY NINE
*/

SELECT EMP_ID, WW_ID, WW_DATE, WW_COMMENTS
FROM WRITTEN_WARNING
WHERE EMP_ID = 3;


/*
	QUERY TEN - start and end dates inclusive
*/


SELECT *, ( DATEDIFF(day, LEAVE_START, LEAVE_END) + 1 ) as "Sick Days Taken"
FROM LEAVE
WHERE LEAVE_TYPE = 'S';

SELECT e.EMP_ID as "Employee ID", e.EMP_NAME as "Employee Name", e.EMP_SICK_DAYS_ENTITLEMENT as "Sick Day Entitlement", SUM ( ISNULL( DATEDIFF(day, SickLeave.LEAVE_START, SickLeave.LEAVE_END) + 1, 0 ) ) as "Sick Days Taken",
	e.EMP_SICK_DAYS_ENTITLEMENT - SUM ( ISNULL( DATEDIFF(day, SickLeave.LEAVE_START, SickLeave.LEAVE_END) + 1, 0 ) ) as "Sick Days Left"
FROM EMPLOYEE e
LEFT JOIN (
	SELECT *
	FROM LEAVE l
	WHERE LEAVE_TYPE = 'S' and DATEPART(year, LEAVE_END) = DATEPART(year, GETDATE())
) as SickLeave
ON SickLeave.EMP_ID = e.EMP_ID
GROUP BY e.EMP_ID, e.EMP_NAME, e.EMP_SICK_DAYS_ENTITLEMENT;

SELECT e.EMP_ID as "Employee ID", e.EMP_NAME as "Employee Name", 
	e.EMP_SICK_DAYS_ENTITLEMENT as "Sick Day Entitlement", 
	SUM ( ISNULL( DATEDIFF(day, 
		(CASE
			WHEN DATEPART(year, SickLeave.LEAVE_START) = DATEPART(year, GETDATE()) THEN SickLeave.LEAVE_START
			ELSE DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
		END), 
		SickLeave.LEAVE_END) + 1, 0 ) ) as "Sick Days Taken",
	e.EMP_SICK_DAYS_ENTITLEMENT - SUM ( ISNULL( DATEDIFF(day, 
		( CASE 
			WHEN DATEPART(year, SickLeave.LEAVE_START) = DATEPART(year, GETDATE()) THEN SickLeave.LEAVE_START
			ELSE DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
		END ), 
		SickLeave.LEAVE_END) + 1, 0 ) ) as "Sick Days Left"
FROM EMPLOYEE e
LEFT JOIN (
	SELECT *
	FROM LEAVE l
	WHERE LEAVE_TYPE = 'S' and DATEPART(year, LEAVE_END) = DATEPART(year, GETDATE())
) as SickLeave
ON SickLeave.EMP_ID = e.EMP_ID
GROUP BY e.EMP_ID, e.EMP_NAME, e.EMP_SICK_DAYS_ENTITLEMENT;
*/

/*
	QUERY ELEVEN - start and end dates inclusive
*/


SELECT *, ( DATEDIFF(day, LEAVE_START, LEAVE_END) + 1 ) as "Vacation Days Taken"
FROM LEAVE
WHERE LEAVE_TYPE = 'V';

SELECT e.EMP_ID as "Employee ID", e.EMP_NAME as "Employee Name", e.EMP_VACATION_ENTITLEMENT as "Vacation Entitlement", SUM ( ISNULL( DATEDIFF(day, VacationLeave.LEAVE_START, VacationLeave.LEAVE_END) + 1, 0 ) ) as "Vacation Days Taken",
	e.EMP_VACATION_ENTITLEMENT - SUM ( ISNULL( DATEDIFF(day, VacationLeave.LEAVE_START, VacationLeave.LEAVE_END) + 1, 0 ) ) as "Vacation Days Left"
FROM EMPLOYEE e
LEFT JOIN (
	SELECT *
	FROM LEAVE l
	WHERE LEAVE_TYPE = 'V'
) as VacationLeave
ON VacationLeave.EMP_ID = e.EMP_ID
GROUP BY e.EMP_ID, e.EMP_NAME, e.EMP_VACATION_ENTITLEMENT;


SELECT e.EMP_ID as "Employee ID", e.EMP_NAME as "Employee Name", 
	e.EMP_VACATION_ENTITLEMENT as "Vacation Entitlement", 
	SUM ( ISNULL( DATEDIFF(day, 
		(CASE
			WHEN DATEPART(year, VacationLeave.LEAVE_START) = DATEPART(year, GETDATE()) THEN VacationLeave.LEAVE_START
			ELSE DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
		END), 
		VacationLeave.LEAVE_END) + 1, 0 ) ) as "Vacation Days Taken",
	e.EMP_VACATION_ENTITLEMENT - SUM ( ISNULL( DATEDIFF(day, 
		( CASE 
			WHEN DATEPART(year, VacationLeave.LEAVE_START) = DATEPART(year, GETDATE()) THEN VacationLeave.LEAVE_START
			ELSE DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)
		END ), 
		VacationLeave.LEAVE_END) + 1, 0 ) ) as "Vacation Days Left"
FROM EMPLOYEE e
LEFT JOIN (
	SELECT *
	FROM LEAVE l
	WHERE LEAVE_TYPE = 'V' and DATEPART(year, LEAVE_END) = DATEPART(year, GETDATE())
) as VacationLeave
ON VacationLeave.EMP_ID = e.EMP_ID
GROUP BY e.EMP_ID, e.EMP_NAME, e.EMP_VACATION_ENTITLEMENT;


/*

--q12, but only current employees
SELECT 
  (SELECT COUNT(*) FROM EMPLOYEE WHERE EMP_GENDER = 'F' AND EMP_FIRE_DATE IS NULL AND EMP_DEPART_DATE IS NULL) AS NumberOfFemaleEmployees,
  (SELECT COUNT(*) FROM EMPLOYEE WHERE EMP_GENDER = 'M' AND EMP_FIRE_DATE IS NULL AND EMP_DEPART_DATE IS NULL) AS NumberOfMaleEmployees,
  AVG(DATEDIFF(YEAR, EMP_DOB, GETDATE())) AS AverageAge,
  (SELECT COUNT(*) FROM EMPLOYEE WHERE DATEDIFF(YEAR, EMP_DOB, GETDATE()) > 50 AND EMP_FIRE_DATE IS NULL AND EMP_DEPART_DATE IS NULL) AS NumberOfEmployeesOver50,
  (SELECT COUNT(*) FROM EMPLOYEE WHERE DATEDIFF(YEAR, EMP_DOB, GETDATE()) < 30 AND EMP_FIRE_DATE IS NULL AND EMP_DEPART_DATE IS NULL) AS NumberOfEmployeesUnder30
FROM EMPLOYEE
WHERE EMP_FIRE_DATE IS NULL AND EMP_DEPART_DATE IS NULL;


--Q13
--List of employees who has the mandatory certification expiring in the next 6 weeks
SELECT 
    e.EMP_ID, e.EMP_NAME, c.CERT_NAME, c.CERT_VALID_FOR, ts.TRAIN_DATE
FROM 
    EMPLOYEE e
JOIN 
    EMP_EXTERNAL_TRAINING eet ON e.EMP_ID = eet.EMP_ID
JOIN 
    EXTERNAL_SESSION es ON eet.TRAIN_ID = es.TRAIN_ID
JOIN 
    CERTIFICATION c ON es.CERT_ID = c.CERT_ID
JOIN 
    TRAINING_SESSION ts ON es.TRAIN_ID = ts.TRAIN_ID
JOIN
    ROLE_CERT rc ON c.CERT_ID = rc.CERT_ID
WHERE 
    e.ROLE_ID = rc.ROLE_ID AND e.EMP_FIRE_DATE IS NULL AND e.EMP_DEPART_DATE IS NULL AND
    DATEADD(month, c.CERT_VALID_FOR, ts.TRAIN_DATE) BETWEEN GETDATE() AND DATEADD(week, 6, GETDATE())
ORDER BY 
    e.EMP_ID;

--Q14
--List of employees who need updated in-house training
-- only checks if the employee skill is not valid anymore
--do we want a list of employee and the skill needed to be updated? or just a list of emps that need new training, do we group by emp or skill?
SELECT e.EMP_ID, e.EMP_NAME, s.SKILL_ID, s.SKILL_NAME
FROM EMPLOYEE e
JOIN EMPLOYEE_SKILL es ON e.EMP_ID = es.EMP_ID
JOIN SKILL s ON es.SKILL_ID = s.SKILL_ID
WHERE es.IS_VALID = 0;



--Q15 -List of employees who have expired training

--
-- ps does it make sense for valid for to be a date rather than an int representing number of months or years valid for.
-- cases emp 1 took 2 sessions for cert 1, passed both, one was 3 years ago , one was last month, not shown, PASS
-- does not take into account if employee needs a cert for their role but has never taken it,
-- does not take into account a cert that the emp has failed
-- update creation of cert and insert to be int for months instead NEEDED for this to work

SELECT DISTINCT e.EMP_ID, e.EMP_NAME, c.CERT_NAME, c.CERT_ID
FROM EMPLOYEE e
JOIN EMP_EXTERNAL_TRAINING eet ON e.EMP_ID = eet.EMP_ID
JOIN EXTERNAL_SESSION es ON eet.TRAIN_ID = es.TRAIN_ID
JOIN CERTIFICATION c ON es.CERT_ID = c.CERT_ID
JOIN TRAINING_SESSION ts ON eet.TRAIN_ID = ts.TRAIN_ID
WHERE DATEADD(MONTH, c.CERT_VALID_FOR, ts.TRAIN_DATE) < GETDATE() AND eet.IS_SUCCESSFUL = 1;


--Q16 --How many uniforms remain un-allocated?

--does not make use of inventory_shift junction table, revist possibly
-- literally just checks quantity of uniforms
-- 

SELECT 
    (SELECT INV_QTY FROM INVENTORY WHERE INV_ID = 10) - 
    (SELECT COUNT(EMP_ID) FROM EMPLOYEE WHERE EMP_FIRE_DATE IS NULL AND EMP_DEPART_DATE IS NULL) 
    AS UnallocatedUniforms;


	*/