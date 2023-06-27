/*
    서브쿼리(SUBQUERY)
    - 하나의 SQL문 안에 포함된 또 다른 SQL문
*/
-- 간단 서브쿼리 예시1
-- 노옹철 사원과 같은 부서원들을 조회
-- 1) 먼저 노옹철 사원의 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; 


--2) 부서코드가 D9인 사원들을 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--> 위의 두 쿼리 합치면 됨!!
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철'); 
                    
--> 전 직원의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 사원명, 직급코드, 급여 조회

SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE);

/*
    서브쿼리의 분류
    - 서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라서 분류됨 
    - 서브쿼리의 종류에 따라 서브쿼리 앞에 붙는 연산자가 달라짐 
*/

/*
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
    - 서브쿼리의 조회 결과값의 개수가 오로지 1개일 때 (한 행 한 열) 
    - 일반 비교연산자 사용 가능 : =, !=, >, <, >=, ...
*/
-- 노옹철 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서명, 
-- 직급 코드, 급여 조회
SELECT EMP_ID, EMP_NAME,DEPT_TITLE,JOB_CODE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE SALARY >(SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'); 

-- 부서별 급여의 합이 가장 큰 부서의 부서 코드, 급여의 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE);

-- 전지연 사원이 속해 있는 부서원들의 사번, 사원명, 전화번호, 직급명, 부서명, 입사일 조회 (단, 전지연 사원은 제외)

SELECT EMP_ID, EMP_NAME, PHONE, DEPT_TITLE ,HIRE_DATE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE =(SELECT DEPT_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '전지연')
AND EMP_NAME NOT IN '전지연'; 

/*
    2. 다중행 서브쿼리
    
    IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 잇다면
*/
-- 각 부서별 최고 급여 조회

SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; 

-- 위의 급여를 받는 사원들 조회
SELECT EMP_NAME,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2890000, 3660000,80000000,3760000,3900000,2490000,2550000);

-- 각 부서별 최고 급여를 받는 사원들 조회
SELECT EMP_NAME,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE);

-- 사원에 대해 사번, 이름, 부서 코드, 구분(사수/사원) 조회
SELECT *
FROM EMPLOYEE;
-- 사수에 해당하는 사번을 조회
SELECT EMP_ID, EMP_NAME,DEPT_CODE, NVL2(MANAGER_ID, '사원', '사수') 구분
FROM EMPLOYEE;

SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 사번이 위와 같은 직원들의 사번, 이름, 부서코드, 구분(사수) 조회
SELECT EMP_ID, EMP_NAME ,DEPT_CODE, '사수' AS "구분"
FROM EMPLOYEE
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL)
UNION
-- 일반 사원에 해당하는 직원들의 사번, 이름, 부서코드, 구분(사원) 조회
SELECT EMP_ID, EMP_NAME ,DEPT_CODE, '사원' AS "구분"
FROM EMPLOYEE
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL);
                 
-- 위의 결과를 합치기만 하면 됨~! 

-- SELECT 절에서 서브쿼리를 사용하는 방법
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL) THEN '사수'
    ELSE '사원'
    END as "구분"
FROM EMPLOYEE; 

/*
    비교대상 > ANY(서브쿼리) : 여러개의 결과값 중에서 "한개라도" 클 경우
                             (여러개의 결과값 중에서 가장 작은 값 보다 클 경우)
                             
    비교대상 < ANY(서브쿼리) : 여러개의 결과값 중에서 "한개라도" 작을 경우
                             (여러개의 결과값 중에서 가장 큰 값 보다 작을 경우)
*/
-- 대리 직급임에도 과장 직급들의 최소 급여보다 많이 받는 직원의 사번,이름, 직급명, 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

SELECT EMP_ID,EMP_NAME,JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY > ANY (SELECT SALARY
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '과장')
AND JOB_NAME = '대리'; 

/*
    비교대상 > ALL(서브쿼리) : 여러개의 "모든" 결과값들 보다 클 경우
    비교대상 < ALL(서브쿼리) : 여러개의 "모든" 결과값들 보다 작을 경우
*/
-- 과장 직급임에도 차장 직급의 최대 급여보다 더 많이 받는 직원들의 사번, 이름, 직급, 급여 조회 (사원 > 대리 > 과장> 차장> 부장)

SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';

SELECT EMP_ID,EMP_NAME,JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL (SELECT SALARY
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '차장');
                
/*
    3. 다중열 서브쿼리
    - 서브쿼리의 조회 결과값이 한 행이지만 컬럼이 여러개일 때 (한행 여러열)
*/
-- 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당하는 사원들 조회
-- 하이유 사원의 부서 코드, 직급코드
SELECT DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';

SELECT EMP_NAME, DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
AND JOB_CODE = 'J5'; 

-- 단일행 서브쿼리로 작성
SELECT EMP_NAME, DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE 
                   FROM EMPLOYEE 
                   WHERE EMP_NAME = '하이유') 
AND JOB_CODE = (SELECT JOB_CODE 
                   FROM EMPLOYEE 
                   WHERE EMP_NAME = '하이유') ; 
                   
-- 다중열 서브쿼리를 사용해서 작성하는 방법
SELECT EMP_NAME, DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE,JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '하이유');
                                
-- 박나라 사원과 직급 코드가 일치하면서 같은 사수를 가지고 있는 사원의 사번, 이름, 직급 코드, 사수 사번 조회
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라';

SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박나라')
                                AND EMP_NAME != '박나라';
/*
    다중행 다중열 서브쿼리
    - 서브쿼리의 조회 결과값이 여러 행, 여러 열일 경우 (여러행 여러열) 
*/
-- 각 직급별로 최소 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여 조회
-- 최자ㅓ급여 
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 다중행 다중열 서브쿼리 사용!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);

/*
    인라인 뷰
    - FROM 절에 서브쿼리를 제시하고, 서브쿼리를 수행한 결과를 테이블 대신 사용 
*/
-- 전 직원 중 급여가 가장 높은 상위 5명 순위, 이름, 급여 조회
-- ROWNUM : 오라클에서 제공하는 컬럼, 조회된 순서대로 1부터 순번을 부여하는 컬럼

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
-- 이미 순번이 정해진 다음에 정렬이 됨

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC)
WHERE ROWNUM <=5;

-- 부서별 평균 급여가 높은 3개 부서의 부서 코드, 평균 급여 조회
SELECT DEPT_CODE, ROUND(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY ROUND(AVG(NVL(SALARY, 0))) DESC;

SELECT ROWNUM, DEPT_CODE, AVG_SALARY
FROM (SELECT DEPT_CODE, ROUND(AVG(NVL(SALARY, 0))) "AVG_SALARY"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY ROUND(AVG(NVL(SALARY, 0))) DESC)
WHERE ROWNUM <= 3;

--2 ) WITH를 사용하는 방법
WITH TOPN_SAL AS (
    SELECT DEPT_CODE, ROUND(AVG(NVL(SALARY, 0))) "AVG_SALARY"
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY AVG(NVL(SALARY, 0)) DESC
)
    
SELECT ROWNUM, DEPT_CODE, AVG_SALARY
FROM TOPN_SAL
WHERE ROWNUM <= 3;


/*
    RANK 함수
    - RANK() OVER(정렬 기준) : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너뛰고 순위를 계산한다.
      (ex. 공동 1위가 2명이면 다음 순위는 3위)
    - DENSE_RANK() OVER(정렬 기준) : 동일한 순위 이후의 등수를 무조건 1씩 증가한다.
      (ex. 공동 1위가 2명이면 다음 순위는 2위)
*/
-- 사원별 급여가 높은 순서대로 순위 매겨서 순위, 사원명, 급여 조회
-- 공동 19위 2명 뒤에 순위는 21위
SELECT 
    RANK() OVER(ORDER BY SALARY DESC),
    EMP_NAME,
    SALARY
FROM EMPLOYEE;

-- 공동 19위 2명 뒤에 순위는 20위
SELECT 
    DENSE_RANK() OVER(ORDER BY SALARY DESC),
    EMP_NAME,
    SALARY
FROM EMPLOYEE;

-- 상위 5명만 조회
-- RANK 함수는 WHERE 절에 사용할 수 없다
SELECT 
    RANK() OVER(ORDER BY SALARY DESC),
    EMP_NAME,
    SALARY
FROM EMPLOYEE
WHERE ROWNUM <=5; -- 이렇게 사용 금지!

SELECT RANK, EMP_NAME, SALARY
FROM(
    SELECT 
        RANK() OVER(ORDER BY SALARY DESC) "RANK",
        EMP_NAME,
        SALARY
    FROM EMPLOYEE
)
WHERE RANK <= 5;










