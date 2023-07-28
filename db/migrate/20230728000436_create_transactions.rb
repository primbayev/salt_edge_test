class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :salt_edge_id
      t.date :made_on
      t.string :category
      t.string :description
      t.string :status
      t.boolean :duplicated, default: false
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.string :currency_code
      t.references :account,
                   type: :uuid,
                   null: false,
                   index: true,
                   foreign_key: true,
                   on_delete: :cascade

      t.timestamps
    end
  end
end
