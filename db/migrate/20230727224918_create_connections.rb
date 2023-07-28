class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections, id: :uuid do |t|
      t.string :salt_edge_id
      t.string :provider_id
      t.string :provider_code
      t.string :provider_name
      t.string :status
      t.references :customer,
                   type: :uuid,
                   null: false,
                   index: true,
                   foreign_key: true,
                   on_delete: :cascade

      t.timestamps
    end
  end
end
