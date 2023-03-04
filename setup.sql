-----------------------------------Tables-----------------------------------
CREATE TABLE Departments (
name TEXT,
abbreviation TEXT NOT NULL,
PRIMARY KEY (name),
UNIQUE (abbreviation)
);

CREATE TABLE Program (
name TEXT NOT NULL,
abbreviations TEXT NOT NULL,
PRIMARY KEY (name)
);

CREATE TABLE hostedBy (
department TEXT,
program TEXT,
PRIMARY KEY(department,program)
);

CREATE TABLE Courses (
Code CHAR(6),
name TEXT NOT NULL,
credits FLOAT NOT NULL,
department TEXT NOT NULL,

CHECK (credits >= 0),
PRIMARY KEY (code),
FOREIGN KEY (department) REFERENCES Departments(name)
);

CREATE TABLE Students (
idnr CHAR (10),
name TEXT NOT NULL,
login TEXT NOT NULL,
program TEXT NOT NULL,

CHECK ((CAST (idnr AS NUMERIC)) >= 0),
PRIMARY KEY (idnr),
FOREIGN KEY (program) REFERENCES Program(name),
UNIQUE (idnr, program),
UNIQUE (login)
);

CREATE TABLE Branches (
name TEXT,
program TEXT,
PRIMARY KEY (name, program),
FOREIGN KEY (program) REFERENCES Program (name)
);


CREATE TABLE Prerequisities (
course CHAR(6) REFERENCES Courses(code),
reqforcourse CHAR (6),
PRIMARY KEY (course, reqforcourse),
FOREIGN KEY (reqforcourse) REFERENCES Courses(code)
);

CREATE TABLE LimitedCourses (
code CHAR(6),
capacity INTEGER NOT NULL,
CHECK (capacity >= 0),
PRIMARY KEY (code),
FOREIGN KEY (code) REFERENCES Courses(code)
);

CREATE TABLE StudentBranches (
student CHAR(10),
branch TEXT ,
program TEXT NOT NULL,
PRIMARY KEY (student),
FOREIGN KEY (student) REFERENCES Students(idnr),
FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
FOREIGN KEY (student, program) REFERENCES Students(idnr, program)

);

CREATE TABLE Classifications (
name TEXT,
PRIMARY KEY (name)
);

CREATE TABLE Classified (
course CHAR(6),
classification TEXT,
PRIMARY KEY (course, classification),
FOREIGN KEY (course) REFERENCES Courses(code),
FOREIGN KEY (classification) REFERENCES Classifications(name)
);

CREATE TABLE MandatoryProgram (
course CHAR(6),
program TEXT,
PRIMARY KEY (course, program),
FOREIGN KEY (course) REFERENCES Courses(code),
FOREIGN KEY (program) REFERENCES Program(name)
);

CREATE TABLE MandatoryBranch (
course CHAR(6),
branch TEXT,
program TEXT,
PRIMARY KEY (course, branch, program),
FOREIGN KEY (course) REFERENCES Courses(code),
FOREIGN KEY (branch, program) REFERENCES Branches(name, program)
);

CREATE TABLE RecommendedBranch (
course CHAR (6),
branch TEXT,
program TEXT,
PRIMARY KEY (course, branch, program),
FOREIGN KEY (course) REFERENCES Courses(code),
FOREIGN KEY (branch, program) REFERENCES Branches(name, program)
);

CREATE TABLE Registered (
student CHAR(10),
course CHAR(6),
CHECK ((CAST (student AS NUMERIC)) > 0),
PRIMARY KEY (student, course),
FOREIGN KEY (student) REFERENCES Students(idnr),
FOREIGN KEY (course) REFERENCES Courses(code),
UNIQUE (student, course) 
);

CREATE TABLE Taken (
student CHAR(10),
course CHAR(6),
grade CHAR(1) NOT NULL,
CHECK (grade in ('U', '3', '4', '5')),
PRIMARY KEY (student, course),
FOREIGN KEY (student) REFERENCES Students(idnr),
FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE WaitingList (
student CHAR(10),
course CHAR(6),
position SERIAL,
UNIQUE (course, position),
PRIMARY KEY (student, course),
FOREIGN KEY (student) REFERENCES Students(idnr),
FOREIGN KEY (course) REFERENCES LimitedCourses(code)
);

-----------------------------------End-Tables-----------------------------------

-----------------------------------INSERT----------------------------------------
INSERT INTO Departments VALUES ('Dep1','D1');
INSERT INTO Departments VALUES ('Dep2','D2');
INSERT INTO Departments VALUES ('Dep3','D3');
INSERT INTO Program VALUES ('Prog1','P1');
INSERT INTO Program VALUES ('Prog2','P2');
INSERT INTO Program VALUES ('Prog3','P3');
INSERT INTO hostedBy VALUES ('Dep1','Prog1');
INSERT INTO hostedBy VALUES ('Dep2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog2');
INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');
INSERT INTO Courses VALUES ('CCC111','C1',22.5,'Dep1');
INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
INSERT INTO Courses VALUES ('CCC444','C4',60,'Dep1');
INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');
INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',2);
INSERT INTO LimitedCourses VALUES ('CCC555',20);
INSERT INTO Classifications VALUES ('math');
INSERT INTO Classifications VALUES ('research');
INSERT INTO Classifications VALUES ('seminar');
INSERT INTO Classified VALUES ('CCC333','math');
INSERT INTO Classified VALUES ('CCC444','math');
INSERT INTO Classified VALUES ('CCC444','research');
INSERT INTO Classified VALUES ('CCC444','seminar');
INSERT INTO StudentBranches VALUES ('2222222222','B1','Prog1');
INSERT INTO StudentBranches VALUES ('3333333333','B1','Prog2');
INSERT INTO StudentBranches VALUES ('4444444444','B1','Prog1');
INSERT INTO StudentBranches VALUES ('5555555555','B1','Prog2');
INSERT INTO MandatoryProgram VALUES ('CCC111','Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC333', 'B1', 'Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC444', 'B1', 'Prog2');
INSERT INTO RecommendedBranch VALUES ('CCC222', 'B1', 'Prog1');
INSERT INTO RecommendedBranch VALUES ('CCC333', 'B1', 'Prog2');
INSERT INTO Registered VALUES ('1111111111','CCC111');
INSERT INTO Registered VALUES ('1111111111','CCC222');
INSERT INTO Registered VALUES ('1111111111','CCC333');
INSERT INTO Registered VALUES ('2222222222','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC333');
INSERT INTO Registered VALUES ('1111111111','CCC555');
INSERT INTO Taken VALUES('4444444444','CCC111','5');
INSERT INTO Taken VALUES('4444444444','CCC222','5');
INSERT INTO Taken VALUES('4444444444','CCC333','5');
INSERT INTO Taken VALUES('4444444444','CCC444','5');
INSERT INTO Taken VALUES('5555555555','CCC111','5');
INSERT INTO Taken VALUES('5555555555','CCC222','4');
INSERT INTO Taken VALUES('5555555555','CCC444','3');
INSERT INTO Taken VALUES('2222222222','CCC111','U');
INSERT INTO Taken VALUES('2222222222','CCC222','U');
INSERT INTO Taken VALUES('2222222222','CCC444','U');
INSERT INTO WaitingList VALUES('3333333333','CCC222',1);
INSERT INTO WaitingList VALUES('3333333333','CCC333',1);
INSERT INTO WaitingList VALUES('2222222222','CCC333',2);

--
INSERT INTO Departments VALUES ('Dep7','D7');
INSERT INTO Departments VALUES ('Dep8','D8');
INSERT INTO Departments VALUES ('Dep9','D9');

INSERT INTO Program VALUES ('Prog7','P7');
INSERT INTO Program VALUES ('Prog8','P8');
INSERT INTO Program VALUES ('Prog9','P9');

INSERT INTO hostedBy VALUES ('Dep7','Prog7');
INSERT INTO hostedBy VALUES ('Dep8','Prog8');
INSERT INTO hostedBy VALUES ('De9','Prog9');

INSERT INTO Branches VALUES ('B7','Prog7');
INSERT INTO Branches VALUES ('B8','Prog8');
INSERT INTO Branches VALUES ('B9','Prog9');

INSERT INTO Students VALUES ('7777777777','N7','ls7','Prog7');
INSERT INTO Students VALUES ('8888888888','N8','ls8','Prog8');
INSERT INTO Students VALUES ('9999999999','N9','ls9','Prog9');

--
INSERT INTO WaitingList VALUES('9999999999','CCC333',3);
INSERT INTO Courses VALUES ('CCC777','C7',70,'Dep7');
INSERT INTO Courses VALUES ('CCC888','C8',50,'Dep8');
INSERT INTO StudentBranches VALUES ('8888888888','B8','Prog8');
INSERT INTO Registered VALUES ('8888888888','CCC888');
INSERT INTO Taken VALUES('8888888888','CCC888','5');
INSERT INTO Prerequisities VALUES ('CCC777','CCC888');
--
-----------------------------------END-INSERT----------------------------------

-------------------------------------------------Views------------------------------------------------------------------
CREATE VIEW BasicInformation AS
SELECT idnr, name, login, Students.program, branch
FROM Students LEFT OUTER JOIN StudentBranches
ON (Students.idnr = StudentBranches.student)
AND (Students.program = StudentBranches.program);


CREATE VIEW FinishedCourses AS
SELECT student, course, grade, credits
FROM BasicInformation, Taken, courses
WHERE (Taken.course = Courses.code) 
AND (BasicInformation.idnr = Taken.student); 


CREATE VIEW PassedCourses AS
SELECT student, course, credits
FROM FinishedCourses
WHERE (FinishedCourses.grade != 'U');


CREATE VIEW Registrations AS
SELECT student, course, COALESCE('registered') AS status
FROM BasicInformation, Registered
Where (BasicInformation.idnr = Registered.student)
UNION ALL
SELECT student, course, COALESCE('waiting') AS status
FROM BasicInformation, WaitingList
Where (BasicInformation.idnr = WaitingList.student);


CREATE VIEW UnreadMandatory AS
WITH
MandatoryforBranch AS
(SELECT DISTINCT idnr AS student, course FROM BasicInformation, MandatoryBranch
WHERE BasicInformation.branch = MandatoryBranch.branch
AND (BasicInformation.program = MandatoryBranch.program)),

MandatoryforProgram AS
(SELECT DISTINCT idnr as student, course FROM BasicInformation, MandatoryProgram
WHERE (BasicInformation.program = MandatoryProgram.program)),

AllmandatoryCourses AS
(SELECT student, course FROM MandatoryforProgram NATURAL FULL JOIN MandatoryforBranch)

SELECT student, course From AllmandatoryCourses
EXCEPT
SELECT student, course FROM PassedCourses;



CREATE VIEW PathToGraduation AS
(WITH
forStudents AS
(SELECT idnr AS student FROM BasicInformation),

studentTotalcredit AS
(SELECT student, SUM(credits) AS totalCredits 
FROM PassedCourses
GROUP BY student),

mandatoryLeftStudent AS
(SELECT student, COUNT(*) AS mandatoryLeft
FROM UnreadMandatory
GROUP BY student),

allMathCredits AS
(SELECT student, SUM(credits) AS mathCredits
FROM PassedCourses, Classified
WHERE (PassedCourses.course = Classified.course)
AND (classification = 'math')
GROUP BY student
),

takenResearchCredits AS
(SELECT student, SUM(credits) AS researchCredits
FROM PassedCourses, Classified
WHERE (PassedCourses.course = Classified.course)
AND (classification = 'research')
GROUP BY student
),

takenSeminarCourses AS
(SELECT student, COUNT(*) AS seminarCourses
FROM PassedCourses, Classified
WHERE (PassedCourses.course = Classified.course)
AND (classification = 'seminar')
GROUP BY student

),

Recommededallforbranch AS
(SELECT idnr AS student, BasicInformation.program, 
        BasicInformation.branch, RecommendedBranch.course
FROM BasicInformation,RecommendedBranch
WHERE BasicInformation.program = RecommendedBranch.program
AND BasicInformation.branch = RecommendedBranch.branch
),

StudentrecommendedCourses AS
(SELECT PassedCourses.student, SUM(PassedCourses.credits) AS PassedRecCourses
FROM PassedCourses, Recommededallforbranch
WHERE PassedCourses.student = Recommededallforbranch.student
AND PassedCourses.course = Recommededallforbranch.course
GROUP BY (PassedCourses.student)
),

finalView1 AS
(SELECT forStudents.student AS student, 
       COALESCE(totalCredits, 0) AS totalCredits,
       COALESCE(mandatoryLeft, 0) AS mandatoryLeft, 
	   COALESCE(mathCredits, 0) AS mathCredits, 
	   COALESCE(researchCredits, 0) AS researchCredits,
	   COALESCE(seminarCourses, 0) AS seminarCourses,
	   COALESCE(PassedRecCourses) AS PassedRecCourses
	   
FROM forStudents LEFT OUTER JOIN studentTotalcredit  
                      ON forStudents.student = studentTotalcredit.student
				 Left Outer JOIN mandatoryLeftStudent
				      ON forStudents.student = mandatoryLeftStudent.student
			     Left Outer JOIN allMathCredits
				      ON forStudents.student = allMathCredits.student
			     Left OUTER JOIN takenResearchCredits
				      ON forStudents.student = takenResearchCredits.student
				 Left OUTER JOIN takenSeminarCourses
				      ON forStudents.student = takenSeminarCourses.student
				LEFT OUTER JOIN StudentrecommendedCourses
				      ON forStudents.student = StudentrecommendedCourses.student
					  ),
					  
finalView2 AS
(SELECT * , (( mandatoryLeft = 0) AND (mathCredits >= 20) AND (researchCredits >= 10) 
           AND (seminarCourses >= 1) AND (PassedRecCourses >= 10)
			AND  student IN (SELECT student from StudentBranches)) AS qualified
From finalView1
)



SELECT student, totalCredits, mandatoryLeft, mathCredits, researchCredits, 
       seminarCourses, COALESCE(qualified, false) AS qualified
FROM finalView2

);	
-----------------------------------------------END-Views---------------------------------------------------

-- code for creating the two triggers && CourseQueuePositions viev


---------------------------------------------Extra-View-----------------------------------------------
/*
Extra Veiw:

för alla studenter som är i en kö för en kurs. 
courseCode, stdIdnr och studentens nuvarande plats i kön.
*/
CREATE VIEW CourseQueuePositions AS 
	 SELECT course, student, position as place
	 FROM WaitingList ORDER BY place;


---------------------------------------------TRIGGERS-----------------------------------------------------
/*
3.1) När en student försöker att registrera sig till en course, det kan hända att course är redan full. 
därför studenten läggas till WaitingList för course. 
	
3.2) När en student avregistrerar sig från en course, är kanske så att det blir en fri  plats för någon 
student som väntar på denna course i WaitingList, då ska studenten som väntar  bli registered ist
och raderas från WaitingList.
*/


--...............................för registration process...........................
CREATE FUNCTION checkRegistrations() RETURNS trigger AS $$
DECLARE courseCapacity INT;
DECLARE	currentNrOfStudents INT;
DECLARE sizeOfWaitingList INT;
	BEGIN 	
		--RAISE NOTICE 'REG'; --THIS LINE CAN BE DELETED, IT IS JUST FOR TEST MASSAGE
		--if course is not founded
		/*IF NOT EXISTS (SELECT code FROM Courses WHERE Courses.code = NEW.course) THEN
     			RAISE EXCEPTION 'the course does not exist!';
		END IF;
		
		--if student is not founded
		IF NOT EXISTS (SELECT idnr FROM Students WHERE Students.idnr = NEW.student) THEN
     			RAISE EXCEPTION 'the student does not exist!';
		END IF;*/
		   		
   		--if the student is already registered
   		IF EXISTS (SELECT student FROM Registered 
   				WHERE Registered.student = NEW.student 
   				AND Registered.course = NEW.course) THEN 
   					RAISE EXCEPTION 'the student already registered!'; 
   		END IF;
   		
   		--if the student already passed the course
   		IF EXISTS (SELECT student FROM PassedCourses 
   				WHERE PassedCourses.student = NEW.student 
   				AND PassedCourses.course = NEW.course) THEN
   					RAISE EXCEPTION 'the student already passed the course!';
		END IF; 
		
		--if the student is in waitinglist for a course and the student want to register to same course
		IF EXISTS (SELECT student FROM WaitingList WHERE student = NEW.student AND course = NEW.course) THEN 
		RAISE EXCEPTION 'Error: the student is waiting to the course';		
		END IF;
		
		--if the course is a limited course 
		IF EXISTS (SELECT capacity FROM LimitedCourses WHERE LimitedCourses.code = NEW.course) THEN 
				courseCapacity := (SELECT capacity FROM LimitedCourses WHERE LimitedCourses.code = NEW.course);
				currentNrOfStudents:= (SELECT COUNT(student) FROM Registered WHERE Registered.course = NEW.course);
				
				--if the course is full, move the student to the waiting list and give student a position in list  
				IF (currentNrOfStudents >= courseCapacity) THEN 
					sizeOfWaitingList:= (SELECT COUNT(student) FROM WaitingList WHERE WaitingList.course = NEW.course);
					INSERT INTO WaitingList VALUES(NEW.student, NEW.course, sizeOfWaitingList+1);
				
				--if the course is not full 
				ELSE
					INSERT INTO Registered VALUES(NEW.student , NEW.course); 
				END IF;
		--if the course is not limited then regidter!
		ELSE
			INSERT INTO Registered VALUES(NEW.student , NEW.course);
		END IF;	
		
		--if the student does not fufill the prerequisites for the course, d.v.s. 
		-- när Prerequisities.reqforcourse == new.course except CoursePassedCourse.student == new.student :: except betyder om det är iinte samma och inte finns
		IF EXISTS ((SELECT reqforcourse FROM Prerequisities WHERE Prerequisities.course = NEW.course)
       				EXCEPT (SELECT course FROM PassedCourses WHERE PassedCourses.student = NEW.student)) THEN
         			RAISE EXCEPTION 'Student doesnt fufill all prerequisites to register';      	 	
        	END IF;	
		
		RETURN NEW;
	END;
$$LANGUAGE plpgsql;

CREATE TRIGGER Registration_Trigger 
INSTEAD OF INSERT ON Registrations
FOR EACH ROW EXECUTE PROCEDURE checkRegistrations();
 



--...............................för unregistration............................................
CREATE FUNCTION unregisterProcess() RETURNS trigger AS $$
DECLARE studentPos1 CHAR(10);
DECLARE coursePos1 CHAR(6); 
DECLARE newPos INT; 

	BEGIN
				

		-- if delete on waiting list then save the students place
		IF EXISTS(SELECT student FROM WaitingList WHERE WaitingList.student = OLD.student 
			   AND WaitingList.course = OLD.course ) THEN	
				newPos:= (SELECT place FROM CourseQueuePositions WHERE course = OLD.course
						AND student = OLD.student); 
				
				DELETE FROM WaitingList WHERE course = OLD.course AND student = OLD.student;
				UPDATE WaitingList SET position = position-1 WHERE course = OLD.course 
					AND position > newPos;

			RETURN OLD;	 
		END IF;
				
		-- delete on registered
		IF EXISTS (SELECT student FROM Registered WHERE Registered.student = OLD.student 
				AND Registered.course = OLD.course) THEN 
					DELETE FROM Registered WHERE student = OLD.student AND course = OLD.course;

			
			-- check if the course is full
		 	IF EXISTS (SELECT code FROM LimitedCourses WHERE LimitedCourses.code = OLD.course)
          				  AND ((SELECT COUNT(student) FROM Registered WHERE Registered.course = OLD.course)
                                                         <
                		  	  	(SELECT capacity FROM LimitedCourses WHERE LimitedCourses.code = OLD.course)) 
                		  		 THEN
                		  	
		 			--studentPos1:= 
		 			SELECT student INTO studentPos1 FROM CourseQueuePositions WHERE course = OLD.course AND place = 1;
		 			--coursePos1:= 
		 			--SELECT course INTO coursePos1 FROM CourseQueuePositions WHERE course = OLD.course AND place = 1;
					
					
					IF (studentPos1 IS NOT NULL) THEN  
						DELETE FROM WaitingList WHERE course = OLD.course AND position = 1;
						INSERT INTO Registered VALUES (studentPos1, OLD.course);
						
						
						-- update waitinglist
						UPDATE WaitingList SET position = position-1 WHERE course = OLD.course AND position >1; 
						RETURN OLD;
					END IF;
				
			END IF;	
			
			RETURN OLD;		
		
		END IF;
		RETURN OLD;
	END;
	
$$LANGUAGE plpgsql;


CREATE TRIGGER Unregistration_Trigger
INSTEAD OF DELETE ON Registrations
FOR EACH ROW EXECUTE PROCEDURE unregisterProcess();



-- some more insert for test
INSERT INTO Registrations VALUES('6666666666','CCC333');
INSERT INTO Registrations VALUES('7777777777','CCC333');






























