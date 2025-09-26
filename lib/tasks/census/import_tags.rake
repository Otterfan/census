namespace :census do

  desc "Import tags"
  task import_tags: :environment do
    tag = Tag.new(value: "Autobiography")
    tag.save
    text = Text.find_by(census_id: "3.711")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.732")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.825")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1311")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Children’s Literature")
    tag.save
    text = Text.find_by(census_id: "3.957")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1030")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1031")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1086")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1091")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1092")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1252")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1277")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1420")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Classical Drama on a Modern Stage")
    tag.save
    text = Text.find_by(census_id: "3.1430")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1431")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1432")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1433")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1430")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1435")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1436")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1437")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1438")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1439")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1440")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1441")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1442")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1443")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1444")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1445")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1446")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1447")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Computer and Edition")
    tag.save
    text = Text.find_by(census_id: "3.168")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.180")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.385")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.387")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Cypriot Literature")
    tag.save
    text = Text.find_by(census_id: "3.823")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.824")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.839")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.915")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.961")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.998")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1000")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1050")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1051")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1054")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1055")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1080")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1098")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1165")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1183")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1187")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1194")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1246")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1249")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1259")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1294")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1295")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1324")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1367")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1368")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1370")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1373")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1473")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1483")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1488")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1495")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1511")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Drama")
    tag.save
    text = Text.find_by(census_id: "3.730")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.738")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.739")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.740")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.741")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.786")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.807")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.823")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.840")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.841")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.842")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.843")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.844")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.845")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.846")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.847")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.891")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.892")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.893")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.894")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.895")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.896")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.925")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.931")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.958")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.959")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.988")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1032")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1043")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1079")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1099")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1100")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1160")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1174")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1176")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1182")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1189")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1207")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1214")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1219")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1220")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1222")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1224")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1274")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1278")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1299")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1334")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1357")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1358")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1360")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1382")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1390")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1391")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1396")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1452")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1482")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1505")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1509")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Greece and the Balkans")
    tag.save
    text = Text.find_by(census_id: "3.785")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.942")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1002")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1116")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1168")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1405")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Greece and Europe")
    tag.save
    text = Text.find_by(census_id: "3.820")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1081")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1389")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Greece and the Orient")
    tag.save
    text = Text.find_by(census_id: "3.1077")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1078")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Greek American Literature")
    tag.save
    text = Text.find_by(census_id: "3.886")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.890")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.926")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.989")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1015")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1016")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1017")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1018")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1019")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1020")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1296")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1309")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1380")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1387")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1394")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1401")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Greek Australian Literature")
    tag.save
    text = Text.find_by(census_id: "3.801")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.802")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.803")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.804")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.805")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.806")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.807")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.808")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.809")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.810")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.811")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.812")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.813")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.814")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.997")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1023")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1024")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1025")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1026")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1027")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1028")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1029")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1044")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1045")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1229")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1230")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1231")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1232")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1233")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1234")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1235")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1236")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1341")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1375")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1397")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "The Greek Book (Modern Period)")
    tag.save
    text = Text.find_by(census_id: "3.702")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.726")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.731")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.736")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.745")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.794")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.830")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.878")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.901")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1003")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1117")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1361")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1450")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1497")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Hellenicity")
    tag.save
    text = Text.find_by(census_id: "3.87")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.129")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.288")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.455")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.467")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.471")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.477")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.480")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.481")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.487")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.493")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.499")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.765")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.766")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.774")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.776")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.788")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.792")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.799")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.828")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.873")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.950")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.967")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.973")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1005")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1082")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1083")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1094")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1095")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1096")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1102")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1103")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1127")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1128")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1130")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1131")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1132")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1139")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1158")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1260")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1323")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1402")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1412")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1463")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1472")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Hellenism in Egypt")
    tag.save
    text = Text.find_by(census_id: "3.1047")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1053")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Language Question")
    tag.save
    text = Text.find_by(census_id: "3.751")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.764")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.800")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.883")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.929")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.947")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1134")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1141")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1146")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1147")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1148")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1152")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1184")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1273")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1298")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1384")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1385")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1426")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1448")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Literary Magazines")
    tag.save
    text = Text.find_by(census_id: "3.719")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.720")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.721")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.722")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.723")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.724")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.725")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.726")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.727")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.728")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.729")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.858")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.866")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.905")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.945")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.946")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.991")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1022")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1177")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1178")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1258")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1262")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1490")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Modern Greek Literature")
    tag.save
    text = Text.find_by(census_id: "3.701")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.703")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.743")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.747")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.749")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.753")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.758")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.769")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.775")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.778")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.796")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.816")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.817")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.818")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.849")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.851")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.855")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.869")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.870")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.871")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.872")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.876")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.877")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.882")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.891")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.903")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.904")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.907")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.910")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.940")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.955")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.966")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.972")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.986")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1006")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1007")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1008")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1010")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1046")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1064")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1066")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1067")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1074")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1093")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1109")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1110")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1111")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1129")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1133")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1149")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1151")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1156")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1162")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1164")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1165")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1173")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1181")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1188")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1192")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1225")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1243")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1248")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1253")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1255")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1257")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1266")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1268")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1269")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1271")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1279")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1288")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1289")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1290")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1291")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1302")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1306")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1310")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1315")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1316")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1317")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1318")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1319")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1343")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1362")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1372")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1404")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1408")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1409")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1410")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1413")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1451")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1456")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1466")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1479")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1480")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1484")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1494")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1499")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1501")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1502")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1508")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1512")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Modern Greek Studies")
    tag.save
    text = Text.find_by(census_id: "3.705")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.742")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.754")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.759")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.763")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.767")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.768")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.854")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.938")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.941")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1062")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1106")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1201")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1228")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1304")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1345")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1346")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1359")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1486")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1503")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1506")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1507")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1510")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Modernism")
    tag.save
    text = Text.find_by(census_id: "3.781")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.782")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.918")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.939")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1005")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1009")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1011")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "1013")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1076")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1085")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1090")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1104")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1105")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1108")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1113")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1120")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1121")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1122")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1196")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1299")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1300")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1337")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1407")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1474")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1500")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Novel")
    tag.save
    text = Text.find_by(census_id: "3.708")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.709")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.723")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.748")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.750")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.755")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.867")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.897")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.898")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.899")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.992")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1041")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1112")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1114")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1115")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1140")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1142")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1191")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1265")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1272")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1297")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1336")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1338")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1339")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1366")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1386")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1388")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1392")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1393")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1414")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1461")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1470")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1471")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Poetry")
    tag.save
    text = Text.find_by(census_id: "3.693")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.712")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.713")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.714")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.715")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.716")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.717")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.722")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.725")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.734")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.737")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.771")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.777")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.783")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.784")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.797")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.798")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.819")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.832")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.833")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.850")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.852")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.857")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.862")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.863")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.887")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.909")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.913")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.916")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.930")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.934")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.935")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.936")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.937")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.949")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.954")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.956")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.960")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.963")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.964")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.974")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1042")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1048")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1049")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1060")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1068")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1069")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1075")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1084")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1097")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1123")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1124")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1126")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1135")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1136")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1137")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1138")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1144")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1170")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1175")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1180")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1195")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1198")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1237")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1244")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1245")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1256")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1264")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1283")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1284")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1285")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1301")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1303")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1305")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1312")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1314")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1320")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1321")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1322")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1327")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1330")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1344")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1347")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1348")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1349")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1355")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1356")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1371")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1377")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1381")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1416")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1417")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1418")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1419")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1425")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1460")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1485")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1491")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1492")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1493")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Poetry and Music")
    tag.save
    text = Text.find_by(census_id: "3.981")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.984")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.985")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1263")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1455")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Prose")
    tag.save
    text = Text.find_by(census_id: "3.704")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.707")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.733")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.756")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.772")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.826")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.831")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.848")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.860")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.879")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.927")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.928")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.943")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.948")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.968")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.969")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.970")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.971")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1089")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1107")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1150")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1153")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1154")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1155")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1163")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1193")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1239")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1267")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1280")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1281")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1292")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1300")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1308")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1411")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1415")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1457")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1458")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1459")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1476")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1489")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1496")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1498")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Rebetica")
    tag.save
    text = Text.find_by(census_id: "3.694")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.695")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.697")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.698")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.699")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.700")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.900")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.917")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.919")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.920")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.921")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.922")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.923")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.924")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.977")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.978")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.982")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.983")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1118")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1247")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1254")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1275")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1276")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1287")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1365")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1366")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1367")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1368")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1369")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1370")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1371")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1372")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1373")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1374")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1375")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1376")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1377")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1378")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1379")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1380")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1381")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1382")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1383")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1399")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Ritual in Greek Literature")
    tag.save
    text = Text.find_by(census_id: "3.706")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.793")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.979")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1337")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1475")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Romanticism")
    tag.save
    text = Text.find_by(census_id: "3.757")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.760")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.779")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.780")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.837")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.902")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.952")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.953")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.995")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.996")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1039")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1143")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1282")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Satire")
    tag.save
    text = Text.find_by(census_id: "3.724")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1143")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Short story")
    tag.save
    text = Text.find_by(census_id: "3.1040")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1161")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1179")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1186")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1226")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1227")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Surrealism")
    tag.save
    text = Text.find_by(census_id: "3.787")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.789")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.790")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.791")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.833")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.975")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1052")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1119")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1328")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1395")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Symbolism")
    tag.save
    text = Text.find_by(census_id: "3.1004")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Translation")
    tag.save
    text = Text.find_by(census_id: "3.721.5")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.744")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.770")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.773")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.827")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.833")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.834")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.835")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.836")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.861")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.864")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.865")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.868")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.885")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.908")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.911")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.912")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.965")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.983")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.987")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.993")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1001")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1012")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1033")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1035")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1036")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1037")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1038")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1058")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1059")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1070")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1071")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1072")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1073")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1101")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1167")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1172")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1202")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1233")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1240")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1241")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1251")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1286")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1307")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1313")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1349")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1351")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1352")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1353")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1354")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1383")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1398")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1400")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1421")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1453")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1454")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1464")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1504")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Women's Writing")
    tag.save
    text = Text.find_by(census_id: "3.761")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.874")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.875")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.880")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.881")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.888")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.906")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.932")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.962")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.976")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1087")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1088")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1250")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1270")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1325")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1326")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1329")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1332")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1333")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1342")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1369")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1422")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1423")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1427")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1428")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.1429")
    if text
      text.tags << tag
      text.save
    end
    tag = Tag.new(value: "Writing in the Diaspora")
    tag.save
    text = Text.find_by(census_id: "3.821")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.822")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.838")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.889")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.932")
    if text
      text.tags << tag
      text.save
    end
    text = Text.find_by(census_id: "3.994")
    if text
      text.tags << tag
      text.save
    end


  end
end
