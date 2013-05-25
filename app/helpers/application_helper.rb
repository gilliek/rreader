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

  def output_errors(errors_list)
    rval = "<ul class=\"icons-ul\">\n"
    errors_list.full_messages.each do |msg|
      rval += "\t<li><i class=\"icon-li icon-remove\"></i> #{msg}</li>\n"
    end
    rval += "</ul>\n"

    return rval
  end
end
