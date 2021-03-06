Setting.find_or_create_by(:namespace => 'datajam-datacard', :name => 'installed', :value => true)

# Create a couple of example data cards

data_card_1 = DataCard.find_or_create_by(
  title: 'Data Card 1',
  display_type: :html,
  tag_string: 'gobal',
  html: "<h3>This is a data card</h3>\r\n<p>Data cards can be raw html, or csv parsed into a template.</p>\r\n<p>\r\n  This provides the flexibility to embed just about anything. \r\n  To change the data card, ensure you're logged in and then select\r\n  'Data Card' from the On Air toolbar.   \r\n</p>",
)
data_card_2 = DataCard.find_or_create_by(
  title: 'Data Card 2',
  display_type: :html,
  tag_string: 'gobal',
  html: "<h3>Try creating your own!</h3><p>To create your own data cards, click 'Data Cards' in the admin site.</p>"
)
