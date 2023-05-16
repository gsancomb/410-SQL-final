#
# DROP TABLE employee;
# DROP TABLE customer;
# DROP TABLE contractor;
# DROP TABLE project;
# DROP TABLE design;
# DROP TABLE equipment;
DROP DATABASE infosy;
CREATE DATABASE infosy;
use infosy;

# ////////////////////////////

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    name VARCHAR(40),
    phone_num BIGINT,
    department VARCHAR(20)
);

CREATE TABLE contractor (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(40),
    phone_num BIGINT,
    type_of_work VARCHAR(20)
);

CREATE TABLE customer(
    customer_id INT PRIMARY KEY,
    l_name VARCHAR(20),
    employee_id INT,

    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE SET NULL
);

CREATE TABLE design(
    design_id INT PRIMARY KEY,
    project_id INT,
    planner_id INT,

    FOREIGN KEY (planner_id) REFERENCES employee(employee_id) ON DELETE SET NULL
);

CREATE TABLE project(
    project_id INT PRIMARY KEY,
    customer_id INT,
    salesman_id INT,
    design_id INT,
    planner_id INT,
    curr_contractor_id INT,
    Location VARCHAR(100),
    estimate INT,

    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ,
    FOREIGN KEY (salesman_id) REFERENCES employee(employee_id) ON DELETE CASCADE,
    FOREIGN KEY (design_id) REFERENCES design(design_id) ON DELETE CASCADE,
    FOREIGN KEY (planner_id) REFERENCES design(planner_id) ON DELETE CASCADE,
    FOREIGN KEY (curr_contractor_id) REFERENCES contractor(company_id) ON DELETE CASCADE
);
CREATE TABLE equip_type(
    type_id INT PRIMARY KEY ,
    type_name varchar(20)
);

CREATE TABLE equipment(
    equip_id INT PRIMARY KEY,
    project_id INT,
    type_id INT,
    brand VARCHAR(20),
    model_num VARCHAR(15),
    price INT,

    FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE SET NULL,
    FOREIGN KEY (type_id) REFERENCES equip_type(type_id) ON DELETE SET NULL
);

# ////////////////////////////

INSERT INTO employee VALUES ( 101, 'Griffin', 4435558650, 'Service');
INSERT INTO employee VALUES ( 102, 'Andy', 4435555921, 'Sales');
INSERT INTO employee VALUES ( 103, 'Garrett', 4435552637, 'Administrative');
INSERT INTO employee VALUES ( 104, 'Carter', 4435559385, 'Planing');

INSERT INTO contractor VALUES ( 201,'Jims Concrete', 7086227151, 'concrete');
INSERT INTO contractor VALUES ( 202,'Tommys plaster', 7082685582, 'Plaster');
INSERT INTO contractor VALUES ( 203,'Tims digs', 3309121747, 'excavation');

INSERT INTO customer VALUES ( 301,'Miller', 102);
INSERT INTO customer VALUES ( 302,'Wilmeth', 102);
INSERT INTO customer VALUES ( 303,'Sancomb', 102);


INSERT INTO design VALUES(501, 401, 104);
INSERT INTO design VALUES(502, 402, 103);
INSERT INTO design VALUES(503, 403, 104);

INSERT INTO project VALUES ( 401, 301, 102, 501, 104, 201,
                            '4273  Hillhaven Drive Rockville, MD', 60000);
INSERT INTO project VALUES ( 402, 302, 102, 502, 104, 203,
                            '3809  Lyndon Street Baltimore, MD', 120000);
INSERT INTO project VALUES ( 403, 303, 102, 503, 104, 202,
                            '3268  Star Route Fredrick, MD', 90000);

INSERT INTO equip_type VALUES(1, 'pump');
INSERT INTO equip_type VALUES(2, 'filter');
INSERT INTO equip_type VALUES(3, 'heater');
INSERT INTO equip_type VALUES(4, 'saltcell');

INSERT INTO equipment VALUES( 601, 402, 1, 'jandy', 'HGD5729039', 1840);
INSERT INTO equipment VALUES( 604, 402, 2, 'Pentair', 'JHG5504940', 375);
INSERT INTO equipment VALUES( 606, 402, 3, 'Pentair', 'JHG0962041', 1500);
INSERT INTO equipment VALUES( 608, 402, 4, 'Pentair', 'JHG3123686', 1050);

INSERT INTO equipment VALUES( 602, 401, 1, 'Pentair', 'JHG9697137', 2000);
INSERT INTO equipment VALUES( 603, 401, 2, 'jandy', 'HGD9304171', 350);
INSERT INTO equipment VALUES( 605, 401, 3, 'jandy', 'HGD0962041', 1550);
INSERT INTO equipment VALUES( 607, 401, 4, 'jandy', 'HGD9931940', 999);

INSERT INTO equipment VALUES( 609, 403, 1, 'jandy', 'HGD5729039', 1840);
INSERT INTO equipment VALUES( 610, 403, 2, 'jandy', 'HGD9304171', 350);
INSERT INTO equipment VALUES( 611, 403, 3, 'Pentair', 'JHG0962041', 1500);
INSERT INTO equipment VALUES( 612, 403, 4, 'jandy', 'HGD9931940', 999);

# ///////////////////////////

UPDATE employee
SET department='installation'
WHERE employee_id= 101;

UPDATE equipment
SET price = 1024
WHERE model_num = 'HGD9931940';

# ///////////////////////////

SELECT estimate FROM project
WHERE project_id = 401;

SELECT model_num, price FROM equipment
WHERE brand = 'Jandy';

# ///////////////////////////

SELECT p.project_id, p.customer_id,customer.l_name, p.salesman_id,
       salesman.name, p.planner_id, planner.name
FROM project AS p
    JOIN customer ON p.customer_id = customer.customer_id
    Join employee salesman ON p.salesman_id = salesman.employee_id
    JOIN employee planner ON p.planner_id = planner.employee_id
ORDER BY project_id;

SELECT p.project_id, e.equip_id, e.model_num, et.type_name, e2.price
From project AS p
    JOIN equipment e on p.project_id = e.project_id
    JOIN equip_type et on e.type_id = et.type_id
    JOIN equipment e2 on p.project_id = e2.project_id
ORDER BY project_id;

SELECT p.project_id, c.company_name
FROM project AS p
    JOIN contractor c ON p.curr_contractor_id = c.company_id
ORDER BY project_id;

SELECT  et.type_id, et.type_name, e.equip_id, e.project_id, e.type_id, e.brand, e.model_num,
       e.price, e.equip_id, e.project_id, e.type_id, e.brand, e.model_num,
       e.price
FROM equipment AS e
    JOIN equip_type et on e.type_id = et.type_id;

# ////////////////////////////

SELECT p.project_id, e.equip_id, e.model_num, et.type_id, et.type_name, e2.price
From project AS p
    JOIN equipment e on p.project_id = e.project_id
    JOIN equip_type et on e.type_id = et.type_id
    JOIN equipment e2 on p.project_id = e2.project_id
WHERE et.type_id = 3
Group By e.project_id;

SELECT p.project_id, d.design_id, d.planner_id, e.name
FROM project AS p
    JOIN design d on p.design_id = d.design_id
    JOIN employee e on d.planner_id = e.employee_id
WHERE d.planner_id = 104
GROUP BY d.project_id;

# ////////////////////////////



