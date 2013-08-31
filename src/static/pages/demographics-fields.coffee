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
        { value: 'left',  label: 'Left',  icon: 'gfx-lefthand'}
        { value: 'right', label: 'Right', icon: 'gfx-righthand'}
        { value: 'mixed', label: 'Mixed', icon: 'gfx-bothhands'}
      ]
    }
    {
      string_id: 'gender'
      type: 'select_by_icon'
      label: 'Sex'
      options: [
        { value: 'female', label: 'Female', icon: 'gfx-female'}
        { value: 'male',   label: 'Male',   icon: 'gfx-male'}
      ]
    }
  ]

