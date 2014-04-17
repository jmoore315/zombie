#########################################
#### SCHOOLS & SCHOOL ADMIN ACCOUNTS ####

# NORTHWESTERN (EVANSTON)
nu = School.create(name:'Northwestern University', nickname: 'Northwestern',code:'northwestern', active:true)
nu.properties.create(name:'The Arch', street_address:'1881 Sheridan Road', city: 'Evanston', state: 'IL', postal_code: '60208')
nu.properties.create(name:'Tech', street_address:'2145 Sheridan Road', city: 'Evanston', state: 'IL', postal_code: '60208')
nu.properties.create(name:'Patten', street_address:'2407 Sheridan Road', city: 'Evanston', state: 'IL', postal_code: '60208')

# NORTHWESTERN - CHICAGO
nuchicago = School.create(name:'Northwestern University - Chicago', nickname: 'NU Chicago', code:'northwesternchicago', active: true)
nuchicago.properties.create(name:'The Law School', street_address:'375 East Chicago Avenue', city: 'Chicago', state: 'IL', postal_code: '60611')
nuchicago.properties.create(name:'Feinberg', street_address:'420 East Superior Street', city: 'Chicago', state: 'IL', postal_code: '60611')

# MICHIGAN
michigan = School.create(name: 'University of Michigan', nickname:'Michigan', code:'michigan', active: true)
michigan.properties.create(street_address: '701 S State Street', city: 'Ann Arbor', state: 'MI', postal_code: '48109')
michigan.properties.create(street_address: '610 E University Avenue', city: 'Ann Arbor', state: 'MI', postal_code: '48109')
michigan.properties.create(street_address: '503 S State Street', city: 'Ann Arbor', state: 'MI', postal_code: '48109')

# OHIO STATE
osu = School.create(name: 'Ohio State University', nickname:'OSU', code: 'osu', active: true)
osu.properties.create(street_address: '164 West 17th Avenue', city: 'Columbus', state: 'OH', postal_code: '43210')
osu.properties.create(street_address: '2041 College Road North', city: 'Columbus', state: 'OH', postal_code: '43210')
osu.properties.create(street_address: '2110 Tuttle Park Place', city: 'Columbus', state: 'OH', postal_code: '43210')
osu.properties.create(street_address: '234 West 18th Avenue', city: 'Columbus', state: 'OH', postal_code: '43210')
osu.properties.create(street_address: '1739 North High Street', city: 'Columbus', state: 'OH', postal_code: '43210')
osu.properties.create(street_address: '29 West Woodruff Avenue', city: 'Columbus', state: 'OH', postal_code: '43210')
osu.properties.create(street_address: '2070 Neil Avenue', city: 'Columbus', state: 'OH', postal_code: '43210')
osu.properties.create(street_address: '333 West 10th Avenue', city: 'Columbus', state: 'OH', postal_code: '43210')

# PENN STATE
pennstate = School.create(name: 'Penn State - University Park', nickname: 'Penn State', code: 'pennstate', active: true)
pennstate.properties.create(name: 'Frances Atheron Hall', street_address:'Frances Atheron Hall', city: 'State College', state: 'PA')
pennstate.properties.create(name: 'Bigler Hall', street_address:'Bigler Hall', city: 'State College', state: 'PA')
pennstate.properties.create(name: 'Harris Hall', street_address:'Harris Hall', city: 'State College', state: 'PA')
pennstate.properties.create(name: 'Hammond', street_address:'Hammond', city: 'State College', state: 'PA')
pennstate.properties.create(name: 'Kern', street_address:'Kern', city: 'State College', state: 'PA')

# DEPAUL - LINCOLN PARK
depaul = School.create(name:'DePaul University', nickname: 'DePaul', code:'depaul', active:true)
depaul.properties.create(name:'The Ray', street_address:'2235 N. Sheffield Avenue', city: 'Chicago', state: 'IL', postal_code: '60614')
depaul.properties.create(name:'McGowan North', street_address:'2325 N. Clifton Avenue', city: 'Chicago', state: 'IL', postal_code: '60614')
depaul.properties.create(name:'The Annex', street_address:'2130 N. Kenmore Avenue', city: 'Chicago', state: 'IL', postal_code: '60614')

# DEPAUL - LOOP
depaulloop = School.create(name:'DePaul University - Loop', nickname: 'DePaul Loop', code:'depaulloop', active:true)
depaulloop.properties.create(name:'The DePaul Center', street_address:'1 East Jackson Boulevard', city: 'Chicago', state: 'IL', postal_code: '60604')

# LOYOLA - LAKE SHORE
loyolalakeshore = School.create(name:'Loyola University Chicago - Lake Shore', nickname: 'Loyola Lake Shore', code:'loyolalakeshore', active:true)
loyolalakeshore.properties.create(street_address: '1191 West Loyola Avenue', city: 'Chicago', state: 'IL')
loyolalakeshore.properties.create(street_address: '1103 West Sheridan Road', city: 'Chicago', state: 'IL')

# LOYOLA - WATER TOWER
loyolawatertower = School.create(name:'Loyola University Chicago - Water Tower', nickname: 'Loyola Water Tower', code:'loyolawatertower', active:true)
loyolawatertower.properties.create(street_address: '111 East Pearson Street', city: 'Chicago', state: 'IL', postal_code: '60611')

# ELMHURST
elmhurst = School.create(name: 'Elmhurst College', nickname: 'Elmhurst', code:'elmhurst', active: true)
elmhurst.properties.create(name: 'Mill Theater', street_address: 'Mill Theater, Walter Street', city: 'Elmhurst', state: 'IL', postal_code: '60126')
elmhurst.properties.create(name: 'SouthEast', street_address: '202 Elm Park Avenue', city: 'Elmhurst', state: 'IL', postal_code: '60126')
elmhurst.properties.create(name: 'SouthEast', street_address: '305 W Elm Park Avenue', city: 'Elmhurst', state: 'IL', postal_code: '60126')

##########################
#### STUDENT ACCOUNTS ####
alex = User.create(email: 'alexandershapiro2013@u.northwestern.edu', code: 'northwestern').account
justin = User.create(email: 'justinmoore1.2014@u.northwestern.edu', code: 'northwestern').account
avery = User.create(email: 'averyalchek2013@u.northwestern.edu', code: 'northwestern').account
jordan = User.create(email: 'jordancohen2015@u.northwestern.edu', code: 'northwestern').account
natasha = User.create(email: 'natasharamanujam2015@u.northwestern.edu', code: 'northwestern').account

nusublet1 = alex.properties.create(street_address: '718 Clark Street', city: 'Evanston', state: 'IL', postal_code: '60201',
	water_included: true, pets_allowed: true, parking: false, television: true, internet: true, gas_included: true,
	smoking: false, furnished: false, graduate_only: false, central_air: false)
nusublet1









