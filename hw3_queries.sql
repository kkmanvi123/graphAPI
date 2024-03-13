drop database if exists graph;
create database graph;
use graph;

create table node (
 node_id int primary key,
 type varchar(20)
 );
 
 create table edge (
 edge_id int primary key,
  in_node int,
  out_node int,
  type varchar(20)
  );
  
create table node_props (
  node_id int,
  propkey varchar(20),
  string_value varchar(100),
  num_value double
  );
  
 
 insert into node values 
 (1,'Person'),
 (2,'Person'),
 (3,'Person'),
 (4,'Person'),
 (5,'Person'),
 (6,'Book'),
 (7,'Book'),
 (8,'Book'),
 (9,'Book');
 
 insert into node_props values
 (1, 'name', 'Emily', null),
 (2, 'name', 'Spencer', null),
 (3, 'name', 'Brendan', null),
 (4, 'name', 'Trevor', null),
 (5, 'name', 'Paxton', null),
 (6, 'title', 'Cosmos', null),
 (6, 'price', null, 17.00),
 (7, 'title', 'Database Design', null),
 (7, 'price', null, 195.00),
 (8, 'title', 'The Life of Cronkite', null),
 (8, 'price', null, 29.95),
 (9, 'title', 'DNA and you', null),
 (9, 'price', null, 11.50);
 
 insert into edge values
 (1, 1, 7, 'bought'),
 (2, 2, 6, 'bought'),
 (3, 2, 7, 'bought'),
 (4, 3, 7, 'bought'),
 (5, 3, 9, 'bought'),
 (6, 4, 6, 'bought'),
 (7, 4, 7, 'bought'), 
 (8, 5, 7, 'bought'),
 (9, 5, 8, 'bought'),
 (10, 1,2,'knows'),
 (11, 2, 1, 'knows'),
 (12, 2, 3, 'knows');
 
-- Queries

-- a. what is the sum of all book prices?
SELECT SUM(num_value) AS total_book_prices
FROM node_props
WHERE propkey = 'price' AND node_id IN (SELECT node_id FROM node WHERE type = 'Book');


-- b. how many people bought each book?
-- Give title and number of times purchased
SELECT np.string_value AS title, COUNT(*) AS times_purchased
FROM edge e
JOIN node_props np ON e.out_node = np.node_id AND np.propkey = 'title'
JOIN node n ON e.out_node = n.node_id
WHERE n.type = 'Book'
GROUP BY np.string_value;


-- c. What is the most expensive book?
-- Give title and price
SELECT np.string_value AS title, np2.num_value AS price
FROM edge e
JOIN node_props np ON e.out_node = np.node_id AND np.propkey = 'title'
JOIN node_props np2 ON e.out_node = np2.node_id AND np2.propkey = 'price'
JOIN node n ON e.out_node = n.node_id
WHERE n.type = 'Book'
ORDER BY np2.num_value DESC
LIMIT 1;


-- d. Who does spencer know?
SELECT np.string_value AS name
FROM edge AS e
JOIN node_props AS np ON e.out_node = np.node_id
WHERE e.in_node = (SELECT node_id FROM node_props WHERE string_value = 'Spencer' AND propkey = 'name') AND e.type = 'knows';


-- e. What books did spencer buy?  Give title and price.
SELECT np.string_value AS title, np2.num_value AS price
FROM edge e
JOIN node_props np ON e.out_node = np.node_id AND np.propkey = 'title'
JOIN node_props np2 ON e.out_node = np2.node_id AND np2.propkey = 'price'
JOIN node n ON e.out_node = n.node_id
WHERE n.type = 'Book' AND e.in_node = (SELECT node_id FROM node_props WHERE string_value = 'Spencer' AND propkey = 'name');


-- f. Who knows each other?
SELECT np_out.string_value AS person1, np_in.string_value AS person2
FROM edge AS e
JOIN node_props AS np_out ON e.out_node = np_out.node_id
JOIN node_props AS np_in ON e.in_node = np_in.node_id
WHERE e.type = 'knows';


-- g. What books were purchased by people who spencer knows?
-- You just have to combine two previous queries
-- Dropping price attribute in the process
-- g. What books were purchased by people who Spencer knows, excluding books that Spencer already owns?
SELECT DISTINCT np.string_value AS title
FROM edge e
JOIN node_props np ON e.out_node = np.node_id AND np.propkey = 'title'
JOIN node n ON e.out_node = np.node_id
JOIN (
    SELECT e.out_node
    FROM edge e
    JOIN node_props np ON e.in_node = np.node_id
    WHERE np.string_value = 'Spencer' AND np.propkey = 'name' AND e.type = 'knows'
) AS spencer_known ON e.in_node = spencer_known.out_node
WHERE n.type = 'Book'
AND e.out_node NOT IN (
    SELECT out_node
    FROM edge
    WHERE in_node = (SELECT node_id FROM node_props WHERE string_value = 'Spencer' AND propkey = 'name'));

