CREATE SCHEMA Person
go
create schema Material
go

create table Person.Doctor(
ID int primary key,
Name varchar(50),
Email varchar(50),
Phone varchar(50),
Specialty varchar(50),
Years_Of_Experience int
)

create table Person.Patient
(
UR_Number int primary key,
Name varchar(50),
Email varchar(50),
Phone varchar(50),
Address varchar(50),
Age int,
Medicare_Card varchar(50),
ID int default 1,
 Constraint FK_Doctor_ID foreign key (ID) REFERENCES Person.Doctor(ID) ON DELETE SET Default
)

create table Material.Pharmaceutical_Company
(
Name varchar(50) primary key,
Address varchar(50),
Phone_Number varchar(50),
)



create table Material.Drug
(
Trade_Name varchar(50) PRIMARY KEY,
Drug_strength int,
Name varchar(50),
constraint FK_Pharmaceutical_Company_Name Foreign key (Name) references Material.Pharmaceutical_Company (Name) ON DELETE Cascade ON UPDATE Cascade 

)



create table Person.Patient_treatment(
    Doctor_ID INT,
    Patient_UR INT,
    Quantity INT,
	Date date,
    Trade_Name varchar(50),
    PRIMARY KEY (Date, Patient_UR,Trade_Name), 
	constraint FK_Patient_treatment_Patient_UR Foreign key ( Patient_UR) REFERENCES Person.Patient (UR_Number) ,
	constraint FK_Patient_treatment_Trade_Name Foreign key ( Trade_Name) REFERENCES Material.Drug (Trade_Name),
	constraint FK_Patient_treatment_Doctor_ID Foreign key ( Doctor_ID) REFERENCES Person.Doctor (ID)  ON DELETE SET DEFAULT ON UPDATE Cascade,
);



insert into Material.Pharmaceutical_Company 
values ('pharma','cairo','999999')

insert into Material.Drug
VALUES ('PANADOL','2','pharma')



insert into Person.Patient_treatment  (Doctor_ID,Patient_UR ,Quantity, Date , Trade_Name)
VALUES (1,1,3.5,GETDATE(),'PANADOL')

select * from Person.Patient_treatment 




--•	SELECT: Retrieve all columns from the Doctor table.
select * from Person.Doctor


--•	ORDER BY: List patients in the Patient table in ascending order of their ages.
select *
from Person.Patient
order by Age asc;

--•	OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.

select *
from Person.Patient 
order by UR_Number
OFFSET 4 ROWS 
FETCH NEXT 10 ROWS ONLY;

--•	SELECT TOP: Retrieve the top 5 doctors from the Doctor table

select TOP 5
*
from Person.Doctor 

--•	SELECT DISTINCT: Get a list of unique address from the Patient table.
select 
DISTINCT Address
from Person.Patient 

--•	WHERE: Retrieve patients from the Patient table who are aged 25.

select name ,UR_Number
from Person.Patient 
WHERE Age =25


--•	NULL: Retrieve patients from the Patient table whose email is not provided.
select *
from Person.Patient 
WHERE Email = null

--•	AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'dentistry'.

select *
from Person.Doctor 
where Years_Of_Experience >5 and Specialty = 'dentistry' 

--- •	IN: Retrieve doctors from the Doctor table whose speciality is either 'dentistry' or 'bones'.

select *
from Person.Doctor 
WHERE
Specialty IN ('dentistry','bones')

----•	BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
select *
from Person.Patient
WHERE Age BETWEEN 18 and 30

---•	LIKE: Retrieve doctors from the Doctor table whose names start with 'el.'.
select *
from Person.Doctor
where
name like 'el%'
---•	Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
select Name as 'DoctorName',Email as 'DoctorEmail'
from Person.Doctor

---•	Joins: Retrieve all prescriptions with corresponding patient names.
select Date,Quantity ,Patient_UR ,p.Name
 from Person.Patient_treatment pp join Person.Patient p
 on p.UR_Number =PP.Patient_UR

 --•	GROUP BY: Retrieve the count of patients grouped by their age.
 select count (*)
 from Person.Patient
 group by age

 ----•	HAVING: Retrieve Address with more than 3 patients.

 select count (*)as 'category of address'
 from Person.Patient
 group by Address
 having  count(*)>3 

-- •	UNION: Retrieve a combined list of doctors and patients. (Search)
select D.ID ,D.Name as 'Combined list'
from Person.Doctor  D
UNION ALL
select p.ID ,P.Name
from Person.Patient p


--•	Common Table Expression (CTE): Retrieve patients along with their doctors using a CTE.
WITH cte_Patients_Doctors AS (
    SELECT    
       p.Name as 'patient name',
	   D.Name as 'Doctor name'
    FROM    
        Person.Patient p 
		JOIN Person.Doctor D on P.ID = D.ID
		
)
SELECT *
FROM cte_Patients_Doctors;

--•	INSERT: Insert a new doctor into the Doctor table.
insert into Person.Doctor VALUES (5,'HADY','HAD@COM','010101','BONES',4)

--•	INSERT Multiple Rows: Insert multiple patients into the Patient table.
INSERT INTO Person.Doctor (ID, Name, Email,Phone,Specialty,Years_Of_Experience)
VALUES 
    (8,'HADY','HAD@COM','010101','BONES',2),
    (9,'HADY','HAD@COM','010101','BONES',6),
    (12,'HaADY','HAD@COM','010101','BONES',6);


--•	UPDATE: Update the phone number of a doctor.
Update Person.Doctor
set Phone ='6666666666'
where ID = 8
 
 ---•	UPDATE JOIN: Update the Address of patients who have a prescription from a specific doctor.
 UPDATE Person.Patient
 set Address = 'elsaf'
 from Person.Patient P join Person.Patient_treatment PT ON  PT.Patient_UR = P.UR_Number
 where Patient_UR =1 AND Quantity is not null


 ---•	DELETE: Delete a patient from the Patient table.

 Delete 
 from Person.Patient
 where UR_Number=4


 --- •	Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
 select * from Person.Doctor
  select * from Person.Patient

  
 begin tran
 insert INTO  Person.Doctor values(20,'MOKHTAR','MOKHTAR@WWW','02029102','Den',2)
 insert INTO   Person.Patient values (20,'hessuin','hessuin@dsds','217281','shubraa',22,'blobemade',50)

 rollback tran
 commit

 ---•	View: Create a view that combines patient and doctor information for easy access.

 create view Doctor_Patient_Info
 AS
 select P.UR_Number, P.Name as 'Patient name ',P.Phone as 'patient phone', D.ID as 'doctor id' ,D.Name as 'doctor name'
 from Person.Patient P join Person.Doctor D
 ON P.ID = D.ID

 ----•	Index: Create an index on the 'phone' column of the Patient table to improve search performance.
 create index Phone_Index
 ON Person.Patient(Phone);

 --•	Backup: Perform a backup of the entire database to ensure data safety.
 -- has been exEcuted by GUI

 