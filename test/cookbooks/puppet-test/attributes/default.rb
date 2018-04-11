default['settings_test'] = {
  'one' => 'a',
  'two' => 'b',
}
default['sections_test'] = {
  'testsec1' => {
    'set1' => 10,
    'set2' => 20,
  },
  'testsec2' => {
    'set21' => 100,
    'set22' => 200,
  },
}
default['sections_del'] = %w(del1 del2)
default['settings_del'] = %w(away1 away2)
