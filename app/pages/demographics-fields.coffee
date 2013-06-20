define [],() ->
  [
    {
      string_id: 'dob'
      type: 'dob'
      label: 'Birthdate'
      placeholder: '01012013'
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
