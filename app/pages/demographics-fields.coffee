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
        'High School - Freshman (9)'
        'High School - Sophmore (10)'
        'High School - Junior (11)'
        'High School - Senior (12)'
        'College - Less than 2 yrs'
        'College - Associates'
        'College - Bachelor\'s'
        'College - Master\'s'
        'College - Ph.D.'
        'Prefer not to answer'
      ]
    }
    {
      string_id: 'handedness'
      type: 'select_by_icon'
      label: 'Handedness'
      options: [
        'Left'
        'Right'
        'Mixed'
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
