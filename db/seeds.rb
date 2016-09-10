# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Asset.create(ip_address: '172.23.41.1', label: 'Server1', description: 'Big Server type X')
Asset.create(ip_address: '172.23.41.2', label: 'Server2', description: 'Big Server type X')
Asset.create(ip_address: '172.23.41.3', label: 'Server3', description: 'Big Server type Y')
