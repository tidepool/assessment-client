define [],() ->
  [
    {
      string_id: 'name'
      label: 'Name'
      placeholder: 'Captain Nemo'
      className: 'large input-block-level'
    }
    {
      string_id: 'email'
      label: 'Email'
      type: 'email'
      placeholder: 'email@address.com'
      className: 'large input-block-level'
    }
    {
      string_id: 'dob'
      type: 'date'
      label: 'Birthdate'
      className: 'large input-block-level'
    }
    {
      string_id: 'education'
      label: 'Education'
      type: 'select'
      className: 'large input-block-level'
#      defaultOption: 'Select Education Level...'
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
      string_id: 'gender'
      label: ''
      type: 'select_by_icon'
      label: 'Gender'
      options: [
        'Female'
        'Male'
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
  ]
