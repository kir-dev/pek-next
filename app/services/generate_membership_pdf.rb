require "prawn"

class GenerateMembershipPdf

  PARAGRAPH_MARGIN = 15

  def self.call(user)
    pdf = Prawn::Document.new(margin: 80)
    pdf.font Rails.root.join("app/assets/fonts/arial.ttf")
    pdf.image "#{Rails.root}/app/assets/images/schlogo.png", width: 80,  position: :center
    pdf.font_size 18
    pdf.text 'Tagfelvételi kérelem', align: :center
    if user.svie.inside_member?
      pdf.text 'Belsős tagsághoz', align: :center
    elsif user.svie.outside_member?
      pdf.text 'Külsős tagsághoz', align: :center
    else
      pdf.text 'Öregtagsághoz', align: :center
    end
    pdf.font_size 11
    pdf.move_down 15
    generate_user_specific_paragraph(pdf, user)
    paragraph(pdf, 'A Budapesti Műszaki Egyetem Villamosmérnöki és Informatikai Karának nappali tagozatos hallgatója vagyok, egyben tagsággal bírok egy, a Schönherz Zoltán Kollégiumban működő Egyesületi Körben.')
    paragraph(pdf, 'E tagsági minőséggel kapcsolatos jogaimat illetve kötelezettségeimet megismertem.')
    paragraph(pdf, 'Tudomásul veszem, hogy amennyiben az Egyesületi Kör, melyben tagsággal bírok megszűnik, és egyidejűleg más Egyesületi Körhöz nem csatlakozom, a Választmány rendes tagságomat automatikusan pártoló tagsággá minősíti.')
    paragraph(pdf, 'Tudomásul veszem, hogy kizárólag egy Egyesületi Körben regisztráltathatom magam szavazatra jogosult rendes tagként, küldöttválasztás során, kizárólag egy Egyesületi Kör tekintetében rendelkezem szavazati jogosultsággal.')
    paragraph(pdf, 'Az Egyesület Alapszabályát illetve Szervezeti Működési Szabályzatát magamra nézve kötelezőnek ismerem el, azt betartom.')
    paragraph(pdf, 'Kijelentem, hogy sem jogszabályban, sem az Egyesület Alapszabályában meghatározott kizáró ok "velem szemben nem áll fenn.')
    paragraph(pdf, 'Tudomásul veszem, hogy jelen belépési nyilatkozat aláírásán kívül az Egyesületbe való belépésem érvényességi feltétele az Egyesület Választmányának jóváhagyó döntése.')
    paragraph(pdf, 'Tudomásul veszem, hogy az Egyesületbe történő belépésem a Választmány jóváhagyó döntését követően a jóváhagyás időpontjában érvényes belépési tagsági díj megfizetésével válik hatályossá. Tudomásul veszem, hogy a vonatkozó jogszabályokban, és az Egyesület alapszabályában biztosított jogaimat ezen tagdíj megfizetésétől gyakorolhatom.')
    paragraph(pdf, 'Egyúttal hozzájárulok ahhoz, hogy jelen nyilatkozatban megadott adataimat az Egyesület, működésének keretein belül szabadon felhasználhatja, azokat kezelheti.')
    paragraph(pdf, "Budapest, #{Date.today.strftime('%Y.%m.%d.')}")
    pdf.move_down 30
    pdf.stroke do 
      pdf.horizontal_line 120, 320
    end
    paragraph(pdf, 'Tanúsítjuk, hogy jelen belépési nyilatkozatot a Nyilatkozó jelenlétünkben írta alá, illetve aláírását a sajátjának ismerte el.')
    pdf.move_down 30
    pdf.image "#{Rails.root}/app/assets/images/signingarea.png", width: 400,  position: :center
    pdf.render
  end

  def self.generate_user_specific_paragraph(pdf, user)
    paragraph(pdf, "Alulírott #{user.full_name} (lakcím: #{user.home_address}, anyja neve: #{user.mother_name}, e-mail cím: #{user.email}) jelen nyilatkozat aláírásával kifejezem belépési szándékom a Schönherzes Villamosmérnökök és Informatikusok Egyesületébe (székhely: 1115 Budapest, Bartók Béla út 152/H. Kelen Irodaház, fszt./a., továbbiakban Egyesület). Kijelentem, hogy az Egyesületbe #{user.svie_member_type} ként kívánok belépni.")
  end

  def self.paragraph(pdf, text)
    pdf.move_down PARAGRAPH_MARGIN
    pdf.text text, align: :justify
  end

end
