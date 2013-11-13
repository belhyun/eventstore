module ApplicationHelper
  def echo(str)
    concat sanitize str
  end
end
