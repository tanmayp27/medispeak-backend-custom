# Create a user
user = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: true
)

# Create the Bahmni template
bahmni_template = Template.create!(
  name: 'Bahmni',
  description: 'Bahmni Registration EMR'
)

# Add domain to the Bahmni template
Domain.create!(
  template: bahmni_template,
  fqdn: 'localhost',
  archived: false
)

# Create the Registration Page
registration_page = Page.create!(
  template: bahmni_template,
  name: 'Registration Page'
)

# Define form fields for the Registration Page
registration_fields = [
  {
    title: "givenName",
    friendly_name: "First Name",
    description: "Patient's Given Name",
    field_type: "string",
    metadata: {}
  },

  {
    title: "middleName",
    friendly_name: "Middle Name",
    description: "Patient's Middle Name",
    field_type: "string",
    metadata: {}
  },

  {
    title: "familyName",
    friendly_name: "Last Name",
    description: "Patient's Family Name",
    field_type: "string",
    metadata: {}
  },

  {
    title: "ageYears",
    friendly_name: "Age (Years)",
    description: "Age in Years",
    field_type: "number",
    minimum: 0,
    maximum: 120,
    metadata: {}
  },

  {
    title: "ageMonths",
    friendly_name: "Age (Months)",
    description: "Age in Months",
    field_type: "number",
    minimum: 0,
    maximum: 11,
    metadata: {}
  },

  {
    title: "ageDays",
    friendly_name: "Age (Days)",
    description: "Age in Days",
    field_type: "number",
    minimum: 0,
    maximum: 30,
    metadata: {}
  },

  {
    title: "birthdate",
    friendly_name: "Birthdate",
    description: "Birthday of Patient",
    field_type: "string",
    metadata: {}
  },

  {
    title: "address1",
    friendly_name: "House Number/Flat Number",
    description: "House Number",
    field_type: "string",
    metadata: {}
  },

  {
    title: "address2",
    friendly_name: "Locality/Sector",
    description: "Locality",
    field_type: "string",
    metadata: {}
  },

  {
    title: "cityVillage",
    friendly_name: "City/Village",
    description: "City/Village",
    field_type: "string",
    metadata: {}
  },

  {
    title: "countyDistrict",
    friendly_name: "District",
    description: "District",
    field_type: "string",
    metadata: {}
  },

  {
    title: "stateProvince",
    friendly_name: "State",
    description: "State",
    field_type: "string",
    metadata: {}
  },

  {
    title: "alternatePhoneNumber",
    friendly_name: "Alternate Phone Number",
    description: "Alternate Phone Number for Patient",
    field_type: "number",
    metadata: {}
  },

  {
    title: "phoneNumber",
    friendly_name: "Phone Number",
    description: "Phone Number of Patient",
    field_type: "number",
    metadata: {}
  },

  {
    title: "postalCode",
    friendly_name: "Pin Code",
    description: "Pin Code",
    field_type: "number",
    metadata: {}
  },

  {
    title: "gender",
    friendly_name: "Gender",
    description: "Patient's gender",
    field_type: "single_select",
    enum_options: [ "M", "F", "O" ],
    metadata: {}
  }
]

# Create the OPD Visit Page
opd_visit_page = Page.create!(
  template: bahmni_template,
  name: 'OPD Visit Page'
)

# Define form fields for the OPD Visit Page
opd_visit_fields = [
  {
    title: "weight",
    friendly_name: "Weight",
    description: "Weight in kilograms",
    field_type: "number",
    metadata: {}
  },

  {
    title: "height",
    friendly_name: "Height",
    description: "Height in centimeters",
    field_type: "number",
    metadata: {}
  },

  {
    title: "systolic_bp",
    friendly_name: "Systolic Blood Pressure",
    description: "Systolic Blood Pressure in mmHg",
    field_type: "number",
    metadata: {}
  },

  {
    title: "diastolic_bp",
    friendly_name: "Diastolic Blood Pressure",
    description: "Diastolic Blood Pressure in mmHg",
    field_type: "number",
    metadata: {}
  },

  {
    title: "pulse",
    friendly_name: "Pulse",
    description: "Pulse rate per minute",
    field_type: "number",
    metadata: {}
  },

  {
    title: "spo2",
    friendly_name: "Arterial Blood Saturation",
    description: "Oxygen saturation in percentage",
    field_type: "number",
    metadata: {}
  },

  {
    title: "registration_fee",
    friendly_name: "Registration Fee",
    description: "Fee for registration",
    field_type: "number",
    metadata: {}
  },

  {
    title: "doctor_name",
    friendly_name: "Doctor's Name",
    description: "Name of the consulting doctor",
    field_type: "string",
    metadata: {}
  },

  {
    title: "consultation_fee",
    friendly_name: "Consultation Fee",
    description: "Fee for consultation",
    field_type: "number",
    metadata: {}
  }
]

# Create all form fields under the Registration Page
registration_fields.each do |field|
  FormField.create!(
    page: registration_page,
    title: field[:title],
    friendly_name: field[:friendly_name],
    description: field[:description],
    field_type: field[:field_type],
    minimum: field[:minimum],
    maximum: field[:maximum],
    enum_options: field[:enum_options],
    metadata: field[:metadata]
  )
end

# Create all form fields under the OPD Visit Page
opd_visit_fields.each do |field|
  FormField.create!(
    page: opd_visit_page,
    title: field[:title],
    friendly_name: field[:friendly_name],
    description: field[:description],
    field_type: field[:field_type],
    minimum: field[:minimum],
    maximum: field[:maximum],
    enum_options: field[:enum_options],
    metadata: field[:metadata]
  )
end

puts "Seeds created successfully!"
puts "User email: #{user.email}"
puts "Bahmni Template: #{bahmni_template.name}"
puts "Total Domains created: #{Domain.count}"
puts "Total Pages created: #{Page.count}"
puts "Form fields created for Registration Page: #{registration_page.form_fields.count}"
puts "Form fields created for OPD Visit Page: #{opd_visit_page.form_fields.count}"
