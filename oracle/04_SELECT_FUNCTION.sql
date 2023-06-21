/*
    함수 : 전달된 컬럼값을 읽어들여서 함수를 실행한 결과를 반환
    
    - 단일행 함수 : N 개의 값을 읽어서 N 개의 결과값을 리턴 (매 행마다 함수 실행 결과 반환)
    
    - 그룹 함수 : N 개의 값을 읽어서 1개의 결과값을 리턴 (그룹별로 함수 실행 결과 반환)
    
    >> SELECT 절에 단일행 함수와 그룹 함수는 함께 사용하지 못함
       왜? 결과 행의 갯수가 다르기 때문에!
       
    >> 함수식을 기술할 수 있는 위치 : SELECT, WHERE, ORDER BY, GROUP BY, HAVING
*/

-- 단일행 함수 --------------------------------------------------------------------------------------------------
/*
 문자 처리 함수
 
 LENGTH / LENGTHB 
 - LENGTH(컬럼|'문자열값') : 해당 값의 글자 수 반환 
 - LENGTHB(컬럼|'문자열값') : 해당 값의 바이트 수 반환
 
 한글 한 글자 -> 3BYTE
 영문자, 숫자, 특수문자 한 글자 -> 1BYTE 
*/
SELECT 
    LENGTH('오라클'), LENGTHB('오라클'),
    LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL; -- 오라클에서 제공하는 가상 테이블

-- 사원명, 사원명의 글자 수, 사원명의 바이트 수, 이메일, 이메일의 글자 수, 이메일의 바이트 수 조회

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE
ORDER BY EMP_NAME;

/*
    INSTR
    - INSTR(STRING, STR [, POSITION, OCCURRENCE])
    - 지정한 위치부터 지정된 숫자 번째로 나타나는 문자의 시작 위치를 반환
    
    설명
    - STRING : 문자 타입 컬럼 또는 문자열
    - STR : 찾으려는 문자열
    - POSITION : 찾을 위치의 시작 값(기본값 1)
        1 : 앞에서부터 찾는다.
       -1 : 뒤에서부터 찾는다.
    - OCCURRENCE : 찾을 문자값이 반복될 때 지정하는 빈도 (기본값 1), 음수 사용 불가 
*/
SELECT INSTR('AABAACAABBAA', 'B') d FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;

-- 's'가 포함되어 있는 이메일 중 이메일, 이메일의 @ 위치, 이메일에서 뒤에서 2번째에 있는 's' 위치 조회
SELECT EMAIL , INSTR (EMAIL, '@'), INSTR ( EMAIL, 's', -1, 2)
FROM EMPLOYEE
WHERE EMAIL LIKE '%s%';

/*
    LPAD / RPAD
    -  문자열을 조회할 떄 통일감있게 조회하고자 할 때 사용 
    - LPAD/RPAD(STRING, 최종적으로 반환할 문자의 길이, [덧붙이고자 하는 문자]) 
    - 문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열을 반환
*/
SELECT LPAD('HELLO', 10) FROM DUAL; -- 덧붙이고자 하는 문자 생략시 공백으로 채운다
SELECT LPAD('HELLO', 10, 'A') FROM DUAL; 
SELECT RPAD('HELLO', 10) FROM DUAL;
SELECT RPAD('HELLO', 10, '*') FROM DUAL;

SELECT RPAD(EMP_NO, 15,'*') FROM EMPLOYEE;

/*
 LTRIM / RTRIM
 - 문자열에서 특정 문자를 제거한 나머지를 반환
 - LTRIM/RTRIM(STRING, [제거하고자 하는 문자들])
 - 문자열의 왼쪽 또는 오른쪽에서 제거하고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환
*/
SELECT LTRIM('                K  H          ') FROM DUAL;
SELECT LTRIM('ACABACCKH', 'ABC') FROM DUAL; 
SELECT RTRIM('5782KH231', '0123456789') FROM DUAL;

/*
    TRIM 
    - 문자열의 양쪽(앞/뒤)에 있는 지정한 문자들을 제거한 나머지 문자열 반환
    - TRIM([LEADING|TRAILING|BOTH] 제거하고자 하는 문자들 FROM STRING)
    
*/
SELECT TRIM('         K        H           ' ) FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZZKHZZZZ') FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZZKHZZZ') FROM DUAL; -- LTRIM 과 같음(앞에만 제거)
SELECT TRIM(TRAILING 'Z' FROM 'ZZZZKHZZZ') FROM DUAL; -- RTRIM 과 같음(뒤에만 제거)

SELECT TRIM(BOTH 'Z' FROM 'ZZZZKHZZZ') FROM DUAL; --  BOTH 양쪽(앞/뒤) 제거

/*
    SUBSTR
    - 문자열에서 특정 문자열을 추출해서 반환
    - SUBSTR(STRING, POSITION, [LENGTH])
        SRING : 문자타입컬럼 또는 '문자열 값'
        POSITION : 문자열을 추출할 시작 위치값 ( 음수값도 가능)
        LENGTH : 추출할 문자 갯수(생략시 끝까지) 
*/

SELECT SUBSTR('PROGRAMMING', 5, 2) FROM DUAL;
SELECT SUBSTR('PROGRAMMING', -8, 3) FROM DUAL;

-- 여자사원들의 이름만 조회
SELECT EMP_NAME 
FROM EMPLOYEE
WHERE SUBSTR (EMP_NO, 8, 1) = 2; -- IN (2, 4);


--남자사원들의 이름만 조회
SELECT EMP_NAME 
FROM EMPLOYEE
WHERE SUBSTR (EMP_NO, 8, 1) = 1; -- IN (1, 3);

-- 사원명과 주민등록번호 (991212-1******) 조회
SELECT EMP_NAME ,RPAD(EMP_NO, 8)||'******'
FROM EMPLOYEE;


SELECT EMP_NAME ,RPAD(SUBSTR(EMP_NO, 1, 8),14,'*')
FROM EMPLOYEE;

-- 직원명, 이메일, 아이디(이메일에서 '@' 앞의 문자) 조회
SELECT EMP_NAME ,EMAIL, RTRIM(EMAIL, '@kh.or.kr') 아이디
FROM EMPLOYEE;

SELECT EMP_NAME , EMAIL, SUBSTR(EMAIL, 1,INSTR(EMAIL, '@') -1 ) 아이디
FROM EMPLOYEE;


/*
    LOWER / UPPER / INITCAP
    - LOWER/UPEER/INITCAP(STRING)
    LOWER : 다 소문자로 변경한 문자열 반환
    UPPER : 다 대문자로 변경한 문자열 반환
    INITCAP : 단어 앞글자마다 대문자로 변경한 문자열 반환
*/

SELECT LOWER('Welcom To My World!') FROM DUAL;
SELECT UPPER('Welcom To My World!') FROM DUAL;
SELECT INITCAP('welcom to ny world!') FROM DUAL;

/*
    CONCAT
    - 문자열 두개 전달받아 하나로 합친 후 결과 반환
    - CONCAT (STRING, STRING) 
*/
SELECT CONCAT('가나다라', 'ABCD') FROM DUAL;
SELECT '가나다라'||'ABCD' FROM DUAL; -- 연결연산자와 동일!

SELECT '가나다라'||'ABCD'||'1234' FROM DUAL; 
SELECT CONCAT(CONCAT(CONCAT('가나다라', 'ABCD'),323232),'hi') FROM DUAL;

/*
    REPLACE 
    - REPLACE(STRING, STR1, STR2)
      STRING : 컬럼 또는 문자열값
      STR1 : 변경시킬 문자열
      SRT2 : 변경할 문자열
*/
SELECT REPLACE('노석우', '석우', '석두') FROM DUAL;
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL; 

-- 사원명, 이메일, 이메일의 kh.or.kr를 gamil.com으로 변경해서 조회
SELECT EMP_NAME 이름,EMAIL "기존 이메일" ,REPLACE(EMAIL, 'kh.or.kr' , 'gamil.com') "변경된 이메일"
FROM EMPLOYEE; 

/*
    숫자 처리 함수
    
    ABS(NEMBER) : 숫자의 절대값을 구해주는 함수 
    
*/
SELECT ABS(-10) FROM DUAL; 

/*
    MOD(NUMBER, NUMBER) : 두 수를 나눈 나머지 값을 반환해주는 함수
*/
SELECT MOD(10, 3) FROM DUAL;
/*
    ROUND(NUMBER, [위치]) : 반올림한 결과를 반환하는 함수
*/
SELECT ROUND(123.456) FROM DUAL; -- 위치 생략시 0 
SELECT ROUND(123.456, 1) FROM DUAL; -- 123.5
SELECT ROUND(123.456, -2) FROM DUAL; --100

/*
    CEIL(NUMBER) : 올림처리해주는 함수
*/
SELECT CEIL(123.156) FROM DUAL; -- 124
/*
    FLOOR(NUMBER) : 소수점 아래 버림처리해주는 함수
*/
SELECT FLOOR(123.952) FROM DUAL;
/*
    TRUNC(NUMBER, [위치]) : 위치 지정 가능한 버림처리해주는 함수
*/
SELECT TRUNC(123.952) FROM DUAL; --123
SELECT TRUNC(123.952, 1) FROM DUAL; -- 123.9
SELECT TRUNC(123.952, -1) FROM DUAL;  --120

/*
    날짜 처리 함수
    SYSDATE : 시스템의 날짜를 반환 (현재 날짜)
*/
SELECT SYSDATE FROM DUAL;
-- 날짜 포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD'; -- 원래 포맷으로 변경

/*
    MONTHS_BETWEEN(DATE, DATE)
    - 입력받는 두 날짜 사이의 개월 수를 반환
*/
SELECT MONTHS_BETWEEN(SYSDATE, '20230521') FROM DUAL; 

-- 직원명, 입사일, 근무 개월 수 조회
SELECT EMP_NAME 직원명, HIRE_DATE 입사일, CEIL (MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무 개월 수" 
FROM EMPLOYEE;

/*
    ADD_MONTHS(DATE, NUMBER)
    - 특정 날짜에 입력받는 숫자만큼의 개월 수를 더한 날짜를 반환
*/
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;  

-- 직원명, 입사일, 입사 후 6개월이 된 날짜를 조회
SELECT EMP_NAME ,HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

/*
    NEXT_DAY(DATE, 요일(문자|숫자))
    - 특정 날짜에서 구하려는 요일의 가장 가까운 날짜를 리턴
    - 요일 : 1 - 일요일, 2 - 월요일, ..., 7 - 토요일
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 4) FROM DUAL;

-- 현재 언어가 KOREAN이기 때문에
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') FROM DUAL;

-- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

/*
    LAST_DAY(DATE)
    - 해당 월의 마지막 날짜를 반환
    
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;
 SELECT LAST_DAY('20230515') FROM DUAL;
 SELECT LAST_DAY('23/11/01') FROM DUAL;


-- 직원명, 입사일, 입사한 월의 마지막 날짜, 입사한 월에 근무한 일수 조회
SELECT EMP_NAME, HIRE_DATE ,LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE) - HIRE_DATE +1 근무일 
FROM EMPLOYEE;

/*
    EXTRACT(YEAR|MONTH|DAY FROM DATE)
    - 특정 날짜에서 연도, 월, 일 정보를 추출해서 반환
      YEAR : 연도만 추출
      MONTH : 월만 추출
      DAY : 일만 추출
*/
-- 직원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE )"입사 년도", EXTRACT(MONTH FROM HIRE_DATE) "입사 월" ,EXTRACT(DAY FROM HIRE_DATE)입사일
FROM EMPLOYEE
ORDER BY 2, 3 ASC, 4 ASC;

/*
    형 변환 
    TO_CHAR(날짜|숫자, [포맷])
    - 날짜 또는 숫자형 데이터를 문자 타입으로 변환해서 반환
*/
SELECT TO_CHAR(1234, 'L999999') FROM DUAL; -- 현재 설정된 나라의 화폐단위
SELECT TO_CHAR(1234, '$999999') FROM DUAL;
SELECT TO_CHAR(1234, 'L99') FROM DUAL; -- 포맷 자리수가 안맞아서
SELECT TO_CHAR(12345678, 'L999,999,999') FROM DUAL;

-- 직원명, 급여, 연봉 (위의 TO_CHAR를 이용해서) 조회
SELECT EMP_NAME 직원명, TO_CHAR(SALARY, 'L999,999,999') 급여 , TO_CHAR(SALARY * 12, 'L999,999,999') 연봉 ,
FROM EMPLOYEE
ORDER BY "연봉"; 

-- 날짜 -> 문자
SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') FROM DUAL;
-- DY, DAY : 요일 / DD : 일
SELECT TO_CHAR(SYSDATE, 'MON DD"일", DY, YYYY') FROM DUAL;

-- 년도와 관련된 포맷
SELECT 
    TO_CHAR(SYSDATE, 'YYYY'),
    TO_CHAR(SYSDATE, 'YY'),
    TO_CHAR(SYSDATE, 'RRRR'),
    TO_CHAR(SYSDATE, 'RR'),
    TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- 월과 관련된 포맷
SELECT
    TO_CHAR(SYSDATE, 'MM'),
    TO_CHAR(SYSDATE, 'MON'),
    TO_CHAR(SYSDATE, 'MONTH'),
    TO_CHAR(SYSDATE, 'RM') -- 로마기호
FROM DUAL;

-- 일과 관련된 포맷 
SELECT
    TO_CHAR(SYSDATE, 'D'), -- 주 기준
    TO_CHAR(SYSDATE, 'DD'), -- 월 기준
    TO_CHAR(SYSDATE, 'DDD') -- 년 기준 
FROM DUAL;

-- 요일과 관련된 포맷
SELECT
    TO_CHAR(SYSDATE, 'DAY'),
    TO_CHAR(SYSDATE, 'DY')
FROM DUAL;

-- 직원명, 입사일 조회
-- 단, 입사일은 포맷을 지정해서 조회! EX) 2023년 06월 21일 (수)

SELECT
    EMP_NAME 직원명, TO_CHAR(HIRE_DATE, 'YYYY"년 "MM"월 "DD"일 " (DY)') 입사일 
FROM EMPLOYEE
ORDER BY 입사일; 

/*
    TO_DATE(숫자|문자, [포맷])
    - 숫자 또는 문자형 데이터를 날짜 타입으로 변환해서 반환 
    
*/
-- 숫자 --> 날짜
SELECT TO_DATE(20230621) FROM DUAL;
SELECT TO_DATE(20230621153410) FROM DUAL; -- 에러
SELECT TO_DATE(20230621153410, 'YYYY-MM-DD HH24:MI:SS') FROM DUAL; 

-- 문자 -> 날짜
SELECT TO_DATE('20230621', 'YYYYMMDD') FROM DUAL;
SELECT TO_DATE('20230621 033823', 'YYYYMMDD HH24MISS') FROM DUAL;


/*
    TO_NUMBER('문자값', [포맷])
    - 문자형 데이터를 숫자 타입으로 변환해서 반환
*/
SELECT '1000000' + '550000' FROM DUAL;
SELECT '1,000,000' + '550,000' FROM DUAL; -- 에러
SELECT TO_NUMBER('1,000,000', '9,999,999')+ TO_NUMBER('550,000', '999,999') 합 FROM DUAL;

/*
    NULL 처리 함수
    
    NVL(값1, 값2)
    - 값1이 NULL이 아니면 값1을 반환하고 값1이 NULL이면 값2를 반환
*/
-- 사원명, 보너스 조회
SELECT 
    EMP_NAME,
    NVL(BONUS, 0)
FROM EMPLOYEE;

-- 사원명, 보너스포함 연봉 = (월급 +월급*보너스) *12 조회
SELECT 
    EMP_NAME,
    NVL(((SALARY+(SALARY*BONUS))*12), SALARY*12) 
FROM EMPLOYEE
ORDER BY 2 DESC;

-- 사원명, 부서코드 조회 (부서코드가 NULL이면 "부서없음") 조회
SELECT
    EMP_NAME, 
    NVL(DEPT_CODE, '부서없음') 
FROM EMPLOYEE
ORDER BY 2;

/*
    NVL2(값1, 값2, 값3)
    - 값1이 NULL이 아니면 값2를 반환하고 값1이 NULL이면 값3를 반환
*/
-- 사원명, 부서코드가 있는 경우 "부서있음", 없는 경우는 "부서없음" 
SELECT
    EMP_NAME,
    NVL2(DEPT_CODE, '부서있음', '부서없음')
FROM EMPLOYEE;

/*
    NULLIF(값1, 값2)
    - 두 개의 값이 동일하면 NULL을 반환하고,
      두 개의 값이 동일하지 않으면 값1을 반환
*/
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL; //
