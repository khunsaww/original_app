module ApplicationHelper
  def yen(amount)
    number_to_currency(amount.to_i, unit: "¥", precision: 0, format: "%u%n")
  end

  def page_title(title)
    content_for(:title) { title }
    tag.h1(title, class: "page-title")
  end

  def nav_class(path)
    current_page?(path) ? "app-nav__link is-active" : "app-nav__link"
  end

  def quantity_counts(new_qty, used_qty, total = nil)
    total ||= new_qty.to_i + used_qty.to_i
    "新品 #{number_with_delimiter(new_qty)} / 使用済み #{number_with_delimiter(used_qty)} / 計 #{number_with_delimiter(total)}"
  end

  def signed_number(value)
    n = value.to_i
    formatted = number_with_delimiter(n.abs)
    return formatted if n.zero?
    n.positive? ? "+#{formatted}" : "-#{formatted}"
  end
end
