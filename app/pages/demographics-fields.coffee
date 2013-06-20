define [],() ->
  [
    {
      string_id: 'dob'
      type: 'date'
      label: 'Birthdate'
    }
    {
      string_id: 'education'
      type: 'select'
      multiselect: true
      options: [
        'Some Elementary School'
        'Some High School'
        'Some College'
        'PhilzDoctor'
      ]
    }
    {
      string_id: 'handedness'
      type: 'select_by_icon'
      multiselect: true
      options: [
        'left'
        'right'
      ]
    }
    {
      string_id: 'gender'
      type: 'select_by_icon'
      label: 'Sex'
      multiselect: false
      options: [
        'Female'
        'Male'
      ]
    }
  ]
