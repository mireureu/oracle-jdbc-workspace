--1번 문제
SELECT STUDENT_NAME AS "학생 이름", STUDENT_ADDRESS AS "주소지"
FROM TB_STUDENT
ORDER BY 1;
--2번 문제
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY 2 DESC;
--3번 문제
SELECT STUDENT_NAME, STUDENT_NO, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_NO,0,1) = '9'
AND SUBSTR(STUDENT_ADDRESS,0,3) ='경기도'
OR SUBSTR(STUDENT_ADDRESS,0,3) ='강원도'
--AND SUBSTR(STUDENT_ADDRESS,0,3) IN ('경기도','강원도')
ORDER BY 1;
--4번 문제
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO = '005'
ORDER BY 2;
--5번 문제
SELECT STUDENT._NO, POINT||''
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE CLASS_NO = 'C3118100'
AND TERM_NO = '200402'
ORDER BY POINT DESC;
--6번 문제
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY 2;
--7번 문제
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY 2;
--8번 문제
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
ORDER BY 2;
--9번 문제
SELECT STUDENT_NO, STUDENT_NAME, ROUND(AVG(POINT),1)
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NO = 059
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY 1;
--10번 문제
SELECT DEPARTMENT_NAME, STUDENT_NAME,PROFESSOR_NAME
FROM TB_DEPARTMENT
JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
JOIN TB_STUDENT USING(DEPARTMENT_NO)
WHERE STUDENT_NO = 'A313047';
--11번 문제
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
WHERE SUBSTR(TERM_NO,0,4) = 2007
AND  CLASS_NO = 'C2604100'
ORDER BY 1;
--12번 문제 죽여주세요
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE CATEGORY = '예체능';

--13번 문제
SELECT STUDENT_NAME, NVL(PROFESSOR_NAME, '지도교수 미지정')
FROM TB_STUDENT
LEFT JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
WHERE COACH_PROFESSOR_NO IS NULL
ORDER BY STUDENT_NO;
