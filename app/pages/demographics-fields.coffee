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
      label: 'Education'
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
      label: 'Handedness'
      options: [
        'left'
        'right'
        'other'
      ]
    }
    {
      string_id: 'gender'
      type: 'select_by_icon'
      label: 'Sex'
      options: [
        'Female'
        'Male'
      ]
    }
  ]
