module ProfileHelper
  def attributes
    # Available parameters: type (:text or :select), name, text, required, visibility_settings, options (if type is :select)
    [
      {type: :text, name: "lastname", text: "Vezetéknév", required: true},
      {type: :text, name: "firstname", text: "Keresztnév", required: true},
      {type: :text, name: "nickname", text: "Becenév", required: false},
      {type: :select, name: "gender", text: "Nem", required: false, options: Rails.configuration.x.genders},
      {type: :text, name: "date_of_birth", text: "Születési dátum", required: false, visibility_settings: true},
      {type: :text, name: "home_address", text: "Cím", required: false, visibility_settings: true},
      {type: :text, name: "email", text: "E-mail", required: true, visibility_settings: true},
      {type: :text, name: "cell_phone", text: "Mobil", required: false, visibility_settings: true},
      {type: :text, name: "webpage", text: "Weboldal", required: false, visibility_settings: true},
      {type: :select, name: "dormitory", text: "Kollégium", options: Rails.configuration.x.dorms, visibility_settings: true},
      {type: :text, name: "room", text: "Szobaszám", required: false, visibility_settings: true},
    ]
  end
end
