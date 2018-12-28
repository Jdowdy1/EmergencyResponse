DROP TABLE IF EXISTS EquipmentList;
DROP TABLE IF EXISTS is_on;
DROP TABLE IF EXISTS teamassignments;
DROP TABLE IF EXISTS EventList;
DROP TABLE IF EXISTS Mission;
DROP TABLE IF EXISTS Equipment;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Volunteer;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS MissionChief;
DROP TABLE IF EXISTS CallStaff;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Person;

CREATE TABLE `Person` (
  `Person_ID` int auto_increment ,
  `FirstName` varchar(30),
  `LastName` varchar(30),
  `PhoneNumber` varchar(40),
  PRIMARY KEY(Person_ID)
);
CREATE TABLE `Employee`(
	`Employee_ID` int auto_increment,
    `Person_ID` int,
    `userName` varchar(20),
    `password` varchar(20),
    FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID)
		on update cascade
        on delete cascade,
    PRIMARY KEY(Employee_ID)
);
CREATE TABLE `CallStaff` (
  `CallStaff_ID` int auto_increment ,
  `Employee_ID` int,
  FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
	on update cascade
	on delete cascade,
  PRIMARY KEY(CallStaff_ID)
);
CREATE TABLE `MissionChief` (
  `MissionChief_ID` int auto_increment ,
  `Employee_ID` int,
  FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
	on update cascade
	on delete cascade,
  PRIMARY KEY(MissionChief_ID)
);

CREATE TABLE `Team` (
  `Team_ID` int auto_increment ,

  PRIMARY KEY(Team_ID)
);

CREATE TABLE `Volunteer` (
  `Volunteer_ID` int auto_increment ,
  `availability` varchar(50),
  CONSTRAINT chk_availability CHECK (availability IN ('available','unavailable')),
  `Person_ID` int,
  FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID)
	on update cascade
	on delete cascade,
  PRIMARY KEY(Volunteer_ID)
);

CREATE TABLE `Event` (
  `Event_ID` int auto_increment,
  `location` varchar(200),
  `description` varchar(200),
  `priority` varchar(50),
  CONSTRAINT chk_priority CHECK (priority IN ('low','medium','high')),
  `status` varchar(50),
  CONSTRAINT chk_status CHECK (status IN ('new','in-progress','complete')),
  PRIMARY KEY (Event_ID),
  `equipNeeded` varchar(100),
  `lat` float,
  `long` float
);
CREATE TABLE `Equipment` (
  `Equipment_ID` int auto_increment, 
  `description` varchar(100),
  `location` varchar(100),
  `ownerInfo` varchar(100),
  `condition` varchar(50),
  CONSTRAINT chk_condition CHECK (`condition` IN ('new','used','broken')),
  PRIMARY KEY (Equipment_ID)
);

CREATE TABLE `Mission` (
  `Mission_ID` int auto_increment, 
  timeSinceAssigned time,
  timeCreated timestamp,
  `priority`  varchar(20),
  `status` varchar(100),
  PRIMARY KEY (Mission_ID)
);

CREATE TABLE `EventList` (
	`Mission_ID` int,
    `Event_ID` int,
	FOREIGN KEY (Mission_ID) REFERENCES Mission(Mission_ID)
		on update cascade
        on delete cascade,
	FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID)
		on update cascade
        on delete cascade
);
CREATE TABLE `EquipmentList` (
	`Mission_ID` int,
    `Equipment_ID` int,
	FOREIGN KEY (Mission_ID) REFERENCES Mission(Mission_ID)
		on update cascade
        on delete cascade,
	FOREIGN KEY (Equipment_ID) REFERENCES Equipment(Equipment_ID)
		on update cascade
        on delete cascade
);
create table teamAssignments(
	Volunteer_ID int 
		primary key,
	Team_ID int,
    FOREIGN KEY (Volunteer_ID) REFERENCES Volunteer(Volunteer_ID)
		on update cascade
        on delete cascade,
	FOREIGN KEY (Team_ID) REFERENCES Team(Team_ID)
		on update cascade
        on delete cascade
);
create table is_on(
	team_id int,
    mission_id int
		primary key,
	FOREIGN KEY (team_id) REFERENCES Team(Team_ID)
		on update cascade
        on delete cascade,
	FOREIGN KEY (mission_id) REFERENCES Mission(Mission_ID)
		on update cascade
        on delete cascade
);

delimiter $$

drop trigger if exists insert_person;
$$
create trigger insert_person before insert on person
	for each row
		begin
        set new.firstName = trim(both from new.firstName);
		if strcmp(new.firstName, "") = 0 then
			set new.firstName = null;
        end if;
        set new.lastName = trim(both from new.lastName);
		if strcmp(new.lastName, "") = 0 then
			set new.lastName = null;
        end if;
        set new.phoneNumber = trim(both from new.phoneNumber);
		if strcmp(new.phoneNumber, "") = 0  or char_length(new.phoneNumber) < 10 then
			set new.phoneNumber = null;
        end if;
end;
$$
drop trigger if exists update_person;
$$
create trigger update_person before update on person
	for each row
		begin
        set new.firstName = trim(both from new.firstName);
		if strcmp(new.firstName, "") = 0 then
			set new.firstName = null;
        end if;
        set new.lastName = trim(both from new.lastName);
		if strcmp(new.lastName, "") = 0 then
			set new.lastName = null;
        end if;
        set new.phoneNumber = trim(both from new.phoneNumber);
		if strcmp(new.phoneNumber, "") = 0  or char_length(new.phoneNumber) < 10 then
			set new.phoneNumber = null;
        end if;
end;

$$
drop trigger if exists insert_employee;
$$
create trigger insert_employee before insert on Employee
	for each row
		begin
        set new.username = trim(both from new.username);
		if strcmp(new.username, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Username cannot be null";
        end if;
        set new.password = trim(both from new.password);
		if strcmp(new.password, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Password cannot be null";
        end if;
        
end;

$$
drop trigger if exists update_emp;
$$
create trigger update_emp before update on Employee
	for each row
		begin
        set new.username = trim(both from new.username);
		if strcmp(new.username, "") = 0 then
			set new.username = "";
        end if;
        set new.password = trim(both from new.password);
		if strcmp(new.password, "") = 0 then
			set new.password = "";
        end if;
end;

$$
drop trigger if exists insert_volunteer;
$$
create trigger insert_volunteer before insert on Volunteer
	for each row
		begin
        set new.availability = trim(both from new.availability);
		if strcmp(new.availability, "") = 0 then
			set new.availability = null;
        end if;
end;
$$
drop trigger if exists update_volunteer;
$$
create trigger update_volunteer before update on Volunteer
	for each row
		begin
        set new.availability = trim(both from new.availability);
		if strcmp(new.availability, "") = 0 then
			set new.availability = null;
        end if;
end;
$$
drop trigger if exists insert_event;
$$
create trigger insert_event before insert on Event
	for each row
		begin
        set new.location = trim(both from new.location);
		if strcmp(new.location, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Address cannot be null";
        end if;
        set new.description = trim(both from new.description);
		if strcmp(new.description, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Event must have a description";
        end if;
        if new.priority not in ("low", "medium", "high") then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Priority must be either low, medium, or high";
        end if;
        if strcmp(new.status, "new") then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A newly created event must have status 'new'";
        end if;
        set new.equipNeeded = trim(both from new.equipNeeded);
		if strcmp(new.equipNeeded, "") = 0 then
			set new.equipNeeded = null;
        end if;
        if new.lat is null or new.lat < -90 or new.lat > 90 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Latitude of created event is invalid";
		end if;
        if new.long is null or new.long < -180 or new.long > 180 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Longitude of created event is invalid";
		end if;
end;
$$
drop trigger if exists update_event;
$$
create trigger update_event before update on Event
	for each row
		begin
        set new.location = trim(both from new.location);
		if strcmp(new.location, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Address cannot be null";
        end if;
        set new.description = trim(both from new.description);
		if strcmp(new.description, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Event must have a description";
        end if;
        if new.priority not in ("low", "medium", "high") then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Priority must be either low, medium, or high";
        end if;
        if new.status not in ("new", "in progress", "assigned", "completed", "aborted") then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Status of an event must be 'new', 'in progress', 'assigned', 'aborted', or 'completed'";
        end if;
        set new.equipNeeded = trim(both from new.equipNeeded);
		if strcmp(new.equipNeeded, "") = 0 then
			set new.equipNeeded = null;
        end if;
        if new.lat is null or new.lat < -90 or new.lat > 90 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Latitude of created event is invalid";
		end if;
        if new.long is null or new.long < -180 or new.long > 180 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Longitude of created event is invalid";
		end if;
end;
$$
drop trigger if exists insert_equipment;
$$
create trigger insert_equipment before insert on Equipment
	for each row
		begin
        set new.description = trim(both from new.description);
		if strcmp(new.description, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Equipment must have a description";
        end if;
        set new.location = trim(both from new.location);
		if strcmp(new.location, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Equipment must have a location";
        end if;
        set new.ownerInfo = trim(both from new.ownerInfo);
		if strcmp(new.ownerInfo, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Equipment must have an owner";
        end if;
        set new.condition = trim(both from new.condition);
		if strcmp(new.condition, "") = 0 then
			set new.condition = null;
        end if;
end;
$$
drop trigger if exists update_equipment;
$$
create trigger update_equipment before update on Equipment
	for each row
		begin
        set new.description = trim(both from new.description);
		if strcmp(new.description, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Equipment must have a description";
        end if;
        set new.location = trim(both from new.location);
		if strcmp(new.location, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Equipment must have a location";
        end if;
        set new.ownerInfo = trim(both from new.ownerInfo);
		if strcmp(new.ownerInfo, "") = 0 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Equipment must have an owner";
        end if;
        set new.condition = trim(both from new.condition);
		if strcmp(new.condition, "") = 0 then
			set new.condition = null;
        end if;
end;
$$
drop trigger if exists insert_mission;
$$
create trigger insert_mission before insert on Mission
	for each row
		begin
		if new.timeSinceAssigned is not null then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A newly created Mission cannot be imidiately assigned";
        end if;
        if new.timeCreated > current_timestamp() then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "New mission is created in the future??";
		end if;
		if new.timeCreated is null then
			set new.timeCreated = current_timestamp();
        end if;
        if new.priority not in ("low", "medium", "high") then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Priority must be 'low', 'medium', 'high'";
		end if;
        if strcmp(new.status, "new") = 0 then
			set new.status = "new";
		end if;
End;
$$
drop trigger if exists update_mission;
$$
create trigger update_mission before update on Mission
	for each row
		begin
        if new.timeSinceAssigned is null and new.status != "new" then
			set new.timeSinceAssigned = '00:00:00';
		elseif new.timeSinceAssigned is not null then
			set new.timeSinceAssigned =  timediff(current_timestamp(), new.timeCreated);
		end if;
        if new.timeCreated != old.timeCreated then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "You cannot alter a Mission's creation time";
		end if;
        if new.priority not in ("low", "medium", "high") then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Priority must be 'low', 'medium', 'high'";
		end if;
        if new.status not in ("new", "assigned", "in progress", "aborted", "completed") then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Status must be 'new', 'assigned', 'in progress', 'aborted', 'completed'";
		end if;
end;
drop view if exists VolxPers;
$$
create view VolxPers as 
select Volunteer.Volunteer_ID, Person.Person_ID, Person.firstName, Person.lastName, Volunteer.availability
from Volunteer
	inner join Person
		on Volunteer.Person_ID = Person.Person_ID


