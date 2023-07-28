class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :salt_edge_id
      t.decimal :balance, precision: 10, scale: 2, default: 0.0
      t.string :currency_code
      t.string :nature
      t.string :name
      t.references :connection,
                   type: :uuid,
                   null: false,
                   index: true,
                   foreign_key: true,
                   on_delete: :cascade

      t.timestamps
    end
  end
end
