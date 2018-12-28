from easygui import *
import proj

def is_empty(any_structure):
    if any_structure:
        #print('Structure is not empty.')
        return False
    else:
        #print('Structure is empty.')
        return True
		
def	loadMessage(passMsg, passTitle):
	ccbox(passMsg, passTitle, choices=('C[o]ntinue', 'C[a]ncel'), image=None, default_choice='Continue', cancel_choice='Cancel')
	
def loadCreateEventGui():
	#EVENT CREATION BLOCK
	msg = "Enter event information"
	title = "EVENT REPORT"
	fieldNames = ["Description","Street Address","City","State","ZipCode", "Phone Number", "Reccomended Equipment", "Priority"]
	fieldValues = []  # we start with blanks for the values
	fieldValues = multenterbox(msg,title, fieldNames)
	
	# make sure that none of the fields was left blank
	while 1:
		if fieldValues == None: break
		errmsg = ""
		for i in range(len(fieldNames)):
			if fieldValues[i].strip() == "":
				errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
		if errmsg == "": break # no problems found
		fieldValues = multenterbox(errmsg, title, fieldNames, fieldValues)
	print ("Reply was:", fieldValues)
	if fieldValues != "None":
		temploc = (fieldValues[1]+", "+fieldValues[2]+", "+fieldValues[3]+", "+fieldValues[4])
		proj.addEvent(loc = temploc, desc = fieldValues[0], prio= fieldValues[7], equip= fieldValues[6] )

def loadCreateEquipmentGui():
	#CREAT EQUIPMENT BLOCK
	msg = "Enter equipment information"
	title = "EQUIPMENT REPORT"
	fieldNames = ["Owner Name","Owner Phone Number","Type", "Description", "Condition", "Location"]
	fieldValues = []  # we start with blanks for the values
	fieldValues = multenterbox(msg,title, fieldNames)
	
	# make sure that none of the fields was left blank
	while 1:
		if fieldValues == None: break
		errmsg = ""
		for i in range(len(fieldNames)):
			if fieldValues[i].strip() == "":
				errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
		if errmsg == "": break # no problems found
		fieldValues = multenterbox(errmsg, title, fieldNames, fieldValues)
	print ("Reply was:", fieldValues)
	if fieldValues != "None":
		proj.addEquipment(desc = fieldValues[3], loc = fieldValues[5], owner = fieldValues[0]+", "+fieldValues[1], cond = fieldValues[4])
	
def loadCreateVolunteerGui():
	#CREATE VOLUNTEER BLOCK
	msg = "Enter volunteer information"
	title = "VOLUNTEER REPORT"
	fieldNames = ["First Name","Last Name","Phone Number", "Availability"]
	fieldValues = []  # we start with blanks for the values
	fieldValues = multenterbox(msg,title, fieldNames)
			
	# make sure that none of the fields was left blank
	while 1:
		if fieldValues == None: break
		errmsg = ""
		for i in range(len(fieldNames)):
			if fieldValues[i].strip() == "":
				errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
		if errmsg == "": break # no problems found
		fieldValues = multenterbox(errmsg, title, fieldNames, fieldValues)
	print ("Reply was:", fieldValues)
	if fieldValues != "None":
		volId = proj.addPerson(fn = fieldValues[0], ln = fieldValues[1], pn = fieldValues[3])
		proj.addVolunteer(volId, avail = fieldValues[3])
	
def loadRemoveEquipmentGui():
	#EQUIPMENT DELETE BLOCK
	
	msg = "Enter Equipment ID"
	title = "DELETE EQUIPMENT"
	fieldNames = ["Equipment ID"]
	fieldValues = []  # we start with blanks for the values
	fieldValues = multenterbox(msg,title, fieldNames)

	# make sure that none of the fields was left blank
	while 1:
		if fieldValues == None: break
		errmsg = ""
		for i in range(len(fieldNames)):
			if fieldValues[i].strip() == "":
				errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
		if errmsg == "": break # no problems found
		fieldValues = multenterbox(errmsg, title, fieldNames, fieldValues)
	print ("Reply was:", fieldValues)
	if fieldValues != "None":
		proj.removeEquipment(int(fieldValues[0]))

def loadReomveVolunteerGui():
	#VOLUNTEER DELETE BLOCK
	msg = "Enter Volunteer ID"
	title = "DELETE VOLUNTEER"
	fieldNames = ["Volunteer ID"]
	fieldValues = []  # we start with blanks for the values
	fieldValues = multenterbox(msg,title, fieldNames)

	# make sure that none of the fields was left blank
	while 1:
		if fieldValues == None: break
		errmsg = ""
		for i in range(len(fieldNames)):
			if fieldValues[i].strip() == "":
				errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
		if errmsg == "": break # no problems found
		fieldValues = multenterbox(errmsg, title, fieldNames, fieldValues)
	print ("Reply was:", fieldValues)
	if fieldValues != "None":
		proj.removeVolunteer(int(fieldValues[0]))

def loadMissionCreateGui():
	#MISSION CREATION BLOCK
	msg = "Enter mission information"
	title = "CREATE MISSION"
	fieldNames = ["Priority"]
	fieldValues = []  # we start with blanks for the values
	fieldValues = multenterbox(msg,title, fieldNames)

	# make sure that none of the fields was left blank
	while 1:
		if fieldValues == None: break
		errmsg = ""
		for i in range(len(fieldNames)):
			if fieldValues[i].strip() == "":
				errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
		if errmsg == "": break # no problems found
		fieldValues = multenterbox(errmsg, title, fieldNames, fieldValues)
	print("Reply was:", fieldValues)
	if fieldValues != "None":
		missionID = proj.addMission(fieldValues[0])
		
		
	value = proj.findUnAssignedTeams()
	if is_empty(value):
		loadMessage("No available Teams", "Team Selection")
	else:
		choice = choicebox(msg = "Pick from the list of teams", title = "Available Teams", choices = value)
		proj.addIsOn(choice, missionID)
	
	value2 = proj.findUnAssignedEvents()
	if is_empty(value2):
		loadMessage("No available Events", "Event Selection")
	else:
		choices1=[]
		choices1 = multchoicebox(msg = "Pick from the list of events", title = "Available Events", choices = value2)
		for i in choices1:
			proj.addEventList(i,missionID)
		
	value3 = proj.findAvailableEquipment()
	if is_empty(value3):
		loadMessage("No available Equipment", "Equipment Selection")
	else:
		choices2=[]
		choices2 = multchoicebox(msg = "Pick from the list of equipment", title = "Available Equipment", choices = value3)
		for p in choices2:
			proj.addEquipmentListWDesc(p,missionID)
		
def loadTeamCreateGui():
	title = "AVAILABLE VOLUNTEERS"
	
	value = proj.findAvailableVolunteers()
	if is_empty(value):
		loadMessage("No Volunteers Available for Team Assignment",'Available Volunteers') 
	
	else:
		msg = "Pick from the list of volunteers"
		fieldValues = []
		fieldValues = multchoicebox(choices = value)
		print ("Reply was:", fieldValues)
	
		teamID = proj.addTeam()
		#size = len(fieldValues)
		for i in fieldValues:
			proj.addTeamAssignment(i[0],teamID)
			print (i[0])
		
def loadTeamUpdateGui():
	#operation can be either add or delete
	msg = "Enter team update"
	title = "UPDATE TEAM"
	fieldNames = ["Team ID","Operation as 'add' or 'remove'"]
	fieldValues = [] # we start with blanks for the values
	fieldValues = multenterbox(msg,title, fieldNames)
	
	# make sure that none of the fields was left blank
	while 1:
		if fieldValues == None: break
		errmsg = ""
		for i in range(len(fieldNames)):
			if fieldValues[i].strip() == "":
				errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
		if errmsg == "": break # no problems found
		fieldValues = multenterbox(errmsg, title, fieldNames, fieldValues)
	print ("Reply was:", fieldValues)
	
	if fieldValues[1]=='add':
		value = proj.findAvailableVolunteers()
		if is_empty(value):
			loadMessage("No Available Volunteers", title)
		else:
			fieldValues2 = []
			fieldValues2 = multchoicebox(msg = "Pick from the list of volunteers", title = "Available Volunteers", choices = value)
			for p in fieldValues2:
				proj.addTeamAssignment(p, fieldValues[0]) #needs error checking for the teamID
	
	elif fieldValues[1] == 'remove':
		value2 = proj.findAssignedVolunteers(fieldValues[0])
		if is_empty(value2):
			loadMessage("No Assigned Volunteers", title)
		else:
			fieldValues3 = []
			print(value2)
			fieldValues3 = multchoicebox(msg = "Pick from the list of volunteers", title = "Assigned Volunteers", choices = value2)
			for q in fieldValues3:
				proj.removeTeamAssignment(q, fieldValues[0]) #needs error checking for the teamID
	

msg = "Enter logon information"
title = "LOGIN"
fieldNames = ["User ID", "Password"]
fieldValues = []  # we start with blanks for the values
fieldValues = multpasswordbox(msg,title, fieldNames)

# make sure that none of the fields was left blank
while 1:
	if fieldValues == None: break
	errmsg = ""
	for i in range(len(fieldNames)):
		if fieldValues[i].strip() == "":
			errmsg = errmsg + ('"%s" is a required field.\n\n' % fieldNames[i])
	
	check = proj.checkUserPass(fieldValues[0], fieldValues[1])
	if check is None:
		errmsg="Not a valid userName or Password"
	else:
		errmsg=""
	if errmsg == "": break # no problems found
	fieldValues = multpasswordbox(errmsg, title, fieldNames, fieldValues)
switch = proj.checkIfCall(check[0])


#SELECTION FOR THE MISSION CHIEF
flagEscape = False
if switch is None:
	while flagEscape == False:
		try:
			msg = "Choose from the following"
			title = "MISSION CHIEF"
			choices = ["Create Mission", "Create Team", "Update Mission", "Update Team", "View Event Map", "Delete Mission"]
			choice = choicebox(msg, title, choices)

			if choice == "Create Mission":
				loadMissionCreateGui()
			elif choice == "Create Team":
				loadTeamCreateGui()
			elif choice == "Update Team":
				loadTeamUpdateGui()
			elif choice == "Update Mission":
				loadMessage("Section not yet implemented", "Sorry")
			elif choice == "View Event Map":
				loadMessage("Section not yet implemented", "Sorry")
			elif choice == "Delete Mission":
				loadMessage("Section not yet implemented" "Sorry")
			else:
				flagEscape = True
		except Exception:
			print("")
	
else: #SELECTION FOR THE CALL STAFF
	while flagEscape == False:
		msg = "Choose from the following"
		title = "CALL STAFF"
		choices = ["Create Event", "Create Equipment", "Create Volunteer", "Delete Equipment", "Delete Volunteer"]
		choice = choicebox(msg, title, choices)
		try:
			if choice == "Create Event":
				loadCreateEventGui()
			elif choice == "Create Equipment":	
				loadCreateEquipmentGui()
			elif choice == "Create Volunteer":
				loadCreateVolunteerGui()
			elif choice == "Delete Equipment":
				loadRemoveEquipmentGui()
			elif choice == "Delete Volunteer":
				loadReomveVolunteerGui()
			else:
				flagEscape = True
		except Exception:
			print("canceled, going back to the main screen")