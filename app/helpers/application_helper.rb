module ApplicationHelper
  def pretty_date(date)
    return date.to_time.strftime('%d/%m/%Y at %H:%M') || ""
  end

  def star_icon(entry)
    return entry.starred ?
      '<i class="icon-star"></i>' : '<i class="icon-star-empty"></i>'
  end

  def read_or_not(entry)
    return !entry.read ? 'bold' : ''
  end
end
