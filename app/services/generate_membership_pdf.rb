require "prawn"

class GenerateMembershipPdf

  PARAGRAPH_MARGIN = 30
  SMALL_MARGIN = 15

  def self.call #(group, membership, post_type_id)
    pdf = Prawn::Document.new
    pdf.font Rails.root.join("app/assets/fonts/arial.ttf")
    pdf.move_down PARAGRAPH_MARGIN
    pdf.text 'A Budapesti Műszaki Egyetem Villamosmérnöki és Informatikai Karának nappali tagozatos hallgatója vagyok, egyben tagsággal bírok egy, a Schönherz Zoltán Kollégiumban működő Egyesületi Körben.'
    pdf.move_down PARAGRAPH_MARGIN
    pdf.text 'E tagsági minőséggel kapcsolatos jogaimat illetve kötelezettségeimet megismertem.'
    pdf.move_down PARAGRAPH_MARGIN
    pdf.text 'Tudomásul veszem, hogy amennyiben az Egyesületi Kör, melyben tagsággal bírok megszűnik, és egyidejűleg más Egyesületi Körhöz nem csatlakozom, a Választmány rendes tagságomat automatikusan pártoló tagsággá minősíti.'
    pdf.move_down SMALL_MARGIN
    pdf.text 'Tudomásul veszem, hogy kizárólag egy Egyesületi Körben regisztráltathatom magam szavazatra jogosult rendes tagként, küldöttválasztás során, kizárólag egy Egyesületi Kör tekintetében rendelkezem szavazati jogosultsággal.'
    pdf.move_down PARAGRAPH_MARGIN
    pdf.text 'Az Egyesület Alapszabályát illetve Szervezeti Működési Szabályzatát magamra nézve kötelezőnek ismerem el, azt betartom.'
    pdf.move_down SMALL_MARGIN
    pdf.text 'Kijelentem, hogy sem jogszabályban, sem az Egyesület Alapszabályában meghatározott kizáró ok "velem szemben nem áll fenn.'
    pdf.move_down SMALL_MARGIN
    pdf.text 'Tudomásul veszem, hogy jelen belépési nyilatkozat aláírásán kívül az Egyesületbe való belépésem érvényességi feltétele az Egyesület Választmányának jóváhagyó döntése.'
    pdf.move_down PARAGRAPH_MARGIN
    pdf.text 'Tudomásul veszem, hogy az Egyesületbe történő belépésem a Választmány jóváhagyó döntését követően a jóváhagyás időpontjában érvényes belépési tagsági díj megfizetésével válik hatályossá. Tudomásul veszem, hogy a vonatkozó jogszabályokban, és az Egyesület alapszabályában biztosított jogaimat ezen tagdíj megfizetésétől gyakorolhatom.', align: :justify
    pdf.move_down PARAGRAPH_MARGIN
    pdf.text 'Egyúttal hozzájárulok ahhoz, hogy jelen nyilatkozatban megadott adataimat az Egyesület, működésének keretein belül szabadon felhasználhatja, azokat kezelheti.'
    pdf.render
  end

end
