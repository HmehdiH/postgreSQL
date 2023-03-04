# Creating a data base which stores the students information: 
 
 <b> This project was a lab given by the Chalmers University of Technology, 2022:</b> 
  <b>"</b>Introduction
In this assignment you will design and construct a database, together with a front end application, that handles university students and courses. You will do this in four distinct tasks:

Construction: create (a prototype of) the database and explore it with queries
Design: take a step back and redesign the database using more systematic approaches
Usage: define more constraints and triggers to maintain the database
Interface: write a wrapper program to permit database access without explicit use of SQL
All of the tasks are related to each other. They deal with the same database domain, and subsequent tasks build on earlier ones to varying degrees.

For each task you will hand in and get feedback on your results. Since errors in one task may propagate to the next one, it is wise to hand in your solutions early to get more chances for feedback. If there is time, teachers can also accept your solution directly in lab sessions.

Be sure to read through the full description of the assignment before you start since the requirements we place on the system must influence your initial design as well.

Domain description
The domain that you will model in this assignment is that of courses and students at a university.  Note that the described domain is not identical to Chalmers or GU.

The university for which you are building this system is organized into departments, such as the Dept. of Computing Science (CS), and educational programs for students, such as the Computer Science and Engineering program (CSEP). Programs are hosted by departments, but several departments may collaborate on a program, which is the case with CSEP that is co-hosted by the CS department and the Department of Computer Engineering (CE). Department names and abbreviations are unique, as are program names but not necessarily program abbreviations.

Each program is further divided into branches, for example CSEP has branches Computer Languages, Algorithms, Software Engineering etc. Note that branch names are unique within a given program, but not necessarily across several programs. For instance, both CSEP and a program in Automation Technology could have a branch called Interaction Design. For each program, there are mandatory courses. For each branch, there are additional mandatory courses that the students taking that branch must read. Branches also name a set of recommended courses from which all students taking that branch must read a certain amount to fulfill the requirements of graduation (see below for additional requirements).

A student always belongs to a program. Students must choose a single branch within that program, and fulfill its graduation requirements, in order to graduate. Typically students choose which branch to take in their fourth year, which means that students who are in the early parts of their studies may not yet belong to any branch.

Each course is given by a department (e.g. CS gives the Databases course). Each course has a unique six character course code. All courses may be read by students from any program. Some courses may be mandatory for certain program, but not for others. Students get academic credits for passing courses, the exact number may vary between courses (but all students get the same number of credits for the same course). Some, but not all, courses have a restriction on the number of students that may take the course at the same time. Courses can be classified as being mathematical courses, research courses or seminar courses. Not all courses need to be classified, and some courses may have more than one classification. The university will occasionally introduce new classifications, so the database needs to allow this. Some courses have prerequisites, i.e. other courses that must be passed before a student is allowed to register to it.

Students need to register for courses in order to read them. To be allowed to register, the student must first fulfill all prerequisites for the course. It should not be possible for a student to register to a course unless the prerequisite courses are already passed. It should not be possible for a student to register for a course which they have already passed. 

If a course becomes full, subsequent registering students are put on a waiting list. If one of the previously registered students decides to drop out, such that there is an open slot on the course, that slot is given to the student who has waited the longest. When the course is finished, all students are graded on a scale of 'U', '3', '4', '5'. Getting a 'U' means the student has not passed the course, while the other grades denote various degrees of success.

A study administrator (a person with direct access to the database) can override both course prerequisite requirements and size restrictions and add a student directly as registered to a course. (Note: you will not implement any front end application for study administrators, only for students. The database must still be able to handle this situation.)

For a student to graduate there are a number of requirements they must first fulfill. They must have passed (have at least grade 3) in all mandatory courses of the educational program they belong to, as well as the mandatory courses of the particular branch that they must have chosen. Also they must have passed at least 10 credits worth of courses among the recommended courses for the branch. Furthermore they need to have read and passed (at least) 20 credits worth of courses classified as mathematical courses, 10 credits worth of courses classified as research courses, and at least one seminar course. Mandatory and recommended courses that are also classified in some way are counted just like any other course, so if one of the mandatory courses of a program is also a seminar course, students of that program will not be required to read any additional seminar courses.

System Specification (also part of the domain description)
You will design and implement a database for the above domain, and a front end application intended for students of the university. Through the application they should be able to see their own information, register to, and unregister from courses.

Formally, your application should have the following modes:

Info: Given a students national identification number, the system should provide:
the name of the student, the students national identification number (10 digits) and their university issued login name/ID (something similar to how the CID works for Chalmers students)
the program and branch (if any) that the student is following.
the courses that the student has read (including failed courses), along with the grade.
the courses that the student is registered to and waiting for (and their queue position if waiting).
whether or not the student fulfills the requirements for graduation
Register: Given a student id number and a course code, the system should try to register the student for that course. If the course is full, the student should be placed in the waiting list for that course. If the student has already passed the course, or is already registered, or does not meet the prerequisites for the course, the registration should fail. The system should notify the student of the outcome of the attempted registration.
Unregister: Given a student id number and a course code, the system should unregister the student from that course. If there are students waiting to be registered, and there is now room on the course, the one first in line should be registered for the course. The system should acknowledge the removed registration for the student. If the student is not registered to the course when trying to unregister, the system should notify them.<b>"</b>