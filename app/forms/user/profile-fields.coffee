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
        'Some Elementary School'
        'Some High School'
        'Some College'
        'PhilzDoctor'
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
        'left'
        'right'
        'other'
      ]
    }
  ]
