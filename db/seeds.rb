# デモ用の多めのマスタ・在庫・数量履歴。何度実行しても同じキー（email / 場所名 / 型番）で更新する。

users_data = [
  { email: "admin@example.com", nickname: "管理者", last_name: "管理", first_name: "太郎",
    last_name_kana: "カンリ", first_name_kana: "タロウ", birthday: Date.new(1980, 1, 1), role: :admin },
  { email: "sato@example.com", nickname: "工場長", last_name: "佐藤", first_name: "一郎",
    last_name_kana: "サトウ", first_name_kana: "イチロウ", birthday: Date.new(1975, 6, 12), role: :admin },
  { email: "user@example.com", nickname: "現場担当", last_name: "山田", first_name: "花子",
    last_name_kana: "ヤマダ", first_name_kana: "ハナコ", birthday: Date.new(1992, 4, 15), role: :general },
  { email: "suzuki@example.com", nickname: "鈴木", last_name: "鈴木", first_name: "美咲",
    last_name_kana: "スズキ", first_name_kana: "ミサキ", birthday: Date.new(1995, 9, 3), role: :general },
  { email: "tanaka@example.com", nickname: "田中", last_name: "田中", first_name: "健",
    last_name_kana: "タナカ", first_name_kana: "ケン", birthday: Date.new(1988, 11, 21), role: :general },
  { email: "watanabe@example.com", nickname: "渡辺", last_name: "渡辺", first_name: "結衣",
    last_name_kana: "ワタナベ", first_name_kana: "ユイ", birthday: Date.new(1998, 2, 8), role: :general },
  { email: "ito@example.com", nickname: "伊藤", last_name: "伊藤", first_name: "大輔",
    last_name_kana: "イトウ", first_name_kana: "ダイスケ", birthday: Date.new(1986, 7, 30), role: :general },
  { email: "nakamura@example.com", nickname: "中村", last_name: "中村", first_name: "陽子",
    last_name_kana: "ナカムラ", first_name_kana: "ヨウコ", birthday: Date.new(1991, 12, 1), role: :general },
  { email: "kobayashi@example.com", nickname: "小林", last_name: "小林", first_name: "誠",
    last_name_kana: "コバヤシ", first_name_kana: "マコト", birthday: Date.new(1983, 5, 18), role: :general },
  { email: "kato@example.com", nickname: "加藤", last_name: "加藤", first_name: "直樹",
    last_name_kana: "カトウ", first_name_kana: "ナオキ", birthday: Date.new(1990, 8, 25), role: :general }
]

users = users_data.map do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.assign_attributes(attrs.merge(password: "password"))
  user.save!
  user
end

staff_users = users.select(&:general?)

location_rows = [
  ["工場A", "製造現場 A（ヘッダー工程）"],
  ["工場B", "製造現場 B（転造工程）"],
  ["工場C", "製造現場 C（トリム・検査）"],
  ["第1倉庫", "本社横の第1倉庫"],
  ["第2倉庫", "本社横の第2倉庫"],
  ["第3倉庫", "新棟の第3倉庫"],
  ["棚A-01", "第1倉庫 棚A-01"],
  ["棚A-02", "第1倉庫 棚A-02"],
  ["棚A-03", "第1倉庫 棚A-03"],
  ["棚B-01", "第2倉庫 棚B-01"],
  ["棚B-02", "第2倉庫 棚B-02"],
  ["棚C-01", "第3倉庫 棚C-01"],
  ["ライン1手元棚", "工場A ライン1の手元在庫"],
  ["ライン2手元棚", "工場B ライン2の手元在庫"],
  ["検査室", "受入・出荷前検査"],
  ["再研磨室", "再研磨待ち・研磨済み"],
  ["予備置き場", "季節変動用の予備"],
  ["廃却待置場", "寿命到達・廃却待ち"],
  ["新設倉庫", "まだダイスを置いていない空き倉庫"]
]

locations = location_rows.map do |name, description|
  Location.find_or_create_by!(name: name) do |location|
    location.description = description
  end.tap { |location| location.update!(description: description) }
end

stock_locations = locations.reject { |location| location.name == "新設倉庫" }

categories = [
  { name: "ヘッダーダイス", code: "HD", min_price: 6_500, max_price: 18_000 },
  { name: "転造ダイス", code: "RD", min_price: 8_000, max_price: 22_000 },
  { name: "トリムダイス", code: "TD", min_price: 7_000, max_price: 16_000 },
  { name: "ポイントダイス", code: "PD", min_price: 5_000, max_price: 12_000 },
  { name: "面取りダイス", code: "CD", min_price: 4_500, max_price: 11_000 },
  { name: "押出ダイス", code: "ED", min_price: 9_000, max_price: 20_000 },
  { name: "カッターダイス", code: "KT", min_price: 6_000, max_price: 14_000 }
]

sizes = [
  ["M3×0.5", "M3-05"],
  ["M4×0.7", "M4-07"],
  ["M5×0.8", "M5-08"],
  ["M6×1.0", "M6-10"],
  ["M8×1.25", "M8-12"],
  ["M10×1.5", "M10-15"],
  ["M12×1.75", "M12-17"],
  ["M14×2.0", "M14-20"],
  ["M16×2.0", "M16-20"],
  ["M18×2.5", "M18-25"],
  ["M20×2.5", "M20-25"],
  ["M24×3.0", "M24-30"]
]

notes_pool = [
  nil, nil, nil, nil,
  "再研磨予定",
  "消耗が早いので予備多め",
  "ライン専用品",
  "受入検査済み",
  "旧ロットと混在注意",
  "廃却候補"
]

rng = Random.new(20260907)
catalog = []

categories.each_with_index do |category, category_index|
  sizes.each_with_index do |size_pair, size_index|
    size, size_code = size_pair
    product_code = "#{category[:code]}-#{size_code}"
    price_span = category[:max_price] - category[:min_price]
    unit_price = category[:min_price] + ((price_span / (sizes.size - 1)) * size_index)
    unit_price = (unit_price / 100) * 100

    low_stock = ((category_index + size_index) % 8).zero?
    scrap = category[:code] == "KT" && size_index >= 10

    if low_stock
      new_quantity = rng.rand(0..2)
      used_quantity = rng.rand(1..3)
    elsif scrap
      new_quantity = 0
      used_quantity = rng.rand(1..4)
    else
      new_quantity = rng.rand(12..95)
      used_quantity = rng.rand(4..40)
    end

    location = if scrap
      stock_locations.find { |item| item.name == "廃却待置場" }
    elsif category[:code] == "RD"
      stock_locations[size_index % 6 + 3]
    else
      stock_locations[(category_index * 3 + size_index) % (stock_locations.size - 1)]
    end

    catalog << {
      name: "#{category[:name]} #{size.split('×').first}",
      product_code: product_code,
      size: size,
      category: category[:name],
      location: location,
      new_quantity: new_quantity,
      used_quantity: used_quantity,
      unit_price: unit_price,
      purchase_date: Date.new(2023, 1, 1) + rng.rand(0..1100),
      notes: notes_pool.sample(random: rng)
    }
  end
end

# 同じ型を別場所にも置く（場所ごとの在庫行）
sizes.first(8).each_with_index do |size_pair, index|
  size, size_code = size_pair
  category = categories[index % categories.size]
  catalog << {
    name: "#{category[:name]} #{size.split('×').first}",
    product_code: "#{category[:code]}-#{size_code}-B",
    size: size,
    category: category[:name],
    location: stock_locations[-(index + 1)],
    new_quantity: rng.rand(8..40),
    used_quantity: rng.rand(2..18),
    unit_price: category[:min_price] + index * 400,
    purchase_date: Date.new(2024, 2, 1) + index * 20,
    notes: "別ライン用の同一型"
  }
end

Die.skip_callback(:update, :after, :record_quantity_change)
begin
  catalog.each do |attrs|
    die = Die.find_or_initialize_by(product_code: attrs[:product_code])
    die.assign_attributes(attrs)
    die.save!
  end
ensure
  Die.set_callback(:update, :after, :record_quantity_change, if: :quantity_changed?)
end

Die.find_each do |die|
  next if die.quantity_changes.exists?

  steps = rng.rand(2..5)
  cursor_new = die.new_quantity + rng.rand(6..28)
  cursor_used = [die.used_quantity - rng.rand(0..6), 0].max
  changed_at = Time.zone.parse("2025-04-01") + rng.rand(0..200).days
  actor_ids = staff_users.map(&:id)

  steps.times do |step|
    before_new = cursor_new
    before_used = cursor_used
    if step == steps - 1
      cursor_new = die.new_quantity
      cursor_used = die.used_quantity
    else
      take = rng.rand(1..8)
      cursor_new = [cursor_new - take, die.new_quantity].max
      cursor_used += take / 2
    end
    next if before_new == cursor_new && before_used == cursor_used

    QuantityChange.create!(
      die: die,
      user_id: actor_ids.sample(random: rng),
      new_quantity_before: before_new,
      new_quantity_after: cursor_new,
      used_quantity_before: before_used,
      used_quantity_after: cursor_used,
      created_at: changed_at,
      updated_at: changed_at
    )
    changed_at += rng.rand(2..18).days
  end
end

puts "シード完了: ユーザー #{User.count} / 保管場所 #{Location.count} / ダイス #{Die.count} / 数量履歴 #{QuantityChange.count}"
puts "ログイン: admin@example.com / password （管理者）"
puts "ログイン: user@example.com / password （一般）"
