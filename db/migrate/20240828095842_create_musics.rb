class CreateMusics < ActiveRecord::Migration[7.2]
  def change
    create_table :musics do |t|
      t.belongs_to :artist, null: false, foreign_key: true
      t.string :title, null: false
      t.index :title, unique: true
      t.string :album_name
      t.string :genre

      t.timestamps
    end
  end
end
