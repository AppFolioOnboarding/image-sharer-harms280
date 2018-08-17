# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
STATUS_CODES = [ 100, 200, 201, 202, 203, 204, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 418, 422, 429, 500, 501, 502]

urls = STATUS_CODES.map do |code|
  {link: "https://httpstatusdogs.com/img/#{code}.jpg", tag_list: 'http, dog'}
end

Image.create(urls)
