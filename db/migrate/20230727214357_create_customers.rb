class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :identifier
      t.references :user,
                   null: false,
                   index: true,
                   foreign_key: true,
                   on_delete: :cascade

      t.timestamps
    end
  end
end
