/* SQLZOO: 9. Self join
http://sqlzoo.net/wiki/Self_join 

Tables:
- stops(id, name)
- route(num, company, pos, stop (ref stops table)) */

/* Ex1. How many stops are in the database. */
SELECT COUNT(name)
FROM stops


/* Ex2. Find the id value for the stop 'Craiglockhart' */
SELECT id
FROM stops
WHERE name = 'Craiglockhart'


/* Ex3. Give the id and the name for the stops on the '4' 'LRT' service. */
SELECT id, name
FROM route r
JOIN stops s
ON r.stop = s.id
WHERE num = '4'
  AND company = 'LRT'


/* Ex4. The query shown gives the number of routes that visit either London Road (149) 
or Craiglockhart (53). Run the query and notice the two services that 
link these stops have a count of 2. Add a HAVING clause to restrict the output 
to these two routes. */
SELECT company, num, COUNT(*)
FROM route
WHERE stop IN ('149', '53')
GROUP BY company, num
HAVING COUNT(*) = 2


/* Ex5. Execute the self join shown and observe that b.stop gives all the places you 
can get to from Craiglockhart, without changing routes. Change the query so that it 
shows the services from Craiglockhart to London Road. */
SELECT r1.company, r1.num, r1.stop, r2.stop
FROM route r1
JOIN route r2
ON r1.company = r2.company
  AND r1.num = r2.num
WHERE r1.stop = 53 AND r2.stop = 149

/* Ex6. The query shown is similar to the previous one, however by joining two copies 
of the stops table we can refer to stops by name rather than by number. 
Change the query so that the services between 'Craiglockhart' and 'London Road' 
are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross' */
SELECT r1.company, r1.num, s1.name, s2.name
FROM route r1
JOIN route r2
ON r1.company = r2.company 
  AND r1.num = r2.num
JOIN stops s1
ON s1.id = r1.stop
JOIN stops s2
ON s2.id = r2.stop
WHERE s1.name = 'Craiglockhart' 
  AND s2.name = 'London Road'


/* Ex7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' 
and 'Leith') */
SELECT DISTINCT r1.company, r1.num
FROM route r1 JOIN route r2
ON r1.company = r2.company
  AND r1.num = r2.num
WHERE r1.stop = 115
  AND r2.stop = 137


/* Ex8. Give a list of the services which connect the stops 'Craiglockhart' and 
'Tollcross' */
SELECT DISTINCT r1.company, r1.num 
FROM route r1
JOIN route r2
ON r1.company = r2.company
  AND r1.num = r2.num
JOIN stops s1
ON s1.id = r1.stop
JOIN stops s2
ON s2.id = r2.stop
WHERE s1.name = 'Craiglockhart'
  AND s2.name = 'Tollcross'


/* Ex9. Give a distinct list of the stops which may be reached from 'Craiglockhart' 
by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. 
Include the company and bus no. of the relevant services. */
SELECT DISTINCT s2.name, r1.company, r1.num
FROM route r1
JOIN route r2
ON r1.company = r2.company
  AND r1.num = r2.num
JOIN stops s1
ON s1.id = r1.stop
JOIN stops s2
ON s2.id = r2.stop
WHERE s1.name = 'Craiglockhart'


/* Ex10. Find the routes involving two buses that can go from Craiglockhart to Sighthill.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.
Hint:
Self-join twice to find buses that visit Craiglockhart and Sighthill, then 
join those on matching stops. */
SELECT t1.num, t1.company, t1.name2, t2.num, t2.company
FROM 
  (SELECT r1.company, r1.num, s1.name AS name1, s2.name AS name2
  FROM route r1
  JOIN route r2
  ON r1.company = r2.company
    AND r1.num = r2.num
  JOIN stops s1
  ON s1.id = r1.stop
  JOIN stops s2
  ON s2.id = r2.stop
  WHERE s1.name = 'Craiglockhart') t1
JOIN 
  (SELECT r1.company, r1.num, s1.name AS name1, s2.name AS name2
  FROM route r1
  JOIN route r2
  ON r1.company = r2.company
    AND r1.num = r2.num
  JOIN stops s1
  ON s1.id = r1.stop
  JOIN stops s2
  ON s2.id = r2.stop
  WHERE s2.name = 'Lochend') t2
ON t1.name2 = t2.name1
