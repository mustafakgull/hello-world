--test datası
CREATE GLOBAL TEMPORARY TABLE  TST
(
productid NUMBER(9)
,color VARCHAR(30)
,siz  VARCHAR(30)
)
;

INSERT  INTO TST VALUES(1,'blue','L');
INSERT  INTO TST VALUES(1,'blue','S');
INSERT  INTO TST VALUES(2,'blue','L');
INSERT  INTO TST VALUES(2,'red','M');
INSERT  INTO TST VALUES(2,'green','M');
INSERT  INTO TST VALUES(3,'blue','L');
INSERT  INTO TST VALUES(4,'red','S');
INSERT  INTO TST VALUES(4,'black','XS');

SELECT * FROM TST;


--beden mappingi
CREATE GLOBAL TEMPORARY TABLE mp
(
ID NUMBER
,sz VARCHAR(30));

INSERT INTO mp VALUES (1,'XS');
INSERT INTO mp VALUES (2,'S');
INSERT INTO mp VALUES (3,'M');
INSERT INTO mp VALUES (4,'L');
INSERT INTO mp VALUES (5,'XL');
SELECT * FROM mp


--renk belirleme
WITH cl  AS 
(
SELECT 
productid
,CASE 
     WHEN COUNT(color)=1 THEN (SELECT color FROM tst WHERE productid IN (SELECT productid FROM tst GROUP BY productid HAVING COUNT(color)<2)) --birden fazla tekli olursa yanlış data döner
     WHEN count(color)=2 THEN 'bi-color'
     ELSE 'multi-color'
     END color
FROM tst
GROUP BY productid
)


--renk + beden belirleme
SELECT 
DISTINCT
t.productid
,t.color
,mp.sz FROM
(
SELECT
tst.PRODUCTID
,cl.color
,MAX(mp.id) OVER(PARTITION BY tst.productid)  tid
FROM TST
LEFT JOIN cl 
ON CL.PRODUCTID=TST.PRODUCTID
LEFT JOIN mp
ON TST.SIZ=mp.sz
) t
LEFT JOIN mp
ON mp.id=t.tid
ORDER BY 1
