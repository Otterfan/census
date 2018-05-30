module SharedMethods
  include ActiveSupport::Concern

  def clean_field(field_val, strict=false)
    coder = HTMLEntities.new

    # remove &gt; and &lt; html entities to avoid removing words wrapped in <> in a later gsub command
    field_val = field_val.gsub(/(&gt;|&lt;)/, "")

    # convert html entities into chars
    field_val = coder.decode(field_val)

    # remove all html <tags>
    field_val = field_val.gsub(/<[^>]*>/, "")

    # clean up special chars
    field_val = field_val.gsub(/["'“”‘’:_\[\]\*]/, "")

    # remove leading periods
    field_val = field_val.gsub(/^\.+/, "")

    if strict
      # remove a stricter set of special chars
      field_val = field_val.gsub(/[\.\(\),«»]/, "")
    end

    # replace newlines with spaces, and strip leading/trailing whitespace
    field_val.gsub(/[\n]/, " ").strip
  end
end