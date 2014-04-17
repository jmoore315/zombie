class String

  def is_datetime?
    begin
      return self.to_datetime
    rescue
      return false
    end
  end

  def to_boolean
		return true if self.to_i != 0
		return false
  end

  def category
    return "Furniture" if self == "Chairs"
    return "Furniture" if self == "Tables"
    return "Furniture" if self == "Desks"
    return "Furniture" if self == "TV Stands"
    return "Furniture" if self == "Storage"
    return "Bedroom" if self == "Beds and Box Springs"
    return "Bedroom" if self == "Mattresses"
    return "Bathroom" if self == "Bathroom Accessories"
    return "Laundry" if self == "Laundry Baskets and Hampers"
    return "Kitchen" if self == "Cookware"
    return "Kitchen" if self == "Food Containers"
    return "Kitchen" if self == "Refrigerators"
    return "Lighting" if self == "Floor Lamps"
    return "Lighting" if self == "Desk Lamps"
    return "Rugs" if self == "Area Rugs"
    return "Electronics" if self == "Televisions"
    return "Electronics" if self == "Phones"
    return "Electronics" if self == "Computers"
    return "Electronics" if self == "Cameras"
    return "Electronics" if self == "Other"
    return "Media" if self == "Textbooks"
    return "Media" if self == "Books"
    return "Media" if self == "Movies and TV"
    return "Media" if self == "Music"
    return "Media" if self == "Video Games"
    return "Media" if self == "Board Games"
    return "Outdoor" if self == "Bicycles"
    return "Outdoor" if self == "Sports Equipment"
    return "Outdoor" if self == "Grills"
    return "Outdoor" if self == "Patio Furniture"
  end

  def subcategories 
    return ["Chairs","Tables","Desks","TV Stands","Storage"] if self == "Furniture"
    return ["Beds and Box Springs","Mattresses"] if self == "Bedroom"
    return ["Bathroom Accessories"] if self == "Bathroom"
    return ["Laundry Baskets and Hampers"] if self == "Laundry"
    return ["Cookware","Food Containers","Refrigerators"] if self == "Kitchen"
    return ["Floor Lamps","Desk Lamps"] if self == "Lighting"
    return ["Area Rugs"] if self == "Rugs"
    return ["Televisions","Phones","Computers","Cameras","Other"] if self == "Electronics"
    return ["Textbooks","Books","Movies and TV","Music","Video Games","Board Games"] if self == "Media"
    return ["Bicycles","Sports Equipment","Grills","Patio Furniture"] if self == "Outdoor"
  end

  def to_digits
    return self.gsub(/[^0-9]/,"")
  end

  def is_telephone?
    digits = self.to_digits
    return true if digits.length == 10
    return true if digits.length == 11 && digits.first == "1"
    return false
  end

  def to_telephone
    digits = self.to_digits
    return "(#{digits[0..2]})#{digits[3..5]}-#{digits[6..9]}" if digits.length == 10
    return "#{digits[0]}(#{digits[1..3]})#{digits[4..6]}-#{digits[7..10]}" if digits.length == 11
    return nil
  end


end